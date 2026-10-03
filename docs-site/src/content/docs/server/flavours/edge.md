---
title: Edge
description: What the Nubo OS Edge flavour is, what it contains, and what is and is not built yet.
sidebar:
  order: 140
---

**Applies to:** Edge

Nubo OS Edge is the smallest Nubo OS Server. It is meant for a Raspberry Pi, old hardware, and appliances that run unattended. The package is `nubo-edge`.

## What is in it

`nubo-edge` is the core of Nubo OS Server plus automatic updates and nothing else.

```text
nubo-edge
  +-- nubo-server-core   identity, SSH without root login, firewall closed except SSH,
  |                      chrony, AppArmor, kernel network hardening
  |     +-- nubo-archive, nubo-base
  +-- unattended-upgrades
```

Compared with the [Server flavour](/server/flavours/server/), Edge leaves out `fail2ban`, `needrestart`, `curl`, `htop`, `less` and `vim-tiny`. Everything the core provides is the same. In particular:

- SSH does not allow root login; password login stays on until you install an SSH key.
- The firewall allows SSH only.
- Security updates install automatically, and the machine never reboots by itself. See [Update and recover an Edge device](/server/flavours/edge-update-and-recover/).
- Ubuntu's snap, Pro and Landscape clients are not installed (they conflict with the core).

You still have `apt`, so you can add whatever your device needs. To add the Server extras later, see [Add or change a flavour](/server/flavours/switch-flavour/).

## Ways to get Edge

| Way | How |
|---|---|
| Installer ISO | The Edge server ISO, built by `iso/build-server-iso.sh` with `FLAVOUR=edge` for amd64 and arm64. See [how Nubo uses autoinstall](/server/autoinstall/how-nubo-uses-autoinstall/). |
| Raspberry Pi image | Built by `images/build-pi.sh` with `FLAVOUR=edge`. See [Raspberry Pi image](/server/images/raspberry-pi-image/). |
| Cloud or VM image | Built by `images/build-cloud.sh` with `FLAVOUR=edge`: qcow2, vhd, vmdk. See [Cloud and VM images](/server/images/cloud-and-vm-images/). |
| An existing Nubo OS Server | `sudo apt install nubo-edge`. |

:::note
The Nubo CI publishes the server installer ISOs for all four flavours. The Raspberry Pi and cloud images are built by scripts that have not run on a CI runner yet, so you build them yourself and treat them as untested.
:::

## What is not built yet

:::caution[Planned]
Edge today is a small, hardened server with automatic security updates. These things are not built, and nothing on the Edge pages should be read as promising them:

- a read-only root file system;
- atomic updates, and rollback to an earlier system image;
- fleet management: enrolling devices, pushing configuration or updates to many devices, a central view;
- remote attestation or secure boot enrolment specific to Nubo.
:::

If you need these today, plan on managing devices yourself, for example with cloud-init for first boot (see [Prepare and provision an Edge device](/server/flavours/edge-prepare-and-provision/)) and your own configuration tooling.

## Edge and the Raspberry Pi

The Raspberry Pi image is based on Ubuntu's preinstalled arm64 Raspberry Pi server image for 26.04, with the Nubo packages added. The script targets Raspberry Pi 4 and 5. It has not been tested on hardware.

## Next steps

- [Prepare and provision an Edge device](/server/flavours/edge-prepare-and-provision/)
- [Update and recover an Edge device](/server/flavours/edge-update-and-recover/)
- [Choose a flavour](/server/flavours/)
