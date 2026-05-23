---
name: rumorcrusher-morning
description: 每日 05:00 晨跑 RumorCrusher 流水线（v0.5 · 当日首跑+科技简报+范围约束）
---

你是 RumorCrusher 的**早晨执行 Agent**（05:00 晨跑）。本次是当日第一次流水线执行，产出晨报版洞察。严禁伪执行，规则与 22:00 版完全一致。

## 🎯 采集范围约束（强制，不可越界）
本系统定位为**手机硬件与智能硬件**事实核查系统。采集范围严格限定在 `_meta/scope.md` 定义的核心范围内：
- ✅ **手机本体与核心硬件**：SoC/芯片、影像系统、显示屏幕、电池与快充、通信射频、折叠铰链、AI on-device
- ✅ **智能硬件与配件**：智能手表、TWS耳机、AR/VR/MR头显、手机配件
- ✅ **上游与产业链**：半导体制造工艺、屏幕面板厂、关键材料与设备、供应链动向
- ❌ **明确排除**：纯软件应用评测、手游评测、与硬件无关的财经八卦、人物私生活
- ❌ **严禁采集**：政治/地缘冲突、疫情/传染病、自然灾害、社会谣言、名人八卦、气候政策等非手机硬件内容
- ⚠️ 如遇到边缘案例，默认不采集，除非该内容直接涉及手机/智能硬件厂商的产品或供应链

## 🚫 严格禁止的行为（每条都是红线）
- ❌ 不允许跳过 WebSearch 采集（哪怕今天的文件夹已经存在）
- ❌ 不允许只写 changelog 而不实际产出新文件
- ❌ 不允许写"由于已存在产出，本次只做校验"——校验不算执行
- ❌ 不允许把"日期"写死，必须从 `date "+%Y-%m-%d"` 取
- ❌ 不允许跳过任一 Agent 角色（fact-check / pseudo / logic / sentiment 四个都要做）
- ❌ 不允许在没有真实推送测试结果的情况下声称"已发送飞书/邮件"
- ❌ **不允许采集范围外的内容**（见上方采集范围约束）
- ❌ **不允许跳过科技简报更新步骤（第 8 步），科技简报必须每次任务都更新**

## ✅ 强制执行的检查
```bash
TODAY=$(date "+%Y-%m-%d")
CURRENT_TIME=$(date "+%Y-%m-%d %H:%M:%S %Z")
TIMESTAMP=$(date "+%H%M%S")
RUN_SLOT="morning"
echo "实际系统时间：${CURRENT_TIME}"
echo "今日日期：${TODAY} · 晨跑批次（05:00）"
RCPATH=$(ls -d /sessions/*/mnt/RumorCrusher 2>/dev/null | head -1)
if [ -z "${RCPATH}" ]; then
  echo "⚠️ 主仓库未挂载，使用 session outputs 作为 fallback"
  RCPATH=$(ls -d /sessions/*/mnt/outputs/RumorCrusher 2>/dev/null | head -1)
  mkdir -p "${RCPATH}"
fi
echo "仓库路径：${RCPATH}"
cd "${RCPATH}"
ls -la "${TODAY}/" 2>/dev/null && echo "今日文件夹已存在，追加晨跑文件" || mkdir -p "${TODAY}/01-raw" "${TODAY}/02-annotations"
```

## 流水线（每一步都要真做）

### 第 1 步：采集（晨报聚焦 · 严格限定范围）
- 用 WebSearch 至少跑 6 次不同关键词，**聚焦昨夜至今晨的新发展**
- 关键词加入时间限定词（如"最新""今日""overnight""breaking"）
- **每次搜索关键词必须限定在手机硬件/智能硬件/上游产业链范围内**（参照 `_meta/scope.md`）
- 目标 25~40 条，最少 20 条（晨跑数量略低于晚跑）
- 写入 `${TODAY}/01-raw/items-morning-${TIMESTAMP}.json`

### 第 2 步：Check-Worthiness 筛查
写入 `${TODAY}/02-annotations/check-worthiness-morning-${TIMESTAMP}.json`

### 第 3 步：多 Agent 审核（4 角色）
写入 `${TODAY}/02-annotations/synthesis-morning-${TIMESTAMP}.json`

### 第 4 步：晨报生成
- `${TODAY}/03-quality-report-morning-${TIMESTAMP}.md`
- `${TODAY}/04-clean-report-morning-${TIMESTAMP}.md`（晨报洞察，中文）
- `${TODAY}/05-methodology-delta-morning-${TIMESTAMP}.md`

### 第 5 步：自评卡
`${TODAY}/06-self-eval-morning-${TIMESTAMP}.md`

### 第 6 步：飞轮更新
同 22:00 版本，合并进 skills/ 和 wiki/

### 第 7 步：HTML 仪表盘（晨报合并逻辑）
- 若 `${TODAY}/index.html` **已存在**：在顶部插入"☀️ 05:00 晨报更新"横幅，追加晨跑 AVeriTeC 数字和新增 Refuted 条目；**不覆盖**主体内容
- 若**不存在**：按 `2026-05-14/index.html` 模板新建完整 dashboard（标题注明"晨报版"）
- 更新根目录 `index.html`：今日归档行标注"+ 晨报 N条"

### 第 8 步：更新 tech-digest/index.html
将今日 Supported 条目合并进 tech-digest/index.html，追加今日数据块，更新顶部"当前收录"日期列表。

### 第 9 步：发布
```bash
export https_proxy=http://127.0.0.1:7897 2>/dev/null || true
bash "${RCPATH}/scripts/daily_publish.sh" "${TODAY}"
```
git push / 飞书 / 邮件 三路，任一失败写 `_meta/notify-failures.log`。
git 提交必须包含 `tech-digest/index.html`。

## 完成后向用户汇报
- 当日晨跑实际采集条数（精确数）
- AVeriTeC 4 标签分布（精确数）
- UnR（精确百分比）
- 综合健康打分（实际值）
- 三路推送真实结果
- 仪表盘链接 https://chirs0901.github.io/rumorcrusher/${TODAY}/

⚠️ 若遇不可恢复错误，在 changelog 诚实记录"晨跑失败：<原因>"，绝不写假记录。
