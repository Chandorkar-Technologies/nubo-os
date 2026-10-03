---
title: Editions comparison
description: Nubo OS Desktop and the four Server editions side by side.
sidebar:
  order: 60
---

Nubo OS 1 "Flow" comes as a desktop and as four server editions. All are based on Ubuntu 26.04 LTS. A machine is either a desktop or a server: the server core package conflicts with the desktop branding package, so the two cannot be installed together.

## At a glance

| | Desktop | Server | Virtualization | Containers | Edge |
|---|---|---|---|---|---|
| For | Everyday computers | General servers | Running virtual machines and system containers | Running application containers | Raspberry Pi, old hardware, appliances |
| Main package | `nubo-desktop` | `nubo-server-base` | `nubo-incus` | `nubo-podman` | `nubo-edge` |
| Graphical desktop | GNOME with the Nubo look | No | No | No | No |
| Installed from | Installer image (see note) | Server image | Server image | Server image | Server image |
| Image name | Not yet published | `nubo-os-server-<version>-<arch>.iso` | `nubo-os-virt-...` | `nubo-os-containers-...` | `nubo-os-edge-...` |
| Architectures built | amd64, arm64 | amd64, arm64 | amd64, arm64 | amd64, arm64 | amd64, arm64 |
| System name | Nubo OS 1 | Nubo OS Server 1 | Nubo OS Server 1 | Nubo OS Server 1 | Nubo OS Server 1 |

:::note
The server installer images are built by the release system for every beta tag. The desktop installer image is built by a script (`iso/build-iso.sh`) on a Linux machine and is not yet built by the release system. See [Known issues](/reference/known-issues/).
:::

## What each edition contains

| Feature | Desktop | Server | Virtualization | Containers | Edge |
|---|---|---|---|---|---|
| Nubo package source and key (`nubo-archive`) | Yes | Yes | Yes | Yes | Yes |
| Network check, time servers, no reports (`nubo-base`) | Yes | Yes | Yes | Yes | Yes |
| SSH server, no root login | No | Yes | Yes | Yes | Yes |
| Firewall closed except SSH | No | Yes | Yes | Yes | Yes |
| Kernel network hardening | No | Yes | Yes | Yes | Yes |
| Time sync (chrony) | No | Yes | Yes | Yes | Yes |
| AppArmor | Ubuntu's default | Yes | Yes | Yes | Yes |
| Automatic updates (`unattended-upgrades`) | See below | Yes | Yes | Yes | Yes |
| Brute-force protection (`fail2ban`) | No | Yes | Yes | Yes | No |
| `needrestart`, `curl`, `htop`, `less`, `vim-tiny` | No | Yes | Yes | Yes | No |
| Podman, Buildah, Skopeo, `nubo-podman-init` | No | No | No | Yes | No |
| Incus, ZFS tools, bridge tools, `nubo-incus-init` | No | No | Yes | No | No |
| QEMU | No | No | Yes (added by the installer image) | No | No |
| Nubo theme, icons, sounds, wallpapers | Yes | No | No | No | No |
| Nubo Search, notification centre, widgets | Yes | No | No | No | No |
| Nubo account sign-in | Yes (early access) | No | No | No | No |
| Flathub apps, grey placeholders for popular apps | Yes | No | No | No | No |
| Snap packages | Stay for the sign-in service | Not installable | Not installable | Not installable | Not installable |
| Ubuntu Pro client | Removed | Not installable | Not installable | Not installable | Not installable |

Automatic updates on the desktop: the settings file is installed by `nubo-archive` and applies wherever `unattended-upgrades` is installed. `nubo-desktop` does not require that package. See [Automatic updates](/updates/automatic-updates/).

## Installer behavior

| | Desktop | Server editions |
|---|---|---|
| Installer | Ubuntu's desktop installer, with Nubo's look and answer file | Ubuntu Server's text installer, with Nubo names and answer file |
| Screens left to you | The installer's usual choices | Language, keyboard, network, storage, user, SSH |
| Screens skipped | Ubuntu Pro page hidden | Installer update, snaps, Ubuntu Pro, mirror |
| Ubuntu packages come from | Nubo Cumulus, with the media as fallback | Nubo Cumulus, with the media as fallback |
| Nubo packages | Carried on the media and installed as the last step | Same |
| Minimal installation | Not applicable | The minimal server source is chosen |

## Other ways to get a server

| Format | Script | Status |
|---|---|---|
| Server installer image (ISO) | `iso/build-server-iso.sh` | Built by the release system for all four editions and both CPUs. The image was built and inspected on arm64; not yet tested on hardware |
| Cloud and VM disk image (`.qcow2`, `.vhd`, `.vmdk`) | `images/build-cloud.sh` | Script exists, marked untested |
| Raspberry Pi image | `images/build-pi.sh` | Script exists, marked untested |

For all four editions, `FLAVOUR` selects `server`, `virt`, `containers` or `edge` in these scripts.

## Choosing

- You want a normal computer for yourself: Desktop.
- You want a general-purpose server: Server.
- You want to host virtual machines or system containers: Virtualization. You can also add `nubo-incus` to a Server later with `sudo apt install nubo-incus`.
- You want to run containers from images and compose files: Containers.
- You have a small or old machine and want as little as possible on it: Edge.

## See also

- [Packages](/reference/packages/)
- [Server](/server/)
- [Desktop](/desktop/)
