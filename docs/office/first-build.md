# First build results

**Applies to:** Developers

Built on 2026-10-07 on a VM with 8 cores, 22 GB RAM, from tag `coda-26.04.3.3-1`.

## What ran

- The engine built with no errors. It reports `Vendor=Nubo` and `ProductKey=Nubo Office 26.04`.
- The rebrand script was applied. The Qt desktop app and the web interface built with no errors (`qt/coda-qt`, about 134 MB).
- The app ran under a virtual display (Xvfb) and was checked from screenshots.

## What we checked

| Check | Result |
|---|---|
| Start screen | Nubo mark, "Nubo Office", blue header and buttons |
| Write, Cells, Present, Draw | Each opens a blank document, in blue, green, orange and violet |
| About window | "Nubo Office", the version, "License Information" and the credit line |
| Help menu | Forum goes to the docs, Report an issue to the issue tracker |
| Pop-up about the legacy script interface | Hidden |
| Second run of the rebrand script | Changes nothing |

## Problems the first build showed, and the fixes

1. The start screen still said "Collabora Office": the title is in a `.tsx` file, and the script was not scanning that type. Fixed.
2. The header was purple: the editor uses a per-document colour variable. Replaced with our colours.
3. The header logo was tiny: the wide logo went into a square slot. Now the mark alone.
4. A notice about macros appeared in every app. Hidden in the desktop app.
5. Running the script twice added the About credit twice and broke the build. The script now leaves the credit line alone and the check passes.

## Not checked yet

- The light theme and the other dialogs.
- Checkbox, radio-button and close-button styling, and toolbar icon tints.
- Opening and saving real Word, Excel and PowerPoint files.
- The Flatpak build, and the web server build.
- Windows, macOS, Android and iOS builds.

## See also

- [Source and build](source-and-build.md)
- [The rebrand script](rebrand-script.md)
