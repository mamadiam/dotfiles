#!/usr/bin/env python3
"""Render MANUAL.md to a sumi-themed HTML page and open it in the browser.
Usage: make manual   (or: python3 scripts/manual-html.py [outfile])
Only uses the stdlib — no pandoc, no pip installs."""
import html
import pathlib
import re
import subprocess
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
SRC = ROOT / "MANUAL.md"
OUT = pathlib.Path(sys.argv[1]) if len(sys.argv) > 1 else pathlib.Path("/tmp/dotfiles-manual.html")

CSS = """
  :root { color-scheme: dark; }
  body { background:#000; color:#cdc4ba; font-family:"Space Grotesk",-apple-system,sans-serif;
         line-height:1.65; max-width:52rem; margin:0 auto; padding:4rem 1.5rem 8rem; }
  h1,h2,h3,h4 { font-family:Fraunces,Georgia,serif; font-weight:400; color:#e8e2d9; }
  h1 { font-size:2.6rem; margin:0 0 1rem; } h2 { font-size:1.7rem; margin:3.5rem 0 1rem;
       padding-bottom:.4rem; border-bottom:1px solid #353330; }
  h3 { font-size:1.25rem; margin:2.2rem 0 .7rem; }
  a { color:#bb9af7; text-decoration:none; } a:hover { text-decoration:underline; }
  code { font-family:"SpaceMono Nerd Font",Menlo,monospace; font-size:.85em;
         background:#161614; border:1px solid #2a2522; border-radius:4px; padding:.1em .35em; color:#e0d8cd; }
  pre { background:#0a0a0a; border:1px solid #2a2522; border-radius:6px; padding:1rem 1.2rem; overflow-x:auto; }
  pre code { background:none; border:none; padding:0; color:#cdc4ba; }
  table { border-collapse:collapse; width:100%; margin:1.2rem 0; font-size:.92em; }
  th,td { border:1px solid #2a2522; padding:.5em .8em; text-align:left; }
  th { background:#161614; color:#e8e2d9; font-family:"Space Grotesk"; }
  tr:nth-child(even) td { background:#0d0d0c; }
  blockquote { border-left:2px solid #e2342a; margin:1rem 0; padding:.2rem 1.2rem; color:#b0a9a0; }
  hr { border:none; border-top:1px solid #2a2522; margin:3rem 0; }
  li { margin:.25rem 0; }
  strong { color:#e8e2d9; }
  .seal { color:#e2342a; }
  .seal-block { border:1px solid #2a2522; border-radius:6px; padding:1.5rem 2rem; background:#0a0a0a; }
  #top-toc { columns:2; column-gap:3rem; font-size:.92em; }
"""

def inline(t: str) -> str:
    t = html.escape(t, quote=False)
    t = re.sub(r"`([^`]+)`", r"<code>\1</code>", t)
    t = re.sub(r"\[([^\]]+)\]\(([^)]+)\)", r'<a href="\2">\1</a>', t)
    t = re.sub(r"\*\*([^*]+)\*\*", r"<strong>\1</strong>", t)
    t = re.sub(r"(?<!\*)\*([^*]+)\*(?!\*)", r"<em>\1</em>", t)
    return t

def slug(t: str) -> str:
    s = re.sub(r"[^\w\s-]", "", t).strip().lower()
    return re.sub(r"[\s]+", "-", s)

def render(md: str) -> str:
    out, i, in_code = [], 0, False
    lines = md.split("\n")
    while i < len(lines):
        ln = lines[i]
        if ln.startswith("```"):
            in_code = not in_code
            out.append("</code></pre>" if not in_code else "<pre><code>")
            i += 1; continue
        if in_code:
            out.append(html.escape(ln)); i += 1; continue
        if re.match(r"^\|.*\|$", ln) and i + 1 < len(lines) and re.match(r"^\|[\s:-]+\|", lines[i + 1]):
            rows, i2 = [], i
            while i2 < len(lines) and lines[i2].startswith("|"):
                cells = [c.strip() for c in lines[i2].strip("|").split("|")]
                if not re.match(r"^[\s:-]+$", "".join(cells)):
                    rows.append(cells)
                i2 += 1
            out.append("<table><thead><tr>" + "".join(f"<th>{inline(c)}</th>" for c in rows[0]) + "</tr></thead><tbody>")
            for r in rows[1:]:
                out.append("<tr>" + "".join(f"<td>{inline(c)}</td>" for c in r) + "</tr>")
            out.append("</tbody></table>")
            i = i2; continue
        m = re.match(r"^(#{1,4})\s+(.*)", ln)
        if m:
            lvl, text = len(m.group(1)), m.group(2)
            sid = slug(re.sub(r"\*\*|`", "", text))
            if lvl == 1:
                out.append(f'<h1 id="{sid}"><span class="seal">力</span> {inline(text)}</h1>')
            else:
                out.append(f'<h{lvl} id="{sid}">{inline(text)}</h{lvl}>')
            i += 1; continue
        if ln.strip() == "---" or ln.strip() == "":
            if ln.strip():
                out.append("<hr>")
            i += 1; continue
        if ln.startswith("> "):
            out.append(f"<blockquote>{inline(ln[2:])}</blockquote>"); i += 1; continue
        m = re.match(r"^(\s*)([-*]|\d+\.)\s+(.*)", ln)
        if m:
            ordered = bool(re.match(r"\d+\.", m.group(2)))
            tag = "ol" if ordered else "ul"
            items = []
            while i < len(lines) and (mm := re.match(r"^(\s*)([-*]|\d+\.)\s+(.*)", lines[i])):
                items.append(f"<li>{inline(mm.group(3))}</li>")
                i += 1
            out.append(f"<{tag}>{''.join(items)}</{tag}>")
            continue
        out.append(f"<p>{inline(ln)}</p>")
        i += 1
    return "\n".join(out)

md_text = SRC.read_text()
# split the TOC list right after the contents heading so it renders in two columns
page = f"""<!doctype html><html><head><meta charset="utf-8">
<title>dotfiles — The Manual</title><style>{CSS}</style></head><body>
{render(md_text)}
</body></html>"""
OUT.write_text(page)
subprocess.run(["open", str(OUT)])
print(f"rendered {SRC.name} -> {OUT} and opened in browser")
