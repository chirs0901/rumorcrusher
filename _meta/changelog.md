# RumorCrusher Changelog

## 2026-05-24 · 05:05 CST 晨跑（v0.5）

- 首次会话化产出，仓库以 session outputs 作为 fallback
- 采集 32 条；Supported 23 / Refuted 2 / NotEnoughEvidence 4 / ConflictingEvidence 3
- 健康打分 78.4
- 新增 skills/date-triple-source-fallback.md
- 新增 skills/oem-codename-disambiguation.md
- 新增 wiki/2026-display-supply-chain.md
- 日期校验异常：CTX_DATE=2026-05-23 ≠ SCHED_DATE=2026-05-24（bash 时钟 -7h 漂移已知），采用 SCHED_DATE

## 2026-05-24 · 22:00 CST 晚跑（v0.5）

- 采集 27 条；4-Agent 评估 20 条 → Supported 13 / Refuted 2 / NotEnoughEvidence 1 / ConflictingEvidence 4
- 健康打分 78
- 日期三源校验：CTX_DATE / SCHED_DATE / BASH_DATE 三源一致 = 2026-05-24，无漂移告警
- 新增 skills/pseudoscience-patterns.md 三条规则：
  - node_naming_oversimplification（节点命名过度简化）
  - radiation_2B_misread（IARC 2B 误读）
  - nightly_charge_legacy_panic（充电过夜陈年恐慌）
- 强辟谣输出：手机辐射致癌（E-014）、充电过夜炸机（E-015）推入科技简报"辟谣"卡片
- 持续关注：京东方 LTPO 良率事件、台积电 2nm 良率波动、英伟达/高通 2nm 分流传闻
- Git：仅 commit，autopush 接管推送

