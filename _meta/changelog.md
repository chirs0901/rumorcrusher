# RumorCrusher Changelog

## 2026-05-30 晚报（RC-20260530-120312）
- **采集**：36条原始采集，9轮搜索，覆盖芯片/显示/存储/折叠屏/电池/供应链
- **AVeriTeC**：Supported=22, CE=7, NEE=5, Refuted=2；综合健康打分78
- **辟谣条目**：
  - 三星Galaxy S26全固态电池声称（汽车电池路线图错误迁移，Refuted，置信度0.80）
  - 三星Galaxy S26自研2nm Exynos（单源无证据推测，Refuted，置信度0.70）
- **新增方法论规则**：
  - R-2026-05-30-01：汽车电池路线图迁移谬误识别
  - R-2026-05-30-02：非官方芯片命名标注规则
  - R-2026-05-30-03：存储价格数据原始来源链要求
  - R-2026-05-30-04：工业传感器≠手机传感器推断
- **Wiki更新**：
  - 新建实体页：`entities/soc/dimensity-9400-plus.md`（天玑9400+建档，DeepSeek-R1-Distill支持）
  - 新建实体页：`entities/soc/apple-a19.md`（iPhone 17 A19芯片建档）
  - 新建技术页：`entities/tech/lytia-brand.md`（索尼LYTIA品牌建档）
  - 更新：`topics/ai-dram-crisis-2026.md`（HBM4挤压LPDDR5X+台积电联盟cHBM新进展）
  - 更新：`topics/tsmc-2nm-supply-2026.md`（苹果>50%产能锁定确认+AMD H2 2026加入）
  - 更新：`wiki/index.md`（新增3实体，2主题更新）
- **知识库**：追加8条（chip×4, display×2, memory×2），知识库总计95条
- **日期校验**：CTX=SCHED=BASH=2026-05-30，三源全部一致，无漂移
- **Git**：仅commit，autopush接管推送

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


## 2026-05-27 晚报（RC-20260527-193256）
- **采集**：30条原始采集，21条进入审核，覆盖芯片/显示/折叠屏/存储/产业链
- **AVeriTeC**：Supported=14, CE=3, NEE=2, Refuted=0；综合健康打分82
- **新增方法论规则**：
  - M-011：供应链"深化合作"标题误导性识别（BOE/iPhone案例触发）
  - M-012：AI产能挤压消费电子系统性追踪框架（三维度分析：产能挤压→BOM→整机）
  - M-013：单一泄露信源分级标注规范（置信度上限0.60）
- **Wiki更新**：
  - 新建实体页：`entities/soc/kirin-2026.md`（华为LogicFolding技术首档）
  - 新建实体页：`entities/brand/boe.md`（京东方OLED供应链首档）
  - 新建技术页：`entities/tech/ltpo-plus.md`（LTPO+技术首档）
  - 更新：`entities/brand/samsung.md`（Z Fold 8发布日期确认+OLED供应）
  - 更新：`topics/foldable-2026.md`（Z Fold 8七月22日四源确认）
  - 更新：`topics/ai-dram-crisis-2026.md`（Q1 DRAM/NAND终版涨幅+BOM+出货量预测）
- **日期校验**：CTX_DATE=2026-05-27；BASH_DATE=2026-05-27；SCHED_DATE=2026-05-28（UTC转CST）→ 以CTX_DATE为准，⚠️ SCHED_DATE轻微漂移
- **Git**：仅commit，autopush接管推送


## 2026-05-29 晚报（RC-20260529-220431）
- **采集**：32条原始采集，28条进入审核，覆盖芯片/显示/折叠屏/存储/AI/电池/产业链
- **AVeriTeC**：Supported=18, CE=5, NEE=4, Refuted=1；综合健康打分83
- **首次辟谣条目**：E-031（台积电2nm三大品牌"同期发布"→Refuted，发布时差实为1-3个月）
- **新增方法论规则**：
  - M-014：多厂"同期"发布声明核查规范（4周阈值标准）
- **Wiki更新**：
  - 新建实体页：`entities/soc/snapdragon-8-elite-gen6.md`（骁龙8 Elite Gen 6首档）
  - 新建实体页：`entities/soc/dimensity-9600.md`（天玑9600规格补充建档）→ 已存在则更新
  - 新建技术页：`entities/tech/ufcs-2.md`（UFCS 2.0标准首档）
  - 更新：`entities/brand/boe.md`（iPhone 18 Pro出局+Galaxy S27竞标新进展）
  - 更新：`entities/brand/samsung.md`（重夺iPhone 18 Pro OLED+Galaxy S27发布窗口）
  - 更新：`entities/brand/apple.md`（iPhone 18 A20 WMCM封装+2nm产能锁定）
  - 更新：`topics/ai-dram-crisis-2026.md`（HBM3E售罄确认+LPDDR5价格涨幅20%）
  - 更新：`topics/foldable-2026.md`（moto razr fold发布确认+小米MIX Trifold认证）
- **日期校验**：CTX=BASH=SCHED=2026-05-29，三源一致，无漂移
- **Git**：仅commit，autopush接管推送
