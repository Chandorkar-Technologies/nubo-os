---
title: Files and paths
description: Where each Nubo package puts its files, which system files it replaces, and which files are yours to change.
sidebar:
  order: 30
---

This page lists the files and folders that matter. It is read from the packaging files in the repository. Small artwork files are grouped.

## Which files are yours to change

| Kind | Examples | Guidance |
|---|---|---|
| Files in your home folder | `~/.config/nubo/widgets.json`, `~/.config/nubo/notify.json` | Yours. See [Configuration keys](/reference/configuration-keys/) |
| Your own apt files | `/etc/apt/apt.conf.d/60-*.conf` | Yours. Use these for your own settings |
| `nubo.sources` | `/etc/apt/sources.list.d/nubo.sources` | Changed by `nubo-channel`. Do not edit by hand otherwise |
| Files under `/usr` | Almost everything else below | Owned by packages. Changes are lost at the next update |
| Files under `/etc` shipped by a package | `52-nubo-unattended.conf`, sshd and sysctl settings | Treated as configuration by `dpkg`. If you change one, `dpkg` asks before replacing it. Prefer adding your own file next to it |

## Shared (all editions)

### nubo-archive

| Path | What it is |
|---|---|
| `/etc/apt/sources.list.d/nubo.sources` | The Nubo package source (stable by default) |
| `/usr/share/keyrings/nubo-archive-keyring.gpg` | The archive signing key (public) |
| `/etc/apt/apt.conf.d/52-nubo-unattended.conf` | Automatic update settings |
| `/usr/sbin/nubo-channel` | The channel command |
| `/usr/share/nubo/ubuntu-sources/ubuntu.sources.amd64` and `.arm64` | The Cumulus versions of Ubuntu's source file; one is copied into place at install |
| `/etc/apt/sources.list.d/ubuntu.sources` | Written by the package at install, pointing at Cumulus (not a normal package file) |
| `/etc/apt/sources.list.d/ubuntu.sources.ubuntu` | Ubuntu's original file, kept by a diversion; returned if the package is removed |
| `/etc/nubo/no-cumulus` | Marker you create to stop the package from switching to Cumulus. See [Use Ubuntu's servers directly](/updates/use-ubuntus-servers-directly/) |

### nubo-base

| Path | What it is |
|---|---|
| `/etc/NetworkManager/conf.d/20-connectivity-ubuntu.conf` | Connectivity check pointed at `archive.nubosuite.tech/check` |
| `/etc/systemd/timesyncd.conf.d/nubo-timesyncd.conf` | Time servers for timesyncd |
| `/etc/chrony/sources.d/ubuntu-ntp-pools.sources` | Time servers for chrony (replaces Ubuntu's file; original kept as `.ubuntu`) |
| `/etc/debuginfod/elfutils.urls` | Empty list: no debug symbol server (original kept as `.ubuntu`) |
| `/etc/update-manager/release-upgrades` | `Prompt=never` (original kept as `.ubuntu`) |
| `/etc/systemd/system/<unit>` linked to `/dev/null` | Masked units: motd-news, whoopsie, apport, Ubuntu Pro timers and services, apt-news, esm-cache |
| `/usr/share/nubo/base/` | The shipped copies of the three files above |

## Desktop

### nubo-branding

| Path | What it is |
|---|---|
| `/usr/lib/os-release` | The system identity: `PRETTY_NAME="Nubo OS 1"` (Ubuntu's original is kept as `.ubuntu`) |
| `/usr/share/nubo/os/` | `issue`, `issue.net`, `lsb-release`, `legal` |
| `/usr/share/nubo/logo/` | Logo files (SVG) |
| `/usr/share/nubo/avatar.png` | The default profile picture |
| `/usr/share/backgrounds/nubo/` | The eight wallpapers (JPEG) |
| `/usr/share/gnome-background-properties/nubo.xml` | Registers the wallpapers in Settings |
| `/usr/share/glib-2.0/schemas/90_nubo.gschema.override` | The desktop defaults. See [Configuration keys](/reference/configuration-keys/) |
| `/etc/dconf/db/nubo.d/nubo-app-folders` and `/etc/dconf/profile/user` | App grid folders and the dconf profile that reads them |
| `/usr/share/plymouth/themes/nubo/`, `/usr/share/plymouth/themes/nubo-text/` | Boot screens |
| `/etc/default/grub.d/zz-nubo-distributor.cfg`, `/etc/grub.d/10_linux` | Boot menu name |
| `/usr/libexec/nubo/nubo-first-boot`, `/usr/lib/systemd/system/nubo-first-boot.service` | The one-time cleanup |
| `/var/lib/nubo/first-boot-done` | Written when the cleanup has finished |
| `/etc/apt/sources.list.d/mozilla.sources`, `/etc/apt/preferences.d/mozilla.pref`, `/etc/apt/keyrings/packages.mozilla.org.asc` | Firefox from Mozilla's package source, preferred over Ubuntu's snap wrapper |
| `/usr/share/nubo/applications/` | Renamed first-party app entries |
| `/usr/share/applications/` | Entries for Help, Maps, the Nubo Store (GNOME Software renamed) and the desktop panel |
| `/usr/share/wayland-sessions/ubuntu.desktop` | The session entry, named "Nubo OS" |
| `/usr/share/gnome-shell/extensions/nubo-menu@nubosuite.tech/` | The top bar menu extension |

### nubo-theme

| Path | What it is |
|---|---|
| `/usr/share/themes/Nubo-Grey-*` | The application and shell themes (dark and light) |
| `/usr/share/nubo/gtk-4.0/` | The libadwaita theme files, linked into `~/.config/gtk-4.0` by the session helper |
| `/usr/share/gnome-shell/theme/Nubo/nubo-gdm-theme.gresource` | The login screen theme |
| `/usr/libexec/nubo/nubo-session-helper` and `/usr/lib/systemd/user/nubo-session-helper.service` | The session helper |

### Other desktop packages

| Package | Path | What it is |
|---|---|---|
| `nubo-icons` | `/usr/share/icons/Nubo*` | The icon theme layer |
| `nubo-sounds` | `/usr/share/sounds/Nubo/` | Sound theme index and links into the Ocean sounds |
| `nubo-glass` | `/usr/share/gnome-shell/extensions/blur-my-shell@aunetx/` | Blur effect |
| `nubo-glass` | `/usr/share/gnome-shell/extensions/app-grid-tuner@m-lab/` | App grid layout |
| `nubo-glass` | `/usr/share/gnome-shell/extensions/glass-widgets@peter-njoro.github.io/` | Desktop widgets (Nubo build) |
| `nubo-glass` | `/usr/share/glib-2.0/schemas/` | Settings schemas of the three extensions |
| `nubo-installer` | `/usr/share/desktop-provision/` | Installer branding (media only) |
| `nubo-account` | `/usr/libexec/nubo/nubo-account-setup`, `/usr/lib/systemd/system/nubo-account-setup.service` | First-boot sign-in setup |
| `nubo-account` | `/etc/authd/brokers.d/nubo.conf` | Registers the "Nubo Account" sign-in method |
| `nubo-account` | `/usr/libexec/nubo/nubo-setup`, `/usr/share/applications/tech.nubosuite.Setup.desktop`, `/etc/xdg/autostart/nubo-setup-autostart.desktop` | The first-run sign-in window |
| `nubo-account` | `/var/lib/nubo/account-setup-done` | Written when setup finished |
| `nubo-account` | `/var/snap/authd-oidc/current/broker.conf` | Written by the setup program (not shipped by the package) |
| `nubo-search` | `/usr/bin/nubo-search`, `/usr/lib/nubo/search/` | The command and the launcher with its libraries |
| `nubo-search` | `/usr/share/nubo/search/nubo.json` | Nubo defaults for the launcher |
| `nubo-search` | `/usr/share/applications/nubo-search.desktop`, `/etc/xdg/autostart/nubo-search-server.desktop` | Menu entry and autostart |
| `nubo-notify` | `/usr/libexec/nubo/nubo-notify-agent`, `/usr/lib/systemd/user/nubo-notify-agent.service` | The background agent |
| `nubo-notify` | `/usr/share/nubo/notify/background-apps.json` | The list of apps the agent keeps running |
| `nubo-notify` | `/usr/share/gnome-shell/extensions/nubo-notify-center@nubosuite.tech/` | The notification history extension |
| `nubo-apps` | `/usr/bin/nubo-get`, `/usr/libexec/nubo/nubo-app-stubs` | The download command and launcher writer |
| `nubo-apps` | `/usr/lib/systemd/user/nubo-app-stubs.service` | Runs the launcher writer at login |
| `nubo-apps` | `/usr/share/nubo/apps/popular.list` | The catalogue of popular apps |

### Files created in your home folder

| Path | Created by | What it is |
|---|---|---|
| `~/.config/nubo/widgets.json` | The widgets extension | Positions of the desktop widgets |
| `~/.config/nubo/notify.json` | `nubo-notify-agent disable` | Apps you turned off |
| `~/.config/nubo/setup-done` | The sign-in window | Marks the first-run window as done |
| `~/.config/vicinae/settings.json` | `nubo-search` | Imports the Nubo launcher defaults |
| `~/.config/gtk-4.0/` | The session helper | Links to the system theme files |
| `~/.local/share/applications/nubo-get-*.desktop`, `nubo-web-*.desktop` | `nubo-app-stubs` | Placeholder and web launchers |
| `~/.local/state/nubo/seeded-extensions` | The session helper | Remembers which extensions it has already switched on |
| `~/.face` | The session helper or first boot | Your profile picture |

## Server

### nubo-server-core

| Path | What it is |
|---|---|
| `/usr/lib/os-release` | `PRETTY_NAME="Nubo OS Server 1"` (Ubuntu's original kept as `.ubuntu`) |
| `/etc/issue`, `/etc/issue.net`, `/etc/lsb-release` | Copied from `/usr/share/nubo/server-os/` at install (originals kept as `.ubuntu`) |
| `/usr/lib/sysctl.d/90-nubo-server.conf` | Kernel network, information and link hardening |
| `/etc/ssh/sshd_config.d/90-nubo-sshd.conf` | SSH settings |
| `/usr/libexec/nubo/nubo-server-firewall` | The firewall script |
| `/etc/update-motd.d/99-nubo-motd` | The login message |
| `/etc/default/grub.d/grub-nubo.cfg` | Sets the boot loader name to "Nubo OS" |

### nubo-podman

| Path | What it is |
|---|---|
| `/etc/containers/registries.conf.d/50-nubo.conf` | `unqualified-search-registries = ["docker.io"]` |
| `/usr/bin/nubo-podman-init` | The setup command |

### nubo-incus

| Path | What it is |
|---|---|
| `/usr/bin/nubo-incus-init` | The setup command |
| `/usr/share/nubo/incus-preseed.yaml` | The preseed: bridge `nubobr0`, storage pool `default` (driver `dir`) |

`nubo-server-base` and `nubo-edge` install no files of their own; they only pull in packages.

## Files that name a state

| Path | Meaning |
|---|---|
| `/var/lib/nubo/first-boot-done` | The desktop cleanup has finished |
| `/var/lib/nubo/account-setup-done` | The Nubo account sign-in is set up |
| `/etc/nubo/no-cumulus` | You chose Ubuntu's servers for Ubuntu packages |

## See also

- [Commands](/reference/commands/)
- [Packages](/reference/packages/)
- [Configuration keys](/reference/configuration-keys/)
