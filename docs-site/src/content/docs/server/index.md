---
title: Nubo OS Server
description: What Nubo OS Server is, who it is for, and where to find installation, administration and security guides.
sidebar:
  order: 1
---

**Applies to:** Server, Virtualization, Containers, Edge

Nubo OS Server is the server edition of Nubo OS 1 "Flow". It is based on Ubuntu 26.04 LTS and uses Ubuntu's text-mode installer, Ubuntu's kernel and Ubuntu's packages. On top of that base it adds a small set of packages (`nubo-server-core` and friends) that give a new machine a sensible starting point:

- A system identity of "Nubo OS Server 1" (in `/etc/os-release`, the login banner and the boot menu).
- SSH without root login, and a firewall that is closed except for SSH.
- Time sync with chrony, using Cloudflare's NTS service and `pool.ntp.org`.
- Kernel network hardening settings.
- Automatic installation of security updates (Server and Edge).
- Package downloads through Nubo Cumulus, a cache for Ubuntu's archive, with Ubuntu's own servers as a fallback.
- No crash reports, login "news" or Ubuntu Pro adverts sent to Canonical.

Nothing here replaces Ubuntu's own tools. You administer the machine with the same commands you would use on Ubuntu Server: `apt`, `systemctl`, `journalctl`, `netplan`, `ufw`. These pages cover the parts that are specific to Nubo, and link to [Ubuntu Server documentation](https://ubuntu.com/server/docs) for the generic parts.

:::note
Nubo OS 1 is in beta. The server images are built for both amd64 and arm64, but they have had limited testing on physical hardware. Where a page describes something we have not tested, it says so.
:::

## The four editions

Nubo OS Server comes in four editions, each an installer image of its own. They differ only in which packages are added to the common core. See [Server flavours](/server/flavours/) for the full comparison.

| Edition | Package | Adds to the core |
|---|---|---|
| Server | `nubo-server-base` | Unattended upgrades, fail2ban, needrestart, curl, htop, less, vim-tiny |
| Virtualization | `nubo-incus` | The Server edition plus Incus, ZFS tools, bridge utilities and QEMU |
| Containers | `nubo-podman` | The Server edition plus Podman, Buildah, Skopeo, uidmap and passt |
| Edge | `nubo-edge` | The core plus unattended upgrades only: the smallest edition |

## Where to go next

| I want to... | Go to |
|---|---|
| Download an image and install a server | [Install](/server/install/) |
| Look after a running server: users, SSH, firewall, updates, disks, backups | [Administer](/server/administer/) |
| Understand what Nubo changes for security, and what the machine contacts | [Security](/server/security/) |
| Pick between Server, Virtualization, Containers and Edge | [Server flavours](/server/flavours/) |
| Install without answering questions | [Automated installs](/server/autoinstall/) |
| Build or use cloud, VM and Raspberry Pi images | [Images](/server/images/) |
| Understand how updates and channels work | [Updates](/updates/) |
| Look up a package, path or command | [Reference](/reference/) |

## A first path through the documentation

If this is your first Nubo OS server, read these in order:

1. [Choose an image](/server/install/choose-an-image/) and verify the download.
2. Install it: [in UTM on a Mac](/server/install/install-in-utm/), [on bare metal](/server/install/install-on-bare-metal/), or [in another hypervisor](/server/install/install-in-kvm-vmware-hyperv-virtualbox/).
3. Run through the [first boot checklist](/server/install/first-boot-checklist/).
4. Install an SSH key and [harden SSH](/server/administer/ssh-keys-and-hardening/).
5. Read [what the defaults do](/server/security/what-the-defaults-do/) so nothing on the machine surprises you.

## Getting help

- Documentation: https://docs.nubosuite.tech
- Support: support@nubo.email
- Security reports: security@nubosuite.tech
- Source code: https://github.com/Chandorkar-Technologies/nubo-os
