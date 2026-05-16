# RumorCrusher 定时任务注册说明

由于注册定时任务只能在**普通 Claude 会话**（非 scheduled-task session）中操作，
请在 Cowork 普通对话中对 Claude 说以下话，Claude 会自动调用工具完成注册：

---

## 任务 1：每日早 7:00 晨跑

对 Claude 说：
> 请帮我注册一个每天早上 7:00 的 RumorCrusher 晨跑定时任务，任务 ID 是 `rumorcrusher-morning`，
> 描述是"每日 07:00 晨跑 RumorCrusher 流水线"，
> cron 表达式是 `0 7 * * *`，
> prompt 内容从文件 `/sessions/dazzling-serene-mendel/mnt/RumorCrusher/scripts/morning-skill.md` 里读取。

---

## 任务 2：本次补跑（约 2 小时后一次性）

对 Claude 说：
> 请帮我创建一个一次性的 RumorCrusher 补跑任务，任务 ID 是 `rumorcrusher-onetime-0516`，
> 触发时间是 `2026-05-16T05:16:00+08:00`，
> prompt 内容与 rumorcrusher-daily 相同。

---

## 已就绪
- 晨跑 SKILL.md 已写入：`scripts/morning-skill.md`
- 代理配置已更新：`scripts/daily_publish.sh`（优先 7897，fallback 1080）
- 今日流水线产出：`2026-05-15/` 全套文件就绪，git commit 完成（push 待代理可达时手动执行）
