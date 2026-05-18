# RumorCrusher 项目演进日志

## 2026-05-18 · 手机硬件专项晚报（072210）

### 本次运行统计
- 采集条目：38条（8轮 WebSearch）
- AVeriTeC分布：Supported×14, Refuted×8, ConflictingEvidence×7, NEE×9
- TSVer触发：6条
- avg EQ：7.42 | UnR：23.7% | 健康打分：82/100

### 今日核心发现
- **最大谎言：** 高通+联发科同步使用"33B参数端侧运行"声称（均未提量化精度），双双被Refuted（EQ 9.5/9.0）
- **硅碳电池主流化完成：** 一加15（7300mAh）/荣耀Magic V6（7150mAh）/摩托罗拉Razr系列实测确认，三星是最后缺口
- **VC均热板全球旗舰普及完成：** iPhone 17 Pro加入后收官，AI负载驱动下一波升级
- **LPDDR5X供应偏紧：** HBM产能挤占是根因，Q4 2026预计缓解（预测，待观察）
- **OpenAI手机2027量产：** 仅Kuo一源，标注NEE

### 飞轮更新
- `skills/pseudoscience-patterns.md`：追加3条新模式（双厂商同步伪科学、硅碳容量倍增话术、散热维度错误对比）
- `skills/logical-fallacy-catalog.md`：追加3条新谬误（苹果与橙子比较、精确数字谬误、产品爆料确定性污染）
- `wiki/entities/soc/dimensity-9400.md`：新建，Agentic AI首发地位核查
- `wiki/entities/tech/vc-vapor-chamber.md`：新建，修正VC vs石墨烯误导比较
- `wiki/topics/silicon-carbon-battery-2026.md`：新建，硅碳电池核查专题

### 产出文件
- `2026-05-18/01-raw/items-072210.json`（38条原始数据）
- `2026-05-18/02-annotations/check-worthiness-072210.json`
- `2026-05-18/02-annotations/synthesis-072210.json`
- `2026-05-18/03-quality-report-072210.md`
- `2026-05-18/04-clean-report-072210.md`
- `2026-05-18/05-methodology-delta-072210.md`
- `2026-05-18/06-self-eval-072210.md`
- `2026-05-18/index.html`（仪表盘）
- `tech-digest/index.html`（更新，新增2026-05-18数据块）

## 2026-05-14 · 项目启动 + 首日试运行
- 完成需求对齐：信源/范围/输出格式/部署方式/可视化风格
- 搭建目录骨架与种子文件：scope.md, source-list.yaml, agents-architecture.md
- 完成 skills 四件套（fact-check / pseudoscience / source-credibility / logical-fallacy）
- 完成 wiki/_index.md 混合图谱框架（实体节点 + 主题节点）
- 完成 .gitignore + secrets.example.yaml（密钥隔离机制）
- 完成首日试运行：20 条素材，多 Agent 委员会判定 9 通过 / 9 警告 / 2 剔除
- 完成 HTML 仪表盘模板（Tailwind + D3 关系图谱）
- 完成飞书通知脚本 + 邮件通知脚本（HTML 全文，163 SMTP）
- 完成首次推送脚本 + 每日发布脚本
- 注册每日 22:00 定时任务 rumorcrusher-daily
- 完成首次 git push 到 GitHub Pages（多次 PAT 权限失误后强制推送修复）
- 引入 Benchmark-Driven QA 框架（AVeriTeC + RealFactBench + MultiCW + TSVer），升级到 v0.2

## 2026-05-14 · 定时任务首次触发（自动）
- 触发：scheduled-task `rumorcrusher-daily`
- 由于今日（2026-05-14）即首日试运行所在日，已存在完整的多 Agent 流水线产出（20 条采集 / 9 pass / 9 warn / 2 fail），本次定时触发执行的是**校验 + 发布**子集，未重新采集以避免覆盖人工种子内容。
- 本次执行的步骤：
  - ✓ 校验目录结构：01-raw、02-annotations、03~06 报告、index.html 全部就位
  - ✓ 校验密钥隔离：`secrets.local.yaml` 未被 git 跟踪、未被 staged
  - ✓ 提交 Benchmark-Driven QA 框架升级：`agents-architecture.md v0.2`（新增 Check-Worthiness/Self-Evaluation Agent）、`fact-check-playbook.md` 追加 §4 AVeriTeC+RealFactBench+MultiCW+TSVer 四件套、新增 `06-self-eval.md` 自评卡
  - → daily_publish.sh 推送：见 `_meta/notify-failures.log`（如有失败）
- 下一日（2026-05-15）起，自评卡由 Self-Evaluation Agent 实时生成。

## 2026-05-15 · 定时任务第二次触发（自动，22:03:30 CST）

- 触发：scheduled-task `rumorcrusher-daily`，v0.3流水线完整执行
- **采集**：8次WebSearch查询，采集40条素材（覆盖中文+英文+官方+学术），items-220330.json
- **Check-Worthiness**：40条全部评分，高档15条/中档17条/低档6条/极低2条
- **多Agent审核**：4角色并行，AVeriTeC分布：Supported 23 / Refuted 10 / Conflicting 4 / NEE 3 / UnR 0
- **TSVer触发**：13条（32.5%），新型「AI→AI循环引用」谣言首次识别
- **avg explanation_quality**：4.05（目标≥3.5，达标）
- **UnR警告**：0.0%（低于健康下限5%，建议下次增加灰色地带素材采集）
- **输出文件**：01-raw/items-220330.json、02-annotations/check-worthiness-220330.json + synthesis-220330.json、03~06报告全套
- **飞轮更新**：pseudoscience-patterns.md +3条新模式，logical-fallacy-catalog.md +5条AI谣言专用模式，source-credibility.md +6个新信源，wiki新增nvidia.md + ai-misinformation-2026.md + deepfake-2026.md
- **发布推送**：见当日推送结果（详见 `_meta/notify-failures.log`）

## 2026-05-16 03:35 · 用户手动触发（补跑 + 定时任务扩展）

- 用户指令：代理端口7897重新推送GitHub + 2小时后补跑 + 新增每日07:00晨跑任务
- git push：失败（sandbox代理403，7897端口在sandbox内不可达）；notify-failures.log 已记录
- daily_publish.sh 已更新：优先探测7897，fallback 1080
- 晨跑任务 SKILL.md 已写入：`scripts/morning-skill.md`（每日07:00，晨报版，支持合并追加到当日dashboard）
- 晚跑任务 v0.4 SKILL 已写入：`scripts/evening-skill-v4.md`（新增晨报合并逻辑）
- 两个新任务待用户在普通Claude对话中注册：详见 `scripts/setup-tasks.md`
- 已在scheduled-task session内直接写入.scheduled/rumorcrusher-daily/SKILL.md（失败：只读文件系统）
  → 改由用户手动在普通会话触发更新

## 2026-05-16 14:11 UTC · 定时晚报（scheduled daily）

### 本次运行统计
- 采集条目：26条（11轮 WebSearch）
- Check-Worthy：22条
- 精审条目：14条
- AVeriTeC分布：Refuted×11, Misleading×3, Supported×1, NEE×1, Conflicting×1
- 综合健康打分：83/100
- avg EQ：6.79 | UnR：4.5% | avg 置信度：0.94

### 今日核心事件
- MV Hondius汉坦病毒疫情引发Critical级谣言爆发（伊维菌素谣言、疫苗阴谋论、以色列阴谋论）
- RFK Jr疫苗误导声明（政界人物医学谬误放大模式首次精确记录）
- 特朗普气候否认声明
- 国内：驾考谣言、山西地震谣言、新能源养路费谣言已被辟谣

### 飞轮更新
- skills/pseudoscience-patterns.md：追加3条新模式（脚本化大流行、跨病毒疗法复用、政界医学谬误放大）
- skills/logical-fallacy-catalog.md：追加3条新谬误（无法证伪框架、地理嫁接、紧急窗口滥用）
- CW评分模型：引入紧迫系数（Urgency Multiplier）

### 产出文件
- 01-raw/items-140910.json（26条原始数据）
- 02-annotations/check-worthiness-140910.json
- 02-annotations/synthesis-140910.json
- 03-quality-report-140910.md
- 04-clean-report-140910.md
- 05-methodology-delta-140910.md
- 06-self-eval-140910.md
- 2026-05-16/index.html（仪表盘，见步骤7）

## 2026-05-17 晚跑（evening-140354）
- **新增主题：** 印巴冲突虚假信息专题（6条，包含官员级传播案例）
- **新增主题：** AI深伪金融欺诈（加密货币+股市双线，EQ≥9.5）
- **新增主题：** 名人谣言（Kohli/SunnyLeone/特朗普健康）
- **中美峰会深化：** Boeing三倍声明/无联合声明细化核查
- **汉坦新变体：** 封城+疫苗阴谋论第二波
- **质量指标：** 采集26条/精审22条，UnR=22.7%，avg EQ=8.04，健康74/100
- **方法论改进：** 建议增加`spreader_tier`字段，印巴冲突纳入必查清单
