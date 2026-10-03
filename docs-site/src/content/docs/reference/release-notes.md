---
title: Release notes
description: What changed in Nubo OS 0.8.0 beta and in the earlier development releases, in plain words.
sidebar:
  order: 70
---

These notes are written from the package changelog and the history of the source repository. Dates are in 2026. For how versions and tags are named, see [Release versions and support](/updates/release-versions-and-support/). For things that are unfinished, see [Known issues](/reference/known-issues/).

## 0.8.0 (beta)

0.8.0 is the first line with a package archive, update channels and a server. At the time of writing it is a beta: builds are published to the beta channel and the final `0.8.0` has not been published as a package version. The release tag `v0.8.0` exists and promotes what beta carries to stable; check `apt-cache policy nubo-base` for the version you have.

### 0.8.0~beta3 (3 October)

- **Server editions.** Four editions now exist: Server (`nubo-server-base`), Virtualization (`nubo-incus`), Containers (`nubo-podman`) and Edge (`nubo-edge`). They share a new package, `nubo-server-core`, that holds what every server has. Files that used to be in `nubo-server-base` moved there. Machines that already had `nubo-server-base` from an earlier beta upgrade cleanly because the new package declares that it replaces the older one.
- **Virtualization** now also adds QEMU, so virtual machines can run as well as containers. The installer image does this as an extra step.
- **Installer images** are now built for all four editions and both architectures (amd64 and arm64) and uploaded to the archive.
- The server installer image installs only the Nubo packages it needs. Incus is not added to the plain Server edition; it comes with the Virtualization edition or with `apt install nubo-incus`.

The server editions are marked in the repository as not yet tested.

### 0.8.0~beta2 (3 October)

- `nubo-desktop` no longer asks for the exact same version of `nubo-search`. It asks for version 0.7.0 or newer. This lets arm64 machines install while the arm64 build of the launcher is released separately.

### 0.8.0~beta1 (3 October)

- **Package archive** at `archive.nubosuite.tech` with a stable and a beta channel, signed with the Nubo archive key. Nubo packages from the stable channel install automatically, together with Ubuntu's security and regular updates. The `nubo-channel` command switches channels. See [Updates](/updates/).
- **Nubo Cumulus.** Ubuntu's packages and images come through Nubo's cache, and apt uses Ubuntu's own servers if the cache is down. Ubuntu's signatures are untouched.
- **Server OS.** `nubo-server-base` and `nubo-incus` appear. A machine can be a server with the Nubo identity, SSH without root login, a firewall closed except SSH, kernel network hardening and automatic security updates.
- **`nubo-base`.** The network check goes to Nubo. Time comes from `time.cloudflare.com` (with NTS) and `pool.ntp.org`. News at login, crash reports and Ubuntu Pro adverts are switched off.
- **Desktop.** Draggable widgets (clock with weather, system, calendar). Nubo Search now builds for arm64. A taller top bar with the Nubo logo and the text "Nubo OS 1"; clicking the logo opens the Activities overview. A default profile picture (the Nubo mark on an orange gradient) for people who have not chosen one.

### Builds after beta3

Further beta tags (up to `v0.8.0-beta10`) were made for the build and release system: building and publishing the packages and installer images, the Cumulus mirror list (a priority of 1 for Cumulus and 2 for Ubuntu, because apt chooses among equal mirrors at random, and the list needs a tab, not a space, before `priority`), staging of packages, and cache headers. These tags did not change the package changelog, so the package version stays at `0.8.0~beta3` while the tag number rises.

## Earlier development releases

These came before the package archive. They are listed so you can see where the desktop comes from.

### 0.7.0 (30 September)

- **Apps.** Calendar, Contacts, Weather, Maps, Videos, Scanner, Archive Manager, Podcasts, Books, Voice Memos, Backup and Reminders. Folio, LocalSend and Newelle come from Flathub on first boot. Entries have Nubo-style names. (Folio was removed again later; Reminders and Text Editor cover it.)
- **Nubo Setup.** A first-run window to sign in or create an account, using a code that you approve on a phone or another computer.
- **First boot and account services** skip the installation media. The earlier test never matched.
- **Identity.** Fonts Inter and JetBrains Mono; the boot menu says Nubo OS; session entry, text boot screen, legal text, console messages, the About version string and the Settings panel icon follow.
- **Package changes.** `nubo-desktop` replaces `ubuntu-desktop-minimal` and conflicts with Ubuntu's Pro, reporting, crash and update tools and the Yaru theme.
- **Firefox** from Mozilla's package repository instead of the snap. Ubuntu's store and helper snaps are removed on first boot. Flathub is added.
- **Nubo Store.** GNOME Software, renamed, with Flatpak support.
- **Dock defaults** and **uniform corner radii** for the dock, menus, notifications and dialogs.
- Ubuntu's first-run wizard removed.

### 0.6.0 (30 September)

- Light mode works again for modern apps. GTK 3 and icon themes follow it through a session helper.
- New package `nubo-account`: Nubo account sign-in, set up on first boot.
- The installer names the product without the Ubuntu base version. The installer app was rebuilt with Nubo OS as the product name.

### 0.5.0 (30 September)

- Six photographic wallpapers added.
- Login screen: user picture, sign-in method list and corner buttons styled.
- Installer illustrations in one neutral grey for both window themes.
- Installation media: rebuilt boot files carry the media identifier.
- Other systems' boot menus list this one as Nubo OS.
- The Welcome app and remaining logo icon names show the Nubo mark.

### 0.4.0 (30 September)

- Wallpaper set in dark and light.
- Installer with Nubo illustrations, slides, colours and window title; the Ubuntu Pro page hidden (new package `nubo-installer`).
- First-run welcome with the Nubo mark; the Ubuntu Pro and telemetry pages skipped.
- Installation media boots with the Nubo boot screen.

### 0.3.1 (30 September)

- The system identifies as Nubo OS; compatibility fields stay Ubuntu.
- The boot loader name is pinned so Secure Boot keeps working.
- Login screen logo sized correctly.

### 0.2.0 (30 September)

- Icons: a thin layer over Papirus with grey folders and the Nubo mark.
- Sounds: new package `nubo-sounds` on top of the Ocean sound theme.
- Glass: new package `nubo-glass` with the blur extension.
- Dock floating at the bottom with the Nubo mark as the app grid button.
- Login screen with its own theme.

### 0.1.0 (29 September)

- First build: theme, icons, branding and the desktop metapackage.

:::note
The wallpaper sets of 0.4.0 and 0.5.0 were replaced later. The desktop now ships eight photographs. See [Licences and credits](/reference/licences-and-credits/).
:::

## See also

- [Known issues](/reference/known-issues/)
- [Packages](/reference/packages/)
- [Updates](/updates/)
