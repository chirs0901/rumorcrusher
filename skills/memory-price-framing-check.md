# Memory Price Framing Check
## 内存价格数据框架核查规则
- 当内存/存储价格涨幅>200%时，必须区分：
  - 消费市场现货价（DRAMeXchange spot price）
  - OEM长约采购价（TrendForce quarterly contract price）
- OEM实际采购成本涨幅参考：TrendForce/IDC季度数据（通常40~80%）
- 禁止用现货价暗示OEM成本涨幅——属misleading_framing逻辑谬误
- 典型案例：DDR4 16GB $12.8→$79（2026-06-02，ID-9，标注clickbait+误导框架）
