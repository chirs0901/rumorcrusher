#!/usr/bin/env python3
"""
update_tech_digest.py
将当日 Supported 条目注入 tech-digest/index.html
用法: python3 scripts/update_tech_digest.py <json_file>

json_file 格式:
{
  "date": "2026-05-17",
  "title": "今日标题",
  "sub": "今日副标题",
  "stats": [{"v":"30+","l":"条采集"}, ...],
  "items": [
    {
      "id": "item-id",
      "category": "手机创新",
      "title": "标题",
      "text": "正文",
      "tags": ["tag1","tag2"],
      "sources": [{"name":"官网","url":"https://...","official":true}, ...],
      "verdict": "Supported",
      "wikiId": null
    }
  ]
}
"""

import json, sys, re, os

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
HTML_PATH = os.path.normpath(os.path.join(SCRIPT_DIR, '..', 'tech-digest', 'index.html'))


def esc(s):
    """Escape a string for use inside JS single-quoted string."""
    return s.replace('\\', '\\\\').replace("'", "\\'")


def build_sources_js(sources, pad='        '):
    if not sources:
        return '[]'
    parts = []
    for s in sources:
        official = ', official:true' if s.get('official') else ''
        parts.append(pad + "{name:'" + esc(s['name']) + "', url:'" + s['url'] + "'" + official + "}")
    return '[\n' + ',\n'.join(parts) + '\n      ]'


def build_items_js(items):
    parts = []
    for item in items:
        tags_js = '[' + ', '.join("'" + esc(t) + "'" for t in item.get('tags', [])) + ']'
        sources_js = build_sources_js(item.get('sources', []))
        wiki_js = 'null' if not item.get('wikiId') else "'" + item['wikiId'] + "'"
        verdict = item.get('verdict', 'Supported')

        part = (
            "      {\n"
            "        id: '"        + esc(item['id'])       + "',\n"
            "        category: '"  + esc(item['category']) + "',\n"
            "        title: '"     + esc(item['title'])    + "',\n"
            "        text: '"      + esc(item['text'])     + "',\n"
            "        tags: "       + tags_js               + ",\n"
            "        sources: "    + sources_js            + ",\n"
            "        verdict: '"   + verdict               + "',\n"
            "        wikiId: "     + wiki_js               + "\n"
            "      }"
        )
        parts.append(part)
    return ',\n'.join(parts)


def build_stats_js(stats):
    parts = []
    for s in stats:
        parts.append("      {v:'" + esc(str(s['v'])) + "', l:'" + esc(s['l']) + "'}")
    return ',\n'.join(parts)


def build_date_block(date, data):
    """Build the complete JS block for one date entry."""
    sep = '  // ' + '═' * 34
    title = esc(data.get('title', date + ' 手机科技简报'))
    sub   = esc(data.get('sub', '经多 Agent 核查后的 Supported 洞察。'))
    stats_js = build_stats_js(data.get('stats', []))
    items_js  = build_items_js(data.get('items', []))

    return (
        sep + "\n"
        "  '" + date + "': {\n"
        "    title: '" + title + "',\n"
        "    sub: '"   + sub   + "',\n"
        "    stats: [\n" + stats_js + "\n    ],\n"
        "    items: [\n" + items_js + "\n    ]\n"
        "  }"
    )


def remove_existing_date(html, date):
    """Remove an existing date entry from DATA (if any)."""
    # Match:  // ═══...  (optional)  \n  'YYYY-MM-DD': { ... \n  },
    # This uses a non-greedy match up to the closing '  }' followed by comma or end
    pattern = (
        r"(?:[ \t]*//[^\n]*\n)?"      # optional separator comment line
        r"[ \t]*'" + re.escape(date) + r"'[ \t]*:[ \t]*\{"
        r"[\s\S]*?"                    # content (non-greedy)
        r"\n  \}(?:,)?"               # closing brace + optional comma
        r"(?:\n|$)"
    )
    cleaned, n = re.subn(pattern, '', html, count=1)
    if n:
        print(f"  ↩ 已移除旧条目 {date}")
    return cleaned


def main():
    if len(sys.argv) < 2:
        print("用法: python3 scripts/update_tech_digest.py <json_file>")
        sys.exit(1)

    json_file = sys.argv[1]
    if not os.path.exists(json_file):
        print(f"错误: 找不到文件 {json_file}")
        sys.exit(1)

    with open(json_file, 'r', encoding='utf-8') as f:
        data = json.load(f)

    date = data.get('date')
    if not date:
        print("错误: JSON 缺少 'date' 字段")
        sys.exit(1)

    if not os.path.exists(HTML_PATH):
        print(f"错误: 找不到 {HTML_PATH}")
        sys.exit(1)

    with open(HTML_PATH, 'r', encoding='utf-8') as f:
        html = f.read()

    # 1. 如果当天条目已存在则先删除（支持同一天重跑）
    if "'" + date + "':" in html:
        html = remove_existing_date(html, date)

    # 2. 构建新条目 JS 字符串
    new_block = build_date_block(date, data)

    # 3. 插入到 DATA 对象最前面（紧跟 var DATA = { 之后）
    marker = 'var DATA = {'
    if marker not in html:
        print(f"错误: 在 HTML 中找不到 '{marker}'")
        sys.exit(1)

    pos = html.index(marker) + len(marker)
    html = html[:pos] + '\n\n' + new_block + ',\n' + html[pos:]

    with open(HTML_PATH, 'w', encoding='utf-8') as f:
        f.write(html)

    n_items = len(data.get('items', []))
    print(f"✓ 已将 {n_items} 条 Supported 资讯（{date}）注入 tech-digest/index.html")


if __name__ == '__main__':
    main()
