---
title: Install and remove apps
description: Install and remove apps with the Nubo Store, the Flatpak command, apt and .deb files, and learn what to avoid.
sidebar:
  order: 30
---

**Applies to:** Desktop

You can add software in four ways. Choose the first one that works for the app you want.

| Method | Use it for | Where the app comes from |
|---|---|---|
| Nubo Store | Most user apps. Easiest. | Flathub |
| `flatpak` command | The same apps, from a terminal or a script. | Flathub |
| `apt` | System tools, command-line programs and packages the archive carries. | Ubuntu's archive and the Nubo archive |
| A `.deb` file | An app that a vendor offers as a download. | The vendor |

## What not to do

- **Do not install apps as snaps.** Nubo OS does not use snaps for apps. The Snap Store, and the Firefox and Thunderbird snaps, are removed on first boot. The `snapd` service stays only because the sign-in connector for the [Nubo account](/desktop/account/sign-in-at-the-login-screen/) is distributed as a snap. Installing apps as snaps would mix a second system into a desktop designed around Flatpak and apt.
- **Do not mix the same app from two sources** unless you want two copies. Remove one first.
- **Do not run `sudo pip install` or `sudo make install`** into system folders. They can break packages that the system manages.
- **Do not add unknown apt sources.** Anything added to apt runs with full rights on your computer.

## Before you begin

- An internet connection.
- For apt and .deb installs: an account that can use `sudo`.

## Install from the Nubo Store

1. Open [Nubo Store](/desktop/apps/nubo-store/).
2. Search for the app, open it, and install it.

## Install from the terminal with Flatpak

```bash
flatpak install flathub org.videolan.VLC
```

Replace the id with the app's Flathub id. Without `--user` the app is installed for all users on the computer and asks for administrator rights. Add `--user` to install for you only. See [Flatpak basics](/desktop/apps/flatpak-basics/).

## Install with apt

```bash
sudo apt update
sudo apt install gnome-sound-recorder
```

Packages come from Ubuntu's archive, which Nubo OS reaches through Nubo Cumulus, a cache with Ubuntu's own as a fallback, and from the Nubo archive. Ubuntu's signatures are not changed.

## Install a .deb file

1. Download the file from the vendor's page.
2. Install it with apt, so dependencies are resolved:

```bash
sudo apt install ./name-of-the-file.deb
```

You can also double-click the file and open it with the Nubo Store. <!-- verify behavior -->

Only install a .deb from a source you trust. Its install scripts run as root.

## Remove an app

```bash
flatpak uninstall org.videolan.VLC       # a Flatpak app
sudo apt remove gnome-sound-recorder     # an apt package
```

Or open the Nubo Store, go to installed apps and uninstall.

To also remove an app's data for Flatpak, add `--delete-data`. User data lives in `~/.var/app/<id>`.

## Verify

```bash
flatpak list --app           # Flatpak apps
apt list --installed | grep name
```

The app appears in the app grid after installing, and is gone after removing.

## Troubleshooting

**"Unable to locate package".** Run `sudo apt update` first. If the package still isn't found, it is probably available only from Flathub.

**"No remote refs found" from Flatpak.** The name is wrong, or Flathub is not added. See the [Nubo Store troubleshooting](/desktop/apps/nubo-store/).

**A .deb needs a package that is not found.** The vendor built it for a different Ubuntu release. Look for a Flatpak instead.

**An app remains in the grid after removal.** A grey placeholder from the [popular list](/desktop/apps/popular-apps-click-to-download/) takes its place, if the app is on that list. That is expected.

**The app does not start.** Run it from a terminal (`flatpak run <id>`) and read the message.

## See also

- [Update apps](/desktop/apps/update-apps/)
- Ubuntu's documentation for apt on the desktop: https://ubuntu.com/desktop/docs
