#!/usr/bin/env python3
"""Write the Nubo Office brand pack into office/brand/.

Everything here is our own: the logos come from the Nubo mark (brand/logo), the
colours from our palette. Nothing is taken from Collabora's brand pack (its files
are all rights reserved). The editor's own open-licensed icons stay as they are.

Usage: make-brand-pack.py
"""

import os
import re

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
OUT = os.path.join(HERE, "brand")
IMG = os.path.join(OUT, "images")

# Accent colours: close to the Nubo workspace (Nubo Email) so the apps feel related.
LIGHT = {"primary": "#2f6fde", "dark": "#1d56b8", "darker": "#174690", "lighter": "#a9c4f0"}
DARK = {"primary": "#5b92ee", "dark": "#3f78d6", "darker": "#2d5fb3", "lighter": "#2a4a80"}


def mark(color):
    """The Nubo mark as SVG inner markup, in one colour, and its viewBox size."""
    src = open(os.path.join(ROOT, "brand", "logo", "nubo-mark-white.svg")).read()
    vb = re.search(r'viewBox="([^"]+)"', src).group(1)
    body = src.split("</metadata>", 1)[-1] if "</metadata>" in src else src
    body = re.sub(r"</?svg[^>]*>", "", body)
    body = re.sub(r'fill="#[0-9a-fA-F]{3,6}"', 'fill="%s"' % color, body)
    return body, [float(x) for x in vb.split()]


def logo(path, color, wordmark, size):
    body, (_x, _y, w, h) = mark(color)
    mw = size * 0.9
    scale = mw / w
    mh = h * scale
    if wordmark:
        width, height = size * 4.2, size
        text = ('<text x="%.1f" y="%.1f" fill="%s" font-family="Inter, Helvetica, Arial, sans-serif" '
                'font-size="%.1f" font-weight="600">Nubo Office</text>' % (mw + size * 0.25, size * 0.64, color, size * 0.42))
    else:
        width, height, text = size, size, ""
    svg = ('<svg xmlns="http://www.w3.org/2000/svg" width="%.0f" height="%.0f" viewBox="0 0 %.1f %.1f">'
           '<g transform="translate(%.1f %.1f) scale(%.5f)">%s</g>%s</svg>\n'
           % (width, height, width, height, 0, (height - mh) / 2, scale, body, text))
    open(os.path.join(IMG, path), "w").write(svg)


# The editor colours its header and highlights per kind of document, and uses a purple
# fallback on the start screen. Ours follow the app icons: Write blue, Cells green,
# Present orange, Draw violet; the start screen takes the suite blue. Values are r, g, b.
DOCTYPE = {"text": "47, 111, 222", "spreadsheet": "15, 157, 88", "presentation": "230, 81, 28", "drawing": "138, 56, 238"}
START = "47, 111, 222"


def css():
    def block(sel, c):
        return ("%s {\n  --color-primary: %s;\n  --color-primary-dark: %s;\n  --color-primary-darker: %s;\n"
                "  --color-primary-lighter: %s;\n  --color-primary-text: #fff;\n}\n"
                % (sel, c["primary"], c["dark"], c["darker"], c["lighter"]))
    return ("/* Nubo Office brand pack: written for Nubo OS. */\n\n"
            + block(":root", LIGHT) + "\n" + block("html[data-theme=dark]", DARK)
            + ":root {\n  --doc-type: %s;\n}\n" % START
            + "".join("[data-doctype='%s'] {\n  --doc-type: %s;\n}\n" % kv for kv in DOCTYPE.items()) + """
.img-coda-app-logo {
  background: url("images/full-logo.svg") no-repeat center !important;
}

html[data-theme=dark] .img-coda-app-logo {
  background: url("images/full-logo-white.svg") no-repeat center !important;
}
""")


def main():
    os.makedirs(IMG, exist_ok=True)
    logo("full-logo.svg", "#111214", True, 100)
    logo("full-logo-white.svg", "#ffffff", True, 100)
    logo("toolbar-bg-logo.svg", "#111214", False, 39)
    logo("toolbar-bg-logo-dark.svg", "#ffffff", False, 39)
    logo("toolbar-bg-logo-notebookbar.svg", "#111214", False, 30)
    open(os.path.join(OUT, "branding.css"), "w").write(css())
    print("brand pack:", sorted(os.listdir(IMG)))


if __name__ == "__main__":
    main()
