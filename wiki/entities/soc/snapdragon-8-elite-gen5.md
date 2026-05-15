# Snapdragon 8 Elite Gen 5

## 基本信息

| 字段 | 值 |
|---|---|
| 厂商 | Qualcomm |
| 工艺 | 3nm（台积电N3P，按官方口径）|
| NPU | Hexagon NPU，相比上代 +37% 性能 |
| 状态 | 已在 2025/H2 量产，2026 旗舰广泛搭载 |

## 关键事实（带可追溯）

### 性能提升数据
- **NPU +37%**：高通官方发布会数据，相比骁龙8 Elite Gen 4
- **AVeriTeC 标签**：Supported（多个独立分析媒体引用一致）
- **来源**：[news.am Tech 综述](https://tech.news.am/eng/news/6838/qualcomm-mediatek-apple-and-samsung-how-do-the-top-smartphone-processors-of-2026-differ.html) · [2026-05-14 干净报告 §SoC](../../../2026-05-14/04-clean-report.md)

### 端侧 LLM 推理能力
- 高通声称"让端侧 LLM 处理成为现实"——属过度泛化措辞（pseudo_science 给 warn）
- **实际用户体验需第三方测量**：首 token 延迟 / 持续 token/s / 持续负载下的降频曲线
- **AVeriTeC 标签**：Not Enough Evidence（量产机实测尚未由 Geekerwan 等独立机构发布）

## 关联实体

- 搭载机型：vivo X300 Ultra（影像旗舰）、OPPO Find X9 Ultra
- 上下游：[硅碳负极电池](../tech/silicon-carbon-anode.md)
- 竞争对手：MediaTek Dimensity 9500、Apple A19 Pro、Kirin 9030

## 待验证

- 首 token 延迟（量产机实测）
- 持续 LLM 推理的稳态功耗
- 与 Dimensity 9500 在相同 INT4 量化下的 token/s 对比

## 信源历史

| 日期 | 信源 | 内容 | AVeriTeC 标签 |
|---|---|---|---|
| 2026-05-14 | qualcomm-news + tech.news.am | NPU +37% | Supported |
