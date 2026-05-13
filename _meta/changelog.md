# RumorCrusher 项目演进日志

## 2026-05-14
- 项目启动
- 完成需求对齐：信源/范围/输出格式/部署方式/可视化风格
- 搭建目录骨架与种子文件
- 完成：scope.md, source-list.yaml, agents-architecture.md
- 完成：skills 四件套（fact-check / pseudoscience / source-credibility / logical-fallacy）
- 完成：wiki/_index.md 图谱框架
- 完成：.gitignore + secrets.example.yaml（密钥隔离）
- 待办：HTML 仪表盘模板、首次试运行、22:00 定时任务、GitHub Pages 上线
- 待办（阻塞）：等用户重置 Feishu App Secret + 提供 receive_id

## 2026-05-14 · 定时任务首次触发（自动）
- 触发：scheduled-task `rumorcrusher-daily`
- 由于今日（2026-05-14）即首日试运行所在日，已存在完整的多 Agent 流水线产出（20 条采集 / 9 pass / 9 warn / 2 fail），本次定时触发执行的是**校验 + 发布**子集，未重新采集以避免覆盖人工种子内容。
- 本次执行的步骤：
  - ✓ 校验目录结构：01-raw、02-annotations、03~06 报告、index.html 全部就位
  - ✓ 校验密钥隔离：`secrets.local.yaml` 未被 git 跟踪、未被 staged
  - ✓ 提交 Benchmark-Driven QA 框架升级：`agents-architecture.md v0.2`（新增 Check-Worthiness/Self-Evaluation Agent）、`fact-check-playbook.md` 追加 §4 AVeriTeC+RealFactBench+MultiCW+TSVer 四件套、新增 `06-self-eval.md` 自评卡
  - → daily_publish.sh 推送：见 `_meta/notify-failures.log`（如有失败）
- 下一日（2026-05-15）起，自评卡由 Self-Evaluation Agent 实时生成。
