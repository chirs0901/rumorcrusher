#!/usr/bin/env bash
# RumorCrusher 每日自动发布脚本
# 由定时任务在 22:00 / 07:00 调用，发生在所有报告生成之后
#
# git push 使用用户本机路径执行（绕过沙箱代理限制）
# 确认可用命令：git -C ~/Documents/Claude/Projects/RumorCrusher push origin main

set -e

DATE="${1:-$(date +%Y-%m-%d)}"
NOTIFY_LOG="$(dirname "$0")/../_meta/notify-failures.log"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S %Z")
REPO_PATH="${HOME}/Documents/Claude/Projects/RumorCrusher"
cd "$(dirname "$0")/.."

# [1/3] git push
echo "[1/3] 推送到 GitHub..."
git add "${DATE}/" skills/ wiki/ index.html _meta/changelog.md 2>/dev/null || true
if ! git diff --staged --quiet; then
  if git commit -m "Daily update ${DATE}" 2>&1 && \
     git -C "${REPO_PATH}" -c http.version=HTTP/1.1 push origin main 2>&1; then
    echo "✓ git push 成功"
    GIT_STATUS="SUCCESS"
  else
    GIT_STATUS="FAILED: push error"
    echo "[${TIMESTAMP}] git push FAILED" >> "${NOTIFY_LOG}"
  fi
else
  echo "  无变化，跳过推送"
  GIT_STATUS="NO_CHANGE"
fi

# [2/3] 飞书通知
echo "[2/3] 推送飞书通知..."
python3 scripts/feishu_notify.py "${DATE}" 2>&1 || {
  echo "[${TIMESTAMP}] 飞书通知 FAILED" >> "${NOTIFY_LOG}"
  echo "  ⚠ 飞书通知失败"
}

# [3/3] 邮件通知
echo "[3/3] 发送邮件通知..."
python3 scripts/email_notify.py "${DATE}" 2>&1 || {
  echo "[${TIMESTAMP}] 邮件通知 FAILED" >> "${NOTIFY_LOG}"
  echo "  ⚠ 邮件通知失败"
}

echo "发布脚本完成. git=${GIT_STATUS}"
