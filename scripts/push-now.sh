#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════
#  RumorCrusher — 立即推送 + 修复 autopush 卡死问题
#  用法：在 Mac Terminal 运行：
#    bash ~/Documents/Claude/Projects/RumorCrusher/scripts/push-now.sh
# ══════════════════════════════════════════════════════════════════
set -e

REPO="$HOME/Documents/Claude/Projects/RumorCrusher"
PLIST="$HOME/Library/LaunchAgents/com.rumorcrusher.autopush.plist"
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

echo "═══════════════════════════════════════"
echo "  RumorCrusher 推送修复工具"
echo "═══════════════════════════════════════"
echo ""

cd "$REPO" || { echo "❌ 找不到仓库: $REPO"; exit 1; }

# 1. 清除僵死锁
echo "→ [1/5] 清除所有锁文件..."
rm -rf /tmp/rumorcrusher-autopush*.lock.d /tmp/rumorcrusher-autopush.lock 2>/dev/null && echo "   ✅ 锁已清除"
find .git -name "*.lock" -delete 2>/dev/null && echo "   ✅ git 锁已清除"

# 2. 检查 git 状态
echo ""
echo "→ [2/5] 检查仓库状态..."
AHEAD=$(git rev-list --count origin/main..HEAD 2>/dev/null || echo "?")
echo "   本地领先 origin/main：$AHEAD 个 commit"
git log --oneline origin/main..HEAD 2>/dev/null | head -10 | sed 's/^/   /'

# 3. 立即推送
echo ""
echo "→ [3/5] 立即 git push..."
if git push origin main; then
  echo "   ✅ 推送成功！"
  echo "   HEAD = $(git rev-parse --short HEAD)"
  # 清除预警状态
  rm -f "$REPO/_meta/push-failure.flag"
else
  echo "   ❌ 推送失败！请检查："
  echo "      • 网络是否正常（代理是否开启）"
  echo "      • GitHub token 是否过期"
  exit 1
fi

# 4. 重新加载 launchd agent
echo ""
echo "→ [4/5] 重新加载 autopush LaunchAgent..."
if [ -f "$PLIST" ]; then
  launchctl unload "$PLIST" 2>/dev/null && echo "   已卸载旧 agent"
  launchctl load -w "$PLIST" && echo "   ✅ 已重新加载 agent"
else
  echo "   ⚠️  未找到 $PLIST，请运行 install-autopush-agent.sh"
fi

# 5. 等待 Pages 部署
echo ""
echo "→ [5/5] 等待 GitHub Pages 部署（约 60 秒）..."
sleep 60
HTTP_CODE=$(curl -o /dev/null -s -w "%{http_code}" --max-time 10 \
  "https://chirs0901.github.io/rumorcrusher/knowledge-base/index.html" 2>/dev/null || echo "000")
[ "$HTTP_CODE" = "200" ] && echo "   ✅ 知识库可访问" || echo "   ⚠️  HTTP $HTTP_CODE（再等 1-2 分钟）"

echo ""
echo "  知识库：https://chirs0901.github.io/rumorcrusher/knowledge-base/"
echo "  日报：  https://chirs0901.github.io/rumorcrusher/2026-05-30/"
