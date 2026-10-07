---
title: "The brand pack and icons"
description: "Our own logos, colours, icon family and welcome slides for Nubo Office, and the scripts that make them."
sidebar:
  order: 40
---

**Applies to:** Developers

Collabora's brand pack is proprietary, so we wrote our own. Everything here is generated or drawn by scripts in the `office/` folder of the repository.

## Files

| Path | What it is | Made by |
|---|---|---|
| `office/brand/branding.js` | Product name, link and the About credit; hides the macro-author notice | written by hand |
| `office/brand/branding.css` | The blue accent theme, light and dark, the per-document colours and the logo rules | `office/make-brand-pack.py` |
| `office/brand/images/` | Logos: full logo (dark and white), toolbar and start-up logo in three variants | `office/make-brand-pack.py` |
| `office/brand/welcome/` | The first-run slide pictures | `office/make-welcome-art.py` |
| `office/icons/` | App icons for Nubo Office, Write, Cells, Present, Draw | `office/make-icons.py` |
| `workspace/icons/` | App icons for Nubo Mail, Calendar, Contacts and Drive, in the same family | `office/make-icons.py` |
| `office/tech.nubosuite.Office.metainfo.xml` | AppStream description | written by hand |

## Colours

The accent is a blue close to Nubo Email's, so the apps look related. The editor also colours each kind of document, and shows a fallback on the start screen. Ours follow the icons:

| Where | Colour (r, g, b) |
|---|---|
| Start screen and suite | 47, 111, 222 (blue) |
| Documents (Write) | 47, 111, 222 (blue) |
| Spreadsheets (Cells) | 15, 157, 88 (green) |
| Presentations (Present) | 230, 81, 28 (orange) |
| Drawings (Draw) | 138, 56, 238 (violet) |

## Icons

One family: a gradient rounded square with a gloss and a layered picture in the middle, one colour per app. Write is a page with a pencil, Cells a grid with a floating bar chart, Present stacked slides with a donut chart and a play button, Draw shapes with a curve and anchor points. The workspace apps follow the same style. Everything is drawn in `make-icons.py`; nothing is copied from another product.

## Welcome slides

- **Slide 1** shows our three app icons in the round frames.
- **Slide 2** is a picture generated with DeepInfra's image API: a document, a spreadsheet with bars and a presentation with a donut chart.
- **Slide 3** is drawn in SVG by the script: one document with two people editing, with name tags, highlights and a comment. Image models could not place these parts precisely.

`make-welcome-art.py` reads the DeepInfra key from the environment variable `DEEPINFRA_API_KEY` or from `~/.config/nubo-os/env`. It never prints or stores the key elsewhere.

## About the "81 images" in Collabora's pack

That pack holds 81 images. We did not redraw them. Most are white one-colour copies of the editor's normal icons, made for Collabora's coloured header bars. Our header colour is the accent, and the editor's own open-licensed icons already work with it. The pieces that matter (logos, the four per-document colours, welcome slides) are covered above. Styling of form controls and icon tints is still to do, from screenshots of the running editor.

## Regenerate

```bash
python3 office/make-icons.py
python3 office/make-brand-pack.py
python3 office/make-welcome-art.py        # needs rsvg-convert and the DeepInfra key
```

## See also

- [The rebrand script](/office/collabora/rebrand-script/)
