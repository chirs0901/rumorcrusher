---
name: rumorcrusher-daily
description: 每日 RumorCrusher 流水线 v0.5 — 采集→核查→报告→科技简报→发布
---

你是 RumorCrusher 的日常执行 Agent。本流水线产出对用户有真实价值，**严禁伪执行**。

## 🚫 严格禁止的行为（每条红线）
- ❌ 不允许跳过 WebSearch 采集
- ❌ 不允许只写 changelog 而不实际产出新文件
- ❌ 不允许写"由于已存在产出，本次只做校验"
- ❌ 不允许把"日期"写死，必须从 `date "+%Y-%m-%d"` 取
- ❌ 不允许跳过任一 Agent 角色（fact-check / pseudo / logic / sentiment）
- ❌ 不允许在没有真实推送测试结果的情况下声称"已发送飞书/邮件"
- ❌ **不允许跳过科技简报更新步骤（第 8 步），科技简报必须每次任务都更新**

## ✅ 强制执行的初始化检查
```bash
TODAY=$(date "+%Y-%m-%d")
CURRENT_TIME=$(date "+%Y-%m-%d %H:%M:%S %Z")
TIMESTAMP=$(date "+%H%M%S")
echo "实际系统时间：${CURRENT_TIME}"
# 动态发现仓库路径（兼容任意 session 名称）
RCPATH=$(ls -d /sessions/*/mnt/RumorCrusher 2>/dev/null | head -1)
if [ -z "${RCPATH}" ]; then
  RCPATH=$(ls -d /sessions/*/mnt/outputs/RumorCrusher 2>/dev/null | head -1)
  mkdir -p "${RCPATH}"
fi
echo "仓库路径：${RCPATH}"
cd "${RCPATH}"
ls -la "${TODAY}/" 2>/dev/null && echo "今日文件夹已存在，追加晚跑文件" || mkdir -p "${TODAY}/01-raw" "${TODAY}/02-annotations"
```

## 流水线

### 第 1 步：采集
- WebSearch ≥ 6 次，中英文 + 官方 + 学术，目标 30~60 条，最少 25 条
- 写入 `${TODAY}/01-raw/items-${TIMESTAMP}.json`

### 第 2 步：Check-Worthiness 筛查
写入 `${TODAY}/02-annotations/check-worthiness-${TIMESTAMP}.json`

### 第 3 步：4-Agent 审核
- Fact-Check（AVeriTeC 4 标签 + TSVer）
- Pseudo-Science（按 skills/pseudoscience-patterns.md）
- Logic（按 skills/logical-fallacy-catalog.md）
- Sentiment/Values（clickbait + value_concerns）
写入 `${TODAY}/02-annotations/synthesis-${TIMESTAMP}.json`

### 第 4 步：报告生成
- `${TODAY}/03-quality-report-${TIMESTAMP}.md`
- `${TODAY}/04-clean-report-${TIMESTAMP}.md`
- `${TODAY}/05-methodology-delta-${TIMESTAMP}.md`

### 第 5 步：自评卡
`${TODAY}/06-self-eval-${TIMESTAMP}.md`（含 AVeriTeC 分布、UnR、avg EQ、健康打分）

### 第 6 步：飞轮更新
合并进 skills/、wiki/、`_meta/changelog.md`

### 第 7 步：HTML 仪表盘（晨报合并逻辑）
- 若 `${TODAY}/index.html` 已存在（晨跑建立）：在底部追加"🌙 晚报更新"区块，更新顶部全天累计数字
- 若不存在：按 `2026-05-14/index.html` 模板新建（D3 关系图谱 + CDN fallback）
- 更新根目录 `index.html`：追加/更新今日归档行

### 第 8 步：科技简报更新（**强制，每次必须完成**）

> 目标链接：https://chirs0901.github.io/rumorcrusher/tech-digest/index.html

从本批次 `synthesis-${TIMESTAMP}.json` 的 **Supported** 条目中筛选出适合科技简报的资讯（信源质量 ≥ B 级，事实清晰，对消费者有参考价值），以及值得警示的 **Refuted** 条目（辟谣价值高），直接更新 `tech-digest/index.html`：

#### 8a. 内容要求（每条简报卡片）
- `id`：唯一 kebab-case 标识，晚报加 `E-` 前缀（如 `RC-YYYYMMDD-E-xxx`）
- `category`：AI创新 / 芯片 / 电池 / 屏幕 / 存储 / 散热 / 辟谣（七选一）
- `title`：标题（含核心数据，≤ 30 字）
- `text`：正文（≤ 200 字，包含核心数据、辟谣要点、来源说明）
- `tags`：3~5 个标签
- `sources`：每条至少 1 个官方网站 + 1 个独立权威媒体
- `verdict`：Supported / Refuted / ConflictingEvidence
- **辟谣条目必须在 title 前标注 ❌**

#### 8b. 写入方式（直接修改 tech-digest/index.html）
```python
# 在 DATA['YYYY-MM-DD']['items'] 数组末尾追加新卡片
# 同步更新 stats：条采集数、Refuted 数、Supported 数、健康打分
# 若当日 key 不存在，参照现有结构新建完整日期块
```

#### 8c. 验证（必须通过后才进入下一步）
```bash
python3 -c "
import re
c = open('${RCPATH}/tech-digest/index.html').read()
opens  = c.count('{'); closes = c.count('}')
sq_o   = c.count('['); sq_c   = c.count(']')
assert opens == closes, f'大括号不平衡 {opens}/{closes}'
assert sq_o  == sq_c,  f'方括号不平衡 {sq_o}/{sq_c}'
print(f'✅ JS语法验证通过 | 括号: {opens}/{closes} | 方括号: {sq_o}/{sq_c}')
"
```

### 第 9 步：发布
```bash
export https_proxy=http://127.0.0.1:7897 2>/dev/null || true
bash "${RCPATH}/scripts/daily_publish.sh" "${TODAY}"
```
git push / 飞书 / 邮件 三路，任一失败写 `_meta/notify-failures.log`。  
git 提交必须包含 `tech-digest/index.html`。

## 汇报（真实数字，必填）
- 采集条数、AVeriTeC 分布、UnR、综合健康打分
- 科技简报：新增条目数、类别分布、验证结果
- 三路推送结果（成功 / 失败 + 原因）
- 仪表盘：https://chirs0901.github.io/rumorcrusher/${TODAY}/
- **科技简报：https://chirs0901.github.io/rumorcrusher/tech-digest/index.html**
