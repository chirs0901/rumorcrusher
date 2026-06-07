#!/usr/bin/env python3
"""
RumorCrusher · 每小时科技新闻自动采集器
==========================================
功能:
  1. DuckDuckGo 搜索手机行业科技新闻和关键器件供应商动态
  2. 结构化存储到 knowledge-base/{date}/{hour}-raw/
  3. 提取实体，增量更新 wiki 知识图谱

运行频率: 每小时一次（LaunchAgent 定时触发）
"""

import json
import re
import sys
import hashlib
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Optional

REPO = Path(__file__).parent.parent
KB_PATH = REPO / "knowledge-base"
WIKI_PATH = REPO / "wiki"
LOG_FILE = REPO / "_meta" / "hourly-collector.log"

# ══════════════════════════════════════════
# 每小时的搜索主题（按 UTC 小时轮换，9个时段循环）
# ══════════════════════════════════════════
HOURLY_TOPICS = [
    {   # 时段0: 芯片+SoC
        "category": "soc",
        "queries": [
            "Snapdragon 8 Elite Gen 6 latest news 2026",
            "Dimensity 9600 天玑9600 最新消息",
            "Apple A20 Pro chip TSMC 2nm",
            "Kirin 麒麟 2026 芯片 最新",
            "手机芯片 制程 2nm 3nm 最新动态",
        ]
    },
    {   # 时段1: 折叠屏+显示
        "category": "display",
        "queries": [
            "折叠屏手机 2026 最新 出货 铰链",
            "Samsung foldable display OLED 2026",
            "BOE 京东方 OLED 手机面板 2026",
            "LTPO OLED 手机屏幕 供应商",
            "UTG 超薄玻璃 折叠屏 供应链",
        ]
    },
    {   # 时段2: 影像+相机
        "category": "camera",
        "queries": [
            "Sony LYTIA sensor 手机 2026",
            "Samsung ISOCELL 手机相机传感器",
            "潜望式长焦 手机 2026 最新",
            "手机影像 计算摄影 AI 2026",
            "可变光圈 手机 相机 2026",
        ]
    },
    {   # 时段3: 电池+充电
        "category": "battery",
        "queries": [
            "硅碳负极电池 手机 2026 最新",
            "手机快充 无线充电 功率 2026",
            "固态电池 手机 最新进展 2026",
            "ATL 新能源 手机电池 供应商",
            "SiC battery smartphone 2026",
        ]
    },
    {   # 时段4: 供应链+代工
        "category": "supply-chain",
        "queries": [
            "TSMC 2nm 产能 苹果 高通 2026",
            "中芯国际 SMIC 制程 进展 2026",
            "Samsung Foundry 2nm GAA 2026",
            "手机芯片 代工 产能 供应 2026",
            "semiconductor foundry smartphone 2026",
        ]
    },
    {   # 时段5: AI+手机
        "category": "ai-phone",
        "queries": [
            "端侧AI 手机 NPU TOPS 2026",
            "on-device AI smartphone LLM",
            "AI手机 功能 芯片 2026 最新",
            "手机AI Agent 智能体 2026",
            "DeepSeek 手机端 部署 2026",
        ]
    },
    {   # 时段6: 品牌动态
        "category": "brand",
        "queries": [
            "华为 Mate 80 最新 动态 2026",
            "Apple iPhone 18 Pro 最新 预测",
            "小米 17 Ultra OPPO Find X9 vivo X300",
            "三星 Galaxy S26 Galaxy Z Fold 最新",
            "荣耀 OV 传音 手机 2026",
        ]
    },
    {   # 时段7: 内存+存储
        "category": "memory",
        "queries": [
            "LPDDR6 手机内存 量产 2026",
            "UFS 5.0 手机存储 最新 2026",
            "SK Hynix Samsung memory smartphone",
            "HBM 手机 AI 内存 需求 2026",
            "手机存储 芯片 涨价 供应链 2026",
        ]
    },
    {   # 时段8: 综合科技
        "category": "general",
        "queries": [
            "smartphone technology breakthrough 2026",
            "手机 新技术 黑科技 2026 最新",
            "mobile phone component supplier 2026",
            "手机行业 趋势 报告 2026",
            "手机 产业链 供应商 动态 2026",
        ]
    },
]


def log(msg: str):
    ts = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    line = f"[{ts}] {msg}"
    print(line)
    with open(LOG_FILE, "a") as f:
        f.write(line + "\n")


def ddg_search(query: str, max_results: int = 8) -> List[Dict]:
    """DuckDuckGo 搜索，返回结构化结果"""
    try:
        from duckduckgo_search import DDGS
    except ImportError:
        log("⚠️ duckduckgo_search 未安装")
        return []

    results = []
    try:
        with DDGS() as ddgs:
            for r in ddgs.text(query, max_results=max_results):
                href = r.get("href", "")
                if not href:
                    continue
                domain = href.split("/")[2] if "://" in href else "unknown"
                results.append({
                    "title": r.get("title", "")[:150],
                    "url": href,
                    "domain": domain,
                    "snippet": (r.get("body", "") or "")[:300],
                    "query": query,
                })
    except Exception as e:
        log(f"  DDG 搜索失败: {e}")

    return results


def extract_entities(results: List[Dict]) -> Dict[str, List[str]]:
    """从搜索结果中提取关键实体"""
    entities = {
        "soc": [], "brand": [], "tech": [], "supplier": [],
        "display": [], "camera": [], "battery": [], "other": [],
    }

    # SoC 芯片正则
    soc_patterns = [
        r'(骁龙\s*\d[\w\s]*Gen\s*\d)', r'(Snapdragon\s*\d[\w\s]*Gen\s*\d)',
        r'(天玑\s*\d{4}\+?)', r'(Dimensity\s*\d{4}\+?)',
        r'(麒麟\s*\d{3,4}\+?\s*[A-Za-z]*)', r'(Kirin\s*\d{3,4}\+?)',
        r'(Apple\s*A\d{2}\+?\s*(?:Pro|Bionic)?)', r'(Exynos\s*\d{4})',
        r'(Tensor\s*G\d)',
    ]
    # 品牌正则
    brand_patterns = [
        r'(华为|Huawei|Apple|苹果|三星|Samsung|小米|Xiaomi|OPPO|vivo|荣耀|Honor|传音|Tecno|Google|谷歌|摩托罗拉|Motorola)',
        r'(BOE|京东方|Samsung\s*Display|LG\s*Display|天马|维信诺)',
    ]
    # 技术正则
    tech_patterns = [
        r'(2nm|3nm|N2P?|N3[EP]?|GAA)', r'(LTPO\+?|OLED|MicroLED)',
        r'(硅碳|Si[-\s]?C|固态电池)', r'(LPDDR\d[EX]?|UFS\s*\d\.?\d)',
        r'(NPU|TOPS|端侧AI)', r'(可变光圈|潜望式|折叠铰链)',
        r'(HBM\d[E]?|cHBM)', r'(TSMC|台积电|SMIC|中芯国际|Samsung Foundry)',
    ]

    all_text = " ".join(r.get("snippet", "") + " " + r.get("title", "") for r in results)

    for pat in soc_patterns:
        for m in re.finditer(pat, all_text, re.IGNORECASE):
            name = m.group(0).strip()
            if name and name not in entities["soc"]:
                entities["soc"].append(name)

    for pat in brand_patterns:
        for m in re.finditer(pat, all_text, re.IGNORECASE):
            name = m.group(0).strip()
            if name and name not in entities["brand"]:
                entities["brand"].append(name)

    for pat in tech_patterns:
        for m in re.finditer(pat, all_text, re.IGNORECASE):
            name = m.group(0).strip()
            if name and name not in entities["tech"]:
                entities["tech"].append(name)

    return entities


def save_results(date_str: str, hour: int, topic: Dict, results: List[Dict], entities: Dict):
    """保存搜索结果和实体到知识库"""
    hour_dir = KB_PATH / date_str / f"{hour:02d}-raw"
    hour_dir.mkdir(parents=True, exist_ok=True)

    # 保存原始结果
    data = {
        "timestamp": datetime.now().isoformat(),
        "category": topic["category"],
        "queries": topic["queries"],
        "results_count": len(results),
        "entities": entities,
        "results": results,
    }

    data_file = hour_dir / "data.json"
    with open(data_file, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

    # 生成 Markdown 摘要
    md = f"""# 科技新闻采集 · {date_str} {hour:02d}:00

> 类别: {topic["category"]} · 采集时间: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}

## 搜索结果

"""
    for r in results[:20]:
        md += f"- [{r['title']}]({r['url']}) · `{r['domain']}`\n"
        if r.get("snippet"):
            md += f"  > {r['snippet'][:200]}\n"

    md += f"""

## 提取实体

"""
    for cat, items in entities.items():
        if items:
            md += f"- **{cat}**: {', '.join(items[:10])}\n"

    md_file = hour_dir / "README.md"
    with open(md_file, "w", encoding="utf-8") as f:
        f.write(md)

    log(f"  已保存: {data_file} ({len(results)} 条结果, {sum(len(v) for v in entities.values())} 个实体)")


def update_wiki_knowledge_graph(date_str: str, all_entities: Dict[str, List[str]]):
    """增量更新 wiki 知识图谱"""
    wiki_index = WIKI_PATH / "index.md"
    if not wiki_index.exists():
        log("  wiki/index.md 不存在，跳过图谱更新")
        return

    index_content = wiki_index.read_text(encoding="utf-8")

    # 收集新增实体（仅在 wiki 中不存在的）
    new_entries = []
    for cat, items in all_entities.items():
        for item in items:
            if item not in index_content:
                new_entries.append((cat, item))

    if not new_entries:
        log("  无新增实体需要加入图谱")
        return

    log(f"  发现 {len(new_entries)} 个新实体: {', '.join(e[1] for e in new_entries[:10])}")

    # 追加到 index.md 变更日志
    changelog_entry = f"\n- **{date_str}**：每小时采集新增实体"
    for cat, item in new_entries[:15]:
        changelog_entry += f" {item}"
    changelog_entry += "（待建档）"

    if "## 三、变更日志" in index_content:
        index_content = index_content.replace(
            "## 三、变更日志",
            f"## 三、变更日志\n{changelog_entry}"
        )
    else:
        index_content += f"\n\n## 三、变更日志\n{changelog_entry}"

    wiki_index.write_text(index_content, encoding="utf-8")
    log("  wiki/index.md 已更新")


def run():
    """主执行流程"""
    now = datetime.now()
    date_str = now.strftime("%Y-%m-%d")
    hour = now.hour

    log(f"{'='*50}")
    log(f"🕐 开始每小时采集 · {date_str} {hour:02d}:00")

    # 按小时轮换主题
    topic = HOURLY_TOPICS[hour % len(HOURLY_TOPICS)]
    log(f"📋 主题: {topic['category']} · {len(topic['queries'])} 个查询")

    # 执行搜索
    all_results = []
    for q in topic["queries"]:
        results = ddg_search(q)
        all_results.extend(results)
        log(f"  '{q[:40]}...' → {len(results)} 条")

    # 去重
    seen = set()
    unique_results = []
    for r in all_results:
        key = r["url"]
        if key not in seen:
            seen.add(key)
            unique_results.append(r)

    log(f"📊 去重后: {len(unique_results)} 条")

    # 提取实体
    entities = extract_entities(unique_results)

    # 保存
    save_results(date_str, hour, topic, unique_results, entities)

    # 更新知识图谱（仅在新的一轮开始时，即 hour % 6 == 0）
    if hour % 6 == 0 and entities:
        update_wiki_knowledge_graph(date_str, entities)

    log(f"✅ 每小时采集完成 · {len(unique_results)} 条新闻 · {sum(len(v) for v in entities.values())} 个实体")
    log("")


if __name__ == "__main__":
    run()
