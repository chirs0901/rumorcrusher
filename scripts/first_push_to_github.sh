#!/usr/bin/env bash
# RumorCrusher 首次推送到 GitHub 的一键脚本（鲁棒版）
#
# 用法：bash <脚本绝对路径>/first_push_to_github.sh
# 例：bash /Users/你/Documents/.../RumorCrusher/scripts/first_push_to_github.sh
#
# 前置条件：
#   1. 在 https://github.com/new 已建好 chirs0901/rumorcrusher 公开仓库（空的）
#   2. _meta/secrets.local.yaml 已填入正确凭证

set -e

# 自动定位项目根目录（脚本所在的上一级）
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$( cd "${SCRIPT_DIR}/.." && pwd )"

echo "→ 项目根目录：${PROJECT_ROOT}"
cd "${PROJECT_ROOT}"

# 校验目录结构
for f in "_meta/source-list.yaml" "_meta/secrets.local.yaml" "skills/fact-check-playbook.md"; do
  if [ ! -f "$f" ]; then
    echo "✗ 缺失文件：${PROJECT_ROOT}/$f"
    echo "  请确认 RumorCrusher 文件夹完整。"
    exit 1
  fi
done
echo "✓ 目录结构完整"

# 用 python 解析 YAML（鲁棒）
read_yaml() {
  python3 -c "
import sys, yaml
try:
    with open('_meta/secrets.local.yaml') as f:
        d = yaml.safe_load(f)
    val = d['github']['$1']
    if not val or 'PLEASE_FILL' in str(val) or 'xxxxxxx' in str(val):
        print(f'__MISSING__$1', file=sys.stderr)
        sys.exit(2)
    print(val)
except KeyError as e:
    print(f'__MISSING_KEY__{e}', file=sys.stderr); sys.exit(3)
except Exception as e:
    print(f'__YAML_ERROR__{e}', file=sys.stderr); sys.exit(4)
"
}

# 检查 python 和 yaml 可用
if ! command -v python3 >/dev/null 2>&1; then
  echo "✗ python3 未安装，请先安装：brew install python3"
  exit 1
fi
if ! python3 -c "import yaml" 2>/dev/null; then
  echo "→ 安装 PyYAML（首次需要）..."
  python3 -m pip install --user pyyaml --quiet 2>&1 || pip3 install --user pyyaml --quiet 2>&1 || {
    echo "✗ PyYAML 安装失败，请手动：python3 -m pip install pyyaml"
    exit 1
  }
fi

USERNAME=$(read_yaml username) || { echo "✗ 无法读取 github.username（错误：$?）"; exit 1; }
REPO=$(read_yaml repo)         || { echo "✗ 无法读取 github.repo（错误：$?）"; exit 1; }
TOKEN=$(read_yaml token)       || { echo "✗ 无法读取 github.token（错误：$?）"; exit 1; }
echo "✓ 凭证读取成功：${USERNAME}/${REPO}, token=${TOKEN:0:18}…"

# 清理任何旧的 .git
if [ -d ".git" ]; then
  echo "→ 清理旧的 .git 目录..."
  chmod -R u+w .git 2>/dev/null || true
  rm -rf .git || {
    echo "✗ 无法删除 .git 目录，请手动 sudo rm -rf '${PROJECT_ROOT}/.git'"
    exit 1
  }
fi

# 初始化新仓库
git init -b main
git config user.email "Dyer_Cantudql@activist.com"
git config user.name "${USERNAME}"

# 添加远程
git remote add origin "https://${USERNAME}:${TOKEN}@github.com/${USERNAME}/${REPO}.git"

# 全量 add
git add .

# 双重保险：验证 secrets.local 不在提交里
if git ls-files | grep -q "secrets.local"; then
  echo "✗ 安全检查失败：secrets.local 被加入提交了，请检查 .gitignore！"
  exit 2
fi
echo "✓ 密钥隔离验证通过"

# 提交
git commit -m "Initial RumorCrusher setup: skeleton + 2026-05-14 trial run

- Project skeleton: scope/source-list/multi-agent architecture
- Skills library (4 files)
- LLM Wiki hybrid graph framework
- 2026-05-14 trial run: 20 items, 9 pass / 9 warn / 2 fail
- Scripts: feishu_notify, email_notify, daily_publish, first_push
- Secrets isolated via .gitignore"

# 推送（捕获错误明确提示）
echo "→ 推送到 GitHub..."
if ! git push -u origin main 2>&1 | tee /tmp/rc-push.log; then
  echo ""
  echo "✗ 推送失败。常见原因："
  grep -q "Repository not found" /tmp/rc-push.log && echo "  → 仓库还没建好。去 https://github.com/new 建公开仓库 ${USERNAME}/${REPO}"
  grep -qE "401|Authentication" /tmp/rc-push.log && echo "  → token 失效或权限不足。重建 PAT 并更新 secrets.local.yaml"
  grep -q "403" /tmp/rc-push.log && echo "  → token 没有对该仓库的 Contents:write 权限"
  exit 1
fi

echo ""
echo "✅ 首次推送成功！"
echo ""
echo "下一步："
echo "  1. 启用 GitHub Pages：https://github.com/${USERNAME}/${REPO}/settings/pages"
echo "     Source 选 'Deploy from a branch' → Branch 'main' + '/ (root)'"
echo "  2. 1~2 分钟后访问：https://${USERNAME}.github.io/${REPO}/"
echo "  3. 推送成功后，到 https://github.com/settings/tokens 把当前 PAT Revoke，重建新 token 更新 secrets.local.yaml"
