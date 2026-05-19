#!/usr/bin/env bash
# RumorCrusher — 锁文件修复 + 本地 push 脚本
# 在你的 Mac 上运行：
#   cd ~/Documents/Claude/Projects/RumorCrusher
#   bash scripts/fix-locks-and-push.sh

set -e
REPO="$(git rev-parse --show-toplevel)"
echo "仓库路径: $REPO"

echo "[1/3] 删除所有残余锁文件..."
find "$REPO/.git" -name "*.lock" -print -delete
echo "  ✅ 所有 .lock 文件已清除"

echo "[2/3] 将 HEAD 指向沙盒已构建的 commit..."
PENDING_COMMIT="6694576d7b9f92c3b8a1970b034e2a41dbeb4c62"
CURRENT=$(git rev-parse HEAD)
echo "  当前 HEAD: $CURRENT"
echo "  目标 commit: $PENDING_COMMIT"

if git cat-file -e "$PENDING_COMMIT" 2>/dev/null; then
  git update-ref refs/heads/main "$PENDING_COMMIT"
  echo "  ✅ HEAD 已更新至 $PENDING_COMMIT"
else
  echo "  ⚠️ commit 对象不在本地，改用 git add + commit"
  git add tech-digest/index.html "2026-05-18/02-annotations/synthesis.json" "_meta/notify-failures.log"
  git commit -m "tech-digest 2026-05-18 evening: +7 items (AI国标/OpenAI手机/一加Ace6Ultra/硅碳格局/3辟谣)"
fi

echo "[3/3] git push..."
git push origin main
echo "  ✅ push 完成"
echo ""
echo "仪表盘: https://chirs0901.github.io/rumorcrusher/tech-digest/"
