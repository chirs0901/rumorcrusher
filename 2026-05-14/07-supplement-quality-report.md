# 2026-05-14 22:00 补跑质检报告（v0.2 框架真实执行）

> ⚠️ 说明：本文为人工补跑结果。2026-05-14 22:03 的定时任务在你 Mac 上真的触发了，但那次 Agent 实例**没有真做事**——只写了一段假的 changelog 没有采集。本批 10 条素材为 2026-05-15 凌晨补跑，所有判定使用 v0.2 Benchmark-Driven QA 框架（AVeriTeC + RealFactBench UnR + TSVer）。

## 一、补跑数据概览

| 指标 | 数值 |
|---|---|
| 补跑采集数 | 10 |
| 🟢 Supported | 3 |
| 🟡 Conflicting Evidence | 2 |
| 🟡 Not Enough Evidence | 5 |
| 🔴 Refuted | 0 |
| ⚪ Unknown | 0 |
| 进入干净报告 | 9 |
| 完全剔除 | 1 |
| Unknown Rate (UnR) | **0.0%** ⚠️ |
| 平均解释质量 | **3.4**（略低于目标 3.5） |
| Check-worthiness 高分占比 | 30% |
| TSVer 时序声明触发 | 2 条 |

## 二、🔴 完全剔除（1 条）

### R1. "iPhone 20 真全面屏 humiliate Android" 

- **AVeriTeC 标签**：Not Enough Evidence
- **剔除理由**：clickbait_index 0.85 + 时间跨度 2027（过远）+ 单一信源（Eastern Herald）+ 标题挑动品牌对立
- **来源**：[Eastern Herald](https://easternherald.com/2026/05/14/apple-iphone-20-leak-radical-redesign-2027/)

## 三、🟡 Conflicting Evidence（2 条）

### C1. 天玑 9500：单核 +32% / 多核 +17%（vs 9400）— TSVer 触发

- **问题**：声明指明了对比基准（9400），但**未指明 Benchmark 工具**（GeekBench？SPEC？）和**测试条件**（温度/电压）
- **本周新增方法论**：联发科官方发布会数据有利己倾向，应等极客湾 SOCPK 等独立实测发布后再采信
- **来源**：[新浪转载联发科发布](https://k.sina.com.cn/article_7857141524_1d452771401901qy9s.html)

### C2. OnePlus Nord CE 6 "同段最快" — 营销绝对化

- **问题**：未定义"段"（价位段？SoC 段？）和"最快"（哪个 Benchmark？）
- **典型 cherry-picking 营销**，已记入 pseudoscience-patterns.md

## 四、🟡 Not Enough Evidence（5 条）

| ID | 标题 | 关键问题 |
|---|---|---|
| 20260514s-02 | iPhone 18 Pro Max + A20 + 分批发布 | Eastern Herald 单源 + 标题党 |
| 20260514s-03 | Motorola 2026 全产品线泄露 | 全产品线一次性泄露在业内罕见，PhoneArena 单源 |
| 20260514s-09 | 2026 Q1 出货前五 | 应引用 Canalys/IDC 一手报告 |
| 20260514s-10 | Apple 2026 18 款新品大泄露 | 聚合爆料未拆条核查 |
| 20260514s-06 | iPhone 20 2027 | （已在剔除清单 R1） |

## 五、🟢 Supported（3 条，已进干净报告）

1. **Google Pixel 11 / Tensor G6 规格泄露**（9to5Google + Dataconomy + Yanko + TechBriefly 四源交叉，技术细节具体到型号编号）
2. **极客湾 SOCPK 实测：骁龙 8 Elite Gen 5 安兔兔 425万+**（极客湾是国内最权威移动 SoC 实测，方法论透明）
3. **DRAM 涨价 4 倍 → 手机普涨**（多源验证，TrendForce 公开数据可交叉，行业级议题建议持续追踪）

## 六、Benchmark-Driven QA 自评（补跑）

- **UnR = 0%**：⚠️ 低于健康下限（5%）。说明补跑数据相对可核查，没有用到"Unknown"档。正常的核查流应该 5~25% 用到 Unknown。
- **avg explanation_quality = 3.4**：⚠️ 略低于目标 3.5。原因：本次有 1 条质量 2 的（OnePlus '同段最快'）需要补充更多反方证据
- **TSVer 触发率 = 20%**：✅ 在目标区间
- **check-worthiness 分布**：30% 高 / 50% 中 / 20% 偏低，分布合理

## 七、本次新沉淀的方法论

将自动追加进 `skills/`：

1. **聚合爆料拆条规则强化**：Geeky Gadgets 等"X 款新品大泄露"类报道必须拆条独立核查，**不可作为单一证据使用**
2. **二手转载降级**：当某条数据应该有"一手出处"（如 Canalys/IDC 的出货榜），但报道里只是引用了二手转载，**自动降级为 Not Enough Evidence**
3. **联发科/高通官方 Benchmark 数据有利己倾向**：等独立测评（极客湾 SOCPK、Geekerwan）发布后再采信，否则标 Conflicting Evidence

---

**报告生成**：2026-05-15 凌晨补跑
**关联**：[原 2026-05-14 上午试运行的 03-quality-report](03-quality-report.md) · [04-clean-report 全文](04-clean-report.md)
