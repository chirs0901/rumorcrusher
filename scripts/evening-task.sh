#!/usr/bin/env bash
# RumorCrusher 晚跑定时任务脚本 (22:00)
# 每天晚上10点：汇总全天每小时采集数据 → 生成4份日报 → 推送到GitHub

set -e

REPO="/Users/zhiqiao/Documents/Qoder/RumorCrusher-qoder"
DATE=$(date +%Y-%m-%d)
LOG_FILE="$REPO/_meta/evening-run.log"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S %Z")

echo "[$TIMESTAMP] 🌙 开始晚跑 RumorCrusher 流水线..." >> "$LOG_FILE"

cd "$REPO" || exit 1

# 检查是否有待处理的失败标志（仅阻止推送步骤）
SKIP_PUSH=false
if [ -f "_meta/push-failure.flag" ]; then
    echo "[$TIMESTAMP] ⚠️ 检测到推送失败标志，跳过推送步骤" >> "$LOG_FILE"
    cat "_meta/push-failure.flag" >> "$LOG_FILE"
    SKIP_PUSH=true
fi

# ── [1/3] 最后采集一次当前小时数据 ──
echo "[$TIMESTAMP] [1/3] 执行每小时采集..." >> "$LOG_FILE"
python3 scripts/hourly_collector.py >> "$LOG_FILE" 2>&1 || echo "[$TIMESTAMP] ⚠️ 采集失败（继续执行）" >> "$LOG_FILE"

# ── [2/3] 汇总全天数据 → 生成4份日报 + wiki更新 ──
echo "[$TIMESTAMP] [2/3] 生成日报（质检/干净/方法论/自评）..." >> "$LOG_FILE"
python3 scripts/daily_report_generator.py >> "$LOG_FILE" 2>&1 || echo "[$TIMESTAMP] ⚠️ 日报生成失败" >> "$LOG_FILE"

# ── [3/3] 发布到GitHub ──
if [ "$SKIP_PUSH" = true ]; then
    echo "[$TIMESTAMP] ⏭️ 跳过推送（有失败标志）" >> "$LOG_FILE"
else
    echo "[$TIMESTAMP] [3/3] 推送到 GitHub..." >> "$LOG_FILE"
    bash scripts/daily_publish.sh "$DATE" >> "$LOG_FILE" 2>&1
fi

echo "[$TIMESTAMP] ✅ 晚跑流水线完成" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"
