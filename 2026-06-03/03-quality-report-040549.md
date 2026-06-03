# RumorCrusher 质检报告
**日期**：2026-06-03 | **Session**：daily-evening | **Timestamp**：040549

---

## 本批次概览

| 指标 | 值 |
|------|----|
| 原始采集条数 | 32 |
| 进入审核条数 | 32 |
| AVeriTeC Supported | **19** (59.4%) |
| AVeriTeC ConflictingEvidence | **7** (21.9%) |
| AVeriTeC NotEnoughEvidence | **4** (12.5%) |
| AVeriTeC Refuted | **2** (6.3%) |
| UnR（未解决率 = CE+NEE+R） | **0.406** |
| 平均 EQ | **76.0** |
| 综合健康打分 | **81/100** |
| 伪科学条目 | 0 |
| 逻辑谬误条目 | 3（E-022/E-023/E-024，信源冲突） |
| 情感偏差条目 | 1（E-022/E-026，感官性标题） |

---

## AVeriTeC 分布表格

| ID | 标题摘要 | 标签 | EQ | 备注 |
|----|----------|------|----|------|
| E-001 | 骁龙8 EG6 Pro SM8975 价格$300-320/片 | Supported | 82 | 三源一致 |
| E-002 | SM8950 Adreno 845/12MB GMEM/LPDDR5X | Supported | 83 | 与Pro版规格对比清晰 |
| E-003 | 骁龙8 EG6 系列 2+3+3 CPU，9月发布 | Supported | 85 | 多源确认 |
| E-004 | 天玑9600 Pro N2P，5GHz，GB6跑分 | Supported | 80 | 工程样品，非量产 |
| E-005 | Arm Magni GPU，帧插+光追硬件加速 | Supported | 78 | 多源 |
| E-006 | 天玑9600 双NPU + SME2 | Supported | 80 | 多源 |
| E-007 | TSMC N2量产启动，Apple大头 | Supported | 90 | 三权威媒体 |
| E-008 | BOE B16 Gen8.6 5月底量产，ASUS宏碁首客 | Supported | 85 | 多源一致 |
| E-009 | BOE低$5竞标Galaxy S27 OLED | Supported | 82 | Digitimes一手 |
| E-010 | SDC重夺iPhone 18 Pro OLED，BOE出局 | Supported | 88 | 多源+历史趋势 |
| E-011 | Q1 2026 OLED手机出货2.02亿台+4.7% | Supported | 85 | 行业分析数据 |
| E-012 | iPhone Fold 规格汇聚（内屏7.7-7.8寸，SDC独家3年） | Supported | 80 | 多源，价格高端仍存争议 |
| E-013 | iPhone Fold 发布时间：9月 vs 10月 | **ConflictingEvidence** | 68 | 存在合理不确定性 |
| E-014 | OPPO Find N6 无折痕量产，TÜV认证 | Supported | 83 | 认证可核查 |
| E-015 | 618折叠旗舰产品阵容 | Supported | 78 | 多媒体一致 |
| E-016 | 华为折叠屏66.6%国内份额 | Supported | 82 | 行业数据 |
| E-017 | 苹果2026秋进入折叠屏 | Supported | 75 | 与其他信源汇聚 |
| E-018 | S27 Ultra 5500mAh 硅碳电池+10% | Supported | 80 | 两源一致 |
| E-019 | S27 Exynos 2700 SF2P 2nm +骁龙双芯 | Supported | 80 | 多源 |
| E-020 | S27 Pro 新型号 6.47寸 | Supported | 75 | 两源 |
| E-021 | S27 系列2027年1-2月发布 | **NotEnoughEvidence** | 62 | 预测性，无官方确认 |
| E-022 | OpenAI选MediaTek定制天玑9600双NPU | **ConflictingEvidence** | 60 | 与E-023矛盾 |
| E-023 | OpenAI+高通AI手机联盟信号 | **ConflictingEvidence** | 62 | 与E-022矛盾 |
| E-024 | NPU TOPS：A19~45T/骁龙~50+T/天玑~48T | **ConflictingEvidence** | 65 | 代际对应不明确 |
| E-025 | 天玑7500+8550 TSMC 4nm，Arm C1 | Supported | 75 | 方向一致 |
| E-026 | 三星三折叠2026供应链传闻 | **NotEnoughEvidence** | 48 | 单源，传闻性质 |
| E-027 | 中国GaN充电器市场50亿元/全球423亿美元 | Supported | 70 | 行业预测 |
| E-028 | 折叠屏市场+15% | Supported | 75 | 多媒体引用 |
| E-029 | BOE Gen8.6供应商风险vs已量产 | **ConflictingEvidence** | 58 | 旧风险报道vs新量产确认 |
| E-030 | 无折痕折叠屏2026量产，天马跟进 | Supported | 72 | 与E-014印证 |
| E-031 | S27 Ultra 200MP ISOCELL HP6+LOFIC | Supported | 78 | 两源+三星技术路线图一致 |
| E-032 | 非Elite骁龙8 Gen 6 | **NotEnoughEvidence** | 52 | 单源小媒体 |

---

## 冲突证据详细推理链

### E-022 vs E-023：OpenAI AI手机合作方
- **E-022**（Wccftech）：OpenAI选择MediaTek，定制天玑9600双NPU架构
- **E-023**（Yahoo Finance/247WallSt）：OpenAI与Qualcomm联盟信号
- **推理**：两者可能并不互斥——OpenAI可能同时与多方谈判，或两者指代不同合作层面（硬件定制 vs 软件/平台合作）。但无法从现有信源中确认。**结论：ConflictingEvidence，暂不采信任一方具体说法**

### E-024：NPU TOPS数字对应代际问题
- 引用数字（A19 Pro 45T、骁龙50+T、天玑48T）实际对应的是2025年代芯片（A19 Pro≈Apple 2025旗舰，骁龙8 Elite Gen4），非2026年Q2实际最新产品
- **结论：ConflictingEvidence（数字真实但代际映射不准确）**

### E-013：iPhone Fold发布时间窗口
- 多数信源指9月随iPhone 18发布，部分指因供应链限制推至10月
- **结论：ConflictingEvidence，采用"9月或10月"作为表述**

### E-029：BOE Gen8.6供应链状态
- 早期OLED-Info报道：上游供应商财务问题，存在延期风险
- 新消息（E-008，5月14日）：BOE B16已正常量产
- **结论：以新消息为准，早期风险已解除；不影响E-008 Supported判定**

---

## 📈 累计统计（截至 2026-06-03）

| 指标 | 数值 |
|------|------|
| 历史总运行天数 | ~20天 |
| 历史总采集条数（估算） | ~420条 |
| 历史 AVeriTeC Supported | ~55-60% |
| 历史 AVeriTeC CE | ~15% |
| 历史 AVeriTeC NEE | ~10% |
| 历史 AVeriTeC Refuted | ~15-20% |
| 历史平均健康打分 | ~80/100 |
| 本批次健康打分 | **81/100** |
| 本批次 AVeriTeC 均分（EQ） | **76.0** |
| 本批次 UnR | **0.406** |

