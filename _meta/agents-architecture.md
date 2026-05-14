# 多 Agent 架构说明

> RumorCrusher 的"审核委员会"由多个独立 Agent 组成，每个 Agent 有清晰职责和输出契约。这份文档既是给我（执行者）的提示模板源，也是给你（项目主人）的可读架构图。

## 流水线总览

```
              ┌──────────────────────┐
              │  ① Collector Agent   │  采集（中/英/官方/学术/视频元信息）
              └──────────┬───────────┘
                         ▼
              ┌──────────────────────┐
              │   01-raw/items.json  │  原始素材池
              └──────────┬───────────┘
                         ▼
   ┌─────────────────────┼─────────────────────┐
   ▼                     ▼                     ▼
┌────────┐         ┌──────────┐         ┌──────────┐
│ Fact   │         │  Pseudo  │         │  Logic   │      ┌──────────┐
│ Check  │         │  Science │         │ Coherence│  +   │ Sentiment│
│ Agent  │         │  Agent   │         │  Agent   │      │ /Values  │
└───┬────┘         └────┬─────┘         └────┬─────┘      └────┬─────┘
    │                   │                    │                  │
    └───────┬───────────┴────────────────────┴──────────────────┘
            ▼
   ┌────────────────────────┐
   │ 02-annotations/*.json  │   各Agent的判定 + 证据链
   └────────────┬───────────┘
                ▼
   ┌────────────────────────┐
   │  ② Synthesizer Agent   │   综合判定（采纳/有问题/边缘）
   └────────────┬───────────┘
                ▼
   ┌────────────────────────────────────────┐
   │   ③ Report Writer Agent (双输出)        │
   ├────────────────────────────────────────┤
   │   • 03-quality-report.md (问题清单)    │
   │   • 04-clean-report.md   (干净分析)    │
   │   • 05-methodology-delta.md (新方法论) │
   └────────────┬───────────────────────────┘
                ▼
   ┌────────────────────────┐
   │  ④ Flywheel Agents     │
   ├────────────────────────┤
   │  • Skill Updater       │  追加新方法论到 skills/
   │  • Wiki Updater        │  合并干净内容到 wiki/
   │  • Visualizer (HTML)   │  生成 index.html 仪表盘
   │  • Notifier (飞书)     │  推送完成通知
   │  • Publisher (git)     │  推送到 GitHub Pages
   └────────────────────────┘
```

## 各 Agent 的输入输出契约

### ① Collector
- 输入：`_meta/source-list.yaml`, 当日日期
- 输出：`01-raw/items.json`（统一schema）
- 约束：每条素材必须有 url, title, source_id, fetched_at, raw_text/summary

### Fact-Check Agent
- 输入：`01-raw/items.json`, `_meta/source-list.yaml`
- 输出：`02-annotations/fact-check.json`
- 单条判定字段：`{item_id, claims[], verifications[], verdict: pass/warn/fail, confidence, evidence_urls[]}`

### Pseudo-Science Agent
- 输入：`01-raw/items.json`, `skills/pseudoscience-patterns.md`
- 输出：`02-annotations/pseudo-science.json`
- 判定字段：`{item_id, matched_patterns[], severity: low/med/high, explanation}`

### Logic Coherence Agent
- 输入：`01-raw/items.json`, `skills/logical-fallacy-catalog.md`
- 输出：`02-annotations/logic.json`
- 判定字段：`{item_id, fallacies[], internal_contradictions[]}`

### Sentiment/Values Agent
- 输入：`01-raw/items.json`
- 输出：`02-annotations/sentiment.json`
- 判定字段：`{item_id, clickbait_index, divisive: bool, value_concerns[]}`

### ② Synthesizer
- 输入：所有 02-annotations/*.json
- 输出：`02-annotations/synthesis.json`
- 综合判定规则：
  - 任一 Agent 给 fail → 综合 fail（进质检报告，不进干净报告）
  - 多个 warn → 进质检报告但同时进干净报告（带warning标注）
  - 全部 pass → 进干净报告

### ③ Report Writer
- 输入：synthesis.json + 原始素材
- 输出：双报告 + methodology-delta

### ④ Flywheel
- Skill Updater: 把 methodology-delta 合并进 `skills/*.md`
- Wiki Updater: 抽取干净报告中的实体/主题，更新 `wiki/`
- Visualizer: 生成 `index.html` 仪表盘
- Notifier: POST 到飞书
- Publisher: `git add . && git commit && git push`

## 失败处理

- 任何 Agent 失败：保留中间产物到 `02-annotations/.tmp/`，报告里附"本日有X个Agent未完成"提示
- git push 失败：保留产物，下次运行时重试
- 飞书推送失败：写入 `_meta/notify-failures.log`，不影响产物
