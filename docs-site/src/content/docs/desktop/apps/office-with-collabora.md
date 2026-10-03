---
title: Office with Collabora
description: Write documents, spreadsheets and presentations with Collabora Office, open Microsoft files, and find out where LibreOffice went.
sidebar:
  order: 50
---

**Applies to:** Desktop

Nubo OS includes **Collabora Office** for documents, spreadsheets and presentations. It is installed from Flathub as `com.collaboraoffice.Office`. It is not a Nubo program, and the project keeps its name as it is.

## Where LibreOffice went

LibreOffice is removed from Nubo OS. On first boot, the system removes the `libreoffice*` packages, and installs Collabora Office in its place. Collabora Office and LibreOffice share a code base, but the Nubo project does not describe differences in features, so check Collabora's own documentation for what each app does. <!-- verify claim about shared code base -->

If you want LibreOffice, you can get it as a Flatpak from Flathub (`org.libreoffice.LibreOffice`) <!-- verify id --> or from the Nubo Store. It is not part of the default set.

## Before you begin

- An internet connection at the first boot, so that Collabora Office can download. It is retried at each boot until done.
- If it is not installed, see Troubleshooting.

## Open the app

1. Open the app grid and find **Collabora Office**.
2. Choose the type of document you want to make or open. <!-- verify label -->

If the icon is grey, the app has not been downloaded yet. Click it. See [Popular apps: click to download](/desktop/apps/popular-apps-click-to-download/).

## Open Microsoft files

Collabora Office reads and writes the common Microsoft formats (`.docx`, `.xlsx`, `.pptx`) in addition to the open document formats. <!-- verify supported formats -->

1. In **Files**, right-click the document.
2. Choose **Open With** and pick Collabora Office. <!-- verify label -->
3. To make it the default, in the same dialog select the option to always use it. <!-- verify label -->

When you save, choose the format. Keep the Microsoft format if you share the file with people who use Microsoft Office. Complex layouts, macros and unusual fonts can change between programs. Open an important file once in the other program before you send it.

## Fonts

The desktop includes `fonts-liberation`, which has metrics compatible with Arial, Times New Roman and Courier New, so most layouts stay the same. Inter and JetBrains Mono are the system fonts.

## Verify

- Create a short document, save it as `.docx`, close the app, and reopen the file from Files.
- `flatpak list --app | grep -i collabora` shows the app.

## Troubleshooting

**Collabora Office is missing.** It could not be downloaded at first boot, for example when you were offline. Check:

```bash
flatpak info --system com.collaboraoffice.Office
```

If it is not found, install it:

```bash
flatpak install flathub com.collaboraoffice.Office
```

**A file opens with the wrong program.** Right-click the file, choose Open With, and choose Collabora Office.

**Text looks different from Microsoft Office.** A font is missing. Install the font, or use a similar one.

**The app cannot open a folder I want.** Flatpak apps are sandboxed. Use the app's open dialog, which gives it access to the chosen file.

## See also

- [Flatpak basics](/desktop/apps/flatpak-basics/)
- [Moving from Windows or Mac](/desktop/apps/moving-from-windows-or-mac/)
- [Update apps](/desktop/apps/update-apps/)
