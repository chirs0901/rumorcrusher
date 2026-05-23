#!/usr/bin/env python3
"""
RumorCrusher 邮件通知脚本
用法：python3 email_notify.py 2026-05-14

读取当日 02-annotations/synthesis.json 和两份报告，组装 HTML 邮件后通过 163 SMTP 发送到收件人列表
"""
import sys, smtplib, ssl, json, yaml, glob
from pathlib import Path
from email.message import EmailMessage
from email.utils import formataddr, make_msgid
from datetime import datetime

ROOT = Path(__file__).resolve().parent.parent

def load_secrets():
    with open(ROOT / "_meta" / "secrets.local.yaml") as f:
        return yaml.safe_load(f)

def build_html(date, summary, items, public_url):
    fails = [x for x in items if x["synthesis"] == "fail"]
    warns = [x for x in items if x["synthesis"] == "warn"]
    passes = [x for x in items if x["synthesis"] == "pass"]

    def render_item(item, color):
        return f"""
        <tr><td style="padding:8px 12px;border-left:3px solid {color};background:#fafafa;">
          <div style="font-weight:600;color:#1e293b;font-size:14px;">{item['title']}</div>
          <div style="color:#64748b;font-size:12px;margin-top:4px;">
            事实核查 verdict: <b>{item['fact_check']['verdict']}</b>
            · 综合判定: <b style="color:{color};">{item['synthesis'].upper()}</b>
          </div>
        </td></tr>
        """

    fail_html = "".join(render_item(x, "#dc2626") for x in fails) or "<tr><td style='padding:8px 12px;color:#64748b;'>今日无剔除项</td></tr>"
    warn_html = "".join(render_item(x, "#f59e0b") for x in warns)
    pass_count = len(passes)

    return f"""<!DOCTYPE html>
<html><head><meta charset="UTF-8"></head>
<body style="font-family:-apple-system,'PingFang SC','Microsoft YaHei',sans-serif;background:#f1f5f9;margin:0;padding:24px;">
  <div style="max-width:680px;margin:0 auto;background:#fff;border-radius:12px;overflow:hidden;box-shadow:0 4px 20px rgba(0,0,0,0.06);">

    <div style="background:linear-gradient(135deg,#e11d48 0%,#be123c 100%);color:#fff;padding:24px 28px;">
      <div style="font-size:24px;font-weight:bold;">🔍 RumorCrusher 日报</div>
      <div style="opacity:0.9;margin-top:4px;font-size:13px;">手机硬件 · 智能硬件 · 配件 · 供应链  ·  {date}</div>
    </div>

    <div style="padding:24px 28px;">
      <div style="display:grid;grid-template-columns:repeat(4,1fr);gap:12px;margin-bottom:24px;">
        <div style="background:#f8fafc;padding:12px;border-radius:8px;text-align:center;">
          <div style="font-size:24px;font-weight:bold;color:#0f172a;">{summary['total']}</div>
          <div style="font-size:11px;color:#64748b;margin-top:2px;">总采集</div>
        </div>
        <div style="background:#f0fdf4;padding:12px;border-radius:8px;text-align:center;border-left:3px solid #10b981;">
          <div style="font-size:24px;font-weight:bold;color:#10b981;">{summary['pass']}</div>
          <div style="font-size:11px;color:#64748b;margin-top:2px;">通过</div>
        </div>
        <div style="background:#fffbeb;padding:12px;border-radius:8px;text-align:center;border-left:3px solid #f59e0b;">
          <div style="font-size:24px;font-weight:bold;color:#f59e0b;">{summary['warn']}</div>
          <div style="font-size:11px;color:#64748b;margin-top:2px;">警告</div>
        </div>
        <div style="background:#fef2f2;padding:12px;border-radius:8px;text-align:center;border-left:3px solid #dc2626;">
          <div style="font-size:24px;font-weight:bold;color:#dc2626;">{summary['fail']}</div>
          <div style="font-size:11px;color:#64748b;margin-top:2px;">剔除</div>
        </div>
      </div>

      <h3 style="color:#0f172a;font-size:16px;margin:24px 0 12px;border-bottom:1px solid #e2e8f0;padding-bottom:8px;">🔴 已剔除（不进干净报告）</h3>
      <table style="width:100%;border-collapse:collapse;">{fail_html}</table>

      <h3 style="color:#0f172a;font-size:16px;margin:24px 0 12px;border-bottom:1px solid #e2e8f0;padding-bottom:8px;">🟡 警告（保留但已标注）</h3>
      <table style="width:100%;border-collapse:collapse;">{warn_html}</table>

      <h3 style="color:#0f172a;font-size:16px;margin:24px 0 12px;border-bottom:1px solid #e2e8f0;padding-bottom:8px;">🟢 通过</h3>
      <p style="color:#475569;font-size:13px;">共 <b>{pass_count}</b> 条素材通过完整事实核查，已直接纳入干净分析报告。</p>

      <div style="margin-top:32px;padding:20px;background:#fef2f2;border-radius:8px;border-left:4px solid #e11d48;">
        <div style="color:#0f172a;font-weight:600;margin-bottom:8px;">📊 完整内容</div>
        <p style="color:#475569;font-size:13px;line-height:1.6;margin:8px 0;">
          • <a href="{public_url}" style="color:#e11d48;">仪表盘可视化（HTML，公开）</a><br/>
          • <a href="{public_url}03-quality-report.md" style="color:#e11d48;">质检报告全文</a><br/>
          • <a href="{public_url}04-clean-report.md" style="color:#e11d48;">干净分析报告全文</a><br/>
          • <a href="{public_url}05-methodology-delta.md" style="color:#e11d48;">方法论增量</a>
        </p>
      </div>

      <p style="color:#94a3b8;font-size:11px;margin-top:32px;text-align:center;">
        由 RumorCrusher Multi-Agent Committee 自动生成 · 每日 22:00（北京时间）<br/>
        项目主页：<a href="https://github.com/chirs0901/rumorcrusher" style="color:#94a3b8;">github.com/chirs0901/rumorcrusher</a>
      </p>
    </div>
  </div>
</body></html>"""

def main():
    date = sys.argv[1] if len(sys.argv) > 1 else datetime.now().strftime("%Y-%m-%d")
    secrets = load_secrets()
    em = secrets.get("email") or {}

    # 校验配置
    required = ["smtp_host", "smtp_port", "username", "auth_code", "from_addr", "recipients"]
    missing = [k for k in required if not em.get(k)]
    if missing:
        print(f"✗ 邮件配置缺失：{missing}", file=sys.stderr)
        return 1

    # 优先找 synthesis-{timestamp}.json，fallback 到 synthesis.json
    synth_dir = ROOT / date / "02-annotations"
    synth_files = sorted(glob.glob(str(synth_dir / "synthesis-*.json")))
    if synth_files:
        synth_path = Path(synth_files[-1])  # 取最新时间戳
    else:
        synth_path = synth_dir / "synthesis.json"
    annot = json.load(open(synth_path))
    gh = secrets["github"]
    public_url = f"https://{gh['username']}.github.io/{gh['repo']}/{date}/"

    html = build_html(date, annot["summary"], annot["items"], public_url)

    msg = EmailMessage()
    msg["Subject"] = f"🔍 RumorCrusher 日报 · {date} · 通过{annot['summary']['pass']}/警告{annot['summary']['warn']}/剔除{annot['summary']['fail']}"
    msg["From"] = formataddr(("RumorCrusher", em["from_addr"]))
    msg["To"] = ", ".join(em["recipients"])
    msg["Message-ID"] = make_msgid(domain="rumorcrusher")
    msg.set_content(f"RumorCrusher {date} 日报。\n\n请使用支持 HTML 的邮件客户端查看，或访问：{public_url}")
    msg.add_alternative(html, subtype="html")

    ctx = ssl.create_default_context()
    print(f"→ 连接 {em['smtp_host']}:{em['smtp_port']} ...")
    if em["smtp_port"] == 465:
        smtp = smtplib.SMTP_SSL(em["smtp_host"], em["smtp_port"], context=ctx, timeout=30)
    else:
        smtp = smtplib.SMTP(em["smtp_host"], em["smtp_port"], timeout=30)
        smtp.starttls(context=ctx)
    smtp.login(em["username"], em["auth_code"])
    smtp.send_message(msg)
    smtp.quit()
    print(f"✓ 邮件发送成功 → {em['recipients']}")
    return 0

if __name__ == "__main__":
    sys.exit(main())
