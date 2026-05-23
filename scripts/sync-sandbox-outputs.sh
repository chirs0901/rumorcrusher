#!/usr/bin/env bash
# 把 Claude 定时任务 sandbox 里的产出同步到真实仓库
# 用法：bash scripts/sync-sandbox-outputs.sh
# 退出码：0=有变化 / 2=无变化 / 1=错误

RCPATH="$HOME/Documents/Claude/Projects/RumorCrusher"
SANDBOX_BASE="$HOME/Library/Application Support/Claude/local-agent-mode-sessions"
LOG="$RCPATH/_meta/sync-sandbox.log"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

mkdir -p "$RCPATH/_meta"

# 找出最近 24 小时内修改过、且包含 outputs/RumorCrusher/ 的所有 sandbox
# 用 while-read 兼容 bash 3.2（macOS 默认）
LATEST=""
LATEST_MTIME=0
while IFS= read -r c; do
  [ -z "$c" ] && continue
  MT=$(stat -f %m "$c" 2>/dev/null)
  if [ -n "$MT" ] && [ "$MT" -gt "$LATEST_MTIME" ]; then
    LATEST_MTIME="$MT"
    LATEST="$c"
  fi
done < <(find "$SANDBOX_BASE" -maxdepth 5 -type d -name "RumorCrusher" -path "*/outputs/*" -mmin -1440 2>/dev/null)

if [ -z "$LATEST" ]; then
  echo "[$TIMESTAMP] 无法定位最新 sandbox" >> "$LOG"
  exit 1
fi

echo "[$TIMESTAMP] 同步源: $LATEST" >> "$LOG"

# 关键步骤：先校验 sandbox 里的 tech-digest/index.html JS 语法
SANDBOX_TD="$LATEST/tech-digest/index.html"
if [ -f "$SANDBOX_TD" ]; then
  # 临时把它放到真实仓库的旁边做校验（不污染真实文件）
  TMP_TD="$RCPATH/tech-digest/.sandbox-candidate.html"
  cp "$SANDBOX_TD" "$TMP_TD"
  # 临时把校验目标指向候选文件
  ORIG_TD="$RCPATH/tech-digest/index.html"
  cp "$ORIG_TD" "$ORIG_TD.backup-pre-sync"
  mv "$TMP_TD" "$ORIG_TD"
  if ! bash "$RCPATH/scripts/validate-tech-digest.sh" >/dev/null 2>&1; then
    # 校验失败 → 回滚，拒绝同步 tech-digest
    mv "$ORIG_TD.backup-pre-sync" "$ORIG_TD"
    echo "[$TIMESTAMP] ⚠️ sandbox tech-digest JS 校验失败，跳过其同步（其他文件继续）" >> "$LOG"
    osascript -e "display notification \"sandbox tech-digest JS 异常，已拒绝同步\" with title \"RumorCrusher 同步守护\"" 2>/dev/null
    SKIP_TD=1
  else
    rm -f "$ORIG_TD.backup-pre-sync"
    SKIP_TD=0
  fi
fi

# rsync sandbox → repo
#   --update: 仅当源文件较新才覆盖（防止旧 sandbox 内容覆盖较新本地版本）
EXCLUDES=(
  # —— 永远不动的目录 ——
  --exclude=.git
  --exclude=.DS_Store

  # —— 本机本地维护的基础设施脚本（绝不允许 sandbox 覆盖）——
  --exclude=scripts/daily_publish.sh
  --exclude=scripts/auto-push-watcher.sh
  --exclude=scripts/autopush-watcher.sh
  --exclude=scripts/validate-tech-digest.sh
  --exclude=scripts/sync-sandbox-outputs.sh
  --exclude=scripts/fix-locks-and-push.sh

  # —— 本机日志（sandbox 没有这些上下文）——
  --exclude=_meta/auto-push.log
  --exclude=_meta/auto-push-launchd.log
  --exclude=_meta/sync-sandbox.log
  --exclude=_meta/.push-pending

  # —— 凭据/配置类（绝对不能被覆盖）——
  --exclude=.git-credentials
  --exclude=scripts/secrets*
  --exclude=scripts/config*.yaml
  --exclude=scripts/config*.yml
)
[ "${SKIP_TD:-0}" = "1" ] && EXCLUDES+=( --exclude=tech-digest/index.html )

rsync -a --update "${EXCLUDES[@]}" "$LATEST/" "$RCPATH/" 2>&1 | tee -a "$LOG"

# 检查仓库是否有新变化
cd "$RCPATH"
if [ -z "$(git status --porcelain 2>/dev/null)" ]; then
  echo "[$TIMESTAMP] 同步后仓库无变化（sandbox 内容可能已存在）" >> "$LOG"
  exit 2
fi

# 自动 commit 同步内容
git add -A
COMMIT_MSG="auto-sync from sandbox $(basename "$(dirname "$(dirname "$LATEST")")") at $TIMESTAMP"
if git commit -m "$COMMIT_MSG" >> "$LOG" 2>&1; then
  echo "[$TIMESTAMP] ✅ 自动 commit 成功" >> "$LOG"
  exit 0
else
  echo "[$TIMESTAMP] ❌ commit 失败" >> "$LOG"
  exit 1
fi
