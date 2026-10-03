---
title: Server images
description: The installer ISOs, cloud and VM images, and Raspberry Pi image of Nubo OS Server, what each one is, and how to build your own.
sidebar:
  order: 30
---

**Applies to:** Server, Virtualization, Containers, Edge

Nubo OS Server is available in several forms. All are built from Ubuntu 26.04 LTS's own images with the Nubo packages added, and all can be built for the four flavours (`server`, `virt`, `containers`, `edge`) by setting the `FLAVOUR` variable. See [Choose a flavour](/server/flavours/).

## Overview

| Image | Built by | Output | Status |
|---|---|---|---|
| Installer ISO | `iso/build-server-iso.sh` | `nubo-os-FLAVOUR-VERSION-ARCH.iso` | Built by CI for four flavours and amd64 and arm64, and published at `https://archive.nubosuite.tech/iso/VERSION/` with a `.sha256` file. |
| Cloud and VM image | `images/build-cloud.sh` | `nubo-os-FLAVOUR-ARCH.qcow2`, `.vhd`, `.vmdk` | Script written; not built by CI; first builds untested. |
| Raspberry Pi image | `images/build-pi.sh` | `nubo-os-FLAVOUR-raspi.img.xz` | Script written; not built by CI; untested on hardware. |

The names of the ISO files come from `ci/build-isos.sh`. The other two names come from the scripts.

## In this section

- [Cloud and VM images](/server/images/cloud-and-vm-images/): qcow2, vhd and vmdk, and how to use them on KVM, Hyper-V and VMware.
- [Raspberry Pi image](/server/images/raspberry-pi-image/): the arm64 image for Raspberry Pi 4 and 5.
- [Build your own image](/server/images/build-your-own-image/): requirements and steps for building the installer ISO and the other images.

## Related

- [Autoinstall and cloud-init](/server/autoinstall/): how the installer media and first boot are configured.
- [Server](/server/): the server section.
