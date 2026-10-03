---
title: What is different from Ubuntu
description: What Nubo OS changes on top of Ubuntu 26.04 LTS, and what it deliberately leaves alone.
sidebar:
  order: 10
---

Nubo OS is based on Ubuntu 26.04 LTS ("resolute"). It is not a rewrite and it is not a fork of the kernel or of the package system. It is Ubuntu plus a set of Nubo packages that change the look, the defaults and some network behaviour. This page lists those changes so you know what you are getting.

For everything that behaves as on Ubuntu, use Ubuntu's own documentation: [Ubuntu Desktop documentation](https://ubuntu.com/desktop/docs) and [Ubuntu Server documentation](https://ubuntu.com/server/docs).

## What stays the same

- **The base system.** Kernel, boot loader, libraries and the vast majority of packages come from Ubuntu's archive, unchanged and still signed by Ubuntu.
- **Package tools.** `apt` and `dpkg` work as on Ubuntu. Nubo packages are normal `.deb` files.
- **Security updates.** They come from Ubuntu's archive through Nubo Cumulus (a cache), with Ubuntu's own servers as a fallback. See [Updates](/updates/).
- **Secure Boot.** The boot loader and kernel on the desktop image are Ubuntu's signed ones, so Secure Boot keeps working.
- **System identity for third-party software.** `/usr/lib/os-release` still says `ID=ubuntu`, `VERSION_ID=26.04` and `VERSION_CODENAME=resolute`, so vendor repositories that check for Ubuntu keep working. Only the visible name changes to "Nubo OS 1".

## What Nubo changes on the desktop

| Area | Ubuntu 26.04 | Nubo OS |
|---|---|---|
| Look | Ubuntu's theme | Nubo glass theme: frosted blur on the top bar, dock, menus, overview and lock screen. Dark by default, light supported. |
| Top bar | Standard GNOME top bar | The Nubo logo with the text "Nubo OS 1" at the left. Clicking it opens the Activities overview. |
| Dock | Ubuntu Dock at the side | A floating dock centred at the bottom. |
| Fonts and cursor | Ubuntu fonts | Inter and JetBrains Mono, Bibata cursor. |
| Wallpapers | Ubuntu's | Eight photographs shipped by `nubo-branding`. |
| Notifications | GNOME notification list | A notification history panel plus a background agent that keeps messaging apps running so their notifications arrive. |
| Widgets | None | Draggable desktop cards for clock with weather, system usage and calendar. |
| Launcher | GNOME overview search | Nubo Search, opened with <kbd>Super</kbd>+<kbd>Space</kbd>. Switching keyboard layouts moves to <kbd>Alt</kbd>+<kbd>Shift</kbd>. |
| Apps | Snap-based Firefox, Ubuntu's app store | Firefox and other apps from Flathub; Geary for mail; Collabora Office instead of LibreOffice. |
| Popular apps | Not offered | Grey placeholder icons for popular apps; one click downloads the app from Flathub. |
| Installer | Ubuntu's installer | The same installer, branded Nubo OS, which installs the Nubo packages as its last step. |

Details of each are in [Desktop](/desktop/).

## What Nubo removes or switches off

- Ubuntu Pro adverts and its client, Apport crash reporting prompts, the `whoopsie` reporter, the message-of-the-day news and the release-upgrade prompt.
- LibreOffice (replaced by Collabora Office), and on first boot the snaps for Ubuntu's store, Firefox and Thunderbird.
- On servers, `snapd`, `landscape-common`, `lxd-installer` and the Ubuntu Pro client are not installed. `nubo-server-core` conflicts with them.

The package `nubo-base` also changes where the machine looks for a few services: the network connectivity check goes to Nubo, and time comes from `time.cloudflare.com` (using NTS) and `pool.ntp.org`. A few contacts with Canonical remain, mainly the snap store on the desktop because the Nubo sign-in broker is a snap. The repository keeps an honest list in `docs/ubuntu-endpoints.md`.

## What Nubo adds

- A signed package archive at `archive.nubosuite.tech` with a stable channel (`resolute`) and a beta channel (`resolute-beta`). You switch with `sudo nubo-channel beta` or `sudo nubo-channel stable`.
- Nubo Cumulus, a cache of Ubuntu's archive and images. You can opt out by creating `/etc/nubo/no-cumulus` and reinstalling `nubo-archive`.
- Server editions: Server, Virtualization (Incus), Containers (Podman) and Edge.
- Early-access sign-in with a Nubo account at the login screen.

## What Nubo does not have yet

:::caution[Planned]
Nubo Drive, Nubo Backup, a migration app, Nubo Pro, published benchmarks, a Nubo Store with its own cloud login, and translations are not built yet. Do not rely on them.
:::

## Trademarks

"Ubuntu" is a trademark of Canonical Ltd. Nubo OS is not made by or endorsed by Canonical. These docs use the name only to say which base system Nubo OS is built on.

## See also

- [Frequently asked questions](/start/faq/)
- [Support and lifecycle](/start/support-and-lifecycle/)
- [Updates](/updates/)
