# RumorCrusher 定时任务配置指引
> 生成时间：2026-05-16 03:35 CST
> 背景：在 scheduled-task session 内无法直接注册/更新定时任务，需在普通 Claude 对话中操作

---

## 操作步骤：在普通 Claude 对话中粘贴以下指令

---

### 任务一：补跑（约 2 小时后，一次性）

> 帮我创建一个一次性 RumorCrusher 补跑定时任务：
> - taskId: rumorcrusher-onetime-0516
> - fireAt: 2026-05-16T05:16:00+08:00
> - description: 2026-05-16 05:16 单次补跑
> - prompt: 使用与 rumorcrusher-daily 相同的流水线 prompt，从文件 /sessions/dazzling-serene-mendel/mnt/RumorCrusher/scripts/morning-skill.md 读取内容

---

### 任务二：每日 07:00 晨跑（新增常设任务）

> 帮我创建一个每天 07:00 的 RumorCrusher 晨跑定时任务：
> - taskId: rumorcrusher-morning
> - cronExpression: 0 7 * * *
> - description: 每日 07:00 晨跑 RumorCrusher 流水线（v0.4 · 晨报版）
> - prompt: 从文件 /sessions/dazzling-serene-mendel/mnt/RumorCrusher/scripts/morning-skill.md 读取

---

### 任务三：更新 22:00 任务 SKILL（支持晨报合并 + 代理7897）

> 帮我更新 rumorcrusher-daily 这个定时任务：
> - description 改为：每日 22:00 跑 RumorCrusher 流水线（v0.4 · 支持晨报合并 + 代理7897）
> - prompt 从文件 /sessions/dazzling-serene-mendel/mnt/RumorCrusher/scripts/evening-skill-v4.md 读取

---

## 当前状态

| 事项 | 状态 |
|------|------|
| 今日（05-15）流水线 | ✅ 完成（40条采集，10条Refuted辟谣）|
| git commit | ✅ 已提交 |
| git push | ❌ 失败（sandbox代理不通7897）|
| 飞书/邮件 | ❌ 跳过（依赖git push成功）|
| 22:00 SKILL.md v0.4 | ✅ 已写入 scripts/evening-skill-v4.md |
| 07:00 SKILL.md | ✅ 已写入 scripts/morning-skill.md |

## 手动 push 命令（在本机终端执行）
```bash
cd ~/Documents/Claude/RumorCrusher  # 或你的本地路径
git push origin main
```
