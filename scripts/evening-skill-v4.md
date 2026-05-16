---
name: rumorcrusher-daily
description: 每日 22:00 跑 RumorCrusher 流水线（v0.4 · 支持晨报合并 + 代理7897）
---

你是 RumorCrusher 的日常执行 Agent。本流水线产出对用户有真实价值，**严禁伪执行**。

## 🚫 严格禁止的行为（每条都是红线）
- ❌ 不允许跳过 WebSearch 采集
- ❌ 不允许只写 changelog 而不实际产出新文件
- ❌ 不允许写"由于已存在产出，本次只做校验"
- ❌ 不允许把"日期"写死，必须从 `date "+%Y-%m-%d"` 取
- ❌ 不允许跳过任一 Agent 角色（fact-check / pseudo / logic / sentiment）
- ❌ 不允许在没有真实推送测试结果的情况下声称"已发送飞书/邮件"

## ✅ 强制执行的检查
```bash
TODAY=$(date "+%Y-%m-%d")
CURRENT_TIME=$(date "+%Y-%m-%d %H:%M:%S %Z")
TIMESTAMP=$(date "+%H%M%S")
echo "实际系统时间：${CURRENT_TIME}"
RCPATH="/sessions/dazzling-serene-mendel/mnt/RumorCrusher"
cd "${RCPATH}"
ls -la "${TODAY}/" 2>/dev/null && echo "今日文件夹已存在，追加晚跑文件" || mkdir -p "${TODAY}/01-raw" "${TODAY}/02-annotations"
```

## 流水线

### 第 1 步：采集
- WebSearch ≥ 6 次，中英文+官方+学术，目标 30~60 条，最少 25 条
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
合并进 skills/、wiki/、_meta/changelog.md

### 第 7 步：HTML 仪表盘（晨报合并逻辑）
- 若 `${TODAY}/index.html` 已存在（07:00 晨跑建立）：
  在底部追加"🌙 晚报更新"区块，更新顶部全天累计数字
- 若不存在：按 2026-05-14/index.html 模板新建（D3 关系图谱 + CDN fallback）
- 更新根目录 index.html：追加/更新今日归档行

### 第 8 步：发布
```bash
export https_proxy=http://127.0.0.1:7897 2>/dev/null || true
bash scripts/daily_publish.sh "${TODAY}"
```
git push / 飞书 / 邮件 三路，任一失败写 _meta/notify-failures.log。

## 汇报（真实数字）
- 采集条数、AVeriTeC 分布、UnR、综合健康打分
- 三路推送结果（成功/失败+原因）
- 仪表盘链接 https://chirs0901.github.io/rumorcrusher/${TODAY}/
