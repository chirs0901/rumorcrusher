#!/usr/bin/env bash
# RumorCrusher 每日自动发布脚本
# 由定时任务在 22:00 / 07:00 调用，发生在所有报告生成之后
#
# 注意：git push 在调度 sandbox 内可能因代理限制失败，脚本会记录失败并继续执行飞书/邮件

DATE="${1:-$(date +%Y-%m-%d)}"
NOTIFY_LOG="$(dirname "$0")/../_meta/notify-failures.log"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S %Z")
REPO_PATH="${HOME}/Documents/Claude/Projects/RumorCrusher"
cd "$(dirname "$0")/.."

# [1/3] git commit + push（失败只记录，不中断后续步骤）
echo "[1/3] 推送到 GitHub..."
# 如果当日 tech-digest-update.json 存在，先注入
if [ -f "${DATE}/tech-digest-update.json" ]; then
  echo "[pre] 注入 tech-digest..."
  python3 scripts/update_tech_digest.py "${DATE}/tech-digest-update.json" 2>&1 || true
fi

# [pre-commit 校验] tech-digest JS 语法自检——失败则拒绝 commit
echo "[pre-commit] tech-digest JS 校验..."
if ! bash scripts/validate-tech-digest.sh; then
  echo "❌ tech-digest/index.html JS 校验失败，拒绝 commit。请检查最近写入是否有未转义引号"
  echo "[${TIMESTAMP}] [validate] tech-digest JS 校验失败，commit 已被阻止" >> "${NOTIFY_LOG}"
  GIT_STATUS="VALIDATION_FAILED"
  # 不退出，让后续飞书/邮件继续报告失败
  SKIP_COMMIT=1
fi

git add "${DATE}/" skills/ wiki/ index.html tech-digest/index.html _meta/changelog.md 2>/dev/null || true
if [ "${SKIP_COMMIT:-0}" = "1" ]; then
  echo "  ⚠ 校验失败，跳过 commit"
elif ! git diff --staged --quiet; then
  if git commit -m "Daily update ${DATE}" 2>&1; then
    # 尝试 push，优先 7897，fallback 1080
    PUSH_OK=0
    for PROXY in "http://127.0.0.1:7897" "http://127.0.0.1:1080" ""; do
      if [ -n "${PROXY}" ]; then
        export https_proxy="${PROXY}"
      else
        unset https_proxy
      fi
      if git -C "${REPO_PATH}" -c http.version=HTTP/1.1 push origin main 2>&1; then
        PUSH_OK=1
        break
      fi
    done
    if [ "${PUSH_OK}" -eq 1 ]; then
      echo "✓ git push 成功"
      GIT_STATUS="SUCCESS"
      # 清除待推送标志（如有）
      rm -f "${REPO_PATH}/_meta/.push-pending"
    else
      GIT_STATUS="COMMITTED_NOT_PUSHED"
      echo "[${TIMESTAMP}] [git] push失败（sandbox代理不通，本机守护进程将自动重试）" >> "${NOTIFY_LOG}"
      echo "  ⚠ git commit 成功，push 失败 → 写入标志文件等待本机守护进程推送"
      # 写标志文件，触发本机 auto-push-watcher.sh（每5分钟检查一次）
      echo "${TIMESTAMP} ${DATE}" > "${REPO_PATH}/_meta/.push-pending"
    fi
  else
    GIT_STATUS="COMMIT_FAILED"
    echo "[${TIMESTAMP}] [git] commit失败" >> "${NOTIFY_LOG}"
  fi
else
  echo "  无变化，跳过推送"
  GIT_STATUS="NO_CHANGE"
fi

# [2/3] 飞书通知
echo "[2/3] 推送飞书通知..."
python3 scripts/feishu_notify.py "${DATE}" 2>&1 || {
  echo "[${TIMESTAMP}] [feishu] FAILED（sandbox内webhook不可达，需用户本机执行）" >> "${NOTIFY_LOG}"
  echo "  ⚠ 飞书通知失败"
}

# [3/3] 邮件通知
echo "[3/3] 发送邮件通知..."
python3 scripts/email_notify.py "${DATE}" 2>&1 || {
  echo "[${TIMESTAMP}] [email] FAILED（sandbox无SMTP配置）" >> "${NOTIFY_LOG}"
  echo "  ⚠ 邮件通知失败"
}

echo "发布脚本完成. git=${GIT_STATUS}"
