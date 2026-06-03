# 日期漂移修复文档
**发现时间：** 2026-06-02（因06-01产出写入错误日期后复盘）

## 根因
沙盒时钟（bash `date`）在UTC+8转换时存在漂移，导致 BASH_DATE 显示为前一日。

## 修复规范（从2026-06-02起强制执行）
1. 从 system-reminder 中读取 `currentDate: Today's date is YYYY-MM-DD` 作为 CTX_DATE（最权威）
2. BASH_DATE 仅作第三源验证，不作为 TODAY 赋值依据
3. TODAY 强制等于 CTX_DATE：`TODAY="${CTX_DATE}"`
4. 若 CTX_DATE != BASH_DATE，写入漂移告警到报告

## 受影响批次
- 2026-06-01 morning（TODAY写为2026-06-01，与CTX_DATE=2026-06-02不符，实为06-02数据错写入06-01目录）
- 2026-06-02 morning（已补跑修复）
