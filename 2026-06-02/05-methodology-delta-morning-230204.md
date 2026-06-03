# 方法论 Delta ☀️ 2026-06-02（补跑版）

## 🔧 日期漂移根因修复（最重要更新）

**根因：** 沙盒时钟（BASH_DATE）在UTC+8转换时存在约22小时漂移，显示为前一日日期。

**修复方案（已写入执行规范）：**
```bash
# 旧逻辑（错误）：
TODAY=$(date "+%Y-%m-%d")   # 直接使用 bash 时钟

# 新逻辑（修复）：
CTX_DATE="2026-06-02"        # 第一源：从 system-reminder 读取 currentDate
BASH_DATE=$(date "+%Y-%m-%d") # 第三源：bash 时钟，仅做校验
if [ "${CTX_DATE}" != "${BASH_DATE}" ]; then
  echo "⚠️ 漂移警告：以 CTX_DATE=${CTX_DATE} 为准"
fi
TODAY="${CTX_DATE}"           # 强制使用 CTX_DATE，不依赖 bash 时钟
```

**写入位置：** `_meta/date-drift-fix.md`（新建）

---

## 新增核查规则

### 1. 误导性价格框架识别（ID-9触发）
- **规则：** 当内存/存储价格数据极端（涨幅>200%）时，必须区分"消费市场现货价"与"OEM长约采购价"
- **标准：** OEM长约价通常为TrendForce/DRAMeXchange季度均价；现货价波动更大，不代表OEM成本
- **加入：** `skills/memory-price-framing-check.md`

### 2. 未确认科技合作声称优先标注指引
- **触发：** OpenAI+高通/联发科案例（ID-3）
- **规则：** 涉及大厂未公开确认合作时，若多媒体报道细节互相冲突（如供应商选择），即使报道数量多也不升级为Supported
- **更新：** `skills/unconfirmed-partnership-handling.md`（追加条款）
