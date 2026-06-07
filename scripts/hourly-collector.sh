#!/usr/bin/env bash
# RumorCrusher · 每小时采集 wrapper
# 由 LaunchAgent 每小时调用
REPO="/Users/zhiqiao/Documents/Qoder/RumorCrusher-qoder"
LOG="$REPO/_meta/hourly-collector.log"

cd "$REPO" || exit 1

# 执行 Python 采集器
python3 scripts/hourly_collector.py >> "$LOG" 2>&1
