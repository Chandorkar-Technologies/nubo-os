---
title: How Nubo uses autoinstall
description: An explanation of the answer file on the Nubo OS Server installer media, what each part does and why, and how the four flavours differ.
sidebar:
  order: 10
---

**Applies to:** Server, Virtualization, Containers, Edge

This page explains how the Nubo OS Server installer works and why its answer file looks the way it does. The file is `iso/server-user-data` in the repository. On the installer media it ends up at `/server/user-data`. For a table of the keys, see the [answer file reference](/server/autoinstall/answer-file-reference/).

## The base: Ubuntu's installer

A Nubo OS Server ISO is Ubuntu 26.04 LTS's live-server image with three changes made by `iso/build-server-iso.sh`:

1. The boot menu and the installer's "type of installation" screen are renamed, for example to "Install Nubo OS Server".
2. A small extra layer carries the Nubo identity files (`os-release`, `issue`, `issue.net`, `lsb-release`) so that the installer's own console says Nubo OS.
3. The Nubo packages for the chosen flavour ride along on the media in `/nubo/pool/`, and an answer file is added in `/server/`.

Nothing is unpacked and rebuilt; the script rearranges files, adds new ones, and rewrites the image with `xorriso`. Ubuntu's own installer code runs as it is.

## How the installer finds the file

The script edits the kernel line in `grub.cfg` and `loopback.cfg`. It inserts these arguments before the `---` that ends the kernel arguments:

```text
autoinstall ds=nocloud\;s=/cdrom/server/ loglevel=3 systemd.show_status=false
```

- `autoinstall` tells Subiquity to use an answer file and not to ask whether to wipe the disk first.
- `ds=nocloud;s=/cdrom/server/` points the cloud-init NoCloud data source at the `/server/` folder on the media, where `user-data` and `meta-data` live. The semicolon is escaped with a backslash because in GRUB a bare `;` ends the command.
- `loglevel=3 systemd.show_status=false` keeps the console quiet.

`meta-data` contains one line, `instance-id: nubo-os-server`.

## What the answer file does

The file begins with `#cloud-config`, because the installer reads it through cloud-init. The settings sit under an `autoinstall:` key.

### Interactive sections

```yaml
interactive-sections:
  - locale
  - keyboard
  - network
  - storage
  - identity
  - ssh
```

Listed sections still ask you. Nubo leaves the personal and hardware decisions to you: language, keyboard, network, disk layout, your user name and password, and whether to install the SSH server. Sections that are not listed and have no answer in the file, such as the Ubuntu Pro and featured snaps screens, are handled by the keys below.

### Skipped screens

- `refresh-installer: update: false` skips the check for a newer installer.
- `snaps: []` selects no snaps. Nubo OS Server has no snaps (the core conflicts with `snapd`).
- The Ubuntu Pro and mirror screens are skipped by the settings in the file.

### Installation source

```yaml
source:
  id: ubuntu-server-minimal
  search_drivers: false
```

`ubuntu-server-minimal` is the minimal server option in Ubuntu's installer. Nubo then adds only what it needs. `search_drivers: false` stops the installer looking for third-party drivers.

### Apt and Nubo Cumulus

```yaml
apt:
  fallback: offline-install
  geoip: false
  mirror-selection:
    primary:
      - arches: [amd64, i386]
        uri: https://archive.nubosuite.tech/cumulus
      - arches: [arm64]
        uri: https://archive.nubosuite.tech/cumulus-arm
  security: (the same two URIs)
```

Ubuntu's packages come through Nubo Cumulus, a cache of Ubuntu's archive run by Nubo. The installer chooses the URI by CPU architecture. The signatures are Ubuntu's, so Cumulus cannot alter packages. `geoip: false` turns off picking a country mirror by location. `fallback: offline-install` lets the installation finish from the media if the network mirror cannot be used.

On the installed system, `nubo-archive` sets up apt with a mirror list that has Cumulus first and Ubuntu's own servers as a fallback. See [Updates](/updates/).

### Late commands

When the installer has laid down the system, the `late-commands` run:

1. Create `/target/var/tmp/nubo`.
2. Copy `/cdrom/nubo/pool/*.deb` into it.
3. Run `apt-get install -y --no-install-recommends -o Dpkg::Options::=--force-confnew /var/tmp/nubo/*.deb` inside the new system (`curtin in-target`).
4. Delete the temporary folder.

This is where the Nubo flavour is installed. The `.deb` files on the media are the ones for the flavour that the ISO was built for.

## What differs per flavour

| Flavour | Packages on the media | Extra late command |
|---|---|---|
| Server | `nubo-archive`, `nubo-base`, `nubo-server-core`, `nubo-server-base` | none |
| Virtualization | the Server set plus `nubo-incus` | installs `qemu-utils` and the QEMU system package and firmware for the CPU: `qemu-system-x86` and `ovmf` on amd64, `qemu-system-arm` and `qemu-efi-aarch64` on arm64 |
| Containers | the Server set plus `nubo-podman` | none |
| Edge | `nubo-archive`, `nubo-base`, `nubo-server-core`, `nubo-edge` | none |

The extra step is appended to the copy of the answer file on the media only. The file in the repository is the same for all flavours.

## What the answer file does not do

- It does not set a user, password, disk layout or network. You choose them.
- It does not make the install unattended. See [A fully unattended install](/server/autoinstall/unattended-install-example/).
- It does not use cloud-init on the installed system. See [cloud-init on Nubo images](/server/autoinstall/cloud-init/).

## See also

- [Answer file reference](/server/autoinstall/answer-file-reference/)
- [Build your own image](/server/images/build-your-own-image/)
- [Subiquity autoinstall reference](https://canonical-subiquity.readthedocs-hosted.com/en/latest/reference/autoinstall-reference.html)
