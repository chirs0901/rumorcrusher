# 注册午跑定时任务（一次性操作）

在**常规 Cowork 窗口**（非定时任务窗口）中，发送以下消息给 Claude：

---

请帮我注册一个每日12:00的定时任务，taskId 为 `rumorcrusher-noon`，cron 表达式为 `0 12 * * *`，描述为"每日 12:00 午跑 RumorCrusher 流水线（v0.1 · 午间补充更新）"，prompt 内容参照 `/Users/zhiqiao/Documents/Claude/Scheduled/rumorcrusher-morning/SKILL.md` 的结构，但将 RUN_SLOT 改为 "noon"、时间说明改为"12:00 午跑"、HTML横幅改为"🌤 12:00 午报更新"。

---

完成后三条定时任务将全部生效：
- 05:00 晨跑（rumorcrusher-morning）✅ 已激活
- 12:00 午跑（rumorcrusher-noon）⏳ 待注册
- 22:00 晚跑（rumorcrusher-daily）✅ 已激活
