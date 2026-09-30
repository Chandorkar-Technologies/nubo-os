#!/usr/bin/env python3
"""Generate the Nubo OS wallpaper set: original, procedural, monochrome.

Each design comes out in a dark and a light version at 3840x2160. Structure
in the image matters: the desktop's frosted-glass panels blur whatever sits
behind them, and flat black shows nothing through glass.

Usage: generate.py OUTPUT_DIR [--size WxH] [--only NAME]
"""

import argparse
import math
import os

import numpy as np
from PIL import Image, ImageDraw, ImageFilter

SIZE = (3840, 2160)


def value_noise(shape, cells, octaves=4, seed=0):
    """Smooth 2-D noise in [0, 1] built from stacked random lattices."""
    rng = np.random.default_rng(seed)
    h, w = shape
    out = np.zeros(shape, dtype=np.float32)
    amp, total = 1.0, 0.0
    for octave in range(octaves):
        n = cells * (2 ** octave)
        lattice = rng.random((n + 2, n + 2)).astype(np.float32)
        ys = np.linspace(0, n, h, endpoint=False)
        xs = np.linspace(0, n, w, endpoint=False)
        y0 = np.floor(ys).astype(int)
        x0 = np.floor(xs).astype(int)
        fy = (ys - y0)[:, None]
        fx = (xs - x0)[None, :]
        fy = fy * fy * (3 - 2 * fy)
        fx = fx * fx * (3 - 2 * fx)
        a = lattice[y0[:, None], x0[None, :]]
        b = lattice[y0[:, None], x0[None, :] + 1]
        c = lattice[y0[:, None] + 1, x0[None, :]]
        d = lattice[y0[:, None] + 1, x0[None, :] + 1]
        layer = (a * (1 - fx) + b * fx) * (1 - fy) + (c * (1 - fx) + d * fx) * fy
        out += layer * amp
        total += amp
        amp *= 0.5
    return out / total


def grain(img, amount, seed=1):
    rng = np.random.default_rng(seed)
    arr = np.asarray(img, dtype=np.float32)
    arr += rng.normal(0, amount, arr.shape).astype(np.float32)
    return Image.fromarray(np.clip(arr, 0, 255).astype(np.uint8))


def to_rgb(gray):
    return Image.fromarray(np.clip(gray, 0, 255).astype(np.uint8)).convert("RGB")


# --- designs -----------------------------------------------------------------

def design_flow(size, dark, seed=7):
    """Thousands of fine streamlines following a noise field."""
    w, h = size
    ss = 2
    W, H = w * ss, h * ss
    bg = 6 if dark else 244
    ink = (255, 255, 255) if dark else (0, 0, 0)
    canvas = Image.new("RGB", (W, H), (bg, bg, bg))
    draw = ImageDraw.Draw(canvas, "RGBA")

    field = value_noise((H // 8, W // 8), 3, octaves=3, seed=seed) * 2 * math.pi * 1.5
    rng = np.random.default_rng(seed)
    starts = rng.random((2600, 2))
    step = 9 * ss
    for sx, sy in starts:
        x, y = sx * W, sy * H
        pts = [(x, y)]
        for _ in range(140):
            fx = min(int(x) // 8, field.shape[1] - 1)
            fy = min(int(y) // 8, field.shape[0] - 1)
            a = field[fy, fx]
            x += math.cos(a) * step
            y += math.sin(a) * step
            if not (0 <= x < W and 0 <= y < H):
                break
            pts.append((x, y))
        if len(pts) > 6:
            alpha = int(rng.integers(18, 48))
            draw.line(pts, fill=ink + (alpha,), width=ss)

    canvas = canvas.resize((w, h), Image.LANCZOS)
    # A soft light field underneath keeps the darker areas from going flat.
    glow = value_noise((h // 4, w // 4), 2, octaves=2, seed=seed + 1)
    glow = Image.fromarray((glow * 255).astype(np.uint8)).resize((w, h), Image.BILINEAR)
    glow = glow.filter(ImageFilter.GaussianBlur(w / 12))
    g = np.asarray(glow, dtype=np.float32) / 255
    arr = np.asarray(canvas, dtype=np.float32)
    lift = (g[..., None] - 0.5) * (28 if dark else 22)
    return grain(Image.fromarray(np.clip(arr + lift, 0, 255).astype(np.uint8)), 2.2)


def design_contours(size, dark, seed=11):
    """Topographic contour lines over a soft gradient."""
    w, h = size
    n = value_noise((h, w), 2, octaves=4, seed=seed)
    n = n * 0.75 + np.linspace(0, 0.25, w)[None, :]
    levels = 26
    phase = (n * levels) % 1.0
    line = np.exp(-((phase - 0.5) ** 2) / (2 * 0.018 ** 2))
    line = np.clip(line, 0, 1)
    if dark:
        base = 8 + n * 40
        gray = base + line * 120
    else:
        base = 246 - n * 34
        gray = base - line * 110
    img = to_rgb(gray)
    return grain(img, 1.8)


def design_beam(size, dark, seed=3):
    """Broad diagonal light with a second soft source; the calm default."""
    w, h = size
    yy, xx = np.mgrid[0:h, 0:w].astype(np.float32)
    u = (xx / w) * 0.85 + (yy / h) * 0.55
    beam = np.exp(-((u - 0.62) ** 2) / (2 * 0.16 ** 2))
    spot = np.exp(-(((xx / w) - 0.18) ** 2 + ((yy / h) - 0.85) ** 2) / (2 * 0.22 ** 2))
    n = value_noise((h // 8, w // 8), 2, octaves=3, seed=seed)
    n = np.asarray(Image.fromarray((n * 255).astype(np.uint8)).resize((w, h)), dtype=np.float32) / 255
    if dark:
        gray = 6 + beam * 88 + spot * 46 + (n - 0.5) * 18
    else:
        gray = 248 - beam * 70 - spot * 36 - (n - 0.5) * 16
    return grain(to_rgb(gray), 2.4)


def design_shards(size, dark, seed=5):
    """Overlapping translucent panes, like sheets of frosted glass."""
    w, h = size
    bg = 6 if dark else 246
    canvas = Image.new("L", (w, h), bg)
    rng = np.random.default_rng(seed)
    layers = []
    for i in range(7):
        pane = Image.new("L", (w, h), 0)
        d = ImageDraw.Draw(pane)
        cx, cy = rng.random() * w, rng.random() * h
        ang = rng.random() * math.pi
        L = w * (0.9 + rng.random() * 0.6)
        T = h * (0.12 + rng.random() * 0.25)
        dx, dy = math.cos(ang), math.sin(ang)
        px, py = -dy, dx
        pts = [
            (cx + dx * L - px * T, cy + dy * L - py * T),
            (cx + dx * L + px * T, cy + dy * L + py * T),
            (cx - dx * L + px * T, cy - dy * L + py * T),
            (cx - dx * L - px * T, cy - dy * L - py * T),
        ]
        d.polygon(pts, fill=255)
        pane = pane.filter(ImageFilter.GaussianBlur(w / 220 + i * w / 400))
        layers.append(np.asarray(pane, dtype=np.float32) / 255 * (0.09 + rng.random() * 0.08))
    arr = np.full((h, w), bg, dtype=np.float32)
    for layer in layers:
        arr = arr + layer * (150 if dark else -130)
    return grain(to_rgb(arr), 2.0)


DESIGNS = {
    "flow": design_flow,
    "contours": design_contours,
    "beam": design_beam,
    "shards": design_shards,
}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("out")
    ap.add_argument("--size", default=f"{SIZE[0]}x{SIZE[1]}")
    ap.add_argument("--only")
    args = ap.parse_args()
    w, h = (int(v) for v in args.size.split("x"))
    os.makedirs(args.out, exist_ok=True)
    for name, fn in DESIGNS.items():
        if args.only and name != args.only:
            continue
        for dark in (True, False):
            img = fn((w, h), dark).convert("L")
            path = os.path.join(args.out, f"nubo-{name}-{'dark' if dark else 'light'}.png")
            img.save(path, optimize=True)
            print("wrote", path)


if __name__ == "__main__":
    main()
