---
title: Build your own image
description: Build a Nubo OS Server installer ISO for any flavour from Ubuntu's live-server image and the Nubo packages.
sidebar:
  order: 30
---

**Applies to:** Server, Virtualization, Containers, Edge

You can build the same installer images that Nubo's CI publishes. The script `iso/build-server-iso.sh` takes Ubuntu's live-server ISO and the Nubo `.deb` files and writes a new ISO. It does not unpack the image or run anything from the target system. It renames the boot entries, adds an answer file and the packages, and writes the image again with `xorriso`. The cloud, VM and Raspberry Pi scripts work in a similar way; see the end of this page.

## Before you begin

- A Linux machine. The script works for amd64 and arm64 images, and the builder does not have to match the architecture of the image (CI builds both on amd64).
- `xorriso` (`sudo apt install xorriso`). Install `squashfs-tools` as well: without `mksquashfs` the script still works, but the boot text will still say Ubuntu.
- Run as a normal user. The script does not need root.
- Ubuntu's 26.04 live-server ISO for the CPU you target. Get it and check its checksum against Ubuntu's `SHA256SUMS`. CI downloads from Nubo Cumulus: `https://archive.nubosuite.tech/cumulus-releases/26.04/ubuntu-26.04-live-server-amd64.iso` for amd64 and `https://archive.nubosuite.tech/cumulus-images/ubuntu/releases/26.04/release/ubuntu-26.04-live-server-arm64.iso` for arm64.
- A folder with the Nubo `.deb` files for the flavour. The script copies the first file that matches `PACKAGE_*.deb` for each required package and stops with an error if one is missing. The required packages:

| `FLAVOUR` | Packages |
|---|---|
| `server` (default) | `nubo-archive`, `nubo-base`, `nubo-server-core`, `nubo-server-base` |
| `virt` | the `server` set plus `nubo-incus` |
| `containers` | the `server` set plus `nubo-podman` |
| `edge` | `nubo-archive`, `nubo-base`, `nubo-server-core`, `nubo-edge` |

Build the packages from the repository with the usual Debian tools, or download them from the Nubo archive.

## Steps

### 1. Get the repository

```bash
git clone https://github.com/Chandorkar-Technologies/nubo-os.git
cd nubo-os
```

### 2. Run the script

```bash
FLAVOUR=containers ARCH=amd64 iso/build-server-iso.sh \
  ~/Downloads/ubuntu-26.04-live-server-amd64.iso \
  ~/nubo-debs \
  ~/nubo-os-containers-amd64.iso
```

The usage line from the script is:

```text
[FLAVOUR=server|virt|containers|edge] build-server-iso.sh UBUNTU_SERVER_ISO NUBO_DEBS_DIR OUTPUT_ISO
```

| Variable | Default | Meaning |
|---|---|---|
| `FLAVOUR` | `server` | Which flavour to build. |
| `ARCH` | the machine's (`dpkg --print-architecture`) | Used in the volume name and the `.disk/info` text. Set it when you build for another CPU than the builder's. |
| `WORK` | a new temporary directory | Where the script keeps intermediate files. |

### 3. What the script does

1. Chooses the packages, the menu title and the volume label from `FLAVOUR`.
2. Copies the `.deb` files into `nubo/pool/` of the new media.
3. Extracts `grub.cfg` and `loopback.cfg` from Ubuntu's image, renames "Ubuntu Server" to the Nubo title, and adds `autoinstall ds=nocloud\;s=/cdrom/server/ loglevel=3 systemd.show_status=false` to the kernel line.
4. Rewrites the installation type names in `casper/install-sources.yaml`.
5. Builds the identity layer `casper/zz-nubo-identity.squashfs` (if `mksquashfs` exists).
6. Writes `.disk/info`, copies `iso/server-user-data` to `server/user-data` (with the QEMU step for `virt`), and copies `iso/server-meta-data` to `server/meta-data`.
7. Updates `md5sum.txt` for the changed files.
8. Writes the new ISO with `xorriso`, keeping Ubuntu's boot setup, with the volume name "Nubo OS LABEL 1 ARCH".

To change what the installer asks or sets, edit `iso/server-user-data` before you run the script. See [How Nubo uses autoinstall](/server/autoinstall/how-nubo-uses-autoinstall/).

### 4. Checksum it

```bash
sha256sum nubo-os-containers-amd64.iso > nubo-os-containers-amd64.iso.sha256
```

## Verify

Check that the answer file and packages are on the media:

```bash
xorriso -indev ~/nubo-os-containers-amd64.iso -ls /server/
xorriso -indev ~/nubo-os-containers-amd64.iso -ls /nubo/pool/
```

Then boot the ISO in a virtual machine and install it. See [Validate and troubleshoot](/server/autoinstall/validate-and-troubleshoot/).

## Troubleshooting

**`Missing tool: xorriso`.** Cause: not installed. Fix: `sudo apt install xorriso`.

**`nubo-server-core .deb not found in ...`.** Cause: the folder lacks a package for the flavour (the message names the package). Fix: add it; check the file name starts with the package name followed by `_`.

**`FLAVOUR must be server, virt, containers or edge`.** Cause: a typo. Fix: use one of the four names.

**The boot text still says Ubuntu.** Cause: `mksquashfs` was missing and the script printed a warning. Fix: install `squashfs-tools`, and rebuild.

**The ISO boots to the standard Ubuntu installer without the Nubo steps.** Cause: the kernel line edit did not apply, for example when the base image's menu changed. Fix: inspect `/boot/grub/grub.cfg` on the new ISO (see the validation page).

**Checksum or download errors.** Cause: base image corrupted or incomplete. Fix: download again, compare with Ubuntu's `SHA256SUMS`.

## Other image types

The cloud, VM and Raspberry Pi scripts take the same `FLAVOUR` variable and the same package sets:

- `sudo FLAVOUR=edge images/build-cloud.sh DEBS_DIR OUT_DIR [amd64|arm64]`: see [Cloud and VM images](/server/images/cloud-and-vm-images/).
- `sudo FLAVOUR=edge images/build-pi.sh DEBS_DIR OUT_DIR`: see [Raspberry Pi image](/server/images/raspberry-pi-image/).

Unlike the installer ISO builder, these two need root, `qemu-utils` and `libguestfs-tools`.

## See also

- [Server images](/server/images/)
- [Choose a flavour](/server/flavours/)
- [Developers](/developers/)
