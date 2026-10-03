---
title: Answer file reference
description: Every key that Nubo sets in the server installer answer file, with its value and effect.
sidebar:
  order: 20
---

**Applies to:** Server, Virtualization, Containers, Edge

This table lists every key set in `iso/server-user-data`, the answer file on the Nubo OS Server installer media. Keys are shown by their path under `autoinstall:`. The file is read through cloud-init, so it starts with the line `#cloud-config`. For the meaning of each key in general, see the [Subiquity autoinstall reference](https://canonical-subiquity.readthedocs-hosted.com/en/latest/reference/autoinstall-reference.html). For the reasons behind Nubo's choices, see [How Nubo uses autoinstall](/server/autoinstall/how-nubo-uses-autoinstall/).

## Keys

| Key | Value set by Nubo | Effect |
|---|---|---|
| `version` | `1` | The autoinstall format version. |
| `interactive-sections` | `locale`, `keyboard`, `network`, `storage`, `identity`, `ssh` | These screens still ask you. |
| `refresh-installer.update` | `false` | Does not check for a newer installer. |
| `snaps` | `[]` | No snaps are chosen. |
| `source.id` | `ubuntu-server-minimal` | The minimal server installation source. |
| `source.search_drivers` | `false` | Does not search for third-party drivers. |
| `apt.fallback` | `offline-install` | If the mirror fails, install from the media. |
| `apt.geoip` | `false` | Does not choose a mirror by country. |
| `apt.mirror-selection.primary` (amd64, i386) | `https://archive.nubosuite.tech/cumulus` | Main archive for those architectures. |
| `apt.mirror-selection.primary` (arm64) | `https://archive.nubosuite.tech/cumulus-arm` | Main archive for arm64. |
| `apt.security` (amd64, i386) | `https://archive.nubosuite.tech/cumulus` | Security archive for those architectures. |
| `apt.security` (arm64) | `https://archive.nubosuite.tech/cumulus-arm` | Security archive for arm64. |
| `late-commands` | four commands | Copy the Nubo packages from the media and install them. See below. |

## Late commands

| Order | Command | Purpose |
|---|---|---|
| 1 | `mkdir -p /target/var/tmp/nubo` | A folder in the new system. |
| 2 | `cp /cdrom/nubo/pool/*.deb /target/var/tmp/nubo/` | Copy the packages from the media. |
| 3 | `curtin in-target --target=/target -- sh -c 'DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends -o Dpkg::Options::=--force-confnew /var/tmp/nubo/*.deb'` | Install them inside the new system. |
| 4 | `rm -rf /target/var/tmp/nubo` | Clean up. |

### Virtualization only

The Virtualization ISO adds a fifth command when the media is built:

```yaml
- >-
  curtin in-target --target=/target -- sh -c
  'DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends
  qemu-utils $(case "$(dpkg --print-architecture)" in
  amd64) echo "qemu-system-x86 ovmf" ;; *) echo "qemu-system-arm qemu-efi-aarch64" ;; esac)'
```

## Keys Nubo does not set

These keys are not in Nubo's file, which means that Subiquity's own defaults or your answers on screen apply:

for example `identity`, `ssh`, `keyboard`, `locale`, `timezone`, `network`, `storage`, `shutdown`, `packages`, `user-data`, `error-commands` and `proxy`. The Subiquity reference has the full list for your installer version. Some of them are needed to make an install unattended; see [A fully unattended install](/server/autoinstall/unattended-install-example/).

## Media layout

| Path on the media | Content |
|---|---|
| `/server/user-data` | The answer file (a copy of `iso/server-user-data`, with the flavour's extra late command if any). |
| `/server/meta-data` | `instance-id: nubo-os-server`. |
| `/nubo/pool/*.deb` | The Nubo packages for the flavour. |
| `/casper/install-sources.yaml` | Names for the installation types ("Nubo OS Server", "Nubo OS Server (minimal)"). |
| `/casper/zz-nubo-identity.squashfs` | The identity layer (only if `mksquashfs` was available at build time). |
| `/boot/grub/grub.cfg`, `/boot/grub/loopback.cfg` | Renamed boot menu with `autoinstall ds=nocloud\;s=/cdrom/server/ loglevel=3 systemd.show_status=false` added to the kernel line. |

## See also

- [Validate and troubleshoot](/server/autoinstall/validate-and-troubleshoot/)
- [Build your own image](/server/images/build-your-own-image/)
