#!/usr/bin/env python3
"""Draw the Nubo app icons (Office suite and workspace apps) as SVG.

One family: a gradient rounded square with a gloss, a layered scene in the middle
(paper, grid, slide, shapes, envelope, ...), soft shadows. One colour per app.
Everything is drawn here; nothing is taken from another product's icons.

Usage: make-icons.py       writes office/icons/*.svg and ../workspace/icons/*.svg
"""

import os

HERE = os.path.dirname(os.path.abspath(__file__))
OFFICE = os.path.join(HERE, "icons")
WORKSPACE = os.path.join(os.path.dirname(HERE), "workspace", "icons")


def frame(key, top, bottom, body, defs=""):
    """512x512 icon: gradient squircle, gloss, inner edge, then the scene."""
    return f"""<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" width="512" height="512" viewBox="0 0 512 512">
<defs>
<linearGradient id="{key}-bg" x1="0.2" y1="0" x2="0.8" y2="1"><stop offset="0" stop-color="{top}"/><stop offset="1" stop-color="{bottom}"/></linearGradient>
<linearGradient id="{key}-gloss" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#fff" stop-opacity=".30"/><stop offset=".55" stop-color="#fff" stop-opacity="0"/></linearGradient>
<linearGradient id="{key}-paper" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#ffffff"/><stop offset="1" stop-color="#eef1f8"/></linearGradient>
<clipPath id="{key}-clip"><rect width="512" height="512" rx="116"/></clipPath>
<filter id="{key}-sh" x="-25%" y="-20%" width="150%" height="160%"><feGaussianBlur in="SourceAlpha" stdDeviation="9"/><feOffset dy="9"/><feComponentTransfer><feFuncA type="linear" slope=".30"/></feComponentTransfer><feMerge><feMergeNode/><feMergeNode in="SourceGraphic"/></feMerge></filter>
{defs}</defs>
<rect width="512" height="512" rx="116" fill="url(#{key}-bg)"/>
<g clip-path="url(#{key}-clip)"><rect width="512" height="300" fill="url(#{key}-gloss)"/></g>
<rect x="1.5" y="1.5" width="509" height="509" rx="114.5" fill="none" stroke="#fff" stroke-opacity=".16" stroke-width="3"/>
{body}
</svg>
"""


def paper(k, x, y, w, h, r=26, extra=""):
    return f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="{r}" fill="url(#{k}-paper)" filter="url(#{k}-sh)"{extra}/>'


def lines(rows, color):
    return "".join(f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="{h/2}" fill="{color}"/>' for x, y, w, h in rows)


# ---------------------------------------------------------------- office suite
def write():
    k = "wr"
    body = (
        paper(k, 130, 78, 252, 346)
        + '<path d="M382 130v-26a26 26 0 0 0-26-26h-40z" fill="#dfe6f6"/><path d="M382 130h-40a26 26 0 0 1-26-26V78z" fill="#c4d1ee" opacity=".0"/>'
        + '<path d="M316 78v52a0 0 0 0 0 0 0h66a0 0 0 0 1 0 0z" fill="none"/>'
        + f'<rect x="168" y="124" width="120" height="22" rx="11" fill="#2f6fde"/>'
        + lines([(168, 176, 196, 14), (168, 204, 176, 14), (168, 232, 196, 14), (168, 260, 150, 14), (168, 296, 196, 14), (168, 324, 120, 14)], "#cdd6ea")
        # pencil
        + '<g transform="translate(352 342) rotate(38)" filter="url(#wr-sh)">'
          '<rect x="-24" y="-150" width="48" height="190" rx="9" fill="#ffc23d"/>'
          '<rect x="-24" y="-150" width="16" height="190" rx="8" fill="#ffd97a"/>'
          '<rect x="-24" y="-168" width="48" height="30" rx="12" fill="#ff7a8c"/><rect x="-24" y="-142" width="48" height="10" fill="#c8cfdb"/>'
          '<polygon points="-24,40 24,40 0,98" fill="#f6dcb8"/><polygon points="-9,76 9,76 0,98" fill="#343944"/></g>'
    )
    return frame(k, "#5fa0ff", "#2250e0", body)


def cells():
    k = "ce"
    body = (
        paper(k, 112, 92, 288, 328)
        + '<path d="M112 118a26 26 0 0 1 26-26h236a26 26 0 0 1 26 26v38H112z" fill="#d6f5e5"/>'
        + '<g stroke="#d3dce0" stroke-width="3"><path d="M112 156h288M112 214h288M112 272h288M112 330h288M204 92v328M300 92v328"/></g>'
        + lines([(128, 118, 56, 12), (220, 118, 56, 12), (316, 118, 56, 12), (128, 176, 40, 12), (128, 234, 46, 12), (222, 176, 52, 12), (318, 234, 60, 12), (222, 292, 40, 12)], "#b5c4cc")
        + '<rect x="206" y="216" width="92" height="56" fill="#e3fbee" stroke="#12a35f" stroke-width="6"/><rect x="288" y="262" width="18" height="18" rx="3" fill="#12a35f" stroke="#fff" stroke-width="3"/>'
        + '<g filter="url(#ce-sh)"><rect x="262" y="296" width="190" height="136" rx="26" fill="#fff"/></g>'
        + '<rect x="292" y="368" width="30" height="42" rx="7" fill="#8fe3b5"/><rect x="336" y="344" width="30" height="66" rx="7" fill="#3fcf86"/><rect x="380" y="318" width="30" height="92" rx="7" fill="#0f9d58"/>'
    )
    return frame(k, "#4fe39a", "#0a9158", body)


def present():
    k = "pr"
    body = (
        '<rect x="126" y="104" width="300" height="196" rx="26" fill="#fff" opacity=".38"/>'
        + paper(k, 86, 156, 330, 232, 28)
        + '<circle cx="176" cy="276" r="48" fill="none" stroke="#ffe0c8" stroke-width="28"/>'
        + '<circle cx="176" cy="276" r="48" fill="none" stroke="#f45a22" stroke-width="28" stroke-linecap="round" stroke-dasharray="196 302" transform="rotate(-90 176 276)"/>'
        + '<circle cx="176" cy="276" r="48" fill="none" stroke="#ffb14a" stroke-width="28" stroke-dasharray="64 302" stroke-dashoffset="-214" transform="rotate(-90 176 276)"/>'
        + lines([(250, 206, 130, 18), (250, 250, 138, 13), (250, 280, 118, 13), (250, 310, 128, 13), (250, 340, 90, 13)], "#c9cfdc")
        + '<rect x="250" y="206" width="130" height="18" rx="9" fill="#2a2e38"/>'
        + '<g filter="url(#pr-sh)"><circle cx="404" cy="372" r="42" fill="#fff"/></g><path d="M393 352l32 20-32 20z" fill="#f45a22"/>'
    )
    return frame(k, "#ffb255", "#ee4d1c", body)


def draw():
    k = "dr"
    body = (
        paper(k, 96, 104, 320, 304, 32)
        + '<circle cx="190" cy="204" r="46" fill="#3f86ff"/><circle cx="178" cy="190" r="14" fill="#fff" opacity=".35"/>'
        + '<rect x="266" y="166" width="96" height="96" rx="24" fill="#ffb21f" transform="rotate(10 314 214)"/>'
        + '<path d="M150 368l64-84 64 84z" fill="#27c985" stroke="#27c985" stroke-width="12" stroke-linejoin="round"/>'
        + '<path d="M132 384C200 310 290 440 392 322" fill="none" stroke="#2d303c" stroke-width="9" stroke-linecap="round"/>'
        + '<path d="M132 384L168 336M392 322L350 346" stroke="#8b91a3" stroke-width="4"/><circle cx="168" cy="336" r="8" fill="#fff" stroke="#2d303c" stroke-width="4"/><circle cx="350" cy="346" r="8" fill="#fff" stroke="#2d303c" stroke-width="4"/>'
        + '<rect x="120" y="374" width="24" height="24" rx="5" fill="#fff" stroke="#2d303c" stroke-width="5"/><rect x="380" y="310" width="24" height="24" rx="5" fill="#fff" stroke="#2d303c" stroke-width="5"/>'
    )
    return frame(k, "#ff7fb0", "#8238ee", body)


def office():
    k = "of"
    def tile(x, y, a, b, key):
        return (f'<defs><linearGradient id="of-{key}" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="{a}"/><stop offset="1" stop-color="{b}"/></linearGradient></defs>'
                f'<rect x="{x}" y="{y}" width="112" height="112" rx="30" fill="url(#of-{key})" filter="url(#of-sh)"/>'
                f'<rect x="{x}" y="{y}" width="112" height="56" rx="28" fill="#fff" opacity=".16"/>')
    body = (tile(124, 124, "#68a6ff", "#2a5ce4", "a") + tile(276, 124, "#58e8a2", "#0f9d58", "b")
            + tile(124, 276, "#ffbb62", "#ee4d1c", "c") + tile(276, 276, "#ff86b5", "#8a3cf0", "d"))
    return frame(k, "#4a4f5c", "#14161b", body)


# ------------------------------------------------------------- workspace apps
def mail():
    k = "ma"
    body = (
        paper(k, 92, 150, 328, 228, 34)
        + '<path d="M104 176l152 108 152-108" fill="none" stroke="#b9cdf5" stroke-width="12" stroke-linecap="round" stroke-linejoin="round"/>'
        + '<path d="M104 360l112-92M408 360L296 268" stroke="#d7e2fa" stroke-width="10" stroke-linecap="round"/>'
        + '<g filter="url(#ma-sh)"><circle cx="410" cy="150" r="40" fill="#ff4d5e"/></g><circle cx="410" cy="150" r="14" fill="#fff"/>'
    )
    return frame(k, "#58c8ff", "#1d63e0", body)


def calendar():
    k = "ca"
    body = (
        paper(k, 90, 98, 332, 332, 38)
        + '<path d="M90 136a38 38 0 0 1 38-38h256a38 38 0 0 1 38 38v52H90z" fill="#ff4d5e"/>'
        + '<rect x="150" y="70" width="22" height="58" rx="11" fill="#fff"/><rect x="340" y="70" width="22" height="58" rx="11" fill="#fff"/>'
        + "".join(f'<circle cx="{x}" cy="{y}" r="13" fill="#cfd5e2"/>' for x in (150, 214, 278, 342) for y in (236, 300, 364) if (x, y) != (278, 300))
        + '<circle cx="278" cy="300" r="30" fill="#ff4d5e"/><circle cx="278" cy="300" r="10" fill="#fff"/>'
    )
    return frame(k, "#fbfbfd", "#dfe3ee", body.replace('filter="url(#ca-sh)"', 'filter="url(#ca-sh)"'))


def contacts():
    k = "co"
    body = (
        paper(k, 100, 96, 312, 320, 36)
        + '<circle cx="256" cy="204" r="52" fill="#ffb347"/><path d="M158 372c6-62 46-92 98-92s92 30 98 92z" fill="#ff8a3d"/>'
        + lines([(158, 392, 196, 0.1)], "none")
        + '<rect x="100" y="96" width="312" height="0" fill="none"/>'
        + '<rect x="410" y="150" width="22" height="46" rx="11" fill="#ffd6a5"/><rect x="410" y="214" width="22" height="46" rx="11" fill="#ffe7c8"/><rect x="410" y="278" width="22" height="46" rx="11" fill="#ffd6a5"/>'
    )
    return frame(k, "#ffc15c", "#f0601f", body)


def drive():
    k = "dv"
    body = (
        '<path d="M96 170a30 30 0 0 1 30-30h92l34 40h134a30 30 0 0 1 30 30v22H96z" fill="#bff3ee" filter="url(#dv-sh)"/>'
        + '<g filter="url(#dv-sh)"><path d="M96 218a30 30 0 0 1 30-30h260a30 30 0 0 1 30 30v132a30 30 0 0 1-30 30H126a30 30 0 0 1-30-30z" fill="url(#dv-paper)"/></g>'
        + '<circle cx="256" cy="300" r="46" fill="#17b8ad"/><path d="M256 324v-48m-22 22l22-22 22 22" fill="none" stroke="#fff" stroke-width="12" stroke-linecap="round" stroke-linejoin="round"/>'
    )
    return frame(k, "#52e2cf", "#0c8a9e", body)


SETS = {OFFICE: {"Office": office, "Write": write, "Cells": cells, "Present": present, "Draw": draw},
        WORKSPACE: {"Mail": mail, "Calendar": calendar, "Contacts": contacts, "Drive": drive}}


def main():
    n = 0
    for folder, icons in SETS.items():
        os.makedirs(folder, exist_ok=True)
        for name, fn in icons.items():
            with open(os.path.join(folder, "tech.nubosuite.%s.svg" % name), "w") as f:
                f.write(fn())
            n += 1
    print("icons written:", n)


if __name__ == "__main__":
    main()
