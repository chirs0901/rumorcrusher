# 方法论 Delta ☀️ 晨报版
**日期：** 2026-06-01 | **批次：** morning-014729

## 本批次方法论更新

### 1. 新增核查规则：单源小媒体传言识别
- **触发案例：** ID-19（英伟达/高通转投三星2nm传言）
- **规则：** 当声称涉及"大客户离开台积电/三星/主要晶圆厂"且仅见于单一小型中文媒体时，需在Digitimes/TechInsights/Reuters中寻找独立印证；缺失时默认降级为Refuted候选
- **加入：** `skills/chip-supply-rumor-patterns.md`

### 2. 强化：AI策略供应链声称核查路径
- **触发案例：** ID-12、ID-23（HBM挤压DRAM）
- **规则：** AI驱动的产能重新分配声称，优先检索TrendForce、IDC、Fortune财经媒体；三源以上一致方可标注Supported
- **更新：** `skills/memory-ai-strategy-checklist.md`

### 3. 新增：官方未确认的技术合作声称处理
- **触发案例：** ID-7（Qualcomm+CXMT）
- **规则：** 技术合作声称缺少官方确认时，需明确标注"官方未确认"并在summary中提示合规风险；不因技术逻辑可信直接升级为Supported
- **加入：** `skills/unconfirmed-partnership-handling.md`

## 无变化项
- AVeriTeC 4标签体系保持不变
- Check-Worthiness优先级评分标准保持不变
- 健康打分公式：`(Supported×1 + ConflictingEvidence×0.3 + NotEnoughEvidence×0.1 - Refuted×0.5) / total × 100` 保持不变
