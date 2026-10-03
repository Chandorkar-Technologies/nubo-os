---
title: Default apps
description: See which apps Nubo OS opens by default and change the app used for the web, mail, files and other types.
sidebar:
  order: 120
---

**Applies to:** Desktop

A default app is the one that opens when you click a link, a file or a mail address. This page lists what Nubo OS installs for common jobs and shows how to change the defaults.

## What comes with Nubo OS

| Job | App | Notes |
|---|---|---|
| Web | Firefox | Installed from Flathub at first boot. The Ubuntu Firefox snap is removed |
| Mail | Mail (Geary) | Geary is the default mail app |
| Files | Files | GNOME Files (Nautilus), pinned in the dock |
| Calendar | Calendar | GNOME Calendar, pinned in the dock |
| Documents | Collabora Office | Installed from Flathub at first boot. LibreOffice is removed |
| PDF | PDF Viewer | Papers, renamed |
| Images | Image Viewer | Loupe, renamed |
| Videos | Videos, and VLC | Videos is Showtime, renamed. VLC comes from Flathub at first boot |
| Text | Text Editor | GNOME Text Editor |
| Terminal | Terminal | Ptyxis, renamed |
| Music | Spotify (x86 only), Shortwave for radio | From Flathub at first boot |
| Chat with AI | Newelle | From Flathub at first boot |
| Archives | Archive Manager | File Roller, renamed |
| File sharing | LocalSend | From Flathub at first boot |

The Flathub apps are downloaded on first boot after installation, and only when the computer is online. If it is offline, the job is retried at the next boot. An app that does not exist for your processor type is skipped. See [Dock and app grid](/desktop/use/dock-and-app-grid/).

## Before you begin

- The app must be installed to be selected.
- For some app kinds, the option to choose lives in the app itself, for example Firefox asks to be the default browser.

## Change a default app

1. Open [Settings](/desktop/settings/) and go to the default apps page. <!-- verify label -->
2. Find the type: web, mail, calendar, music, video, photos.
3. Pick another app from the list.

For other file types:

1. Right-click a file in Files and choose to open it with another app. <!-- verify label -->
2. Choose an app, and turn on the option to always use it for this type.

Or from a terminal, to see the current default for a type:

```bash
xdg-mime query default application/pdf
```

To set it:

```bash
xdg-mime default org.gnome.Papers.desktop application/pdf
```

<!-- verify label: desktop file ids; org.gnome.Papers is listed in Nubo's rebrand list -->

## Install another app

Click a grey icon in the app grid, or use the app store (Nubo Store, GNOME Software with Flathub). New apps then appear in the lists above. See [Dock and app grid](/desktop/use/dock-and-app-grid/).

## Verify

1. Click a web link in a chat or document. It opens in the app you chose.
2. Run `xdg-settings get default-web-browser`. It prints the browser's desktop file name.
3. Open a PDF and check the app.

## Troubleshooting

**The wrong app opens.**
Cause: the app is not set as the default for that type. Fix: set it as above, for the exact file type.

**My app is not in the list.**
Cause: it is not installed or provides no desktop entry for that type. Fix: install it; for Flatpak, check it is exported to the system.

**Firefox keeps asking to be the default.**
Cause: the setting was not saved. Fix: set it in Settings, not only in Firefox.

**Links from an app open a different browser.**
Cause: some Flatpak apps use the portal, which follows the system default. Fix: set the system default.

## See also

- [Dock and app grid](/desktop/use/dock-and-app-grid/)
- [Startup and background apps](/desktop/settings/startup-and-background-apps/)
- [Files](/desktop/use/files/)
