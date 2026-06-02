# ============================================================
# RumorCrusher · 阿里云 OSS 部署配置
# ============================================================
# 使用方法:
#   1. 复制此文件: cp scripts/oss-config.example.sh scripts/oss-config.sh
#   2. 编辑 scripts/oss-config.sh，填入你的配置
#   3. 运行: bash scripts/deploy-oss.sh

# ── OSS 配置 ──
OSS_BUCKET="your-bucket-name-here"
OSS_ENDPOINT="oss-cn-hangzhou.aliyuncs.com"
OSS_REGION="cn-hangzhou"

# ── AccessKey（可选，也可以运行 ossutil config 手动配置） ──
# OSS_ACCESS_KEY_ID="LTAI5tXXXXXXXXXXXXXX"
# OSS_ACCESS_KEY_SECRET="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

# ── API 服务器地址（部署 API 后端后填写） ──
# 本地开发: http://127.0.0.1:5000
# 云服务器: http://YOUR-ECS-IP:5000
API_URL="http://127.0.0.1:5000"
