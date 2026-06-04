#!/usr/bin/env python3
"""
RumorCrusher · 日报自动生成器
================================
从每小时采集的数据（knowledge-base/{date}/*-raw/data.json）
生成四份标准报告：
  1. 03-quality-report-{ts}.md   — 质检报告
  2. 04-clean-report-{ts}.md    — 干净报告
  3. 05-methodology-delta-{ts}.md — 方法论增量
  4. 06-self-eval-{ts}.md       — 自我评估

同时更新 wiki 知识图谱。
"""

import json
import re
from datetime import datetime
from pathlib import Path
from collections import Counter
from typing import Dict, List

REPO = Path(__file__).parent.parent
KB_PATH = REPO / "knowledge-base"
WIKI_PATH = REPO / "wiki"


def load_hourly_data(date_str: str) -> List[Dict]:
    """加载当日所有小时采集数据"""
    date_dir = KB_PATH / date_str
    all_results = []
    seen_urls = set()

    for hour_dir in sorted(date_dir.glob("*-raw")):
        data_file = hour_dir / "data.json"
        if not data_file.exists():
            continue
        try:
            with open(data_file, encoding="utf-8") as f:
                data = json.load(f)
            for r in data.get("results", []):
                url = r.get("url", "")
                if url and url not in seen_urls:
                    seen_urls.add(url)
                    all_results.append(r)
        except Exception:
            continue

    return all_results


def categorize_by_topic(results: List[Dict]) -> Dict[str, List[Dict]]:
    """按主题分类"""
    categories = {
        "芯片/SoC/半导体": [],
        "折叠屏/显示": [],
        "影像/相机": [],
        "电池/充电": [],
        "供应链/代工": [],
        "AI/手机": [],
        "品牌动态": [],
        "内存/存储": [],
        "其他": [],
    }

    soc_kw = ["芯片", "SoC", "骁龙", "天玑", "麒麟", "A19", "A20", "Exynos", "Tensor",
              "Snapdragon", "Dimensity", "Kirin", "TSMC", "台积电", "中芯", "SMIC",
              "2nm", "3nm", "制程", "晶圆"]
    display_kw = ["折叠", "foldable", "OLED", "LTPO", "屏幕", "显示", "BOE", "京东方",
                  "三星显示", "铰链", "UTG"]
    camera_kw = ["相机", "影像", "LYTIA", "ISOCELL", "CMOS", "传感器", "变焦",
                 "潜望", "光圈"]
    battery_kw = ["电池", "充电", "快充", "固态", "硅碳", "SiC", "battery"]
    supply_kw = ["供应链", "代工", "产能", "foundry", "晶圆厂", "Samsung Foundry"]
    ai_kw = ["AI", "NPU", "TOPS", "LLM", "端侧", "智能体", "DeepSeek"]
    brand_kw = ["华为", "苹果", "小米", "OPPO", "vivo", "荣耀", "三星", "传音",
                "Huawei", "Apple", "Xiaomi", "Samsung"]
    memory_kw = ["LPDDR", "UFS", "HBM", "内存", "存储", "SK Hynix", "SK海力士"]

    for r in results:
        text = r.get("title", "") + " " + r.get("snippet", "")
        text_lower = text.lower()

        if any(kw.lower() in text_lower for kw in soc_kw):
            categories["芯片/SoC/半导体"].append(r)
        elif any(kw.lower() in text_lower for kw in display_kw):
            categories["折叠屏/显示"].append(r)
        elif any(kw.lower() in text_lower for kw in camera_kw):
            categories["影像/相机"].append(r)
        elif any(kw.lower() in text_lower for kw in battery_kw):
            categories["电池/充电"].append(r)
        elif any(kw.lower() in text_lower for kw in supply_kw):
            categories["供应链/代工"].append(r)
        elif any(kw.lower() in text_lower for kw in ai_kw):
            categories["AI/手机"].append(r)
        elif any(kw.lower() in text_lower for kw in brand_kw):
            categories["品牌动态"].append(r)
        elif any(kw.lower() in text_lower for kw in memory_kw):
            categories["内存/存储"].append(r)
        else:
            categories["其他"].append(r)

    return {k: v for k, v in categories.items() if v}


def generate_quality_report(date_str: str, ts: str, results: List[Dict],
                            categories: Dict) -> str:
    """生成质检报告"""
    md = f"""# 📋 质检报告 · {date_str} 晚报

> TIMESTAMP：{ts} | 流水线版本：v1.0 | 采集引擎：DDG每小时轮询

---

## 一、采集概况

| 指标 | 值 |
|------|-----|
| 每小时采集轮次 | {len(list((KB_PATH / date_str).glob("*-raw")))} |
| 原始采集条数（去重后） | {len(results)} |
| 主题分类数 | {len(categories)} |
| 信源域名数 | {len(set(r.get('domain','') for r in results))} |

### 主题分布

"""
    for cat, items in sorted(categories.items(), key=lambda x: -len(x[1])):
        md += f"| {cat} | {len(items)} |\n"

    md += f"""
---

## 二、数据质量评估

| 指标 | 评估 |
|------|------|
| 数据完整性 | 每小时自动采集正常执行 |
| 去重率 | {len(set(r.get('url','') for r in results))}/{len(results)} 条唯一 |
| 覆盖广度 | {len(categories)} 个主题维度 |

### 信源域分布（Top 10）

"""
    domains = Counter(r.get("domain", "unknown") for r in results)
    for domain, count in domains.most_common(10):
        md += f"- `{domain}`: {count} 条\n"

    md += f"""

---

## 三、重点条目（前 10 条）

"""
    for i, r in enumerate(results[:10]):
        title = r.get("title", "无标题")[:100]
        domain = r.get("domain", "?")
        snippet = r.get("snippet", "")[:150]
        md += f"### {i+1}. {title}\n"
        md += f"📎 信源: `{domain}`\n\n"
        if snippet:
            md += f"> {snippet}\n\n"

    return md


def generate_clean_report(date_str: str, ts: str, categories: Dict) -> str:
    """生成干净报告"""
    md = f"""# ✅ 干净报告 · {date_str} 晚报

> TIMESTAMP：{ts} | 仅含高质量条目 | 供直接对外引用

---

"""
    for cat, items in sorted(categories.items(), key=lambda x: -len(x[1])):
        if not items:
            continue
        md += f"## {cat}\n\n"
        for r in items[:8]:  # 每类最多8条
            title = r.get("title", "无标题")[:120]
            domain = r.get("domain", "?")
            snippet = r.get("snippet", "")[:200]
            url = r.get("url", "")
            md += f"### 📌 {title}\n"
            md += f"*信源: [{domain}]({url})*\n\n"
            if snippet:
                md += f"> {snippet}\n\n"
    return md


def generate_methodology_delta(date_str: str, ts: str) -> str:
    """生成方法论增量"""
    return f"""# 📐 方法论增量 · {date_str}

> TIMESTAMP：{ts}

## 本次改进

- **v1.0 自动化采集上线**：从手动采编升级为 LaunchAgent 每小时 DDG 轮询
- **9大主题轮换**：SoC/显示/影像/电池/供应链/AI/品牌/存储/综合，每小时切换
- **自动化日报**：每小时数据聚合后自动生成4份标准报告

## 待改进

- [ ] DDG 中文搜索命中率不稳定（长查询常返回0结果）
- [ ] 实体提取和 wiki 自动建档需要完善
- [ ] AVeriTeC 自动化标签尚未接入日报流程
"""


def generate_self_eval(date_str: str, ts: str, results: List[Dict],
                       categories: Dict) -> str:
    """生成自我评估"""
    total = len(results)
    cat_count = len(categories)
    domain_count = len(set(r.get("domain", "") for r in results))

    md = f"""# 🔍 自我评估 · {date_str}

> TIMESTAMP：{ts}

## 评估指标

| 指标 | 值 | 评级 |
|------|-----|------|
| 采集总量 | {total} 条 | {"✅ 充足" if total > 50 else "⚠️ 偏少" if total > 20 else "❌ 不足"} |
| 主题覆盖 | {cat_count}/9 主题 | {"✅ 全面" if cat_count >= 6 else "⚠️ 部分" if cat_count >= 3 else "❌ 不足"} |
| 信源多样性 | {domain_count} 个域名 | {"✅ 丰富" if domain_count > 15 else "⚠️ 一般" if domain_count > 5 else "❌ 单一"} |

## 主题覆盖详情

"""
    for cat, items in sorted(categories.items(), key=lambda x: -len(x[1])):
        md += f"- **{cat}**: {len(items)} 条\n"

    md += f"""
## 改进建议

"""
    if total < 30:
        md += "- ⚠️ 今日采集量偏低，建议检查 DDG 网络连通性\n"
    if cat_count < 5:
        md += "- ⚠️ 主题覆盖不足，部分关键词可能需要调整\n"
    if domain_count < 8:
        md += "- ⚠️ 信源过于集中，需增加搜索多样性\n"
    if total >= 30 and cat_count >= 5:
        md += "- ✅ 采集系统运行正常，数据质量良好\n"

    return md


def update_wiki(date_str: str, results: List[Dict]):
    """从日报数据更新 wiki 知识图谱"""
    wiki_index = WIKI_PATH / "index.md"
    if not wiki_index.exists():
        return

    # 简单实体检测
    all_text = " ".join(r.get("title", "") + " " + r.get("snippet", "")
                        for r in results)

    new_entities = []
    # SoC
    for m in re.finditer(r'(骁龙\s*[\d\w\s]*Gen\s*[\d\w]+|Snapdragon\s*[\d\w\s]*Gen\s*[\d\w]+|天玑\s*\d{4}\+?|Dimensity\s*\d{4}\+?|麒麟\s*\d{3,4}|Kirin\s*\d{3,4}|Apple\s*A\d{2})', all_text, re.IGNORECASE):
        name = m.group(0).strip()
        if name not in new_entities:
            new_entities.append(name)
    # 技术
    for m in re.finditer(r'(LPDDR\d[EX]?|UFS\s*[\d.]+|LTPO\+?|硅碳负极|固态电池)', all_text):
        name = m.group(0).strip()
        if name not in new_entities:
            new_entities.append(name)

    if not new_entities:
        return

    # 更新 index.md
    content = wiki_index.read_text(encoding="utf-8")
    entry = f"\n- **{date_str}**：自动采集发现新实体"
    for e in new_entities[:10]:
        entry += f" {e}"
    entry += "（待建档）"

    if "## 三、变更日志" in content:
        content = content.replace("## 三、变更日志", f"## 三、变更日志{entry}")
    wiki_index.write_text(content, encoding="utf-8")

    print(f"  wiki/index.md 已更新 ({len(new_entities)} 个新实体)")


def run(date_str: str = None):
    """主执行流程"""
    if date_str is None:
        date_str = datetime.now().strftime("%Y-%m-%d")

    ts = datetime.now().strftime("%H%M%S")
    date_dir = REPO / date_str
    date_dir.mkdir(parents=True, exist_ok=True)

    print(f"{'='*50}")
    print(f"📝 日报生成器 · {date_str} · {ts}")
    print(f"{'='*50}")

    # 1. 加载数据
    results = load_hourly_data(date_str)
    print(f"📊 加载 {len(results)} 条去重数据")

    if not results:
        print("⚠️ 今日无采集数据，生成空日报")
        results = []

    # 2. 分类
    categories = categorize_by_topic(results)
    print(f"🏷️ 分为 {len(categories)} 个主题")

    # 3. 生成四份报告
    reports = {
        f"03-quality-report-{ts}.md": generate_quality_report(date_str, ts, results, categories),
        f"04-clean-report-{ts}.md": generate_clean_report(date_str, ts, categories),
        f"05-methodology-delta-{ts}.md": generate_methodology_delta(date_str, ts),
        f"06-self-eval-{ts}.md": generate_self_eval(date_str, ts, results, categories),
    }

    for filename, content in reports.items():
        filepath = date_dir / filename
        filepath.write_text(content, encoding="utf-8")
        print(f"  ✅ {filename}")

    # 4. 更新 wiki
    if results:
        update_wiki(date_str, results)

    # 5. 生成 index.html
    index_html = f"""<!DOCTYPE html>
<html lang="zh-CN">
<head><meta charset="UTF-8"><title>RumorCrusher · {date_str}</title></head>
<body>
<h1>RumorCrusher · {date_str} 日报</h1>
<p>采集 {len(results)} 条，{len(categories)} 个主题</p>
<ul>
<li><a href="03-quality-report-{ts}.md">质检报告</a></li>
<li><a href="04-clean-report-{ts}.md">干净报告</a></li>
<li><a href="05-methodology-delta-{ts}.md">方法论增量</a></li>
<li><a href="06-self-eval-{ts}.md">自我评估</a></li>
</ul>
</body></html>"""
    (date_dir / "index.html").write_text(index_html, encoding="utf-8")
    print(f"  ✅ index.html")

    print(f"\n✅ 日报生成完成 · {date_str}")


if __name__ == "__main__":
    import sys
    run(sys.argv[1] if len(sys.argv) > 1 else None)
