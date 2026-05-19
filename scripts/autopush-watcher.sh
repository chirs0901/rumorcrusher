#!/usr/bin/env bash
REPO="$HOME/Documents/Claude/Projects/RumorCrusher"
LOG="$REPO/_meta/autopush.log"
cd "$REPO" || exit 1

# 清理残余锁文件
find .git -name "*.lock" -delete 2>/dev/null

# 检查是否有未推送的 commits
LOCAL=$(git rev-parse HEAD 2>/dev/null)
REMOTE=$(git rev-parse origin/main 2>/dev/null)

if [ "$LOCAL" != "$REMOTE" ] && [ -n "$LOCAL" ]; then
    TS=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[$TS] 检测到未推送 commits ($LOCAL)，开始推送..." >> "$LOG"
    
    if git push origin main >> "$LOG" 2>&1; then
        echo "[$TS] ✅ push 成功" >> "$LOG"
    else
        echo "[$TS] ❌ push 失败" >> "$LOG"
    fi
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] 无新 commits，跳过" >> "$LOG"
fi
