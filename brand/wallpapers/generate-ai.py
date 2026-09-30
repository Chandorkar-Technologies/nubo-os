#!/usr/bin/env python3
"""Generate photographic monochrome wallpapers with an image model (DeepInfra).

Companion to generate.py (procedural). Needs DEEPINFRA_API_KEY in the
environment. Output is 3840x2160 grayscale PNG; the model renders at its
maximum size and the result is upscaled with light sharpening and grain.

Usage: generate-ai.py OUTPUT_DIR [--model MODEL] [--only NAME]
"""

import argparse
import base64
import json
import os
import sys
import urllib.request
from io import BytesIO

import numpy as np
from PIL import Image, ImageFilter

MODEL = "black-forest-labs/FLUX-1.1-pro"
RENDER = (1440, 832)      # widest 16:9-ish size the model accepts
OUT_SIZE = (3840, 2160)

STYLE = ("black and white photograph, monochrome, no text, no letters, no logo, "
         "no people, minimalist, high detail, subtle film grain, wallpaper composition "
         "with calm empty areas")

DESIGNS = {
    "dunes-dark": ("aerial view of sand dunes with low side light, long soft shadows, "
                   "bright ridges against dark valleys, strong contrast", True),
    "silk-dark": ("close-up of black silk fabric folds with a single soft light source, "
                  "elegant curves, mostly dark", True),
    "glass-dark": ("macro photograph of frosted glass panes stacked at angles on black, "
                   "soft refractions and highlights, mostly dark", True),
    "water-dark": ("close-up of gentle ripples on dark water with bright specular "
                   "highlights from a low sun, strong contrast", True),
    "paper-light": ("folded white paper with soft shadows, bright and airy, mostly white",
                    False),
    "cloud-light": ("soft cloud layers seen from above, bright overcast light, mostly white",
                    False),
}


def request(model, prompt, key):
    body = json.dumps({"prompt": prompt, "width": RENDER[0], "height": RENDER[1]}).encode()
    req = urllib.request.Request(
        f"https://api.deepinfra.com/v1/inference/{model}",
        data=body,
        headers={"Authorization": f"bearer {key}", "Content-Type": "application/json"},
    )
    with urllib.request.urlopen(req, timeout=180) as resp:
        data = json.load(resp)
    url = data.get("image_url") or (data.get("images") or [None])[0]
    if not url:
        raise RuntimeError(f"no image in response: {list(data)}")
    if url.startswith("data:"):
        return base64.b64decode(url.split(",", 1)[1])
    with urllib.request.urlopen(url, timeout=180) as resp:
        return resp.read()


def finish(png_bytes, dark):
    img = Image.open(BytesIO(png_bytes)).convert("L")
    # Fill the target frame, then crop the excess.
    scale = max(OUT_SIZE[0] / img.width, OUT_SIZE[1] / img.height)
    img = img.resize((round(img.width * scale), round(img.height * scale)), Image.LANCZOS)
    left = (img.width - OUT_SIZE[0]) // 2
    top = (img.height - OUT_SIZE[1]) // 2
    img = img.crop((left, top, left + OUT_SIZE[0], top + OUT_SIZE[1]))
    img = img.filter(ImageFilter.UnsharpMask(radius=2, percent=60, threshold=2))
    arr = np.asarray(img, dtype=np.float32)
    rng = np.random.default_rng(0)
    arr += rng.normal(0, 2.0, arr.shape).astype(np.float32)
    # Keep extremes usable behind text: dark ones stay dark, light ones light.
    arr = np.clip(arr, 0, 255)
    return Image.fromarray(arr.astype(np.uint8))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("out")
    ap.add_argument("--model", default=MODEL)
    ap.add_argument("--only")
    args = ap.parse_args()
    key = os.environ.get("DEEPINFRA_API_KEY")
    if not key:
        sys.exit("DEEPINFRA_API_KEY is not set")
    os.makedirs(args.out, exist_ok=True)
    for name, (prompt, dark) in DESIGNS.items():
        if args.only and name != args.only:
            continue
        png = request(args.model, f"{prompt}, {STYLE}", key)
        path = os.path.join(args.out, f"nubo-{name}.png")
        finish(png, dark).save(path, optimize=True)
        print("wrote", path)


if __name__ == "__main__":
    main()
