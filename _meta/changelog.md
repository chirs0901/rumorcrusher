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
## 2026-05-31 手动补跑（晨跑session卡死补救）
- 采集20条，Supported 14，Refuted 1（小米MiMo时间归因错误）
- tech-digest 新增6条：三星Unpacked/骁龙天玑跑分/三星5000nit OLED/天马无痕折叠屏/超轻泡沫VC/存储BoM超20%
- 问题记录：07:05 晨跑session (local_1ced4167) 卡死3+小时，原因疑为凌晨网络断连导致WebSearch超时
## 2026-06-03 晚报（22:00 Run, Timestamp=040549）
- **采集**：32条原始采集，8轮 WebSearch，覆盖芯片/显示/折叠屏/AI/电池/产业链
- **AVeriTeC**：Supported=19, CE=7, NEE=4, Refuted=2；综合健康打分81
- **主要核查发现**：
  - 骁龙8 EG6 Pro（SM8975）完整规格确认：Adreno 850/18MB GMEM/LPDDR6/$300-320（Supported）
  - 天玑9600 Pro完整规格：TSMC N2P/5GHz/Arm Magni GPU/双NPU+SME2/LPDDR6（Supported，工程样品）
  - TSMC N2量产2025Q4确认，Apple大头，Fab22高雄主产（Supported，高权威）
  - BOE B16 Gen8.6 5月底量产，比计划提前1个月以上，ASUS/宏碁首客（Supported）
  - iPhone Fold多源汇聚：书本式/7.7-7.8寸/SDC独家3年OLED/1100万片/$2000+/Touch ID（Supported）
  - OPPO Find N6无折痕量产+TÜV莱茵认证+60万次折叠（Supported）
  - OpenAI AI手机合作方冲突：MediaTek(Wccftech) vs Qualcomm(Yahoo Finance)，标注CE
- **新增方法论规则**：
  - M-015：多方合作声明交叉核查规范（OpenAI/MediaTek/Qualcomm案例）
  - M-016：NPU TOPS数字代际核查规范
- **Wiki更新**：
  - 更新：`entities/soc/snapdragon-8-elite-gen6.md`（Pro版规格补全：Adreno 850/18MB GMEM/LPDDR6）
  - 更新：`entities/soc/dimensity-9600.md`（Arm Magni GPU/双NPU+SME2/OpenAI合作传闻CE）
  - 更新：`entities/brand/boe.md`（B16 Gen8.6量产确认/S27竞标最新进展）
  - 更新：`entities/brand/samsung.md`（S27 Exynos 2700+骁龙双芯/Ultra硅碳电池/SDC iPhone Fold独家）
  - 更新：`entities/brand/apple.md`（iPhone Fold多源汇聚/TSMC N2大头）
  - 更新：`topics/foldable-2026.md`（iPhone Fold书本式确认/OPPO N6里程碑/折叠屏+15%市场）
  - 更新：`topics/tsmc-2nm-supply-2026.md`（N2量产确认+三大2nm旗舰芯片对比）
  - wiki/index.html：追加6个实体信源历史行，更新footer日期至2026-06-03
- **知识库**：新增8条（chip×3/display×2/brands×2/ai×1，含1条CE辟谣条目），总计约112条
- **日期校验**：CTX=BASH=SCHED=2026-06-03，三源一致，无漂移
- **Git**：仅commit，autopush接管推送
