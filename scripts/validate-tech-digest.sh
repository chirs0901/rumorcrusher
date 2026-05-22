#!/usr/bin/env bash
# 校验 tech-digest/index.html 的 JS 是否能正确解析
# 用法：bash scripts/validate-tech-digest.sh
# 退出码：0=通过；1=语法错误（拒绝提交）

set -u
RCPATH="$(cd "$(dirname "$0")/.." && pwd)"
HTML="$RCPATH/tech-digest/index.html"

if [ ! -f "$HTML" ]; then
  echo "❌ 文件不存在：$HTML"
  exit 1
fi

# 用 Node 执行 <script> 内容，捕获语法错误
RESULT=$(python3 - "$HTML" << 'PYEOF'
import re, subprocess, tempfile, os, sys

with open(sys.argv[1], 'r', encoding='utf-8') as f:
    content = f.read()

scripts = re.findall(r'<script>(.*?)</script>', content, re.DOTALL)
if not scripts:
    print("WARN: 文件中没有 <script> 块")
    sys.exit(0)

js_code = '\n'.join(scripts)

# 充分 mock 浏览器对象，避免 runtime 报错被误判为语法错误
mock = """
var _elm = { innerHTML:'', textContent:'', style:{}, appendChild:function(){}, addEventListener:function(){} };
var document = {
  getElementById: function(){ return _elm; },
  querySelectorAll: function(){ return []; },
  addEventListener: function(){}
};
var window = { addEventListener: function(){} };
var location = { hash:'', href:'' };
var navigator = { userAgent:'' };
"""

with tempfile.NamedTemporaryFile('w', suffix='.js', delete=False) as f:
    f.write(mock + js_code)
    tmp = f.name

r = subprocess.run(['node', '--check', tmp], capture_output=True, text=True, timeout=15)
os.unlink(tmp)

if r.returncode == 0:
    print("OK")
else:
    print("FAIL")
    err = r.stderr.strip()
    # 截取关键错误信息
    for line in err.split('\n')[:6]:
        print(line)
PYEOF
)

if echo "$RESULT" | head -1 | grep -q "^OK"; then
  echo "✅ tech-digest JS 校验通过"
  exit 0
else
  echo "❌ tech-digest JS 校验失败："
  echo "$RESULT" | tail -n +2
  exit 1
fi
