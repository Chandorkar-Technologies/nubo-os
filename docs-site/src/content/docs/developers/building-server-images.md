---
title: Building the server images
description: Build the Nubo OS Server installer ISOs for all four flavours with iso/build-server-iso.sh, and how the identity layer and answer file work.
sidebar:
  order: 60
---

**Applies to:** Server, Virtualization, Containers, Edge

`iso/build-server-iso.sh` builds a Nubo OS Server installer from Ubuntu's live-server ISO. Unlike the desktop build, it needs no unpacking of system images and no root: it renames the boot menu entries, points the installer at an answer file, adds a thin identity layer, and carries the Nubo packages on the media. Drone builds all eight images (four flavours, two CPUs) on every beta tag; see [CI with Drone](/developers/ci-with-drone/).

:::note
The four flavours were added in `0.8.0~beta3`. The commit that introduced them describes them as not yet tested, and the images have not been tested on hardware yet.
:::

## Before you begin

- `xorriso` (the script exits with "Missing tool: xorriso" without it).
- `mksquashfs` from `squashfs-tools`. It is optional for the script but needed for the identity layer; without it the boot text still says Ubuntu, and the script prints a warning.
- Ubuntu 26.04's live-server ISO for the CPU you target (amd64 or arm64).
- A directory with the built packages. For the flavour you build it must contain the `.deb` files named in the table below.
- No root is needed. The script runs as a normal user and works for both architectures, because it only rearranges files and runs nothing from the target system. One amd64 machine builds both.

## The flavours

| `FLAVOUR` | Packages put on the media | Menu title | Volume name |
|---|---|---|---|
| `server` (default) | `nubo-archive`, `nubo-base`, `nubo-server-core`, `nubo-server-base` | Nubo OS Server | `Nubo OS Server 1 <arch>` |
| `virt` | the `server` set plus `nubo-incus` | Nubo OS Server (Virtualization) | `Nubo OS Virtualization 1 <arch>` |
| `containers` | the `server` set plus `nubo-podman` | Nubo OS Server (Containers) | `Nubo OS Containers 1 <arch>` |
| `edge` | `nubo-archive`, `nubo-base`, `nubo-server-core`, `nubo-edge` | Nubo OS Edge | `Nubo OS Edge 1 <arch>` |

Any other value stops the script with "FLAVOUR must be server, virt, containers or edge". The same four lists appear in `images/build-cloud.sh` and `images/build-pi.sh`; change all three if a flavour's package set changes.

## Steps

1. Build or download the packages into one directory, here `debs/`.

2. Run the script:

   ```bash
   ARCH=amd64 FLAVOUR=virt iso/build-server-iso.sh \
     ubuntu-26.04-live-server-amd64.iso debs nubo-os-virt-amd64.iso
   ```

   | Setting | Default | Meaning |
   |---|---|---|
   | `ARCH` | `dpkg --print-architecture` | Used in the volume name and `.disk/info`. |
   | `FLAVOUR` | `server` | See the table above. |
   | `WORK` | a new temporary directory | Scratch space. |

3. The script then, in order:

   1. Copies one `.deb` of each required package into `nubo/pool/` on the new media. If any is missing it stops with `<package> .deb not found in <dir>`. Only the Nubo packages are carried. Their dependencies are fetched from the network (through Cumulus) at install time, so the server install needs a network connection.
   2. Brands the boot menu (see below).
   3. Renames the entries in `casper/install-sources.yaml` ("Ubuntu Server" to "Nubo OS Server").
   4. Builds the identity layer.
   5. Writes `.disk/info` as `<title> 1 "Flow" - Release <arch> (<date>)`, copies `server-user-data` to `server/user-data` and `server-meta-data` to `server/meta-data`.
   6. For `virt`, appends one more late command (see below).
   7. Updates `md5sum.txt` and writes the image with `xorriso`, replaying the original boot setup with `-boot_image any replay`.

## The identity layer

The installer's own system, what you see while it boots and in its console, is Ubuntu's. The script builds a small extra squashfs, `casper/zz-nubo-identity.squashfs`, that holds four files: `/usr/lib/os-release`, `/etc/issue`, `/etc/issue.net` and `/etc/lsb-release`, taken from `server/`. Casper stacks every `.squashfs` in `/casper` and the name that sorts last ends up on top, which is why the layer name starts with `zz-`. Files in the layer are owned by root (`-all-root`).

## Branding the boot menu, and the GRUB escaping gotcha

The script extracts `boot/grub/grub.cfg` and `loopback.cfg` from the source image and rewrites them line by line:

- "Try or Install Ubuntu Server" becomes "Install <title>", and any other "Ubuntu Server" becomes the title.
- On a line containing ` ---` (the end of the kernel arguments), it inserts the arguments `autoinstall ds=nocloud\;s=/cdrom/server/ loglevel=3 systemd.show_status=false` in front of the dashes.

The gotcha is the semicolon. In GRUB, a bare `;` ends a command. The cloud-init data source argument `ds=nocloud;s=/cdrom/server/` therefore has to be written with a backslash in `grub.cfg`: `ds=nocloud\;s=/cdrom/server/`. The script's variable uses single quotes so the backslash survives, and cloud-init receives the semicolon. If you change that line and the installer ignores your answer file, look at the escaping first.

## The answer file

`iso/server-user-data` is a `#cloud-config` file with an `autoinstall` section. The installer reads it from `/cdrom/server/`. Every screen stays interactive except those listed as skipped:

| Key | Effect |
|---|---|
| `interactive-sections` | `locale`, `keyboard`, `network`, `storage`, `identity`, `ssh` stay interactive. The Ubuntu Pro, featured snaps, mirror and installer-update screens are skipped. |
| `refresh-installer.update: false` | No installer self-update. |
| `snaps: []` | No snaps. |
| `source.id: ubuntu-server-minimal` and `search_drivers: false` | The minimal server is installed, with no driver search. |
| `apt.fallback: offline-install`, `apt.geoip: false` | Offline fallback; no location lookup. |
| `apt.mirror-selection` and `apt.security` | amd64 and i386 through `.../cumulus`; arm64 through `.../cumulus-arm`. |
| `late-commands` | Copy the packages from `/cdrom/nubo/pool/` into the target, install them with `apt-get install -y --no-install-recommends -o Dpkg::Options::=--force-confnew`, delete the copies. |

`iso/server-meta-data` holds `instance-id: nubo-os-server`.

The `virt` flavour adds a second late command that installs `qemu-utils` and, by CPU, `qemu-system-x86` and `ovmf` (amd64) or `qemu-system-arm` and `qemu-efi-aarch64` (otherwise), with `--no-install-recommends`.

## Other images

- `images/build-cloud.sh DEBS_DIR OUT_DIR [amd64|arm64]` customises Ubuntu's cloud image into `nubo-os-<flavour>-<arch>.qcow2`, then converts it to `.vhd` and `.vmdk`. It needs root, `qemu-utils` and `libguestfs-tools`.
- `images/build-pi.sh DEBS_DIR OUT_DIR` adds the server packages to Ubuntu's preinstalled arm64 Raspberry Pi image.

`images/README.md` lists both as untested and still says the server ISO is "not written yet"; that line predates `build-server-iso.sh`.

## Verify

1. The script ends with `Done: <path>`.
2. Check the files on the media:

   ```bash
   xorriso -indev nubo-os-virt-amd64.iso -ls /nubo/pool /server /casper 2>/dev/null
   ```

   You should see the Nubo packages, `user-data`, `meta-data` and `zz-nubo-identity.squashfs`.
3. Boot the image in a VM. The menu title should be the one in the table, the installer should show only the six screens listed, and after the install `cat /etc/os-release` should show `PRETTY_NAME="Nubo OS Server 1"`. See [Testing checklist](/developers/testing-checklist/).

## Troubleshooting

- **"`<package> .deb not found`".** The packages directory does not hold that package. Build all packages, or download the set from the archive.
- **Boot text still says Ubuntu.** `mksquashfs` was missing. Install `squashfs-tools` and run again.
- **The installer asks every question, including the ones that should be skipped.** The answer file was not found. Check the escaped semicolon in the GRUB kernel line, and that `server/user-data` exists on the media.
- **The installed system lacks the flavour's software.** Check that the flavour's package was among the `.deb` files and that `late-commands` ran (look in `/var/log/installer/` on the new system).
- **Wrong architecture.** Match the ISO and `ARCH`. The packages are architecture-independent, but the ISO is not.

## See also

- [CI with Drone](/developers/ci-with-drone/)
- [Server](/server/)
- [Packaging notes](/developers/packaging-notes/)
