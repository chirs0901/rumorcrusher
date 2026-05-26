#!/usr/bin/env bash
# RumorCrusher 本地 autopush 守护脚本
# 由 launchd LaunchAgent 每 5 分钟调用一次。
# 任务：检查仓库是否有本地领先 origin/main 的 commit，有就推；没有就静默退出。
#
# 设计要点：
#   - 用 flock 保证不会两个实例并发跑
#   - 用 git fetch + rev-list 判断是否真的需要 push（避免无谓的网络调用）
#   - 推送失败不抛错（launchd 会反复退出码失败导致冷却），只写日志
#   - 日志在 _meta/autopush.log，按天滚动
#   - 不依赖任何外部 token，吃 macOS keychain 里已有的 git credential helper

set -u

REPO="${RUMORCRUSHER_REPO:-$HOME/Documents/Claude/Projects/RumorCrusher}"
BRANCH="${RUMORCRUSHER_BRANCH:-main}"
REMOTE="${RUMORCRUSHER_REMOTE:-origin}"
LOCKFILE="/tmp/rumorcrusher-autopush.lock"
LOG_DIR="$REPO/_meta"
LOG_FILE="$LOG_DIR/autopush.log"

log() {
  local ts
  ts=$(date "+%Y-%m-%d %H:%M:%S %Z")
  printf '[%s] %s\n' "$ts" "$*" >> "$LOG_FILE"
}

# 基本健康检查
if [ ! -d "$REPO/.git" ]; then
  # 仓库不存在或不是 git 仓库时，写到系统日志而不是 _meta（_meta 可能也不存在）
  logger -t rumorcrusher-autopush "REPO=$REPO is not a git repository, skipping"
  exit 0
fi

mkdir -p "$LOG_DIR"

# 获取独占锁；拿不到（上一轮还没跑完）就直接退出
exec 9>"$LOCKFILE"
if ! flock -n 9; then
  log "skip: previous run still holding lock"
  exit 0
fi

cd "$REPO" || { log "fatal: cd to $REPO failed"; exit 0; }

# 让 launchd 环境也能找到 git / ssh
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

# 1) 先抓远端最新引用
if ! git fetch --quiet "$REMOTE" "$BRANCH" 2>>"$LOG_FILE"; then
  log "fetch failed; will retry next cycle"
  exit 0
fi

# 2) 判断本地是否领先
AHEAD=$(git rev-list --count "$REMOTE/$BRANCH..$BRANCH" 2>/dev/null || echo 0)
BEHIND=$(git rev-list --count "$BRANCH..$REMOTE/$BRANCH" 2>/dev/null || echo 0)

if [ "$AHEAD" = "0" ]; then
  # 没东西要推，安静退出（不写日志，避免刷屏）
  exit 0
fi

if [ "$BEHIND" != "0" ]; then
  # 远端有本地没有的提交，先尝试 fast-forward；失败就报警等人工
  if ! git merge --ff-only "$REMOTE/$BRANCH" >>"$LOG_FILE" 2>&1; then
    log "WARN diverged from $REMOTE/$BRANCH (ahead=$AHEAD behind=$BEHIND); manual resolve needed"
    exit 0
  fi
fi

# 3) 推送
log "pushing $AHEAD commit(s) to $REMOTE/$BRANCH"
if git push "$REMOTE" "$BRANCH" >>"$LOG_FILE" 2>&1; then
  HEAD_SHA=$(git rev-parse --short HEAD)
  log "OK pushed $AHEAD commit(s), HEAD=$HEAD_SHA"
else
  log "ERR push failed (often: 网络/凭证)；下个周期重试"
fi
