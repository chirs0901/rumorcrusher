# RumorCrusher · 粉碎谣言，侦测事实真伪

> 一个全自动运行的手机硬件类资讯**事实核查 + 知识沉淀**系统。
> 每天 05:00（早班）和 22:00（晚班）自动采集中英文多源内容，由多 Agent 审核委员会完成事实核查、伪科学检测、逻辑一致性分析、情感/价值观过滤，产出双份报告并驱动知识飞轮持续沉淀。

**公开地址：** [`https://chirs0901.github.io/rumorcrusher/`](https://chirs0901.github.io/rumorcrusher/)

---

## 核心价值

| 维度 | 说明 |
|------|------|
| 📰 新闻时效性 | **只采集近 3–5 天发布的新闻**，宁缺毋滥，拒绝以旧充新 |
| 🔍 多维核查 | 事实 / 伪科学 / 逻辑谬误 / 情感价值观，四审叠加 |
| 🏷 AVeriTeC 标签 | Supported / ConflictingEvidence / Refuted / NotEnoughEvidence |
| 🧠 知识积累 | 每日产出喂入知识飞轮，方法论和实体图谱持续成长 |
| 🌐 公开透明 | 所有核查报告和知识库部署至 GitHub Pages，可公开访问 |
| 💬 实时检测 | **新增交互式谣言检测器**，用户可随时提交声称进行验证 |

---

## 每日工作流程

```
每天 05:00（早班）& 22:00（晚班）自动触发
                    ↓
  ① Collector Agent — 采集近 3–5 天中英文资讯
     信源：科技媒体 / OEM 官方 / 学术预印本 / 视频元信息
     铁律：发布日期超过 5 天的内容一律丢弃
                    ↓
  ② Check-Worthiness Filter — 对每条素材打 0~1 可查证分
     高分 → 全量四 Agent 审核
     中分 → 事实 + 逻辑两 Agent 审核
     低分 → 仅记录存档
                    ↓
  ③ 审核委员会（四 Agent 并行）
     • Fact-Check Agent     — 交叉信源验证 + 时序追问（TSVer）
     • Pseudo-Science Agent — 对照伪科学模式库检测
     • Logic Coherence Agent— 识别逻辑谬误 + 内部矛盾
     • Sentiment/Values Agent — 标注标题党、煽动性表达
                    ↓
  ④ Synthesizer Agent — 综合判定
     任一 fail → 进质检报告（不进干净报告）
     多个 warn → 双报告均收录（干净版带 warning 标注）
     全 pass   → 仅进干净报告
                    ↓
  ⑤ Report Writer — 写入当日目录
     03-quality-report.md   问题内容清单 + 证据链
     04-clean-report.md     剔除问题后的洞察分析
     05-methodology-delta.md 本次发现的新核查方法
     06-self-eval.md        AVeriTeC 标签分布 / UnR 率 / 质量评分
                    ↓
  ⑥ 知识飞轮 Agents
     • Skill Updater  → 追加新方法论到 skills/
     • Wiki Updater   → 更新实体图谱 wiki/ 及 wiki/index.html
     • KB Updater     → 将干净报告推入 knowledge-base/index.html
     • Visualizer     → 生成/刷新 tech-digest/index.html 日报汇总
     • Publisher      → git commit + push 到 GitHub Pages
```

---

## 目录结构

```
RumorCrusher/
├── README.md                        # 本文件
├── index.html                       # 项目入口（GitHub Pages 首页）
├── rumor-detector.html              # 💬 实时谣言检测器（交互式界面）
│
├── tech-digest/
│   └── index.html                   # 📰 每日资讯汇总（按日期倒序）
│
├── knowledge-base/
│   └── index.html                   # 🗂 可浏览知识库（7 大品类过滤）
│                                    #   brands / chip / display / battery
│                                    #   thermal / memory / ai
│
├── wiki/
│   ├── index.html                   # 🧠 LLM 知识图谱可视化（实体 + 话题）
│   ├── entities/
│   │   ├── soc/                     # 芯片实体（骁龙/天玑/麒麟/A系列…）
│   │   ├── brand/                   # 品牌实体（苹果/三星/华为/联发科…）
│   │   └── tech/                    # 技术实体（硅碳负极/均热板…）
│   └── topics/                      # 行业话题文件（供应链/影像战…）
│
├── skills/                          # ⚙️ 核查技能库（飞轮①）
│   ├── fact-check-playbook.md       # 核查通用手册
│   ├── pseudoscience-patterns.md    # 伪科学模式库
│   ├── logical-fallacy-catalog.md   # 逻辑谬误目录
│   ├── source-credibility.md        # 信源可信度分级
│   ├── date-triple-source-fallback.md # 日期三源校验方法
│   ├── oem-codename-disambiguation.md # OEM 代号消歧手册
│   ├── foundry-competition-tracker.md # 晶圆代工竞争追踪
│   ├── apple-foldable-tracker.md    # 苹果折叠屏追踪
│   └── pseudoscience-patterns.md    # 伪科学模式库
│
├── _meta/
│   ├── scope.md                     # 采集范围定义（含明确排除清单）
│   ├── agents-architecture.md       # 多 Agent 架构图 + 输入输出契约
│   └── source-list.yaml             # 信源清单（含可信度分级）
│
├── scripts/                         # 历史脚本 / 任务注册文档
│   ├── rumor_detector_api.py        # 💬 谣言检测器 API 服务器
│   ├── start-rumor-detector.sh      # 💬 启动谣言检测器
│   ├── RUMOR-DETECTOR-README.md     # 💬 谣言检测器详细文档
│   ├── install-scheduled-tasks.sh   # 定时任务安装脚本
│   ├── test-scheduled-tasks.sh      # 定时任务测试脚本
│   └── SCHEDULED-TASKS-GUIDE.md     # 定时任务配置指南
│
└── YYYY-MM-DD/                      # 每日产出目录（自动创建）
    ├── 03-quality-report-*.md       # 问题内容清单
    ├── 04-clean-report-*.md         # 干净洞察报告
    ├── 05-methodology-delta-*.md    # 新方法论
    └── 06-self-eval-*.md            # 自评估
```

---

## 采集范围（核心）

**优先采集：**
- SoC / 芯片：高通、联发科、苹果 A/M 系列、麒麟、Exynos、谷歌 Tensor
- 影像系统：CMOS 传感器、ISP、计算摄影
- 显示屏幕：OLED / Micro-OLED / Mini-LED
- 电池与快充：硅碳负极、快充协议
- 半导体制造：台积电 / 三星代工 / 中芯国际，工艺节点进展
- 面板与供应链：BOE / 三星显示 / LPDDR / HBM 动态
- AI 端侧硬件：NPU、大模型手机适配

**明确排除：** 纯软件评测、手游、政治地缘、人物私生活、与硬件无关的财经八卦

---

## 质量控制指标

| 指标 | 目标区间 |
|------|---------|
| Unknown Rate (UnR) | 5% – 25% |
| avg explanation_quality | ≥ 3.5 / 5 |
| TSVer 时序触发比例 | 记录，不设硬性上限 |
| 新闻时效窗口 | ≤ 5 天（铁律，不可绕过） |

---

## 💬 实时谣言检测器（新功能）

RumorCrusher 现在提供**交互式谣言检测服务**，用户可以随时提交任何声称进行验证。

### 快速开始

```bash
# 1. 启动 API 服务器
bash scripts/start-rumor-detector.sh

# 2. 在浏览器中打开
open rumor-detector.html
```

### 功能特点

- 🔍 **智能搜索**：支持自然语言输入，提供热门示例
- 📚 **双源检索**：优先检索本地知识库，不足时自动网络搜索
- 🤖 **多Agent审核**：Fact-Check + Pseudo-Science + Logic Coherence 三重验证
- 📊 **可视化结果**：明确的判定（真实/谣言/证据不足）+ 置信度评分
- 📝 **详细报告**：各Agent独立报告 + 证据摘要 + 参考信源

### 使用示例

```
输入：iPhone 18将搭载固态电池
输入：天玑9600 GPU性能超越A20 Pro
输入：台积电2nm产能被苹果独占50%
```

系统会自动：
1. 检索本地知识库和Wiki图谱
2. （如需要）执行网络搜索采集信息
3. 通过三Agent审核委员会深度验证
4. 给出最终判定和置信度

详细文档请参考：[scripts/RUMOR-DETECTOR-README.md](scripts/RUMOR-DETECTOR-README.md)

---

## 定时任务

### macOS LaunchAgent 配置（✅ 已激活）

RumorCrusher 使用 macOS LaunchAgent 实现自动化定时任务：

| 任务名 | 时间 | 频率 | 说明 |
|--------|------|------|------|
| `com.rumorcrusher.morning` | 每天 05:00 | 每日 | 早班采集，覆盖隔夜境外科技媒体更新 |
| `com.rumorcrusher.evening` | 每天 22:00 | 每日 | 晚班采集，覆盖国内当日媒体动态 |
| `com.rumorcrusher.autopush` | - | 每5分钟 | 自动检测并推送未同步的 commits |

**安装命令：**
```bash
cd /Users/zhiqiao/Documents/Qoder/RumorCrusher-qoder
bash scripts/install-scheduled-tasks.sh
```

**验证状态：**
```bash
launchctl list | grep rumorcrusher
```

**查看日志：**
```bash
tail -f _meta/morning-stdout.log   # 晨跑日志
tail -f _meta/evening-stdout.log   # 晚跑日志
tail -f _meta/autopush.stdout.log  # 推送日志
```

详细配置说明请参考：[scripts/SCHEDULED-TASKS-GUIDE.md](scripts/SCHEDULED-TASKS-GUIDE.md)

### 任务工作流程

两个班次任务共享同一套 SKILL.md 工作流，产出写入对应日期目录，完成后自动 git push 到 GitHub Pages。

**注意：** 当前的任务脚本 (`morning-task.sh` / `evening-task.sh`) 是框架版本，包含 TODO 标记。需要根据实际的 Agent 实现来填充具体的执行逻辑。详见 [scripts/TIMED-TASKS-FIX-REPORT.md](scripts/TIMED-TASKS-FIX-REPORT.md)。

---

## 项目方

- 负责人：Croesuszn Perrygi
- GitHub：[@chirs0901](https://github.com/chirs0901)
- 启动日期：2026-05-14
- 当前版本：v0.8（2026-05 · 双班次 + 新闻时效铁律）
