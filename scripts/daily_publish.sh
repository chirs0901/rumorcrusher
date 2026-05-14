#!/usr/bin/env bash
# RumorCrusher 每日自动发布脚本
# 由定时任务在 22:00 调用，发生在所有报告生成之后
#
# 流程：
#   1. git add 当天产出
#   2. commit
#   3. push 到 GitHub Pages
#   4. 调用 feishu_notify.py 推送飞书通知

set -e

DATE="${1:-$(date +%Y-%m-%d)}"
cd "$(dirname "$0")/.."

# 推送 git
echo "[1/2] 推送到 GitHub..."
git add "${DATE}/" skills/ wiki/ index.html _meta/changelog.md 2>/dev/null || true
if ! git diff --staged --quiet; then
  git commit -m "Daily update ${DATE}"
  git push origin main
  echo "✓ git 推送完成"
else
  echo "  无变化，跳过推送"
fi

# 飞书通知
echo "[2/3] 推送飞书通知..."
python3 scripts/feishu_notify.py "${DATE}" || echo "  ⚠ 飞书通知失败，继续"

# 邮件通知
echo "[3/3] 发送邮件通知..."
python3 scripts/email_notify.py "${DATE}" || echo "  ⚠ 邮件通知失败，继续"
