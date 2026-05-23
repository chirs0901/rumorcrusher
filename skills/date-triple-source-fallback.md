# Skill · 日期三源校验回退优先级

## 三源
1. CTX_DATE — system-reminder 的 `currentDate`
2. SCHED_DATE — `lastRunAt` 转 CST 的日期部分
3. BASH_DATE — `date "+%Y-%m-%d"`

## 决策矩阵

| CTX vs SCHED | CTX vs BASH | SCHED vs BASH | 决策 |
|---|---|---|---|
| = | = | = | 直接采用 CTX |
| = | ≠ | ≠ | 采用 CTX，记录 bash 漂移 |
| ≠ | = | ≠ | **采用 SCHED**（如本次），CTX/BASH 同步漂移 |
| ≠ | ≠ | = | 采用 BASH=SCHED，CTX 单独漂移 |
| ≠ | ≠ | ≠ | 采用 SCHED（调度器是唯一不可辩驳的触发事实） |

## 旁证

- env header 中的 "Today's date: ..." 与 `ls -la` 文件系统时间戳，可作为辅助旁证。
- 当 SCHED_DATE 与运行槽位（morning=05:00 CST / daily=22:00 CST）语义一致时，优先级抬升。

## 备注

- 本规则在 2026-05-24 晨跑首次触发：CTX=2026-05-23，SCHED=2026-05-24，BASH=2026-05-23。
- 输出文件夹按 SCHED_DATE 命名：`/2026-05-24/...`，避免在用户视角下出现『晨报夹到昨天文件夹』的现象。
