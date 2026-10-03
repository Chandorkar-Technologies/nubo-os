---
title: Packages
description: Every Nubo OS binary package with its description, architecture, dependencies, conflicts and the editions that install it.
sidebar:
  order: 20
---

All Nubo packages are built from one source package, `nubo-os`, and share one version number. Dependencies written as `(= version)` mean the same version as the package itself. The lists below name Nubo's own packages and the most important dependencies. For the full dependency list, run `apt-cache depends <package>` or read the package's control file.

## Summary

| Package | Architecture | What it is | Installed by |
|---|---|---|---|
| `nubo-desktop` | all | The desktop metapackage | Desktop |
| `nubo-theme` | all | App, shell and login screen theme | Desktop |
| `nubo-icons` | all | Icon theme | Desktop |
| `nubo-sounds` | all | System sounds | Desktop |
| `nubo-glass` | all | Blur and shell extensions | Desktop |
| `nubo-branding` | all | Identity, wallpapers, boot screen, defaults | Desktop |
| `nubo-installer` | all | Installer appearance | Installation media only |
| `nubo-account` | all | Nubo account sign-in | Desktop |
| `nubo-search` | amd64, arm64 | Nubo Search launcher | Desktop |
| `nubo-notify` | all | Notification centre and background agent | Desktop |
| `nubo-apps` | all | Placeholder launchers for popular apps | Desktop |
| `nubo-base` | all | Network check, time, no reports | Desktop and all server editions |
| `nubo-archive` | all | Package source, key, update settings | Desktop and all server editions |
| `nubo-server-core` | all | What every server has | All server editions |
| `nubo-server-base` | all | Server tools and automatic updates | Server, Virtualization, Containers |
| `nubo-edge` | all | The smallest server | Edge |
| `nubo-podman` | all | Podman container host | Containers |
| `nubo-incus` | all | Incus virtualization host | Virtualization |

"all" means one package file for every CPU.

## Desktop packages

### nubo-desktop

The complete Nubo OS desktop: GNOME with the Nubo look, Nubo apps and defaults. It replaces Ubuntu's desktop metapackages and its Ubuntu-specific tools.

- **Architecture:** all.
- **Depends on (Nubo):** `nubo-notify`, `nubo-apps`, `nubo-archive`, `nubo-base`, `nubo-account`, `nubo-branding`, `nubo-glass`, `nubo-icons`, `nubo-sounds`, `nubo-theme`, all at the same version, and `nubo-search (>= 0.7.0)`.
- **Depends on (other):** the GNOME desktop (`gdm3`, `gnome-shell`, `gnome-control-center`, `gnome-software` with its Flatpak plug-in, `nautilus`), `flatpak`, `geary`, GSConnect and `scrcpy`, fonts (Inter, JetBrains Mono, Noto and others), sound (`pipewire-pulse`, `wireplumber`), `ubuntu-session` and `ubuntu-settings`, and a long list of supporting packages.
- **Recommends:** the default app set (for example `gnome-calendar`, `gnome-contacts`, `gnome-maps`, `loupe`, `showtime`, `simple-scan`, `ptyxis`, `firefox`), printing, Bluetooth and network tools.
- **Conflicts with:** `apport` and related, `gnome-initial-setup`, `landscape-common`, `popularity-contest`, `snap-store`, `ubuntu-advantage-desktop-daemon`, `ubuntu-desktop`, `ubuntu-desktop-minimal`, `ubuntu-insights`, `ubuntu-pro-client`, `ubuntu-release-upgrader-gtk`, `ubuntu-report`, `update-manager`, `update-manager-core`, `update-notifier`, `update-notifier-common`, `whoopsie`, `gnome-package-updater`, and the Yaru themes.

### nubo-theme

Monochrome theme for applications, GNOME Shell, libadwaita apps and the login screen. Built from the Colloid GTK theme (grey variant). Depends on `gnome-themes-extra` and `gtk2-engines-murrine`. Also ships the session helper that keeps themes in step with light and dark mode.

### nubo-icons

A thin layer over the Papirus icon theme: grey folders and the Nubo mark in place of distributor logos. Depends on `hicolor-icon-theme` and `papirus-icon-theme`. All other icons come from Papirus and update with it.

### nubo-sounds

Sound theme for Nubo OS. Currently maps onto the Ocean sound theme. Depends on `ocean-sound-theme` and `sound-theme-freedesktop`.

### nubo-glass

Frosted-glass blur for the top bar, dock, overview and lock screen. Ships the Blur my Shell extension system-wide, and also the app grid and widget extensions (see [Files and paths](/reference/files-and-paths/)). Depends on `gnome-shell (>= 46)`.

### nubo-branding

Logo files, default wallpapers, the boot screen, the system identity (`os-release`), first-run defaults and the one-time cleanup after installation.

- **Depends on:** `dconf-cli`, `plymouth`, `plymouth-theme-ubuntu-text`.
- **Provides:** `ubuntu-wallpapers`.
- **Conflicts with and replaces:** `ubuntu-wallpapers`, `ubuntu-wallpapers-resolute`.
- A machine is a desktop or a server, never both: `nubo-server-core` conflicts with this package.

### nubo-installer

Configuration, illustrations and slides that give the desktop installer the Nubo look. It is used only on installation media and is not a dependency of `nubo-desktop`.

### nubo-account

Connects the login screen to the Nubo account. It sets itself up on the first boot that has a network connection and tries again at each boot until it succeeds. Depends on `authd`, `curl`, `gir1.2-adw-1`, `gir1.2-gtk-4.0`, `libsecret-tools`, `librsvg2-bin`, `python3-gi` and **`snapd`**. The sign-in service, `authd-oidc`, is distributed as a snap, which is why `snapd` stays on the desktop. See [Known issues](/reference/known-issues/).

### nubo-search

A launcher for apps, files, calculations and clipboard history, built from Vicinae. Starts with the session and opens with <kbd>Super</kbd>+<kbd>Space</kbd>. It carries its own libraries, so its dependencies are only basic system libraries (OpenGL, Wayland, X11, DBus, font and drawing libraries).

- **Architecture:** amd64 and arm64. This is the only package built per CPU.
- The arm64 build is released separately from the rest, so `nubo-desktop` asks for `nubo-search (>= 0.7.0)` rather than an exact version.

### nubo-notify

A notification history for every app, grouped by app with an unread count and Do Not Disturb, and an agent that keeps messaging apps running in the background. Depends on `gnome-shell (>= 46)`, `procps`, `python3`. Recommends `flatpak`.

### nubo-apps

Grey "tap to download" launchers for popular apps on Flathub, which download and open the app when clicked, and web launchers for popular sites. Depends on `imagemagick`, `python3`, `zenity`. Recommends `flatpak`.

## Packages for every edition

### nubo-base

Network check, time servers and update settings that point to Nubo or to neutral services, and no crash reports, news or adverts sent to Canonical. Depends on `nubo-archive` (same version). Installed on the desktop and on every server edition.

### nubo-archive

The apt source and signing key for the Nubo archive, the automatic update settings, the `nubo-channel` command, and the file that points Ubuntu's packages at Nubo Cumulus. It declares no other dependencies. The package description in the control file refers to packages published at `os.nubosuite.tech`; the archive address is `archive.nubosuite.tech`.

## Server packages

### nubo-server-core

What every Nubo OS server has: the Nubo identity, SSH without root login, a firewall closed except SSH, time sync and kernel network hardening.

- **Depends on:** `nubo-archive`, `nubo-base` (same version), `openssh-server`, `ufw`, `chrony`, `apparmor`.
- **Conflicts with:** `nubo-branding`, `snapd`, `landscape-common`, `lxd-installer`, `ubuntu-pro-client`, `ubuntu-advantage-tools`.
- **Replaces and breaks:** `nubo-server-base (<< 0.8.0~beta3)`, because some files moved from that package into this one in 0.8.0~beta3.

### nubo-server-base

The core plus automatic security updates, brute-force protection and the everyday tools for running a server. It is the "Server" edition.

- **Depends on:** `nubo-server-core` (same version), `unattended-upgrades`, `fail2ban`, `needrestart`, `curl`, `ca-certificates`, `htop`, `less`, `vim-tiny`.

### nubo-edge

The smallest Nubo OS server, for Raspberry Pi, old hardware and appliances: the core and automatic security updates.

- **Depends on:** `nubo-server-core` (same version), `unattended-upgrades`.

### nubo-podman

Rootless containers with Podman, ready for compose files, with `nubo-podman-init` to start the Podman service for your user.

- **Depends on:** `nubo-server-base` (same version), `podman`, `buildah`, `skopeo`, `uidmap`, `passt`.
- **Recommends:** `podman-compose`.

### nubo-incus

Containers and virtual machines with Incus, set up by `nubo-incus-init` with a bridge and a storage pool.

- **Depends on:** `nubo-server-base` (same version), `incus`, `zfsutils-linux`, `bridge-utils`.
- **Recommends:** `qemu-system-x86` or `qemu-system-arm`. The server installer for this edition installs QEMU for the machine's CPU as an extra step. On an installed machine, a plain `apt install nubo-incus` pulls QEMU in only if recommended packages are enabled (the default for apt).

## Which packages each edition installs

| Package | Desktop | Server | Virtualization | Containers | Edge |
|---|---|---|---|---|---|
| `nubo-archive` | Yes | Yes | Yes | Yes | Yes |
| `nubo-base` | Yes | Yes | Yes | Yes | Yes |
| `nubo-server-core` | No | Yes | Yes | Yes | Yes |
| `nubo-server-base` | No | Yes | Yes | Yes | No |
| `nubo-edge` | No | No | No | No | Yes |
| `nubo-incus` | No | No | Yes | No | No |
| `nubo-podman` | No | No | No | Yes | No |
| `nubo-desktop` and the desktop packages | Yes | No | No | No | No |

The desktop packages are `nubo-theme`, `nubo-icons`, `nubo-sounds`, `nubo-glass`, `nubo-branding`, `nubo-account`, `nubo-search`, `nubo-notify` and `nubo-apps`. `nubo-installer` is on the installation media only.

## See also

- [Editions comparison](/reference/editions-comparison/)
- [Files and paths](/reference/files-and-paths/)
- [Commands](/reference/commands/)
