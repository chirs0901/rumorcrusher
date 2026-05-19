#!/usr/bin/env bash
REPO="$HOME/Documents/Claude/Projects/RumorCrusher"
LOG="$REPO/_meta/autopush.log"
cd "$REPO" || exit 1

TS=$(date "+%Y-%m-%d %H:%M:%S")

# 清理残余锁文件
find .git -name "*.lock" -delete 2>/dev/null

# 先 pull --rebase 确保本地不落后于远端
echo "[$TS] 执行 git pull --rebase..." >> "$LOG"
git pull --rebase origin main >> "$LOG" 2>&1
PULL_STATUS=$?

if [ $PULL_STATUS -ne 0 ]; then
    echo "[$TS] ⚠️  pull/rebase 失败，中止推送" >> "$LOG"
    exit 1
fi

# 检查是否有未推送的 commits
LOCAL=$(git rev-parse HEAD 2>/dev/null)
REMOTE=$(git rev-parse origin/main 2>/dev/null)

if [ "$LOCAL" != "$REMOTE" ] && [ -n "$LOCAL" ]; then
    echo "[$TS] 检测到未推送 commits ($LOCAL)，开始推送..." >> "$LOG"

    if git push origin main >> "$LOG" 2>&1; then
        echo "[$TS] ✅ push 成功" >> "$LOG"
    else
        echo "[$TS] ❌ push 失败" >> "$LOG"
    fi
else
    echo "[$TS] 无新 commits，跳过" >> "$LOG"
fi
