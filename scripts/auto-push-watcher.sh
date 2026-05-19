#!/bin/bash
# RumorCrusher 自动推送守护脚本
# 监测定时任务完成标志，自动 git push
RCPATH="$HOME/Documents/Claude/Projects/RumorCrusher"
FLAG_FILE="$RCPATH/_meta/.push-pending"
LOG="$RCPATH/_meta/auto-push.log"

if [ -f "$FLAG_FILE" ]; then
  TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
  echo "[$TIMESTAMP] 检测到推送标志，开始 git push..." >> "$LOG"
  cd "$RCPATH"
  export https_proxy=http://127.0.0.1:7897
  if git -c http.version=HTTP/1.1 push origin main >> "$LOG" 2>&1; then
    echo "[$TIMESTAMP] ✓ 推送成功" >> "$LOG"
    rm -f "$FLAG_FILE"
  else
    unset https_proxy
    if git -c http.version=HTTP/1.1 push origin main >> "$LOG" 2>&1; then
      echo "[$TIMESTAMP] ✓ 推送成功（无代理）" >> "$LOG"
      rm -f "$FLAG_FILE"
    else
      echo "[$TIMESTAMP] ✗ 推送失败，将在下次检查时重试" >> "$LOG"
    fi
  fi
fi
