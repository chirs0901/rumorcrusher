# Methodology Delta — Morning 2026-05-17

## Upgrades vs Yesterday (2026-05-16)

### 1. 新模式：反犹太叙事嫁接（antisemitic_conspiracy_grafting）
汉坦病毒谣言出现将病毒名称与以色列强行关联的变体（N004/N025）。此模式需要独立标签：
- `antisemitic_conspiracy_grafting`：将健康事件与反犹太/反以太叙事强行嫁接

### 2. 机构级深伪（institutional_deepfake）
N009 NRSC案例表明威胁等级升级——从民间PAC到全国级政党机构。建议：
- 新增维度：`actor_tier`（individual / pac / national_party / state_actor）
- `actor_tier = national_party` 时，severity自动上调一级

### 3. 汉坦病毒集群规模升级
5条（vs昨日3条），建议触发"集群告警"阈值（≥4条联动谣言围绕同一事件）

## 指标对比（昨晨 vs 今晨）
| 指标 | 5月16日晨 | 5月17日晨 | 变化 |
|------|-----------|-----------|------|
| 采集条数 | 28 | 26 | -2 |
| Refuted率 | 50.0% | 47.6% | -2.4pp |
| Supported率 | 22.7% | 28.6% | +5.9pp ↑ |
| UnR | 27.3% | 23.8% | -3.5pp ↑ |
| 健康评分 | 92 | 94 | +2 ↑ |
| Critical items | 6 | 5 | -1 |

## 覆盖缺口（同昨日）
- Telegram/Discord封闭平台仍不可见
- 中文辟谣覆盖仍依赖官方平台
