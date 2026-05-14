# LLM Wiki 索引 / Knowledge Graph Index

> **Karpathy 风格的"知识飞轮"** —— 每日干净报告中的事实、关系、结论会持续合并进此图谱。混合图谱：同时维护**实体节点**（具体的芯片、品牌、机型、技术）和**主题节点**（趋势、事件、争议）。
>
> 编辑规则：所有内容必须有可追溯的信源链接（指向原始报告或外部权威）。每次合并若发现冲突，旧条目不删除，而是用 `> 已更正` 区块叠加，保留历史。

## 一、实体节点 / Entities

### SoC 芯片
- [ ] `entities/soc/snapdragon-x-elite-gen2.md` — Snapdragon X Elite Gen 2
- [ ] `entities/soc/apple-a19-pro.md` — Apple A19 Pro
- [ ] `entities/soc/mediatek-dimensity-9500.md` — MediaTek Dimensity 9500
- [ ] `entities/soc/google-tensor-g5.md` — Google Tensor G5
- [ ] `entities/soc/kirin-9020.md` — 华为麒麟 9020

### 品牌
- [ ] `entities/brand/apple.md`
- [ ] `entities/brand/samsung.md`
- [ ] `entities/brand/xiaomi.md`
- [ ] `entities/brand/huawei.md`
- [ ] `entities/brand/honor.md`
- [ ] `entities/brand/oppo.md`
- [ ] `entities/brand/vivo.md`
- [ ] `entities/brand/google.md`

### 技术
- [ ] `entities/tech/lpddr5x.md`
- [ ] `entities/tech/ufs4.md`
- [ ] `entities/tech/satellite-comm.md`
- [ ] `entities/tech/foldable-hinge.md`
- [ ] `entities/tech/on-device-llm.md`
- [ ] `entities/tech/computational-photography.md`

## 二、主题节点 / Topics

- [ ] `topics/2026-flagship-cycle.md` — 2026 年旗舰周期总览
- [ ] `topics/on-device-ai-race.md` — 端侧 AI 竞赛
- [ ] `topics/foldable-mainstreaming.md` — 折叠屏走向大众化
- [ ] `topics/satellite-everywhere.md` — 卫星通信普及
- [ ] `topics/ar-vision-pro-aftermath.md` — Apple Vision Pro 之后的头显格局

## 三、引用与冲突管理

- 每个实体页底部都有 `## 信源` 区块，记录所有提供过事实的报告链接
- 每个事实必须标注：「报告日期 + 信源 + Agent 标记的可信度」
- 当两个信源对同一事实给出冲突结论时：
  1. 优先采纳官方/高可信源
  2. 保留低可信源结论于 `### 待验证` 子区
  3. 若 30 天内无新证据，迁移到 `### 历史争议（已归档）`

## 四、自动更新流程

```
每日 22:00 试运行完成 → wiki-updater Agent 触发
    ├─ 扫描当日 04-clean-report.md 中提到的所有实体
    ├─ 对每个实体：
    │     • 若 wiki/entities/.../X.md 已存在 → 增量合并
    │     • 不存在 → 自动创建并填入首次出现的事实
    ├─ 扫描主题趋势 → 追加到对应 topics/X.md
    └─ 更新本 _index.md 的 [x] 状态
```

## 五、变更日志

- 2026-05-14：初始化索引框架，等待首日试运行填充内容
