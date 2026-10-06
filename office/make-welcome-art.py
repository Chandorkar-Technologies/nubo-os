#!/usr/bin/env python3
"""Make the first-run welcome pictures for Nubo Office into office/brand/welcome/.

  slide1-left/center/right.png   our own app icons (Write, Cells, Present), no AI
  slide2.png                     illustration from DeepInfra's image API
  slide3.png                     drawn here as SVG (two people editing one document), no AI

The API key is read from DEEPINFRA_API_KEY, or from ~/.config/nubo-os/env (a line
DEEPINFRA_API_KEY=...). It is never printed or written anywhere else.
Needs rsvg-convert for the icons. Run on the build VM, or any machine that has it.

Usage: make-welcome-art.py [--no-ai | --ai-only] [--only slideN.png]
       DEEPINFRA_MODEL=... overrides the model (default black-forest-labs/FLUX-1-schnell).
"""

import base64
import json
import os
import subprocess
import sys
import urllib.error
import urllib.request

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "brand", "welcome")
MODEL = os.environ.get("DEEPINFRA_MODEL", "black-forest-labs/FLUX-1-schnell")
API = "https://api.deepinfra.com/v1/openai/images/generations"

STYLE = ("minimal flat vector illustration, calm, soft monochrome greys with one blue accent (#2f6fde), "
         "lots of empty space, clean shapes, no text, no letters, no logos, no people's faces")
PICTURES = {
    # file: (prompt, width, height) - sizes are the ones the welcome page shows, doubled for sharp screens
    "slide2.png": ("three overlapping app windows in a tidy fan arrangement, centered: on the left a text document with "
                   "heading and paragraph lines, in the middle a spreadsheet with a small bar chart, on the right a presentation "
                   "slide with a donut chart, rounded corners, soft shadows, front view, " + STYLE, 1024, 512),
}


SLIDE3 = """<svg xmlns="http://www.w3.org/2000/svg" width="768" height="512" viewBox="0 0 768 512">
<defs><filter id="sh" x="-30%" y="-30%" width="160%" height="190%"><feGaussianBlur in="SourceAlpha" stdDeviation="12"/><feOffset dy="10"/><feComponentTransfer><feFuncA type="linear" slope=".18"/></feComponentTransfer><feMerge><feMergeNode/><feMergeNode in="SourceGraphic"/></feMerge></filter></defs>
<g filter="url(#sh)"><rect x="96" y="36" width="440" height="420" rx="24" fill="#fff"/></g>
<rect x="148" y="86" width="190" height="26" rx="13" fill="#23262e"/>
<g fill="#d3d8e3"><rect x="148" y="146" width="336" height="16" rx="8"/><rect x="148" y="186" width="300" height="16" rx="8"/><rect x="148" y="226" width="336" height="16" rx="8"/><rect x="148" y="266" width="260" height="16" rx="8"/><rect x="148" y="306" width="336" height="16" rx="8"/><rect x="148" y="346" width="200" height="16" rx="8"/><rect x="148" y="386" width="290" height="16" rx="8"/></g>
<rect x="148" y="182" width="190" height="24" rx="6" fill="#2f6fde" opacity=".28"/>
<rect x="148" y="302" width="150" height="24" rx="6" fill="#f59a2e" opacity=".32"/>
<g><rect x="338" y="174" width="3" height="40" rx="1.5" fill="#2f6fde"/><rect x="341" y="150" width="62" height="28" rx="9" fill="#2f6fde"/><text x="372" y="169.5" font-family="Helvetica, Arial, sans-serif" font-size="15" font-weight="700" fill="#fff" text-anchor="middle">Asha</text></g>
<g><rect x="298" y="294" width="3" height="40" rx="1.5" fill="#f59a2e"/><rect x="301" y="270" width="58" height="28" rx="9" fill="#f59a2e"/><text x="330" y="289.5" font-family="Helvetica, Arial, sans-serif" font-size="15" font-weight="700" fill="#fff" text-anchor="middle">Ravi</text></g>
<g filter="url(#sh)"><path d="M560 120h120a22 22 0 0 1 22 22v62a22 22 0 0 1-22 22h-82l-26 24v-24h-12a22 22 0 0 1-22-22v-62a22 22 0 0 1 22-22z" fill="#fff"/></g>
<circle cx="590" cy="150" r="13" fill="#f59a2e"/><g fill="#d3d8e3"><rect x="612" y="143" width="62" height="10" rx="5"/><rect x="578" y="176" width="96" height="10" rx="5"/><rect x="578" y="194" width="70" height="10" rx="5"/></g>
<g filter="url(#sh)"><rect x="560" y="278" width="142" height="56" rx="18" fill="#fff"/></g>
<circle cx="588" cy="306" r="14" fill="#2f6fde"/><path d="M581 306l5 5 9-10" fill="none" stroke="#fff" stroke-width="3.5" stroke-linecap="round" stroke-linejoin="round"/><g fill="#d3d8e3"><rect x="610" y="296" width="70" height="9" rx="4.5"/><rect x="610" y="311" width="46" height="9" rx="4.5"/></g>
</svg>
"""


def slide3():
    svg = os.path.join(OUT, "slide3.svg")
    open(svg, "w").write(SLIDE3)
    subprocess.run(["rsvg-convert", "-w", "768", "-h", "512", svg, "-o", os.path.join(OUT, "slide3.png")], check=True)
    os.remove(svg)
    print("made slide3.png")


def key():
    if os.environ.get("DEEPINFRA_API_KEY"):
        return os.environ["DEEPINFRA_API_KEY"]
    path = os.path.expanduser("~/.config/nubo-os/env")
    if os.path.exists(path):
        for line in open(path):
            line = line.strip()
            if line.startswith("DEEPINFRA_API_KEY="):
                return line.split("=", 1)[1].strip().strip("\"'")
    return ""


def icons():
    """The three round pictures on slide 1 are our own app icons."""
    for name, icon, px in (("slide1-left.png", "Write", 136), ("slide1-center.png", "Cells", 192), ("slide1-right.png", "Present", 136)):
        svg = os.path.join(HERE, "icons", "tech.nubosuite.%s.svg" % icon)
        subprocess.run(["rsvg-convert", "-w", str(px), "-h", str(px), svg, "-o", os.path.join(OUT, name)], check=True)
        print("made", name)


def generate(name, prompt, w, h, token):
    body = json.dumps({"model": MODEL, "prompt": prompt, "size": "%dx%d" % (w, h), "n": 1,
                       "response_format": "b64_json"}).encode()
    req = urllib.request.Request(API, data=body, headers={
        "Authorization": "Bearer " + token, "Content-Type": "application/json"})
    try:
        with urllib.request.urlopen(req, timeout=180) as r:
            data = json.load(r)
    except urllib.error.HTTPError as e:
        print("DeepInfra answered %d for %s: %s" % (e.code, name, e.read()[:300].decode("utf-8", "replace")), file=sys.stderr)
        return False
    item = data["data"][0]
    raw = base64.b64decode(item["b64_json"]) if item.get("b64_json") else urllib.request.urlopen(item["url"], timeout=120).read()
    open(os.path.join(OUT, name), "wb").write(raw)
    print("made", name, "(%d bytes)" % len(raw))
    return True


def main():
    os.makedirs(OUT, exist_ok=True)
    if "--ai-only" not in sys.argv:
        icons()
        slide3()
    if "--no-ai" in sys.argv:
        return 0
    token = key()
    if not token:
        print("No DEEPINFRA_API_KEY: slide2.png and slide3.png not made.", file=sys.stderr)
        return 1
    only = sys.argv[sys.argv.index("--only") + 1] if "--only" in sys.argv else None
    ok = all([generate(n, p, w, h, token) for n, (p, w, h) in PICTURES.items() if not only or n == only])
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
