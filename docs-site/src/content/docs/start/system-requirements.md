---
title: System requirements
description: What your computer needs for Nubo OS, with a clear line between confirmed and unconfirmed figures.
sidebar:
  order: 20
---

**Applies to:** Desktop, Server

Nubo OS 1 is in beta and Nubo has not yet published minimum hardware figures of its own. This page lists what is confirmed from the project, and says plainly where a number is not confirmed yet. It does not guess.

## Confirmed

| Item | Requirement |
|---|---|
| Processor family | 64-bit Intel or AMD (amd64), or 64-bit Arm (arm64). |
| Base system | Ubuntu 26.04 LTS "resolute", so hardware that Ubuntu 26.04 supports is the starting point. |
| Boot | UEFI with Secure Boot works on the desktop image, because the boot loader and kernel are Ubuntu's signed ones. |
| Network | Needed for the first-boot app downloads from Flathub and for Nubo account sign-in setup. Both retry on the next boot if you are offline. |
| Installation medium | A USB stick, or a virtual disk image in a VM. |

### Notes on architectures

- The Nubo Search launcher is built for amd64 and arm64.
- Spotify, which is installed from Flathub on first boot, exists only for x86. On arm64 the installer skips it and installs the others.
- The desktop installer image build script is architecture-aware, but the arm64 desktop image has not been tested on real hardware. Treat arm64 desktop installs as experimental.
- The desktop image is not built by the automated pipeline yet. Server images for both CPUs are built and published for every release.

## Not yet confirmed

These figures have not been measured on Nubo OS. Do not treat them as promises.

| Item | Status |
|---|---|
| Minimum RAM | Not yet confirmed. |
| Minimum free disk space | Not yet confirmed. |
| Minimum screen size | Not yet confirmed. |
| Graphics hardware for the glass blur effect | Not yet confirmed. |
| Hardware certification list | None exists. |

## What Ubuntu asks for

As a reference point only, Ubuntu Desktop 26.04 publishes its own requirements on its download page: a dual-core 2 GHz processor, 6 GB of memory and 25 GB of disk, with a USB stick or DVD for installing. Nubo OS adds a desktop shell effect, a notification agent, widgets and a launcher on top of Ubuntu Desktop, so it is reasonable to plan for at least what Ubuntu lists. See [Ubuntu's download page](https://ubuntu.com/download/desktop) for the current figures.

The Nubo development virtual machines, which the project uses for building and testing, use a virtual UEFI machine with a virtual disk and a virtio display. They are described in the repository, but their sizes are tuned for building packages, not as user advice.

## Servers

The server editions install Ubuntu Server's text installer with Nubo packages on top. See [Server](/server/) for edition-specific notes. For hardware, follow [Ubuntu Server's requirements](https://ubuntu.com/server/docs).

## Checking your own machine

Before you commit to an install, you can boot the USB stick in "try" mode and see how the desktop behaves on your hardware. See [Try Nubo OS from a USB stick](/desktop/get-started/try-from-usb/).

## See also

- [Install Nubo OS on a PC](/desktop/get-started/install-on-a-pc/)
- [Install Nubo OS in a virtual machine](/desktop/get-started/install-in-a-vm/)
- [Getting help](/start/getting-help/)
