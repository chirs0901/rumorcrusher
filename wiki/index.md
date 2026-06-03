# LLM Wiki 索引 / Knowledge Graph Index

> **Karpathy 风格的"知识飞轮"** —— 每日干净报告中的事实、关系、结论持续合并进此图谱。混合图谱：**实体节点**（具体的芯片、品牌、机型、技术）+ **主题节点**（趋势、事件、争议）。
>
> 编辑规则：所有内容必须有可追溯的信源链接。每次合并若发现冲突，旧条目不删除，用 `> 已更正` 区块叠加保留历史。

## 一、实体节点 / Entities

### SoC 芯片
- ✅ [Snapdragon 8 Elite Gen 5](entities/soc/snapdragon-8-elite-gen5.md) — NPU +37%，可作端侧 LLM 推理（待量产实测验证）
- ✅ [MediaTek Dimensity 9400](entities/soc/dimensity-9400.md) — Agentic AI 首发地位核查（2026-05-18建档）
- ✅ Snapdragon 6 Gen 5 / 4 Gen 5 — 4nm工艺，2026-05-07高通官方发布（2026-05-29建档）
- ✅ [MediaTek Dimensity 9400+](entities/soc/dimensity-9400-plus.md) — 3nm N3E，SpD+端侧AI+20%，DeepSeek-R1-Distill支持（2026-05-30建档）
- ✅ [Apple A19](entities/soc/apple-a19.md) — 台积电第三代3nm，iPhone 17搭载，6核CPU/5核GPU（2026-05-30建档）
- ✅ [MediaTek Dimensity 9600](entities/soc/dimensity-9600.md) — TSMC N2P，首引双超大核（~5GHz），Q3 2026发布（爆料，官宣待确认）（2026-05-25建档）
- ✅ [Snapdragon 8 Elite Gen 6](entities/soc/snapdragon-8-elite-gen6.md) — TSMC 2nm，9月发布，Adreno 845 GPU，UFS 5.0，CPU提升幅度信源冲突（CE）（2026-05-29建档）
- ✅ [麒麟2026 / Kirin 2026](entities/soc/kirin-2026.md) — LogicFolding技术，晶体管密度+53.5%，频率首超3GHz，今秋发布（2026-05-27建档）
- ⏳ MediaTek Dimensity 9500 — 待建档
- ⏳ Apple A19 / A19 Pro — 待建档
- ⏳ Google Tensor G5 — 待建档
- ✅ [Kirin 9030 Pro](entities/soc/kirin-9030-pro.md) — 中芯N+3制程，TechInsights确认，Mate 80 Pro Max搭载（2026-05-25建档）

### 品牌
- ✅ [华为 Huawei](entities/brand/huawei.md) — Mate 80 系列 + 麒麟 9030 + 鸿蒙 6
- ✅ [英伟达 NVIDIA](entities/brand/nvidia.md) — 黄仁勋访华事件 + 中国业务停滞 + 芯片出口管制立场（2026-05-15建档）
- ✅ [Apple](entities/brand/apple.md) — iPhone 18 Pro预测：A20 Pro 2nm+可变光圈+屏下FaceID（分析师），苹果Q1 2026全球出货第一（2026-05-25建档）
- ✅ [Samsung](entities/brand/samsung.md) — Galaxy Z Fold 8（7月22日待官确，4.1mm，$1999），HBM4E发布，重夺iPhone 18 Pro OLED（2026-05-25更新）
- ✅ [Xiaomi 小米](entities/brand/xiaomi.md) — 小米17 Ultra 6000mAh Si-C电池；小米17 Max 8000mAh CCC认证（2026-05-26建档）
- ✅ [BOE 京东方](entities/brand/boe.md) — Gen 8.6 OLED工厂5月底量产；iPhone 18 Pro被排除，MacBook Pro OLED主供（2026-05-27建档）
- ⏳ OPPO / vivo / Google — 待建档

### 技术
- ✅ [硅碳负极电池](entities/tech/silicon-carbon-anode.md) — 硅含量 10%→16% 演进，7000mAh 已量产
- ✅ [VC均热板散热](entities/tech/vc-vapor-chamber.md) — 修正VC vs石墨烯误导比较（2026-05-18建档）
- ✅ [LPDDR6](entities/tech/lpddr6.md) — SK海力士14.4Gbps / 三星12.8Gbps，2026年H2量产，专为AI手机设计（2026-05-26建档）
- ✅ [WL-MCM封装](entities/tech/wl-mcm-packaging.md) — 晶圆级多芯片模组，苹果A20 Pro首发，集成HBM实现本地LLM（2026-05-26建档）
- ✅ [LTPO+](entities/tech/ltpo-plus.md) — 苹果iPhone 18 Pro首次规模化部署，BOE因此被排除旗舰供应链（2026-05-27建档）
- ✅ [UFCS 2.0](entities/tech/ufcs-2.md) — 40W无鉴权跨品牌互通，华为/OPPO/vivo/荣耀联签（2026-05-29建档）
- ✅ [索尼LYTIA品牌](entities/tech/lytia-brand.md) — IMX系列移动传感器品牌全面转型LYTIA，2026年完成（2026-05-30建档）
- ⏳ LPDDR5X / UFS 4 / 卫星通信 / 折叠铰链 / 端侧 LLM 加速 / 计算摄影

## 二、主题节点 / Topics

- ✅ [2026 影像旗舰战](topics/2026-flagship-imaging-war.md) — vivo X300 Ultra / OPPO Find X9 Ultra / 小米 17 Max 三机集中
- ✅ [2026 折叠形态](topics/foldable-2026.md) — 三星 50万次折叠 + Apple液态金属 + moto razr fold发布 + 苹果Fold OLED三星供货确认（2026-05-26更新）
- ✅ [AI生成虚假信息 2026](topics/ai-misinformation-2026.md) — 工业化传播链 + 闭环AI引用 + 五批网信办典型案例（2026-05-15建档）
- ✅ [Deepfake技术与治理 2026](topics/deepfake-2026.md) — 静态97%检测率 + 视频检测人类优于AI + 立法进展（2026-05-15建档）
- ✅ [硅碳电池核查专题](topics/silicon-carbon-battery-2026.md) — 硅碳电池主流化完成核查（2026-05-18建档）
- ✅ [OpenAI硬件战略时间线](openai-hardware-timeline.md) — 从耳机到手机的形态矛盾追踪（2026-05-19建档）
- ⏳ 2026 旗舰周期总览
- ⏳ 端侧 AI 竞赛（75 TOPS 门槛与争议）
- ⏳ 卫星通信普及（华为 700MHz / iPhone 卫星消息）
- ⏳ Apple Vision Pro 之后的头显格局
- ✅ [AI驱动的DRAM供应危机](topics/ai-dram-crisis-2026.md) — LPDDR5X Q2暴涨83%，HBM产能挤压手机内存，手机均价上涨传导链（2026-05-25建档）
- ✅ [TSMC 2nm产能格局2026](topics/tsmc-2nm-supply-2026.md) — 五座N2晶圆厂，苹果占逾50%，AI硅片与手机芯片争产能（2026-05-25建档）
- ✅ [中芯国际自主制程进展](topics/smic-process-evolution.md) — N+1→N+3演进路线，DUV多重曝光突破，麒麟9030 Pro确认N+3（2026-05-25建档）

## 三、变更日志

- **2026-05-30**：新增实体 Dimensity 9400+ / Apple A19 / 索尼LYTIA品牌；更新主题 AI-DRAM危机（HBM4+cHBM）/ TSMC 2nm产能（AMD加入+台积电万亿营收）

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
- **2026-05-25**：新增实体 dimensity-9600.md / kirin-9030-pro.md / apple.md / samsung.md；新增主题 ai-dram-crisis-2026.md / tsmc-2nm-supply-2026.md / smic-process-evolution.md；更新索引
- **2026-05-26**：新增实体 xiaomi.md / lpddr6.md / wl-mcm-packaging.md；更新主题 foldable-2026.md（moto razr fold发布+荣耀V6+苹果Fold OLED供货确认）/ ai-dram-crisis-2026.md（HBM23%产能+Micron警告+LPDDR6路线）/ tsmc-2nm-supply-2026.md（N2P提前至2026年H2量产+苹果WL-MCM+三星争夺联发科）
- **2026-05-27**（晚报）：新增实体 kirin-2026.md（华为LogicFolding技术首档）/ boe.md（京东方OLED供应链）/ ltpo-plus.md；更新实体 samsung.md（Z Fold 8七月22日确认+OLED供应）；更新主题 foldable-2026.md（Z Fold 8四源确认）/ ai-dram-crisis-2026.md（Q1 DRAM/NAND终版涨幅）
- **2026-05-29**（晚报）：新增实体 snapdragon-8-elite-gen6.md / ufcs-2.md；更新实体 boe.md（iPhone 18 Pro出局+Galaxy S27竞标）/ samsung.md（重夺iPhone 18 Pro OLED+S27发布窗口）/ apple.md（A20 WMCM封装+2nm产能锁定）；更新主题 ai-dram-crisis-2026.md（HBM3E售罄确认+LPDDR5涨幅）/ foldable-2026.md（moto razr fold发布+小米MIX Trifold认证）
- **2026-06-03**：更新实体 Snapdragon 8 Elite Gen 6（Pro规格补全）/ Dimensity 9600（GPU+NPU详情+OpenAI合作传闻）/ BOE（B16 Gen8.6量产确认+S27竞标）/ Samsung（S27规格汇聚+iPhone Fold SDC独家）/ Apple（iPhone Fold书本式+$2000+）；更新主题 折叠形态2026（iPhone Fold汇聚+OPPO N6里程碑+市场+15%）/ TSMC 2nm（N2量产确认+三大2nm旗舰芯片对比）
