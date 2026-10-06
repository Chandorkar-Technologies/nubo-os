#!/usr/bin/env python3
"""Make the first-run welcome pictures for Nubo Office into office/brand/welcome/.

  slide1-left/center/right.png   our own app icons (Write, Cells, Present), no AI
  slide2.png, slide3.png         illustrations from DeepInfra's image API

The API key is read from DEEPINFRA_API_KEY, or from ~/.config/nubo-os/env (a line
DEEPINFRA_API_KEY=...). It is never printed or written anywhere else.
Needs rsvg-convert for the icons. Run on the build VM, or any machine that has it.

Usage: make-welcome-art.py [--no-ai | --ai-only]
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
    "slide2.png": ("floating abstract documents, a spreadsheet grid, a presentation slide and a pencil drawing "
                   "arranged together like an open workspace, " + STYLE, 1024, 512),
    "slide3.png": ("a single soft cloud over a simple desktop window, symbol of an open, private computer, " + STYLE, 768, 512),
}


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
    if "--no-ai" in sys.argv:
        return 0
    token = key()
    if not token:
        print("No DEEPINFRA_API_KEY: slide2.png and slide3.png not made.", file=sys.stderr)
        return 1
    ok = all([generate(n, p, w, h, token) for n, (p, w, h) in PICTURES.items()])
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
