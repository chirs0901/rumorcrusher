# RumorCrusher 质检报告 · 晨报版
**日期：** 2026-06-07 ☀️ 05:00 晨跑  
**TIMESTAMP：** 210623  
**核查方法：** AVeriTeC 4标签 + TSVer + MultiCW（可信度×影响力×可核查性）

---

## ✅ 日期三源校验

| 来源 | 值 | 说明 |
|------|------|------|
| CTX_DATE（系统注入，最权威） | 2026-06-07 | system-reminder: "Today's date is 2026-06-07" |
| SCHED_DATE（调度器lastRunAt） | 2026-06-07 | lastRunAt=2026-06-06T21:05:59Z → CST 2026-06-07 05:05 |
| BASH_DATE（系统时钟） | 2026-06-06 | bash UTC时间 2026-06-06 21:06，+8=2026-06-07 |

**结论：** 三源一致（均指向 CST 2026-06-07）。Bash显示UTC日期与CTX_DATE不同（UTC vs CST），以CTX_DATE为准。无漂移告警。

---

## 📊 AVeriTeC 分布表格

| 标签 | 条数 | 占比 |
|------|------|------|
| ✅ Supported | 22 | 64.7% |
| ⚠️ ConflictingEvidence | 6 | 17.6% |
| ❌ Refuted | 2 | 5.9% |
| ❓ NotEnoughEvidence | 2 | 5.9% |
| **合计** | **32** | **100%** |

**UnR（不可靠率）：** (6+2+2)/32 = **0.3125**  
**AVeriTeC 均分（avg EQ）：** 0.79  
**综合健康打分：** 74/100

---

## 🔴 ConflictingEvidence 详细推理链

### CE-1：骁龙8 Elite Gen 6 Pro LPDDR6支持（条目7）
- **声称：** 骁龙8 Elite Gen6 Pro（SM8975）支持LPDDR6内存，峰值带宽约14.4 Gbps
- **推理链：** GSMArena/Beebom报道了Pro版规格泄露 → 多源覆盖Adreno 850和18MB GMEM → 但LPDDR6支持规格仅见于"Gen6 Pro完整规格"泄露文章，其他泄露仅提LPDDR5X → 目前LPDDR6标准仍在制定中，2026年量产手机能否搭载存疑 → 规格可信但无官方确认
- **结论：** Pro变体存在Supported；LPDDR6规格为ConflictingEvidence

### CE-2：天玑9600 Pro峰值频率接近5GHz（条目9）
- **声称：** 天玑9600 Pro Peak CPU接近5GHz，可媲美桌面处理器
- **推理链：** Gizmochina 2026-04-07单一报道 → Nokiamob 5月底确认Pro变体存在但未提具体频率 → 天玑9500 C1-Ultra峰值4.21GHz，9600 Pro宣称5GHz为约20%提升，技术上合理但数字未获独立验证 → "媲美桌面"表述明显夸大（桌面CPU 5GHz≠移动端5GHz，功耗热设计完全不同）
- **结论：** Pro变体存在Supported；5GHz频率待验证=ConflictingEvidence；"媲美桌面"为逻辑谬误

### CE-3：固态电池2026年消费落地说法（条目21）
- **声称：** 部分媒体称固态电池"即将"在2026年商用手机中落地
- **推理链：** TechTheBest "5 Solid State Phones to Watch in 2026"列举了手机 → 但逐条核查发现列举机型均为半固态（semi-solid）或固态计划机型，非完全固态 → TechnoLogic等专业分析明确指出2027-2028年才是现实窗口 → 宁德时代神行已量产的是硅碳液态锂离子，非固态
- **结论：** 部分报道存在"固态"与"半固态"混淆，半固态商用=Supported；全固态量产时间=ConflictingEvidence

### CE-4：iPhone Fold"无折痕"材料技术（条目28）
- **声称：** 苹果开发了"新材料特性"，使iPhone Fold折叠后无可见折痕
- **推理链：** AppleInsider/Gadgeteer等多篇文章均引用此说法 → 追溯来源均归至同一分析师Mark Gurman和一份供应链爆料 → 无第三方实物测试数据 → 宣传措辞含"regardless of cost"，可能属于营销放大 → 技术上折叠后零折痕与行业现状差距较大（华为Mate X7等折叠屏仍有折痕）
- **结论：** iPhone Fold试产=Supported；无折痕声称=ConflictingEvidence

### CE-5：高通"60%以上推理将在端侧执行"（条目25）
- **声称：** 高通研究部门称2026年底旗舰Android设备60%以上AI推理将在端侧运行
- **推理链：** 数据来源为高通自身研究部门声明，存在显著利益相关 → 未见IDC/Counterpoint等独立机构验证 → 端侧推理占比统计口径未明确（是总推理量还是旗舰设备推理量） → "60%"是相对乐观值，与独立分析师估计的30-40%存在差距
- **结论：** 端侧AI趋势Supported；60%具体比例为ConflictingEvidence

### CE-6：蓝思科技承接iPhone Fold 70% UTG（条目29 → 升级为NEI）
- 已标记为NotEnoughEvidence（见NEI区块）

---

## ❌ Refuted 详细推理链

### R-1：天玑9600 Q4 2026发布（条目10）
- **声称（流传说法）：** 联发科天玑9600将于2026年第四季度发布（腾讯新闻/知乎2026年1月报道）
- **推理链：** 2026年1月初确实存在Q4发布的早期预测 → 2026年4月多家媒体报道芯片规格泄露并明确指出Q3/9月发布窗口 → AndroidHeadlines（4月）、Nokiamob（4月）、Gizmochina（4月-5月）、PCPai均确认9月发布 → Nokiamob 5月29日报道确认Pro版全规格，时间线仍为Q3 2026
- **核查结论：** ❌ **REFUTED**。Q4说法是过期预测，2026年Q2已有充分证据更新为Q3（9月）窗口。首批量产手机vivo X500和OPPO Find X10计划9月发布

### R-2：BOE仍是iPhone 18 Pro面板主供（隐含错误声称）
- **声称（循环流传）：** BOE已通过认证，将稳定供应iPhone 18 Pro OLED
- **推理链：** BOE确实进行了认证尝试 → 但Sammy Fans 2026-05-07明确报道"Samsung takes back iPhone 18 Pro OLED business from BOE" → AppleInsider报道BOE iPhone 17份额仅约1%，且质量问题在iPhone 15/16/17三代持续积累 → UBI Research 2026年预测BOE供量均归入bar-type条目，未出现在Pro机型供应中
- **核查结论：** ❌ **REFUTED**。三星显示已收回Pro机型供应权，BOE 2026年iPhone业务份额极低，旗舰供应商地位不成立

---

## 📈 累计统计

| 指标 | 今日（2026-06-07 晨） | 历史估算（5/14-6/6，~47次运行） | 合计 |
|------|------|------|------|
| 采集条数 | 32 | ~1,180 | **~1,212** |
| Supported | 22 (68.75%) | ~822 (69.7%) | **~844 (69.6%)** |
| ConflictingEvidence | 6 (18.75%) | ~164 (13.9%) | **~170 (14.0%)** |
| NotEnoughEvidence | 2 (6.25%) | ~123 (10.4%) | **~125 (10.3%)** |
| Refuted | 2 (6.25%) | ~70 (5.9%) | **~72 (5.9%)** |
| 综合健康打分 | **74/100** | ~80.5（平均） | — |

**今日辟谣条数：** 2（天玑9600 Q4说法辟谣 + BOE iPhone 18 Pro主供说法辟谣）  
**aiStrategy条目：** 9条（台积电2nm AI产能、骁龙8 EG6、天玑9600 N2P、HBM危机3条、骁龙8 Gen4 NPU、高通端侧推理比例、AI产能预订）

---

## 🏷️ 类别分布

| 类别 | 条数 |
|------|------|
| 芯片/SoC | 10 |
| 品牌/机型 | 7 |
| 显示屏幕 | 4 |
| 内存/DRAM | 4 |
| 电池/快充 | 3 |
| AI策略 | 2 |
| 影像传感器 | 2 |

*RumorCrusher Morning Pipeline v0.7 · 2026-06-07 05:06 CST*
