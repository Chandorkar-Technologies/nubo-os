---
title: "Popular apps: click to download"
description: How the grey placeholder icons work, which apps are on the popular list, and what happens when you click one.
sidebar:
  order: 20
---

**Applies to:** Desktop

Some well-known apps are too big or not free to put on the install image. Nubo OS shows them anyway, as grey icons in the app grid. Click one and the app downloads from Flathub, then opens. After that the grey icon is replaced by the real app.

## How it works

Three small pieces do the work.

| Piece | What it is | What it does |
|---|---|---|
| `popular.list` | `/usr/share/nubo/apps/popular.list` | The list of apps. One line per app: kind, id or address, name, category, preinstall (yes or no). |
| `nubo-app-stubs` | `/usr/libexec/nubo/nubo-app-stubs`, run by a user service at login and after each download | Writes the launchers into `~/.local/share/applications`. |
| `nubo-get` | `/usr/bin/nubo-get` | Downloads a Flatpak app from Flathub, then starts it. |

For each Flatpak app on the list that is **not installed**, `nubo-app-stubs` writes a launcher with a grey version of the app's icon and the comment "Click to download". If the app's own icon is not available, it draws a grey tile with the first letter of the name. The launcher runs `nubo-get <id> "<name>"`.

`nubo-get` then:

1. Checks whether the app is installed. If not, it adds Flathub for your user if it is missing.
2. Shows a small progress window titled "Nubo Store" with the text "Downloading <name>…".
3. Runs `flatpak install --user --noninteractive` from Flathub.
4. Refreshes the placeholders, so the grey icon disappears, and starts the app.

If the download fails, a message says "Could not download <name>" and asks you to check your internet connection.

Apps installed this way go into your user's Flatpak area, not the system one. Nothing is installed for other users.

## The "More apps" folder

The `preinstall` column does not mean the app is installed on the image. It controls where the grey icon sits:

- `yes`: the placeholder is on the front pages of the app grid.
- `no`: the placeholder is tucked into a folder named **More apps**. See [App folders](/desktop/apps/app-folders/).

Whether an app is really installed on the first boot is a separate list, see [Install and remove apps](/desktop/apps/install-and-remove-apps/).

## Web apps

Rows of kind `web` are links to websites, not downloads. Only the rows with `yes` get a launcher. It is named after the site, has the comment "Opens in your browser", and opens the address with your default browser (`xdg-open`). Rows with `no` are in the list but get no launcher today.

## The list

The list currently holds 33 entries. It is a catalogue that the project maintains, and it can change with updates.

| Name | Kind | Id or address | Category | Front page (preinstall column) |
|---|---|---|---|---|
| Spotify | flatpak | `com.spotify.Client` | media | yes |
| Telegram | flatpak | `org.telegram.desktop` | chat | yes |
| Signal | flatpak | `org.signal.Signal` | chat | no |
| Discord | flatpak | `com.discordapp.Discord` | chat | no |
| Slack | flatpak | `com.slack.Slack` | chat | no |
| Zoom | flatpak | `us.zoom.Zoom` | chat | no |
| VLC | flatpak | `org.videolan.VLC` | media | yes |
| WhatsApp | web | `https://web.whatsapp.com` | chat | yes |
| YouTube | web | `https://www.youtube.com` | media | yes |
| YouTube Music | web | `https://music.youtube.com` | media | no |
| Netflix | web | `https://www.netflix.com` | media | no |
| Instagram | web | `https://www.instagram.com` | social | no |
| Telegram Web | web | `https://web.telegram.org` | chat | no |
| Collabora Office | flatpak | `com.collaboraoffice.Office` | work | yes |
| Obsidian | flatpak | `md.obsidian.Obsidian` | work | no |
| VS Code | flatpak | `com.visualstudio.code` | dev | no |
| Dropbox | flatpak | `com.dropbox.Client` | work | no |
| Thunderbird | flatpak | `org.mozilla.Thunderbird` | work | no |
| Gmail | web | `https://mail.google.com` | work | no |
| Google Docs | web | `https://docs.google.com` | work | no |
| Google Meet | web | `https://meet.google.com` | work | no |
| Notion | web | `https://www.notion.so` | work | no |
| Figma | web | `https://www.figma.com` | design | no |
| Canva | web | `https://www.canva.com` | design | no |
| OBS Studio | flatpak | `com.obsproject.Studio` | create | no |
| GIMP | flatpak | `org.gimp.GIMP` | create | no |
| Inkscape | flatpak | `org.inkscape.Inkscape` | create | no |
| Krita | flatpak | `org.kde.krita` | create | no |
| Blender | flatpak | `org.blender.Blender` | create | no |
| Audacity | flatpak | `org.audacityteam.Audacity` | create | no |
| Google Chrome | flatpak | `com.google.Chrome` | browser | no |
| Brave | flatpak | `com.brave.Browser` | browser | no |
| Steam | flatpak | `com.valvesoftware.Steam` | games | no |

Notes:

- The list file says every Flathub id must be checked against flathub.org before shipping. An id that no longer exists would give a download error.
- Spotify, Slack, Zoom, Discord, Steam, Chrome and Dropbox are proprietary. The install image carries none of them. You download them yourself from Flathub.
- Geary is the default mail app and is not in the list. See [Mail with Geary](/desktop/account/mail-with-geary/).
- Spotify is for x86 computers only. On an arm64 machine there is no Flathub build, so the grey icon will fail to download. <!-- verify behavior on arm64 -->

## Before you begin

To download an app from a grey icon you need:

- An internet connection.
- The `flatpak` program. It is part of the desktop.

## Steps: get an app from its grey icon

1. Open the app grid and find the grey icon. If you cannot see it, open the **More apps** folder.
2. Click the icon. A small window shows the download.
3. Wait. The app opens by itself when the download ends.

## Verify

- The grey icon is replaced by the normal icon.
- `flatpak list --app` shows the app.

## Troubleshooting

**"Could not download".** No network, or Flathub could not be reached. Connect and click again.

**The icon is still grey after the app opened.** The placeholders refresh after a download and at each login. Log out and in, or run `/usr/libexec/nubo/nubo-app-stubs`.

**The app is not in the list.** Search for it in the [Nubo Store](/desktop/apps/nubo-store/) instead.

**You want to remove an app.** See [Install and remove apps](/desktop/apps/install-and-remove-apps/).

## See also

- [Flatpak basics](/desktop/apps/flatpak-basics/)
- [Nubo Store](/desktop/apps/nubo-store/)
