---
title: "The rebrand script"
description: "What office/rebrand.py changes in a Collabora checkout, how to run it, and what it leaves alone."
sidebar:
  order: 30
---

**Applies to:** Developers

`office/rebrand.py` in the Nubo OS repository applies the Nubo names to a checkout of Collabora's monorepo. We run it on every upstream release we take, so the rebrand is a script plus our own assets and not a fork to maintain by hand.

## Run it

```bash
python3 office/rebrand.py /path/to/collabora --version 26.04.3.3-nubo1
python3 office/rebrand.py /path/to/collabora --report     # list what still names Collabora or LibreOffice
```

It needs `rsvg-convert` (package `librsvg2-bin`) to redraw the start-centre icons. It is safe to run twice: a second run changes nothing.

## What it changes

| Area | Change |
|---|---|
| Names in `qt/` and `browser/` | Replaces "Collabora Office", "Collabora Online" and the "Development Edition (unbranded)" name with "Nubo Office". Scans `.ts`, `.tsx`, `.js`, `.html`, `.css`, `.cpp`, `.hpp`, `.xml`, `.desktop`, `.json` and more |
| App id | `com.collaboraoffice.Office` becomes `tech.nubosuite.Office` in file names, the D-Bus name and path, desktop and metadata files, icon names |
| Links | Help, forum and issue links go to `docs.nubosuite.tech` and the Nubo OS issue tracker. Links to Collabora's SDK documentation stay, since they are references and not branding |
| Start-centre icons | Redrawn from our icon at every size |
| `browser/images/collabora-office-*.svg` | Replaced by our mark |
| AppStream file | Replaced by our own (name, text, links, no Collabora screenshots) |
| Flatpak manifest | Uses our brand pack in place of Collabora's, builds the engine with our product name and vendor |
| Welcome slides | New text for all three slides, our pictures |
| About window | Adds the credit line "Built on Collabora Online and LibreOffice technology" |
| Defaults | Hides the macro-author notice about the legacy script interface in the desktop app, and defaults it to hidden on the server |

## What it never touches

- Copyright, licence and SPDX lines.
- Translations (`browser/po`, `browser/l10n`, `qt/translations`) and tests.
- The credit line, which the name rules would otherwise rewrite.
- Internal install folder names such as `/app/collaboraoffice`, which users never see.

## Known leftovers

`--report` lists about 35 files. They are mostly code comments, the word "collaborative", links to Collabora's SDK documentation, and the server-administration pages. The internal names above stay on purpose.

## Troubleshooting

- **The TypeScript build fails with "Cannot redeclare block-scoped variable".** An edit was applied twice by an older version of the script. Restore the file with `git checkout`, then run the current script.
- **The window still says "Collabora Office".** A file type was missed. Run `--report` and look in `browser/src`.

## See also

- [The brand pack and icons](/office/collabora/brand-pack/)
- [Licence and trademark rules](/office/collabora/licence-and-trademark/)
