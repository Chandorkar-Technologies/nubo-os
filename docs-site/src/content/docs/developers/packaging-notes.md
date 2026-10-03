---
title: Packaging notes
description: Why the Nubo OS packages use diversions, copy some files instead of shipping them, conflict with each other and use tilde versions.
sidebar:
  order: 40
---

Nubo OS changes an Ubuntu system by installing packages. That works only if the packages follow rules that keep Ubuntu's own updates flowing and keep `apt` from stopping to ask questions. This page explains the rules the code in `debian/` follows and the reason for each. Read it before you add a file that Ubuntu already provides.

## The central problem: files Ubuntu owns

Some of the files Nubo wants to change belong to Ubuntu packages: `/usr/lib/os-release`, `/etc/issue`, the boot menu script `/etc/grub.d/10_linux`, the Settings panel entry, the Ubuntu logos in `/usr/share/pixmaps`. A package may not simply overwrite a file another package owns; dpkg refuses. There are three tools in use.

### 1. Diversions

A diversion tells dpkg: "when any package installs this path, put it somewhere else, and let my package's file take the original place." The Nubo packages divert in `preinst` and undo it in `postrm`:

```sh
dpkg-divert --package nubo-branding --add --rename \
    --divert "$file.ubuntu" "$file"
```

`--rename` moves Ubuntu's existing file to `<path>.ubuntu` at once, and later Ubuntu updates of that file land on the `.ubuntu` path. When Nubo's package is removed, the diversion is removed with `--rename` and the original returns. Diversions are tied to a package name with `--package`, so another package cannot remove them by accident.

| Package | Diverts |
|---|---|
| `nubo-branding` | `/usr/lib/os-release`, `/etc/issue`, `/etc/lsb-release`, `/etc/issue.net`, `/etc/legal`, `gnome-ubuntu-panel.desktop`, `org.gnome.Software.desktop`, five logo files in `/usr/share/pixmaps`, `/etc/grub.d/10_linux` (parked at `/usr/share/nubo/os/grub-10_linux.ubuntu` because GRUB runs every executable in `/etc/grub.d`), `/usr/share/wayland-sessions/ubuntu.desktop` |
| `nubo-server-core` | `/usr/lib/os-release`, `/etc/issue`, `/etc/issue.net`, `/etc/lsb-release` |
| `nubo-base` | `/etc/chrony/sources.d/ubuntu-ntp-pools.sources`, `/etc/debuginfod/elfutils.urls`, `/etc/update-manager/release-upgrades` |
| `nubo-archive` | `/etc/apt/sources.list.d/ubuntu.sources` (done in `postinst`, see below) |

The session file `ubuntu.desktop` keeps its file name on purpose: it is the session id that the login manager remembers. Only its displayed name changes.

### 2. Copy in `postinst` instead of shipping under `/etc`

Debhelper marks every file a package ships under `/etc` as a conffile. If two packages ship the same conffile path, or if a file changed locally, every install stops and asks which version to keep. For `/etc/issue`, `/etc/issue.net` and `/etc/lsb-release` the packages avoid that: they ship the files under `/usr/share/nubo/os/` (or `/usr/share/nubo/server-os/`) and copy them into place with `install -m 0644` in `postinst`. The comment in `nubo-branding.postinst` gives the reason.

On removal, `postrm` deletes the copies, then removes the diversion so Ubuntu's file comes back.

`nubo-base` does the same for three settings files: it copies from `/usr/share/nubo/base/` in `postinst`, and diverts the originals in `preinst`.

### 3. Masking units

Services that send data to Canonical are masked with a symlink to `/dev/null` in `/etc/systemd/system/`, written by `nubo-base.postinst`: `motd-news`, `whoopsie`, `apport`, the Ubuntu Pro timers, `apt-news`, `esm-cache` and the two `ubuntu-advantage` services. Masking works inside a chroot and offline, which matters during image builds. `postrm` removes only symlinks that still point at `/dev/null`.

## `nubo-archive` and the Ubuntu source file

`nubo-archive.postinst` runs only on `configure`, and only when `/etc/nubo/no-cumulus` does not exist. It picks the Ubuntu source file for the CPU (`ubuntu.sources.amd64` or `.arm64` from `/usr/share/nubo/ubuntu-sources/`), diverts `/etc/apt/sources.list.d/ubuntu.sources` to `ubuntu.sources.ubuntu` (checking first that a Nubo diversion does not already exist), and installs the Cumulus version in its place. This is why the opt-out is "create the marker file, then reinstall `nubo-archive`": the script runs again and does nothing.

## Maintainer script conventions

- Every script starts with `#!/bin/sh` and `set -e`, and ends with `#DEBHELPER#` so debhelper can add its own parts.
- Actions are guarded by the first argument: `preinst` acts on `install` and `upgrade`; `postinst` on `configure`; `postrm` and `prerm` on `remove` (and `purge` for `postrm`).
- Commands that may not exist in a chroot are guarded or end with `|| true`: `update-initramfs`, `update-grub`, `dconf update`, `systemctl daemon-reload`.
- `nubo-server-core.postinst` runs the firewall script only on a first install (`$2` empty), so an upgrade never resets rules you changed.
- Nothing in a maintainer script reaches the network.
- Alternatives: `nubo-branding` registers the boot screen (`default.plymouth`, priority 200) and the text boot screen, and `nubo-theme` registers the login theme `gdm-theme.gresource` at priority 50 (Ubuntu's own registers at 15). Removal runs `update-alternatives --remove`.

## Conflicts, replaces and breaks

| Declaration | Reason |
|---|---|
| `nubo-server-core` **Conflicts** `nubo-branding`, `snapd`, `landscape-common`, `lxd-installer`, `ubuntu-pro-client`, `ubuntu-advantage-tools` | A machine is a desktop or a server. Both packages divert `os-release`, so they must never be installed together. The rest are Canonical services the server does not carry. |
| `nubo-desktop` **Conflicts** `ubuntu-desktop`, `ubuntu-desktop-minimal`, `update-manager`, `update-notifier`, `whoopsie`, `apport` and others | Nubo's desktop replaces Ubuntu's meta-packages and the tools that report to Canonical. |
| `nubo-branding` **Provides**, **Conflicts** and **Replaces** `ubuntu-wallpapers`, `ubuntu-wallpapers-resolute` | Other packages depend on the wallpaper package; Nubo satisfies that with its own wallpapers. |
| `nubo-server-core` **Replaces** and **Breaks** `nubo-server-base (<< 0.8.0~beta3)` | In `0.8.0~beta3` files moved from `nubo-server-base` into `nubo-server-core`. `Replaces` lets the new package take those files over, and `Breaks` tells apt that an older `nubo-server-base` cannot stay installed next to it, so the old one is upgraded in the same step. |

## Dependencies between Nubo packages

Packages that belong together depend on each other with an exact version, `(= ${source:Version})`, so a machine never mixes builds. The one exception is `nubo-search`, described next.

## Substitution variables

dpkg's `-V` option lets `debian/rules` pass a variable into `debian/control`:

```make
override_dh_gencontrol:
	dh_gencontrol -- "-Vnubo:search=nubo-search (>= 0.7.0),"
```

`nubo-desktop` lists `${nubo:search}` among its dependencies. The reason is in the comment in `rules`: the arm64 build of `nubo-search` is released on its own, so the desktop asks for "this one or newer". The other variables, `${misc:Depends}` and `${source:Version}`, are standard debhelper and dpkg variables.

## Versioning

The version lives in `debian/changelog`, the suite is `resolute`, and the source format is native.

- **Every release has a new version.** The archive pool is shared by both channels. `reprepro` refuses a package file whose name matches an existing one but whose contents differ.
- **Betas use a tilde.** `0.8.0~beta4` sorts below `0.8.0` in dpkg's ordering, so a machine on the beta channel upgrades to the final release when it arrives.
- **Promotion does not change versions.** `repo/publish.sh --promote` copies what beta carries into stable without rebuilding. What stable carries after a promotion is whatever version beta carried, for example `0.8.0~beta4`.

Add an entry at the top of `debian/changelog`, in this format:

```text
nubo-os (0.8.0~beta5) resolute; urgency=medium

  * What changed, in one line.

 -- Your Name <you@example.org>  Sat, 03 Oct 2026 12:00:00 +0530
```

The signature line needs two spaces before the date and a valid RFC 2822 date.

## Other `debian/rules` choices

- The launcher carries its own libraries, so `dh_strip`, `dh_dwz`, `dh_shlibdeps` and `dh_makeshlibs` are switched off; they would only break it.
- `dh_compress` and `dh_strip_nondeterminism` are switched off.
- `dh_link` skips `nubo-icons`, because its folders are absolute symlinks into Papirus by design.
- Systemd units are installed per package with named units (`nubo-account-setup`, `nubo-first-boot`, and user units for `nubo-session-helper`, `nubo-notify-agent` and `nubo-app-stubs`).
- The desktop and the server differ in one boot detail. `data/os/zz-nubo-distributor.cfg` pins `GRUB_DISTRIBUTOR="Ubuntu"` so the signed boot loader keeps finding its files under `EFI/ubuntu`; `server/grub-nubo.cfg` sets `GRUB_DISTRIBUTOR="Nubo OS"`. <!-- verify: boot on UEFI with Secure Boot for a server install -->

## See also

- [Building the packages](/developers/building-packages/)
- [Brand and licence rules](/developers/brand-and-licence-rules/)
- [Archive internals](/developers/archive-internals/)
