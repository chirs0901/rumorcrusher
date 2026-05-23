# RumorCrusher 晨报 · 方法学增量（2026-05-24 05:05 CST）

## 本次新增 / 调整

1. **日期三源校验异常处理**：本次出现 CTX_DATE(2026-05-23) vs SCHED_DATE(2026-05-24) 不一致情况。新增规则：当 SCHED_DATE 由 lastRunAt 转 CST 推出，且其语义与运行槽位（morning=05:00 CST）一致时，采用 SCHED_DATE，记录 CTX 不一致告警。env 标签与文件系统时间戳作为辅助旁证。
2. **iPhone 17 vs iPhone 18 命名混淆识别器**：本期出现 iPhone 17 已上市 + iPhone 18 Pro 即将发布的双线消息，需在标注阶段明确机型代际，避免误判。
3. **远期 2027 单源消息阈值收紧**：>=18 个月远期 + 单源 + 含『radical』『revolutionary』等情绪词的，clickbait>=0.6 即判 Refuted。
4. **OLED 面板供应链交叉源要求**：BOE/Samsung Display/LG Display 出货量级类消息要求至少 2 个独立媒体源 + 1 个 TrendForce/Counterpoint 类研究源。

## 待沉淀进 skills/

- skills/date-triple-source-fallback.md：补充『CTX 与 SCHED 冲突』的优先级矩阵
- skills/oem-codename-disambiguation.md：补充 iPhone 17/18，Quest 4 Pismo/Puffin 等代号对照表
- wiki/2026-display-supply-chain.md：BOE B16 投产 + Apple-Samsung-LG-BOE 份额最新切片

## 未触发但应保持监测的红线

- 政治 / 地缘 / 灾害 / 名人八卦：0 命中
- 移动游戏评测、纯软件评测：0 命中
- 健康宣称（充电速度 / SAR 等）：1 次黄色提示（M20 OnePlus 15 120W）
