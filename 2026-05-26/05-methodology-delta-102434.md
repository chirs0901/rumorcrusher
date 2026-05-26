# RumorCrusher 方法论变更记录 · 2026-05-26（晚跑）

> 批次：RC-20260526-evening-102434

## 本批次无重大方法论变更

### 沿用规则确认
- AVeriTeC 4标签体系（Supported/ConflictingEvidence/Refuted/NotEnoughEvidence）保持不变
- aiStrategy标记：供应商因AI需求调整产能/工艺/供应优先级 → true（本批次9条）
- 逻辑谬误分类：hasty_generalization / appeal_to_authority / false_dichotomy 等
- 健康评分公式：base=100 - ConflictingEvidence*5 - NotEnoughEvidence*3 - Refuted*10，本批次=86

### 新增观察
1. **"推断性代工转移"警示规则**：当信源仅为推断（如"高通/联发科被迫跳过2nm"）时，应标记hasty_generalization，降置信度至<60%，并统一归NotEnoughEvidence。本批次已执行。

2. **全息3D屏报道分离原则**：针对同一企业同时有已验证技术（FMP）和未验证路线图（全息3D屏）的情况，拆分为独立子结论，分别标注置信度，避免混合报道整体拉高/拉低置信度。

3. **价格涨幅"预测vs事实"区分**：具体价格涨幅百分比（如LPDDR5X+20%）如仅来自机构预测，不可标注为Supported，应标注ConflictingEvidence或NotEnoughEvidence，并在推理链中注明"机构预测，待合同价公开核实"。

### 已知待优化项
- 供应链爆料的可信度评估：目前主要依赖来源媒体信誉和交叉印证，未来可引入爆料者历史准确率模型
- 新增实体追踪：moto razr fold、小米17 Max、荣耀Magic V6已写入Wiki
