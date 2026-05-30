#!/usr/bin/env bash
# RumorCrusher 本地 autopush 守护脚本 v2
# 由 launchd LaunchAgent 每 5 分钟调用一次。
#
# ── 预警机制 ─────────────────────────────────────────────────────
#   连续失败 3 次（≥15 分钟）→ 写入 _meta/push-failure.flag
#   连续失败 6 次（≥30 分钟）→ 发送 macOS 系统通知
#   推送成功 → 清除 flag 文件
#   每日定时流水线启动时读取 flag 文件；有 flag 则预警并中止
# ─────────────────────────────────────────────────────────────────
#
# ── 锁机制 ───────────────────────────────────────────────────────
#   用 mkdir 原子锁（macOS/Linux 通用）替代 flock（Linux-only）
# ─────────────────────────────────────────────────────────────────

set -u

REPO="${RUMORCRUSHER_REPO:-$HOME/Documents/Claude/Projects/RumorCrusher}"
BRANCH="${RUMORCRUSHER_BRANCH:-main}"
REMOTE="${RUMORCRUSHER_REMOTE:-origin}"
LOCKDIR="/tmp/rumorcrusher-autopush.lock.d"
LOG_DIR="$REPO/_meta"
LOG_FILE="$LOG_DIR/autopush.log"
FAIL_FLAG="$LOG_DIR/push-failure.flag"   # 预警标志文件
FAIL_COUNT_FILE="/tmp/rc-push-fail-count" # 临时失败计数

log() {
  local ts; ts=$(date "+%Y-%m-%d %H:%M:%S %Z")
  printf '[%s] %s\n' "$ts" "$*" >> "$LOG_FILE"
  printf '[%s] %s\n' "$ts" "$*"   # 同时输出到 stdout（launchd 捕获）
}

alert_macos() {
  # macOS 系统通知（即使锁屏也会弹出）
  osascript -e "display notification \"$1\" with title \"🚨 RumorCrusher 推送失败\" sound name \"Basso\"" 2>/dev/null || true
  # 同时写入 macOS 系统日志，方便 Console.app 查看
  logger -t rumorcrusher-autopush "ALERT: $1"
}

write_fail_flag() {
  local count="$1" last_err="$2"
  cat > "$FAIL_FLAG" << EOF
PUSH_FAILED
first_failure: $(head -1 "$FAIL_FLAG" 2>/dev/null | grep -o 'first_failure:.*' | cut -d' ' -f2 || date '+%Y-%m-%d %H:%M:%S')
last_failure: $(date '+%Y-%m-%d %H:%M:%S %Z')
consecutive_failures: $count
last_error: $last_err
fix_command: bash $REPO/scripts/push-now.sh
EOF
}

# ── 基本健康检查 ──────────────────────────────────────────────────
if [ ! -d "$REPO/.git" ]; then
  logger -t rumorcrusher-autopush "REPO=$REPO is not a git repository, skipping"
  exit 0
fi

mkdir -p "$LOG_DIR"
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

# ── 获取原子锁 ────────────────────────────────────────────────────
if ! mkdir "$LOCKDIR" 2>/dev/null; then
  # 检查是否僵死锁（超过 10 分钟）
  if command -v stat >/dev/null 2>&1; then
    LOCK_MTIME=$(stat -f %m "$LOCKDIR" 2>/dev/null || stat -c %Y "$LOCKDIR" 2>/dev/null || echo 0)
    LOCK_AGE=$(( $(date +%s) - LOCK_MTIME ))
  else
    LOCK_AGE=0
  fi
  if [ "$LOCK_AGE" -gt 600 ]; then
    log "WARN: stale lock (age=${LOCK_AGE}s), removing"
    rmdir "$LOCKDIR" 2>/dev/null || true
    mkdir "$LOCKDIR" 2>/dev/null || { log "skip: cannot acquire lock after cleanup"; exit 0; }
  else
    # 正常的锁争用，静默退出（不刷日志）
    exit 0
  fi
fi
trap 'rmdir "$LOCKDIR" 2>/dev/null; exit' EXIT INT TERM

cd "$REPO" || { log "fatal: cd to $REPO failed"; exit 0; }

# ── 清理 git 残余锁文件 ───────────────────────────────────────────
find .git -name "*.lock" -mmin +5 -delete 2>/dev/null || true

# ── fetch 远端 ────────────────────────────────────────────────────
if ! git fetch --quiet "$REMOTE" "$BRANCH" 2>>"$LOG_FILE"; then
  FAIL_N=$(( $(cat "$FAIL_COUNT_FILE" 2>/dev/null || echo 0) + 1 ))
  echo "$FAIL_N" > "$FAIL_COUNT_FILE"
  log "fetch failed (consecutive=$FAIL_N)"
  write_fail_flag "$FAIL_N" "git fetch failed"
  if [ "$FAIL_N" -ge 6 ]; then
    alert_macos "连续 ${FAIL_N} 次 fetch 失败！请运行 push-now.sh 修复"
  fi
  exit 0
fi

# ── 判断是否需要 push ─────────────────────────────────────────────
AHEAD=$(git rev-list --count "$REMOTE/$BRANCH..$BRANCH" 2>/dev/null || echo 0)
BEHIND=$(git rev-list --count "$BRANCH..$REMOTE/$BRANCH" 2>/dev/null || echo 0)

if [ "$AHEAD" = "0" ]; then
  # 无待推送 commit，同时清除失败状态（说明网络正常）
  if [ -f "$FAIL_FLAG" ]; then
    log "network OK (no commits to push), clearing failure flag"
    rm -f "$FAIL_FLAG" "$FAIL_COUNT_FILE"
  fi
  exit 0
fi

if [ "$BEHIND" != "0" ]; then
  if ! git merge --ff-only "$REMOTE/$BRANCH" >>"$LOG_FILE" 2>&1; then
    log "WARN diverged (ahead=$AHEAD behind=$BEHIND); manual resolve needed"
    write_fail_flag "$(cat "$FAIL_COUNT_FILE" 2>/dev/null || echo 1)" "diverged, manual resolve needed"
    alert_macos "仓库分叉！需要手动处理（ahead=$AHEAD behind=$BEHIND）"
    exit 0
  fi
fi

# ── 推送 ──────────────────────────────────────────────────────────
log "pushing $AHEAD commit(s) to $REMOTE/$BRANCH ..."
PUSH_LOG=$(git push "$REMOTE" "$BRANCH" 2>&1)
PUSH_EXIT=$?

if [ $PUSH_EXIT -eq 0 ]; then
  HEAD_SHA=$(git rev-parse --short HEAD)
  log "OK pushed $AHEAD commit(s), HEAD=$HEAD_SHA"
  # ── 推送成功：清除所有预警状态 ──
  if [ -f "$FAIL_FLAG" ]; then
    log "push recovered — clearing failure flag"
    rm -f "$FAIL_FLAG" "$FAIL_COUNT_FILE"
  fi
  echo 0 > "$FAIL_COUNT_FILE"
else
  FAIL_N=$(( $(cat "$FAIL_COUNT_FILE" 2>/dev/null || echo 0) + 1 ))
  echo "$FAIL_N" > "$FAIL_COUNT_FILE"
  log "ERR push failed (consecutive=$FAIL_N): $PUSH_LOG"
  write_fail_flag "$FAIL_N" "${PUSH_LOG:0:120}"

  # 失败 3 次（15 分钟）：写入 flag 文件，下次定时任务启动时会发现并中止
  if [ "$FAIL_N" -ge 3 ]; then
    log "ALERT: $FAIL_N consecutive push failures — flag written, pipeline will abort on next run"
  fi
  # 失败 6 次（30 分钟）：macOS 系统通知
  if [ "$FAIL_N" -ge 6 ]; then
    alert_macos "推送已连续失败 ${FAIL_N} 次！运行 scripts/push-now.sh 修复"
  fi
fi
