#!/usr/bin/env bash
# RumorCrusher 实时谣言检测器启动脚本

set -e

REPO="/Users/zhiqiao/Documents/Qoder/RumorCrusher-qoder"
cd "$REPO"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔍 RumorCrusher 实时谣言检测器"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# 检查Python
if ! command -v python3 &> /dev/null; then
    echo "❌ 错误: 未找到 Python3"
    echo "请先安装 Python 3.7+"
    exit 1
fi

echo "✅ Python3: $(python3 --version)"

# 检查依赖
echo ""
echo "检查依赖..."
if ! python3 -c "import flask" 2>/dev/null; then
    echo "⚠️  Flask 未安装，正在安装..."
    pip3 install flask flask-cors
else
    echo "✅ Flask 已安装"
fi

if ! python3 -c "import flask_cors" 2>/dev/null; then
    echo "⚠️  flask-cors 未安装，正在安装..."
    pip3 install flask-cors
else
    echo "✅ flask-cors 已安装"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "启动 API 服务器..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📡 API地址: http://127.0.0.1:5000"
echo "📄 前端页面: file://$REPO/rumor-detector.html"
echo ""
echo "或者使用HTTP服务器访问前端:"
echo "   python3 -m http.server 8080"
echo "   然后访问: http://localhost:8080/rumor-detector.html"
echo ""
echo "按 Ctrl+C 停止服务器"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# 启动API服务器
python3 scripts/rumor_detector_api.py --host 127.0.0.1 --port 5000
