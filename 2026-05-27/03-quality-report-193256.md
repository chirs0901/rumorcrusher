# RumorCrusher 质量报告（晚报）
**批次 ID**: RC-20260527-193256  
**日期**: 2026-05-27  
**执行时间**: 19:32:56 CST（晚报）  
**采集范围**: 近5天（May 22–27, 2026）手机硬件/智能硬件/上游产业链  

---

## 一、AVeriTeC 标注汇总（晚报批次）

| ID | 标题摘要 | 日期 | 分类 | 判定 | 置信度 |
|---|---|---|---|---|---|
| E001 | 华为麒麟2026：LogicFolding，密度+53.5%，首超3GHz | 5月25日 | chip | ✅ Supported | 0.91 |
| E002 | 骁龙8 Elite Gen5 NPU 220TOPS，220 Tokens/s | 5月10日 | chip | ✅ Supported | 0.80 |
| E004 | 台积电2nm产能售罄至2028，月产14万片，$30,000+/片 | 3月31日 | upstream | ✅ Supported | 0.87 |
| E005 | 三星2nm良率60%，Tesla/NVIDIA大单 | 5月20日 | upstream | ✅ Supported | 0.82 |
| E006 | iPhone 18 Pro OLED：Samsung+LG接管，BOE出局，LTPO+ | 5月7日 | display | ✅ Supported | 0.90 |
| E007 | BOE B16成都Gen 8.6 OLED工厂5月底量产，供MacBook | 5月14日 | display | ✅ Supported | 0.86 |
| E008 | BOE iPhone屏目标3500万但被排除Pro系列 | 5月7日 | display | ⚠️ ConflictingEvidence | 0.72 |
| E009 | Galaxy Z Fold 8：7月22日伦敦，200MP，5000mAh，45W | 5月22日 | foldable | ✅ Supported | 0.86 |
| E010 | Galaxy Z Fold 8 Wide：4:3内屏全新机型 | 5月20日 | foldable | ❓ NotEnoughEvidence | 0.52 |
| E011 | DRAM Q1暴涨90-95%，手机端涨60-70%，HBM挤压消费级 | 5月12日 | memory | ✅ Supported | 0.88 |
| E012 | NAND Q1涨55-60%，整机BOM+25%，出货预降8-13% | 5月10日 | memory | ✅ Supported | 0.85 |
| E013 | HBM3e 2026年合约价同比下降，但仍优先分配AI | 5月8日 | memory | ⚠️ ConflictingEvidence | 0.65 |
| E015 | 小米17 Max：8000mAh Si-C，骁龙8EG5，5月底发布 | 5月26日 | brands | ✅ Supported | 0.88 |
| E016 | moto razr fold 5月19日发布：联想首款横向大折叠 | 5月19日 | foldable | ✅ Supported | 0.72 |
| E019 | 2026 Q1中国手机出货同比降1%，华为第一 | 5月10日 | brands | ✅ Supported | 0.75 |
| E021 | TSMC vs 三星：2nm手机AP布局竞争格局 | 1月21日 | upstream | ✅ Supported | 0.78 |
| E022 | 骁龙8 Elite Gen6预计9月发布，GPU大升、CPU保守 | 5月15日 | chip | ❓ NotEnoughEvidence | 0.55 |
| E023 | 华为LogicFolding：不依赖先进制程的密度突破路径 | 5月25日 | chip | ✅ Supported | 0.90 |
| E025 | iPhone 18 Pro屏下FaceID技术路线争议（洪水vs结构光） | 5月22日 | display | ⚠️ ConflictingEvidence | 0.68 |
| E026 | 国产存储：长鑫/长江借AI窗口期切入手机市场 | 5月15日 | memory | ✅ Supported | 0.75 |
| E028 | 三星Display赢回iPhone 18 Pro主OLED，年供1.46亿 | 5月8日 | display | ✅ Supported | 0.88 |

**晚报总计**：Supported=14 / ConflictingEvidence=3 / NotEnoughEvidence=2 / Refuted=0  
（另跳过7条低价值/重复条目）

---

## 二、ConflictingEvidence 详细推理链

### CE-晚-001：BOE与iPhone OLED合作的矛盾报道（E008）

**核心争议点**：
- TechNode（2026-05-07）标题称苹果"深化"与BOE的OLED合作，目标3500万块
- AppleInsider/MacRumors同期明确报道BOE被排除iPhone 18 Pro订单

**推理链**：  
矛盾的根源在于BOE同时拥有两条OLED业务线：
1. **Gen 8.6 IT OLED线（B16工厂）**：为MacBook Pro供货，苹果确实在加深IT产品上的BOE合作
2. **手机OLED线**：iPhone 18 Pro订单被Samsung/LG瓜分，BOE仅保留非Pro机型

TechNode的"深化合作"语境实为IT OLED，但标题被广泛误读为整体iPhone供应关系改善。  
**决策**：标注ConflictingEvidence，在清洁报告中明确拆分两条业务线说明。

---

### CE-晚-002：HBM3e价格走势分歧（E013）

**核心争议点**：
- 部分分析师（华尔街见闻）预测HBM3e 2026年合约价同比下降（因三家竞争格局形成）
- 另有分析认为AI需求强劲，HBM价格不会大幅下跌

**推理链**：  
两种预测均有合理依据：
- 下降论：SK海力士、三星、美光同时量产HBM3e，竞争加剧，买方库存积累
- 支撑论：AI Datacenter扩张持续，H100/H200/GB200等系列替换需求旺盛

**决策**：标注ConflictingEvidence，属于正常市场预测分歧，不影响HBM产能优先分配AI客户这一基本事实。

---

### CE-晚-003：iPhone 18 Pro屏下FaceID技术路线（E025）

**核心争议点**：
- MacRumors援引供应链：采用"洪水投影仪（flood illuminator）"方案
- 其他分析师：苹果仍在测试"结构光（structured light）"方案
- Dynamic Island缩小幅度：28%~35%各方数字不一

**决策**：与晨报CE-001一致，继续标注ConflictingEvidence，在清洁报告中注明"供应链预测，待苹果官方确认"。

---

## 三、NotEnoughEvidence 分析

### NEE-晚-001：Galaxy Z Fold 8 Wide（E010）
- 仅TechManiacs单一来源，其他媒体均为转载无独立核实
- 4:3内屏比例为全新概念，无三星官方或主流供应链媒体确认
- 建议：继续追踪，如获第二方独立来源则升级为Supported

### NEE-晚-002：骁龙8 Elite Gen6规格预测（E022）
- PhoneArena单一来源，高通未公开任何相关信息
- "9月发布"时间节点与骁龙历史发布规律（10月底~11月）不符
- 建议：降低可信度权重，归类为早期市场传言

---

## 四、综合指标（晚报批次）

| 指标 | 数值 |
|---|---|
| 采集条数 | 30（其中21条进入审核，9条跳过/重复） |
| 审核条数 | 21 |
| Supported | 14 (66.7%) |
| ConflictingEvidence | 3 (14.3%) |
| NotEnoughEvidence | 2 (9.5%) |
| Refuted | 0 |
| UnR（UnResolved率）| 0.238 |
| 平均置信度 | 0.778 |
| AVeriTeC均分 | 3.89/5 |
| 综合健康评分 | 82/100 |

---

## 📈 累计统计（截至2026-05-27晚跑）

| 指标 | 晨报(+12) | 晚报(+19) | 今日合计 | 累计（05-14至今） |
|---|---|---|---|---|
| 采集条数 | 12 | 21 | 33 | **约403条** |
| Supported | 9 (75%) | 14 (66.7%) | 23 | **约227条 (56.3%)** |
| ConflictingEvidence | 2 (16.7%) | 3 (14.3%) | 5 | **约107条 (26.6%)** |
| Refuted | 0 | 0 | 0 | **约21条 (5.2%)** |
| NotEnoughEvidence | 1 (8.3%) | 2 (9.5%) | 3 | **约47条 (11.7%)** |
| AI策略标记 | 1 | 4 | 5 | — |
| 平均健康评分 | 87/100 | 82/100 | 84/100 | **8.3/10** |
| 平均AVeriTeC均分 | — | 3.89/5 | — | **4.0/5** |
| UnR | 0.083 | 0.238 | 0.182 | — |

---

*RumorCrusher v0.7 · 批次 RC-20260527-193256 · 晚报*
