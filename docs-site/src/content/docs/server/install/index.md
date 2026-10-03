---
title: Install Nubo OS Server
description: Download, verify and install Nubo OS Server on a Mac, a PC, a server or a virtual machine.
sidebar:
  order: 1
---

**Applies to:** Server, Virtualization, Containers, Edge

Installing Nubo OS Server takes about the same effort as installing Ubuntu Server, because it uses Ubuntu's text-mode installer. The installer asks you for the same things (language, keyboard, network, disk, a user, SSH). The Nubo images skip the screens that would contact Canonical (installer update, snaps, Ubuntu Pro) and add the Nubo packages as the last step.

## Pages in this section

| Page | What it covers |
|---|---|
| [Choose an image](/server/install/choose-an-image/) | The eight server images (four editions, two CPU types), where to download them and how to verify the checksum. |
| [Install in UTM on a Mac](/server/install/install-in-utm/) | Step by step on Apple silicon with the arm64 image. |
| [Install on bare metal](/server/install/install-on-bare-metal/) | Write the image to a USB stick and boot a physical machine with UEFI. |
| [Install in KVM, VMware, Hyper-V or VirtualBox](/server/install/install-in-kvm-vmware-hyperv-virtualbox/) | The settings that matter in each hypervisor. |
| [Installer screens explained](/server/install/installer-screens-explained/) | Each screen the installer shows, what to choose, and what Nubo skips and why. |
| [First boot checklist](/server/install/first-boot-checklist/) | Commands to confirm the new server is what you expect. |

## Before you start

- A machine or virtual machine with a 64-bit CPU: Intel or AMD (amd64), or Arm (arm64).
- A network connection that can reach https://archive.nubosuite.tech during the install. The answer file falls back to installing Ubuntu's packages from the media if the network is missing, but a completely offline install has not been tested.
- A way to type at the machine's console during the install: a screen and keyboard, or the console window of your hypervisor. The installer is text mode and has no remote access by default.

## What you get

After the installer finishes and you reboot, you have a minimal Ubuntu 26.04 LTS system with the Nubo packages for the edition you chose. You log in with the user you created. SSH is installed only if you selected it on the SSH screen.

:::tip
If you want to repeat installs without answering questions, see [Automated installs](/server/autoinstall/).
:::

When the install is done, go to the [first boot checklist](/server/install/first-boot-checklist/), then to [Administer](/server/administer/).
