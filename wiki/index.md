# LLM Wiki 索引 / Knowledge Graph Index

> **Karpathy 风格的"知识飞轮"** —— 每日干净报告中的事实、关系、结论持续合并进此图谱。混合图谱：**实体节点**（具体的芯片、品牌、机型、技术）+ **主题节点**（趋势、事件、争议）。
>
> 编辑规则：所有内容必须有可追溯的信源链接。每次合并若发现冲突，旧条目不删除，用 `> 已更正` 区块叠加保留历史。

## 一、实体节点 / Entities

### SoC 芯片
- ✅ [Snapdragon 8 Elite Gen 5](entities/soc/snapdragon-8-elite-gen5.md) — NPU +37%，可作端侧 LLM 推理（待量产实测验证）
- ✅ [MediaTek Dimensity 9400](entities/soc/dimensity-9400.md) — Agentic AI 首发地位核查（2026-05-18建档）
- ⏳ Snapdragon 6 Gen 5 / 4 Gen 5 — 待 2026-05-15 起逐日合并
- ⏳ MediaTek Dimensity 9500 / 9600 — 待 9月发布会
- ⏳ Apple A19 / A19 Pro
- ⏳ Google Tensor G5
- ⏳ Kirin 9030（华为）

### 品牌
- ✅ [华为 Huawei](entities/brand/huawei.md) — Mate 80 系列 + 麒麟 9030 + 鸿蒙 6
- ✅ [英伟达 NVIDIA](entities/brand/nvidia.md) — 黄仁勋访华事件 + 中国业务停滞 + 芯片出口管制立场（2026-05-15建档）
- ⏳ Apple / Samsung / Xiaomi / OPPO / vivo / Google — 持续合并中

### 技术
- ✅ [硅碳负极电池](entities/tech/silicon-carbon-anode.md) — 硅含量 10%→16% 演进，7000mAh 已量产
- ✅ [VC均热板散热](entities/tech/vc-vapor-chamber.md) — 修正VC vs石墨烯误导比较（2026-05-18建档）
- ⏳ LPDDR5X / UFS 4 / 卫星通信 / 折叠铰链 / 端侧 LLM 加速 / 计算摄影

## 二、主题节点 / Topics

- ✅ [2026 影像旗舰战](topics/2026-flagship-imaging-war.md) — vivo X300 Ultra / OPPO Find X9 Ultra / 小米 17 Max 三机集中
- ✅ [2026 折叠形态](topics/foldable-2026.md) — 三星 50万次折叠 + Apple 液态金属
- ✅ [AI生成虚假信息 2026](topics/ai-misinformation-2026.md) — 工业化传播链 + 闭环AI引用 + 五批网信办典型案例（2026-05-15建档）
- ✅ [Deepfake技术与治理 2026](topics/deepfake-2026.md) — 静态97%检测率 + 视频检测人类优于AI + 立法进展（2026-05-15建档）
- ✅ [硅碳电池核查专题](topics/silicon-carbon-battery-2026.md) — 硅碳电池主流化完成核查（2026-05-18建档）
- ✅ [OpenAI硬件战略时间线](openai-hardware-timeline.md) — 从耳机到手机的形态矛盾追踪（2026-05-19建档）
- ⏳ 2026 旗舰周期总览
- ⏳ 端侧 AI 竞赛（75 TOPS 门槛与争议）
- ⏳ 卫星通信普及（华为 700MHz / iPhone 卫星消息）
- ⏳ Apple Vision Pro 之后的头显格局

## 三、自动更新规则

每日 22:00 流水线完成后，由 Wiki Updater Agent 触发：
1. 扫描当日 04-clean-report.md 中提到的所有实体
2. 已存在 → 增量合并到对应文件的"信源历史"表格
3. 不存在 → 自动创建并填入首次出现的事实
4. 扫描主题趋势 → 追加到对应 topics/X.md
5. 更新本索引页（把 ⏳ 改为 ✅，新增条目按字母序插入）

## 四、引用与冲突管理

- 每个实体页底部有 `## 信源历史` 表格，记录所有提供过事实的报告链接 + AVeriTeC 标签
- 当两个信源对同一事实给出冲突结论：
  1. 优先采纳官方/高可信源
  2. 保留低可信源结论，标 `Conflicting Evidence`
  3. 30 天内无新证据则迁移到"历史争议"子区

## 五、变更日志

- **2026-05-14**：初始化索引 + 5 个种子页面（snapdragon-8-elite-gen5 / huawei / silicon-carbon-anode / 2026-flagship-imaging-war / foldable-2026）
- **2026-05-15**：新增实体页面 nvidia.md；新增主题页面 ai-misinformation-2026.md / deepfake-2026.md；更新索引
- **2026-05-18**：新增实体 dimensity-9400.md / vc-vapor-chamber.md；新增主题 silicon-carbon-battery-2026.md
- **2026-05-19**：新增主题 openai-hardware-timeline.md（OpenAI硬件战略追踪）
