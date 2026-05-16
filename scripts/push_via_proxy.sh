#!/bin/bash
# 自动检测系统代理并推送到 GitHub

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_DIR"

echo "📡 检测系统代理设置..."

# 尝试从 macOS 系统偏好设置读取代理
detect_proxy() {
  # 遍历常见网络接口
  for iface in Wi-Fi Ethernet "USB 10/100/1000 LAN" en0 en1; do
    proxy_info=$(networksetup -getsecurewebproxy "$iface" 2>/dev/null)
    enabled=$(echo "$proxy_info" | grep "Enabled: Yes")
    if [ -n "$enabled" ]; then
      host=$(echo "$proxy_info" | grep "Server:" | awk '{print $2}')
      port=$(echo "$proxy_info" | grep "Port:" | awk '{print $2}')
      if [ -n "$host" ] && [ "$port" != "0" ]; then
        echo "https://$host:$port"
        return
      fi
    fi
    # 也试 HTTP 代理
    proxy_info=$(networksetup -getwebproxy "$iface" 2>/dev/null)
    enabled=$(echo "$proxy_info" | grep "Enabled: Yes")
    if [ -n "$enabled" ]; then
      host=$(echo "$proxy_info" | grep "Server:" | awk '{print $2}')
      port=$(echo "$proxy_info" | grep "Port:" | awk '{print $2}')
      if [ -n "$host" ] && [ "$port" != "0" ]; then
        echo "http://$host:$port"
        return
      fi
    fi
  done

  # 常见端口暴力探测
  for port in 7890 7891 1087 1086 1080 10809 8080 8118; do
    if nc -z -w1 127.0.0.1 $port 2>/dev/null; then
      echo "http://127.0.0.1:$port"
      return
    fi
  done
}

PROXY=$(detect_proxy)

if [ -n "$PROXY" ]; then
  echo "✅ 使用代理: $PROXY"
  export https_proxy="$PROXY"
  export http_proxy="$PROXY"
  export HTTPS_PROXY="$PROXY"
  export HTTP_PROXY="$PROXY"
else
  echo "⚠️  未检测到代理，尝试直连..."
fi

echo "🚀 推送到 GitHub..."
git push origin main

if [ $? -eq 0 ]; then
  echo "✅ 推送成功！"
else
  echo "❌ 推送失败，请检查网络或代理设置。"
fi
