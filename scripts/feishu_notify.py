#!/usr/bin/env python3
"""
RumorCrusher 飞书通知脚本
用法：python3 feishu_notify.py 2026-05-14
读取同日 02-annotations/synthesis.json 摘要发送卡片
"""
import sys, json, urllib.request, urllib.error, yaml
from pathlib import Path
from datetime import datetime

ROOT = Path(__file__).resolve().parent.parent

def load_secrets():
    with open(ROOT / "_meta" / "secrets.local.yaml") as f:
        return yaml.safe_load(f)

def http_post(url, payload, headers=None):
    data = json.dumps(payload).encode("utf-8")
    h = {"Content-Type": "application/json; charset=utf-8"}
    if headers: h.update(headers)
    req = urllib.request.Request(url, data=data, headers=h, method="POST")
    try:
        with urllib.request.urlopen(req, timeout=30) as resp:
            return resp.status, json.loads(resp.read().decode("utf-8"))
    except urllib.error.HTTPError as e:
        return e.code, json.loads(e.read().decode("utf-8"))

def get_tenant_token(app_id, app_secret):
    status, body = http_post(
        "https://open.feishu.cn/open-apis/auth/v3/tenant_access_token/internal",
        {"app_id": app_id, "app_secret": app_secret}
    )
    if body.get("code") != 0:
        raise RuntimeError(f"tenant_token 失败: {body}")
    return body["tenant_access_token"]

def build_card(date, summary, fail_items, public_url):
    fails_md = "\n".join([f"🔴 {x['title']}" for x in fail_items]) or "（今日无剔除）"
    return {
      "config": {"wide_screen_mode": True},
      "header": {"template": "red", "title": {"tag": "plain_text", "content": f"🔍 RumorCrusher 日报 {date}"}},
      "elements": [
        {"tag": "div", "text": {"tag": "lark_md", "content":
          f"**采集**：{summary['total']} 条 · **通过** {summary['pass']} · **警告** {summary['warn']} · **剔除** {summary['fail']}"}},
        {"tag": "hr"},
        {"tag": "div", "text": {"tag": "lark_md", "content": f"**今日剔除项**\n{fails_md}"}},
        {"tag": "hr"},
        {"tag": "action", "actions": [
          {"tag": "button", "text": {"tag": "plain_text", "content": "📊 查看仪表盘"}, "type": "primary", "url": public_url}
        ]}
      ]
    }

def main():
    date = sys.argv[1] if len(sys.argv) > 1 else datetime.now().strftime("%Y-%m-%d")
    secrets = load_secrets()
    fs = secrets["feishu"]

    annot = json.load(open(ROOT / date / "02-annotations" / "synthesis.json"))
    summary = annot["summary"]
    fail_items = [x for x in annot["items"] if x["synthesis"] == "fail"]
    gh = secrets["github"]
    public_url = f"https://{gh['username']}.github.io/{gh['repo']}/{date}/"

    token = get_tenant_token(fs["app_id"], fs["app_secret"])
    card = build_card(date, summary, fail_items, public_url)
    payload = {
      "receive_id": fs["receive_id"],
      "msg_type": "interactive",
      "content": json.dumps(card, ensure_ascii=False)
    }
    status, body = http_post(
        f"https://open.feishu.cn/open-apis/im/v1/messages?receive_id_type={fs['receive_id_type']}",
        payload,
        headers={"Authorization": f"Bearer {token}"}
    )
    if body.get("code") == 0:
        print(f"✓ 飞书推送成功：{body['data']['message_id']}")
        return 0
    else:
        print(f"✗ 飞书推送失败：{body}", file=sys.stderr)
        return 1

if __name__ == "__main__":
    sys.exit(main())
