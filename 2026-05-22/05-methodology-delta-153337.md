# 方法论增量记录 | 2026-05-22

**本次运行发现的新模式及处理经验**

---

## 新增检测模式

### 模式：预发布多芯比较（Pre-Release Multi-Chip Comparison）
- **触发条件：** 宣称某款未发布芯片在GPU/CPU性能上超越其他同样未发布的芯片
- **检测信号：** 所有被比较对象均为"预计X季度发布"状态，无任何实测Benchmark
- **处置建议：** 直接标记 Refuted，逻辑谬误为 Appeal to Future Performance
- **新增至：** skills/logical-fallacy-catalog.md（"多芯预发布比较"子类）
- **首见案例：** RC-20260522-002（天玑9600 vs A20 Pro vs 骁龙8 Elite Gen 6 GPU比较）

### 模式：市场份额信源不透明
- **触发条件：** 报道援引市场排名/出货量数据但未指明研究机构（IDC/Counterpoint/Canalys）
- **处置建议：** 降至 C 级信源，标记为 ConflictingEvidence，优先交叉核实
- **首见案例：** RC-20260522-018（华为Q1中国市场第一的声称）

---

## 信源质量更新

- **TechInsights** 确认为 A 级权威信源（芯片拆解分析领域）
- **Sourceability** 确认为 B 级供应链数据信源（价格追踪可信）
- **PjTime.com** 降级至 C 级（面板行业报道煽情化标题倾向）

---

## 飞轮规则新增（2条）

1. **规则：** 学术阶段电池研究（TechXplore/学术期刊）不直接进入消费者科技简报，应加注"实验室阶段"标签
2. **规则：** 单一信源的"战略放弃"类报道（如苹果Vision Pro），必须要求2+个独立信源才能从ConflictingEvidence升级至Supported
