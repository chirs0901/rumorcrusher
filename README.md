# RumorCrusher · 粉碎谣言，侦测事实真伪

> 一个每日运行的手机硬件类资讯**事实核查 + 知识沉淀**系统。
> 每天 22:00 自动采集中英文+官方+学术+视频多源内容，由多 Agent 审核委员会做事实/伪科学/逻辑/三观核查，产出两份报告：
>
> - **质检报告**：本日发现的有问题内容清单 + 证据 + 方法论
> - **干净分析报告**：剔除所有问题内容后的洞察分析
>
> 同时驱动两个**知识飞轮**：
>
> 1. **个人技能库** (`skills/`)：每日新发现的核查方法持续追加
> 2. **LLM Wiki** (`wiki/`)：Karpathy 风格的实体+主题混合图谱

## 公开报告地址

> 部署到 GitHub Pages 后，公开访问链接为：
> `https://chirs0901.github.io/rumorcrusher/`
>
> （首次发布后此链接生效）

## 目录结构

```
RumorCrusher/
├── README.md                     # 本文件
├── .gitignore                    # 排除密钥
├── _meta/
│   ├── scope.md                  # 采集范围定义
│   ├── source-list.yaml          # 信源清单（含可信度）
│   ├── agents-architecture.md    # 多Agent架构
│   ├── changelog.md              # 项目演进日志
│   ├── secrets.example.yaml      # 密钥模板（不含真实值）
│   └── secrets.local.yaml        # 真实密钥（被gitignore忽略）
├── skills/                       # 个人技能库（飞轮①）
│   ├── fact-check-playbook.md
│   ├── pseudoscience-patterns.md
│   ├── source-credibility.md
│   └── logical-fallacy-catalog.md
├── wiki/                         # LLM Wiki（飞轮②）
│   ├── _index.md
│   ├── entities/{soc,brand,tech}/
│   └── topics/
└── YYYY-MM-DD/                   # 每日产出
    ├── 01-raw/
    ├── 02-annotations/
    ├── 03-quality-report.md
    ├── 04-clean-report.md
    ├── 05-methodology-delta.md
    └── index.html                # 仪表盘可视化
```

## 项目方
- 负责人：Croesuszn Perrygi
- GitHub：[@chirs0901](https://github.com/chirs0901)
- 启动日期：2026-05-14
