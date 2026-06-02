#!/usr/bin/env bash
# ============================================================
# RumorCrusher · 阿里云 OSS 一键部署
# 使用方法:
#   1. cp scripts/oss-config.example.sh scripts/oss-config.sh
#   2. 编辑 scripts/oss-config.sh 填入阿里云配置
#   3. bash scripts/deploy-oss.sh
# ============================================================
set -e

REPO="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO"

# ── 加载配置 ──
if [ -f "scripts/oss-config.sh" ]; then
    source scripts/oss-config.sh
fi

OSS_BUCKET="${OSS_BUCKET:-}"
OSS_ENDPOINT="${OSS_ENDPOINT:-oss-cn-hangzhou.aliyuncs.com}"
OSS_REGION="${OSS_REGION:-cn-hangzhou}"
API_URL="${API_URL:-http://YOUR-ECS-IP:5000}"

if [ -z "$OSS_BUCKET" ]; then
    echo "❌ 请先配置 OSS_BUCKET"
    echo ""
    echo "📋 快速开始（3 步）："
    echo ""
    echo "  第1步：创建 OSS Bucket"
    echo "    1. 打开 https://oss.console.aliyun.com"
    echo "    2. 创建 Bucket（名称全局唯一，如 rumor-crusher-app）"
    echo "    3. 读写权限选择「公共读」"
    echo "    4. 开启「静态网站托管」，默认首页设为 rumor-detector.html"
    echo ""
    echo "  第2步：获取 AccessKey"
    echo "    1. 打开 https://ram.console.aliyun.com/manage/ak"
    echo "    2. 创建 AccessKey，保存 Key ID 和 Secret"
    echo ""
    echo "  第3步：配置本项目"
    echo "    cp scripts/oss-config.example.sh scripts/oss-config.sh"
    echo "    编辑 scripts/oss-config.sh，填入上述信息"
    echo "    bash scripts/deploy-oss.sh"
    echo ""
    exit 1
fi

echo "============================================"
echo "🚀 RumorCrusher · OSS 部署"
echo "============================================"
echo "Bucket:   $OSS_BUCKET"
echo "Endpoint: $OSS_ENDPOINT"
echo "Region:   $OSS_REGION"
echo "API URL:  $API_URL"
echo "============================================"

# ── 检查/安装 ossutil ──
ensure_ossutil() {
    if command -v ossutil &> /dev/null; then
        return 0
    fi
    echo ""
    echo "📦 ossutil 未安装，正在安装..."
    
    # macOS
    if command -v brew &> /dev/null; then
        brew install ossutil 2>/dev/null && return 0
    fi
    
    # 通用安装（macOS Apple Silicon）
    local os="darwin"
    local arch="arm64"
    if [[ "$(uname -m)" == "x86_64" ]]; then
        arch="amd64"
    fi
    
    local url="https://gosspublic.alicdn.com/ossutil/1.7.19/ossutil-v1.7.19-${os}-${arch}.zip"
    echo "  下载: $url"
    curl -sL "$url" -o /tmp/ossutil.zip
    unzip -qo /tmp/ossutil.zip -d /tmp/ossutil_install
    chmod +x /tmp/ossutil_install/ossutil
    sudo cp /tmp/ossutil_install/ossutil /usr/local/bin/ 2>/dev/null || cp /tmp/ossutil_install/ossutil /usr/local/bin/ 2>/dev/null || {
        echo "  ⚠️ 无法安装到 /usr/local/bin，使用临时路径"
        alias ossutil=/tmp/ossutil_install/ossutil
    }
    rm -rf /tmp/ossutil.zip /tmp/ossutil_install
}

ensure_ossutil

# ── 配置 ossutil ──
if [ -n "$OSS_ACCESS_KEY_ID" ]; then
    ossutil config -i "$OSS_ACCESS_KEY_ID" -k "$OSS_ACCESS_KEY_SECRET" \
        -e "$OSS_ENDPOINT" --mode AK 2>/dev/null || true
fi

# ── 生成 API 配置文件（上传到 OSS） ──
cat > /tmp/rc-config.js << EOF
// RumorCrusher API 配置（自动生成）
window.RC_API_BASE = '${API_URL}';
EOF

# ── 上传文件列表 ──
FILES=(
    "rumor-detector.html"
    "index.html"
    "README.md"
    ".nojekyll"
)

# 日期目录（知识库报告）
for dir in 2026-*; do
    if [ -d "$dir" ]; then
        for f in "$dir"/*.html "$dir"/*.md "$dir"/02-annotations/*.json 2>/dev/null; do
            [ -f "$f" ] && FILES+=("$f")
        done
    fi
done

# 静态资源目录
for dir in wiki skills knowledge-base _meta; do
    if [ -d "$dir" ]; then
        while IFS= read -r -d '' f; do
            FILES+=("$f")
        done < <(find "$dir" -type f \( -name "*.html" -o -name "*.md" -o -name "*.yaml" -o -name "*.json" -o -name "*.css" -o -name "*.js" \) -print0 2>/dev/null)
    fi
done

echo ""
echo "📤 上传 ${#FILES[@]} 个文件..."

SUCCESS=0
FAILED=0
for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        if ossutil cp "$file" "oss://${OSS_BUCKET}/${file}" \
            --endpoint "$OSS_ENDPOINT" --update 2>/dev/null; then
            ((SUCCESS++)) || true
        else
            echo "     ⚠️ 失败: $file"
            ((FAILED++)) || true
        fi
    fi
done

# 上传 API 配置
ossutil cp /tmp/rc-config.js "oss://${OSS_BUCKET}/rc-config.js" \
    --endpoint "$OSS_ENDPOINT" 2>/dev/null && echo "  ✅ rc-config.js (API配置)" || true
rm -f /tmp/rc-config.js

echo ""
echo "============================================"
echo "✅ 部署完成！成功: $SUCCESS  失败: $FAILED"
echo "============================================"
echo ""
echo "🌐 访问地址（任选其一）："
echo "   https://${OSS_BUCKET}.${OSS_ENDPOINT}/rumor-detector.html"
echo "   http://${OSS_BUCKET}.${OSS_ENDPOINT}/rumor-detector.html"
echo ""
echo "📋 下一步："
echo "   1. ✅ 静态网站已部署 → 可直接访问"
echo "   2. ⚠️ API 服务器需要单独部署（ECS 或阿里云函数计算）"
echo "   3. 📝 API 地址已在 rc-config.js 中配置为: $API_URL"
echo "   4. 🔧 如 API 地址变更，重新运行本脚本即可"
echo ""
echo "💡 绑定自定义域名（可选）："
echo "   OSS 控制台 → Bucket 管理 → 传输加速/域名管理"
echo ""
