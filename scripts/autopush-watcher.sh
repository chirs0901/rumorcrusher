#!/usr/bin/env bash
# RumorCrusher autopush watcher（由 install-autopush-agent.sh 生成 / launchd 调用）
# macOS/Linux 通用版本 —— 不依赖 flock

REPO="$HOME/Documents/Claude/Projects/RumorCrusher"
LOG="$REPO/_meta/autopush.log"
LOCKDIR="/tmp/rumorcrusher-autopush-watcher.lock.d"

log() { printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*" >> "$LOG"; }

# 原子锁（mkdir，跨平台安全）
if ! mkdir "$LOCKDIR" 2>/dev/null; then
  LOCK_AGE=$(( $(date +%s) - $(stat -f %m "$LOCKDIR" 2>/dev/null || stat -c %Y "$LOCKDIR" 2>/dev/null || echo 0) ))
  [ "$LOCK_AGE" -gt 600 ] && rmdir "$LOCKDIR" 2>/dev/null || { log "skip: lock held ${LOCK_AGE}s"; exit 0; }
  mkdir "$LOCKDIR" 2>/dev/null || { log "skip: cannot acquire lock"; exit 0; }
fi
trap 'rmdir "$LOCKDIR" 2>/dev/null' EXIT INT TERM

export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

cd "$REPO" || { log "fatal: cd failed"; exit 1; }

# 清理残余 git 锁文件（沙盒写入时偶发）
find .git -name "*.lock" -mmin +5 -delete 2>/dev/null

# fetch 远端
git fetch --quiet origin main 2>>"$LOG" || { log "fetch failed"; exit 0; }

LOCAL=$(git rev-parse HEAD 2>/dev/null)
REMOTE_SHA=$(git rev-parse origin/main 2>/dev/null)

if [ "$LOCAL" = "$REMOTE_SHA" ]; then
  exit 0   # 已同步，静默退出
fi

AHEAD=$(git rev-list --count origin/main..HEAD 2>/dev/null || echo 0)
if [ "$AHEAD" = "0" ]; then
  exit 0
fi

log "检测到 $AHEAD 个未推送 commit，开始 push..."
if git push origin main >> "$LOG" 2>&1; then
  log "✅ push 成功 HEAD=$(git rev-parse --short HEAD)"
else
  log "❌ push 失败（检查网络/代理/凭证）"
fi
