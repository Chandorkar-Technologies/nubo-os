---
title: App folders
description: The folders in the Nubo OS app grid, which apps are in each, and how a "More apps" folder works.
sidebar:
  order: 90
---

**Applies to:** Desktop

The app grid keeps everyday apps on the front pages and puts tools in folders. Nubo OS defines three folders at system level: **Utilities**, **Accessories** and **More apps**.

![The app grid with the Utilities folder](../../../../assets/screens/grid1.jpg)

The screenshot also shows another folder named **System**. That one is not defined by Nubo's settings and comes from the base system.

## Utilities

| App (launcher name) | Desktop id |
|---|---|
| Languages | `gnome-language-selector` |
| Resources | `net.nokyan.Resources` |
| Characters | `org.gnome.Characters` |
| Disk Usage | `org.gnome.baobab` |
| Disk Utility <!-- verify label --> | `org.gnome.DiskUtility` |
| Logs | `org.gnome.Logs` |
| Fonts | `org.gnome.font-viewer` |
| Archive Manager | `org.gnome.FileRoller` |
| Backup | `org.gnome.DejaDup` |
| Passwords and Keys <!-- verify label --> | `org.gnome.seahorse.Application` |
| Terminal | `org.gnome.Ptyxis` |
| LocalSend | `org.localsend.localsend_app` |

## Accessories

| App | Desktop id |
|---|---|
| Document Scanner | `simple-scan` |
| Calculator | `org.gnome.Calculator` |
| Voice Memos | `org.gnome.SoundRecorder` |
| Clocks | `org.gnome.clocks` |
| Text Editor | `org.gnome.TextEditor` |

## More apps

This folder is different. It is not a fixed list. It collects every launcher in the category `X-Nubo-Placeholder`. These are the grey placeholders of popular apps that are not installed and are not on the front page. See [Popular apps: click to download](/desktop/apps/popular-apps-click-to-download/). When you install an app, its placeholder leaves this folder.

## How the folders are defined

The folders are set in the dconf file `/etc/dconf/db/nubo.d/nubo-app-folders`, installed by `nubo-branding`. The folder names are not translated (`translate=false`).

Some apps are renamed in the launcher, such as Files, Videos or Mail. Their programs are unchanged. See the list in the project, `data/apps/rebrand.list`. A few entries from Ubuntu are hidden from the launcher (not removed), such as GNOME Maps, Yelp and the Extension Manager.

## Before you begin

Nothing is required. This page is information.

## Change your own layout

Folders are normal GNOME app grid folders, so you can arrange them by dragging.

1. Open the app grid.
2. Drag an icon onto another to make a folder, or drag it out of a folder to remove it.
3. Rename a folder you made by opening it and editing its name. <!-- verify label -->

Folders defined by the system may not be renamed or removed this way. <!-- verify behavior -->

## Verify

Open the app grid. You should see Utilities and Accessories, and More apps if some popular apps are not installed.

## Troubleshooting

**An app is not where this page says.** The app is not installed, or its desktop id differs, for example a Flatpak build. Search for it by name.

**More apps is missing.** It shows only when at least one grey placeholder has the category. If you have downloaded every app on the list, the folder has nothing to show.

**The folders are gone after an update.** The folders come from the dconf database. Run `sudo dconf update` and log in again.

## See also

- [Apps](/desktop/apps/)
- [Desktop](/desktop/)
