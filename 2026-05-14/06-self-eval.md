# 自评卡 · 2026-05-14（首日 · 回填）

> 说明：首日试运行时尚未引入 Benchmark-Driven QA 框架，这份自评卡是事后用 AVeriTeC + RealFactBench + MultiCW 规则**对当日 20 条素材回填打分**，作为基线值。从 2026-05-15 起，自评卡由 Self-Evaluation Agent 实时生成。

## 一、AVeriTeC 4 级标签分布（回填）

将原 pass/warn/fail 三档映射到 AVeriTeC 4 级标签：

| AVeriTeC 标签 | 数量 | 占比 | 对应原条目 |
|---|---|---|---|
| **Supported** | 7 | 35% | Snapdragon 6/4 Gen 5、小米17 Max、SD 8 Elite NPU+37%、iPhone 17e、Google I/O、Samsung Jinju、OPPO 手持影像 |
| **Refuted** | 0 | 0% | 本日无"明确被反驳"的，最接近的"75 TOPS 跑 7B"严格说是证据不足而非反驳 |
| **Not Enough Evidence** | 8 | 40% | 联发科开发者大会、10000mAh双爆料(2条)、Apple 折叠 iPhone、Galaxy Z Fold 7 50万次、Mate 80 +42%、iPhone 18 Pro 10项、75TOPS模型 |
| **Conflicting Evidence (Cherry-picking)** | 3 | 15% | vivo X300 Ultra（CIPA 命名争议）、OPPO Find X9 Ultra（口袋哈苏品牌借光）、Android Authority 民调（自身没问题但揭示行业 cherry-picking 现象） |
| **Unknown（无法核查）** | 2 | 10% | OpenAI+高通+联发科爆料（缺二阶证据）、硅碳负极 16% 硅含量（数据合理但单一来源） |
| **总计** | 20 | 100% | |

> 修订：原"剔除"标签下的 OpenAI 爆料更精确的归类应是 **Unknown**（信息无法获得而非被反驳）。"75 TOPS 跑 7B"应归 **Not Enough Evidence**（缺关键技术参数）。这种归类细化是引入 4 级标签后最直接的收益。

## 二、Unknown Rate（UnR）

- **本日 UnR：2/20 = 10.0%**
- 健康区间：5%~25% ✅ 在区间内
- 解读：略偏低但合理。首日采集侧重官方+主流媒体，可核查性较高；明日采集可主动加入更多爆料/泄露内容以测试 UnR 上行表现

## 三、平均解释质量（avg explanation_quality）

每条 verdict 按 1-5 评分（参考 fact-check-playbook.md 第 4.5 节）：

| 评分 | 数量 | 占比 |
|---|---|---|
| 5（含理由+多证据+反方+常识对照）| 4 | 20% |
| 4（含理由+多证据+反方）| 7 | 35% |
| 3（含理由+一个证据链接）| 6 | 30% |
| 2（一句话理由）| 3 | 15% |
| 1（仅标签）| 0 | 0% |

**均值：3.6 ✅** 高于目标 3.5 阈值。

待提升：3 条得 2 分的条目（小米17 Max、Samsung Jinju、OPPO 手持影像），下次需补充更多交叉证据。

## 四、Check-Worthiness 分布（事后打分）

| 档位 | 数量 | 占比 |
|---|---|---|
| **高（≥0.7）** | 11 | 55% |
| **中（0.4~0.7）** | 6 | 30% |
| **低（0.2~0.4）** | 3 | 15% |
| **极低（<0.2）** | 0 | 0% |

> 本日全部素材都过了 0.2 阈值，但有 3 条偏低（如 OPPO 手持影像官宣、iPhone 17e 已发布的复盘），这些可以在未来定时任务里**只跑轻量两 Agent 而非全流程**，节省 30% 计算预算。

## 五、TSVer 时序声明触发数

本日触发**时序声明**追问的条目数：**5 条**

1. Snapdragon 4 Gen 5 GPU "提升 77%" → 已追问对比基准（相比 Snapdragon 4 Gen 4），通过
2. Snapdragon 8 Elite Gen 5 NPU "+37%" → 已追问对比基准，通过
3. 华为 Mate 80 "性能 +42%" → 追问失败（厂商未指明基准），降级为 **Conflicting Evidence**
4. Galaxy Z Fold 7 耐久 "20万→50万" → 追问失败（无第三方实验室认证），降级为 **Not Enough Evidence**
5. 硅碳负极硅含量 "10%→16%" → 追问通过（多源验证）

## 六、方法论增量

本日新沉淀方法论数：**6 条**（已合并进 skills/ 各文件）

- CIPA 自定义标准命名陷阱
- "全球首发"边界条件缺失
- 耐久度单代>2×跃升须第三方认证
- 品牌借光技术贡献披露
- 直接竞品共合作矛盾
- 聚合爆料拆条规则

## 七、综合健康打分

| 指标 | 目标 | 实际 | 评价 |
|---|---|---|---|
| UnR | 5%~25% | 10.0% | ✅ |
| 平均解释质量 | ≥ 3.5 | 3.6 | ✅ |
| TSVer 触发率 | ≥ 15% | 25%（5/20） | ✅ |
| 方法论增量 | ≥ 3 / 日 | 6 | ✅ |
| AVeriTeC 标签分布合理性 | 4 类均出现 | 3 类出现 | ⚠️ Refuted=0 |

**首日基线建立：综合健康度 ✅ 良好**

## 八、本周复盘锚点

每周日由 QA Trend Updater 自动汇总本周 7 日数据生成 `wiki/topics/qa-trend-week-N.md`，重点关注：
- UnR 趋势（是否长期偏低 → 过度自信，或偏高 → 过度保守）
- avg explanation_quality 是否稳定 ≥ 3.5
- AVeriTeC 标签分布是否 4 类都有出现
- 新沉淀方法论是否每天都有

---

**自评卡生成**：RumorCrusher Self-Evaluation Agent v0.1（首日回填，正式版从 2026-05-15 起）
**对齐基准**：AVeriTeC 1/2 + RealFactBench + MultiCW + TSVer 方法论
