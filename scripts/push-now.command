#!/usr/bin/env bash
cd ~/Documents/Claude/Projects/RumorCrusher

echo "🔧 清理所有 git 锁文件..."
find .git -name "*.lock" -delete
echo "✅ 锁文件清除完成"

echo ""
echo "📦 执行 git add + commit + push..."
git add -A
git status --short

# 如果有未提交内容则 commit
if ! git diff --staged --quiet; then
  git commit -m "tech-digest 2026-05-18 evening: +7 items & autopush agent"
fi

git push origin main
echo ""
echo "✅ Push 完成！"
echo "🌐 科技简报：https://chirs0901.github.io/rumorcrusher/tech-digest/"
echo ""
echo "📌 安装自动推送 LaunchAgent（每5分钟自动同步）..."
bash ~/Documents/Claude/Projects/RumorCrusher/scripts/install-autopush-agent.sh
echo ""
echo "🎉 全部完成！按任意键关闭..."
read -n 1
