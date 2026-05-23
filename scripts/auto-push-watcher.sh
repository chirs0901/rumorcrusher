#!/bin/bash
# RumorCrusher 自动推送守护脚本 v2
# 每 5 分钟检查本地有无未推送 commit；有就自动 push（不依赖标志文件）
# 这样不管定时任务在哪里跑、是否写得了标志文件，本机都能感知到并推送

RCPATH="$HOME/Documents/Claude/Projects/RumorCrusher"
LOG="$RCPATH/_meta/auto-push.log"

cd "$RCPATH" 2>/dev/null || { echo "[$(date '+%F %T')] ❌ 仓库路径不存在" >> "$LOG"; exit 78; }

# ── 步骤 0：sandbox → repo 同步（拉取定时任务在 sandbox 里的产出）─────────────
# sync-sandbox-outputs.sh 退出码：0=有新内容并自动 commit / 2=无变化 / 1=错误
if [ -x "$RCPATH/scripts/sync-sandbox-outputs.sh" ]; then
  bash "$RCPATH/scripts/sync-sandbox-outputs.sh" >/dev/null 2>&1
fi

# 确保获取最新远端状态（不阻塞太久）
git fetch origin main --quiet 2>/dev/null

# 检查有无未推送 commit
AHEAD=$(git rev-list --count origin/main..HEAD 2>/dev/null)

if [ -z "$AHEAD" ] || [ "$AHEAD" = "0" ]; then
  # 没有未推送 commit，静默退出（避免日志暴涨）
  exit 0
fi

TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
echo "[$TIMESTAMP] 检测到 $AHEAD 个未推送 commit，开始 push..." >> "$LOG"

# 顺序尝试代理：7897 → 1080 → 直连
PUSH_OK=0
for PROXY in "http://127.0.0.1:7897" "http://127.0.0.1:1080" ""; do
  if [ -n "$PROXY" ]; then
    export https_proxy="$PROXY"
    LABEL="proxy=$PROXY"
  else
    unset https_proxy
    LABEL="proxy=none"
  fi
  if git -c http.version=HTTP/1.1 push origin main >> "$LOG" 2>&1; then
    echo "[$TIMESTAMP] ✓ 推送成功（$LABEL）" >> "$LOG"
    PUSH_OK=1
    break
  fi
done

if [ "$PUSH_OK" -eq 0 ]; then
  echo "[$TIMESTAMP] ✗ 所有代理均失败，下次（5分钟后）重试" >> "$LOG"
  exit 1
fi

# 清掉旧的标志文件（如果有）
rm -f "$RCPATH/_meta/.push-pending"

# ── 推送后页面健康自检（等 GitHub Pages 构建）─────────────────
echo "[$(date '+%F %T')] 等待 90 秒后做页面自检..." >> "$LOG"
sleep 90

# 后台跑健康检查，不阻塞主流程
(
  CHECK_TS=$(date "+%F %T")
  URL="https://chirs0901.github.io/rumorcrusher/tech-digest/index.html?t=$(date +%s)"
  HTTP_CODE=$(curl -s -o /tmp/td-check.html -w "%{http_code}" --max-time 20 "$URL" 2>&1)
  FILE_SIZE=$(wc -c < /tmp/td-check.html 2>/dev/null | tr -d ' ')

  # 校验 1: HTTP 状态
  if [ "$HTTP_CODE" != "200" ]; then
    echo "[$CHECK_TS] ⚠️  自检失败：HTTP $HTTP_CODE" >> "$LOG"
    osascript -e "display notification \"tech-digest 返回 HTTP $HTTP_CODE\" with title \"RumorCrusher 推送自检\"" 2>/dev/null
    rm -f /tmp/td-check.html
    exit 1
  fi

  # 校验 2: 文件大小（小于 10KB 大概率是错误页）
  if [ -z "$FILE_SIZE" ] || [ "$FILE_SIZE" -lt 10240 ]; then
    echo "[$CHECK_TS] ⚠️  自检失败：页面大小异常 ${FILE_SIZE} bytes" >> "$LOG"
    osascript -e "display notification \"tech-digest 页面异常小（${FILE_SIZE}B）可能加载失败\" with title \"RumorCrusher 推送自检\"" 2>/dev/null
    rm -f /tmp/td-check.html
    exit 1
  fi

  # 校验 3: 必含关键 DOM 标识
  if ! grep -q "var DATA" /tmp/td-check.html || ! grep -q "filter-bar" /tmp/td-check.html; then
    echo "[$CHECK_TS] ⚠️  自检失败：缺关键 DOM/JS 节点" >> "$LOG"
    osascript -e "display notification \"tech-digest 缺关键节点，请打开浏览器检查\" with title \"RumorCrusher 推送自检\"" 2>/dev/null
    rm -f /tmp/td-check.html
    exit 1
  fi

  echo "[$CHECK_TS] ✅ 自检通过（HTTP 200, 大小 ${FILE_SIZE}B, DOM 完整）" >> "$LOG"
  rm -f /tmp/td-check.html
) &

exit 0
