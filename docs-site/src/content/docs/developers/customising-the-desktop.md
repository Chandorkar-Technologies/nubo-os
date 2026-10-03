---
title: Customising the desktop
description: Add a popular app, hide or rename launchers, change background apps, add a wallpaper and override defaults, by editing the lists and files that ship with Nubo OS.
sidebar:
  order: 120
---

**Applies to:** Desktop

Most of what makes the desktop Nubo's is data, not code. A handful of small files decide which apps get a grey download icon, which launchers are hidden or renamed, which messaging apps keep running in the background, which wallpapers ship and what the default settings are. This page shows each file, its format and how to change it.

All of these end up inside the package `nubo-branding`, `nubo-apps` or `nubo-notify`, so a change takes effect when you rebuild and install the package. See [Development loop](/developers/development-loop/).

## Before you begin

- A checkout of the repository and a way to build and install in a VM ([Development loop](/developers/development-loop/)).
- The Flathub application id of any app you add. Check it on flathub.org first; the list file itself says "Verify every id against flathub.org before shipping".

## Add a popular app

The file is `data/apps/popular.list`. It is installed to `/usr/share/nubo/apps/popular.list` by `nubo-apps`. One app per line, five fields separated by `|`:

```text
kind | id-or-url | Nubo name | category | preinstall(yes/no)
```

| Field | Meaning |
|---|---|
| `kind` | `flatpak` (a Flathub app) or `web` (a site opened as an app). |
| `id-or-url` | The Flathub id, for example `org.gimp.GIMP`, or the site URL. |
| name | The label shown on the launcher. |
| category | A grouping word used in the list: `media`, `chat`, `work`, `dev`, `design`, `create`, `browser`, `social`, `games`. |
| `preinstall` | `yes` or `no`. See below. |

Lines starting with `#` and blank lines are ignored. Rows with fewer than five fields are skipped.

### Steps

1. Add the line in the right group, for example:

   ```text
   flatpak|org.gimp.GIMP|GIMP|create|no
   ```

2. Rebuild and install `nubo-apps`, then log out and in. `nubo-app-stubs` runs once at login and rewrites the launchers.

### What the two kinds do

- **`flatpak`**: until the app is installed, a grey launcher named `nubo-get-<id>.desktop` appears in `~/.local/share/applications`. Clicking it runs `nubo-get <id> "<name>"`, which adds Flathub for the user if needed, installs the app with `flatpak install --user`, then opens it. Once the app is installed, the grey launcher is removed.
- **`web`**: a launcher that opens the URL with `xdg-open`. It is written only when `preinstall` is `yes`.

For a `flatpak` row, `preinstall=yes` puts the grey launcher at the top level of the app grid, and `no` puts it into the "More apps" folder (the launcher gets the category `X-Nubo-Placeholder`, which the app grid folder `NuboMore` in `data/dconf/nubo-app-folders` collects). Note that `preinstall` here controls placement of the placeholder. The apps that the first-boot step actually installs are named in `data/firstboot/nubo-first-boot` (the `FLATPAKS` variable), a separate list.

Proprietary apps (Spotify, Slack, Zoom, Discord, Steam, Chrome, Dropbox) are never bundled. The person downloads them from Flathub when they click.

## Hide a launcher

`data/apps/hide.list` holds desktop ids, one per line, without `.desktop`. `brand/make-hidden-entries.sh` writes an override copy of each one with `NoDisplay=true`; the program stays installed and only its menu entry is hidden. Ids that are not installed at build time are skipped.

```text
org.gnome.Maps
org.gnome.Yelp
```

Add an id, rebuild `nubo-branding`.

## Rename a launcher

`data/apps/rebrand.list` has one line per app:

```text
desktop-id|Nubo name|Nubo comment|optional-icon-name
```

For example, `org.gnome.Nautilus|Files|Browse and manage your files`. `brand/make-app-entries.sh` copies the original entry, replaces `Name`, `Comment` and `GenericName` (and the translated `Name[xx]` lines are dropped), and sets `Icon` if you gave a fourth field. The result is installed under `/usr/share/nubo/applications/`, and `nubo-branding`'s `postinst` links each file into `/usr/local/share/applications/`, which the desktop searches first.

Ids that are not installed at build time are skipped with a message, so build on a machine that has the apps installed.

## Choose the background messaging apps

`notify/background-apps.json` is installed to `/usr/share/nubo/notify/background-apps.json`. The agent `nubo-notify-agent` starts each listed app that is installed and not already running, and restarts it with a growing delay if it crashes. An app that exits cleanly (the person chose Quit) stays closed until the next login.

```json
{"id": "org.telegram.desktop", "name": "Telegram", "flatpak": "org.telegram.desktop", "args": ["-startintray"]}
```

| Key | Meaning |
|---|---|
| `id` | Unique id used by `nubo-notify-agent enable ID` and `disable ID`. |
| `name` | Label. |
| `flatpak` | Flathub id, for apps run with `flatpak run`. |
| `command` | The program and arguments, for apps from the Ubuntu archive (as for `geary`). |
| `match` | Process name used to check whether a copy is already running. |
| `args` | Extra arguments for a flatpak app, such as a "start in tray" flag. |

People can turn an app off for their own account with `nubo-notify-agent disable <id>`; this is saved in `~/.config/nubo/notify.json`. Check an app's own flag for starting hidden before you add it.

## Add a wallpaper

Wallpapers are photographs with a free licence, kept in `brand/wallpapers/photos/`, and each one is recorded in `brand/wallpapers/SOURCES.md` with its source, author and licence.

1. Add a 16:9 JPEG (the existing files are 3840x2160, quality 90, sRGB, metadata stripped) to `brand/wallpapers/photos/`, named with a number and a short slug.
2. Add its source, author and licence to `SOURCES.md`. Only add images whose licence allows redistribution without a credit requirement; the current set contains public-domain and CC0 images and no images that need attribution.
3. Add an entry to `data/backgrounds/nubo.xml`, copying an existing `<wallpaper>` block and changing `name` and the file paths (`/usr/share/backgrounds/nubo/<file>`).
4. Rebuild `nubo-branding`. The install list takes every `brand/wallpapers/photos/*.jpg`.

The defaults are set in the gsettings override (next section). The login screen theme is built from `brand/wallpapers/photos/06-golden-dunes.jpg` in `debian/rules`, so do not rename that file without changing the rule.

## Change a default setting

`data/gschema/90_nubo.gschema.override` holds the system-wide defaults: theme, icons, cursor, fonts, wallpaper, enabled extensions, the dock, the glass effect, the widgets, the app grid size, the Files view and the keyboard layout shortcut. It is installed to `/usr/share/glib-2.0/schemas/` and compiled at install.

Ubuntu ships its own defaults scoped to the `ubuntu` session, and those win over unscoped ones. For that reason each section appears twice, as `[org.gnome.desktop.interface]` and `[org.gnome.desktop.interface:ubuntu]`. When you change a value, change both. For example, the default wallpapers:

```text
[org.gnome.desktop.background]
picture-uri='file:///usr/share/backgrounds/nubo/05-pastel-dunes.jpg'
picture-uri-dark='file:///usr/share/backgrounds/nubo/02-misty-bay-layers.jpg'
```

The widgets use keys such as `show-clock`, `show-weather`, `show-stats` and `show-calendar` in `org.gnome.shell.extensions.glass-widgets`. A person's own choices are stored per user and win over these defaults.

App grid folders are separate: `data/dconf/nubo-app-folders` defines `NuboUtilities`, `NuboAccessories` and `NuboMore`, and `dconf update` runs in `nubo-branding`'s `postinst`.

## Verify

After rebuilding and installing:

```bash
# popular apps
ls ~/.local/share/applications | grep nubo-get
# gsettings defaults (as a new user)
gsettings get org.gnome.desktop.interface gtk-theme
# renamed and hidden entries
ls /usr/share/nubo/applications | head
ls -l /usr/local/share/applications | head
# background agent
nubo-notify-agent list
```

Check the new app's grey icon in the app grid, the new wallpaper in Settings (the background picker), and that a renamed app shows its new name.

## Troubleshooting

- **The grey icon does not appear.** Log out and in so `nubo-app-stubs` runs, and check `popular.list` for a line with fewer than five fields.
- **The app installs but the grey icon stays.** The Flathub id in the list does not match the installed app's id.
- **A renamed launcher still shows the old name.** The app was not installed when `nubo-branding` was built (the script skipped it), or `/usr/local/share/applications` has no link for it.
- **A default change has no effect.** It was set for the unscoped section only. Change the `:ubuntu` section too, and remember that an existing user's own settings win.
- **The wallpaper is missing from Settings.** The entry is not in `data/backgrounds/nubo.xml`, or the file name does not match.
- **`nubo-notify-agent list` omits an app.** Check the JSON is valid and the app has either `flatpak` or `command`.

## See also

- [Repository layout](/developers/repo-layout/)
- [Brand and licence rules](/developers/brand-and-licence-rules/)
- [Desktop](/desktop/)
