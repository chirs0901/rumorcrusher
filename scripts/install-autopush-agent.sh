#!/usr/bin/env bash
# RumorCrusher — 自动推送 LaunchAgent 安装脚本
# 一次性运行即可：bash scripts/install-autopush-agent.sh

REPO="$HOME/Documents/Claude/Projects/RumorCrusher"
PLIST="$HOME/Library/LaunchAgents/com.rumorcrusher.autopush.plist"
LOG="$REPO/_meta/autopush.log"
WATCHER="$REPO/scripts/autopush-watcher.sh"

echo "🔧 安装 RumorCrusher 自动推送 LaunchAgent..."

# 写 watcher 脚本
cat > "$WATCHER" << 'WATCHER_EOF'
#!/usr/bin/env bash
REPO="$HOME/Documents/Claude/Projects/RumorCrusher"
LOG="$REPO/_meta/autopush.log"
cd "$REPO" || exit 1

# 清理残余锁文件
find .git -name "*.lock" -delete 2>/dev/null

# 检查是否有未推送的 commits
LOCAL=$(git rev-parse HEAD 2>/dev/null)
REMOTE=$(git rev-parse origin/main 2>/dev/null)

if [ "$LOCAL" != "$REMOTE" ] && [ -n "$LOCAL" ]; then
    TS=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[$TS] 检测到未推送 commits ($LOCAL)，开始推送..." >> "$LOG"
    
    if git push origin main >> "$LOG" 2>&1; then
        echo "[$TS] ✅ push 成功" >> "$LOG"
    else
        echo "[$TS] ❌ push 失败" >> "$LOG"
    fi
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] 无新 commits，跳过" >> "$LOG"
fi
WATCHER_EOF
chmod +x "$WATCHER"

# 写 LaunchAgent plist（每5分钟检查一次）
cat > "$PLIST" << PLIST_EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.rumorcrusher.autopush</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>$WATCHER</string>
    </array>
    <key>StartInterval</key>
    <integer>300</integer>
    <key>RunAtLoad</key>
    <true/>
    <key>StandardOutPath</key>
    <string>$LOG</string>
    <key>StandardErrorPath</key>
    <string>$LOG</string>
    <key>EnvironmentVariables</key>
    <dict>
        <key>HOME</key>
        <string>$HOME</string>
        <key>PATH</key>
        <string>/usr/local/bin:/usr/bin:/bin:/opt/homebrew/bin</string>
    </dict>
</dict>
</plist>
PLIST_EOF

# 加载 LaunchAgent
launchctl unload "$PLIST" 2>/dev/null || true
launchctl load -w "$PLIST"

echo "✅ LaunchAgent 已安装并启动"
echo "   • 每 5 分钟自动检查并推送未同步 commits"
echo "   • 日志：$LOG"
echo "   • 停用命令：launchctl unload $PLIST"
echo ""
echo "验证状态："
launchctl list | grep rumorcrusher
