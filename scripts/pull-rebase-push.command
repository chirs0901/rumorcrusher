#!/usr/bin/env bash
cd ~/Documents/Claude/Projects/RumorCrusher

echo "🔧 清理 git 锁文件..."
find .git -name "*.lock" -delete 2>/dev/null && echo "✅ 锁文件清除完成" || echo "ℹ️  无锁文件"

echo ""
echo "📥 git pull --rebase origin main..."
git pull --rebase origin main
PULL_STATUS=$?

if [ $PULL_STATUS -ne 0 ]; then
  echo "❌ pull/rebase 失败，中止"
  read -n 1 -p "按任意键关闭..."
  exit 1
fi

echo ""
echo "📤 git push origin main..."
git push origin main
PUSH_STATUS=$?

if [ $PUSH_STATUS -eq 0 ]; then
  echo ""
  echo "✅ 推送成功！科技简讯已更新到 GitHub Pages"
  echo "🌐 https://chirs0901.github.io/rumorcrusher/tech-digest/"
else
  echo ""
  echo "❌ 推送失败，状态码: $PUSH_STATUS"
fi

echo ""
read -n 1 -p "按任意键关闭..."
