---
title: Dual boot with Windows
description: The Nubo-specific cautions when you install Nubo OS beside Windows, and where to find the full steps.
sidebar:
  order: 70
---

**Applies to:** Desktop

You can keep Windows and add Nubo OS on the same computer, and choose at start-up which one to use. The installer is Ubuntu's, so the partitioning steps are the same as for Ubuntu. This page covers only what is specific to Nubo OS. For the full generic steps, including BitLocker, AHCI and Intel RST, use Ubuntu's documentation: [Ubuntu Desktop documentation](https://ubuntu.com/desktop/docs).

## Before you begin

- A full backup of Windows and your files, on a different disk.
- A Nubo OS installer USB stick. See [Write the installer to a USB stick](/desktop/get-started/write-the-installer-usb/).
- Free space on the disk. Shrink the Windows partition from inside Windows first, using Disk Management, rather than letting another tool do it. Nubo has not published a minimum size, so follow [System requirements](/start/system-requirements/).
- Your BitLocker recovery key, if Windows uses BitLocker. Ubuntu's documentation has a how-to on turning BitLocker off.
- Fast Startup turned off in Windows, so the disk is left in a clean state.

## Steps

1. In Windows, turn off Fast Startup and shrink the main partition to leave free space.
2. Restart and boot the Nubo OS USB stick. See [Try Nubo OS from a USB stick](/desktop/get-started/try-from-usb/).
3. Run the installer as in [Install Nubo OS on a PC](/desktop/get-started/install-on-a-pc/).
4. At the disk step, choose the option that installs beside Windows, if the installer offers it. The names of the options come from Ubuntu's installer. <!-- verify label -->
5. Finish the install and restart.
6. At start-up, use the firmware's boot menu to choose between Windows and Nubo OS.

## Nubo-specific cautions

- **The boot loader entry is named Ubuntu.** The Nubo OS desktop keeps the boot loader name `Ubuntu`, because the signed boot loader looks for its files under `EFI/ubuntu`. Renaming it would stop Secure Boot from working. In the firmware boot menu, the Nubo OS entry may therefore read Ubuntu.
- **The boot menu is hidden on a normal start.** GRUB's menu does not show unless you hold a key or the firmware chooses it. If you want to pick the system on every start, use the firmware boot menu.
- **Other systems list Nubo OS by its description.** Nubo OS writes `/etc/lsb-release` with the description "Nubo OS 1". Other systems' boot menus use it to name this system.
- **Secure Boot stays on.** You do not need to turn it off, because the boot loader and kernel are Ubuntu's signed ones.
- **Windows updates can change the boot order.** If Windows starts directly after an update, open the firmware boot menu and choose Nubo OS, or change the boot order in the firmware settings.

## Verify

1. The firmware boot menu lists both Windows and an entry for the Nubo OS installation.
2. Windows still starts, and your files are there.
3. Nubo OS starts, and Settings then About shows "Nubo OS 1". <!-- verify label -->

## Troubleshooting

- **Windows asks for a BitLocker recovery key after the install.** Changes to the boot setup can trigger it. Enter the key from your Microsoft account. To avoid it next time, follow Ubuntu's how-to on BitLocker before installing.
- **The installer shows no option to install alongside Windows.** The disk may be fully used, or encrypted, or using RAID or Intel RST. Check Ubuntu's documentation on Intel RST and BitLocker, then try again. You can also partition by hand.
- **The computer goes straight to Windows.** Choose Nubo OS in the firmware boot menu, or move it first in the boot order.
- **The computer will not start at all.** See [Boot problems](/desktop/troubleshooting/boot-problems/).

## See also

- [Install Nubo OS on a PC](/desktop/get-started/install-on-a-pc/)
- [Boot problems](/desktop/troubleshooting/boot-problems/)
- [Ubuntu Desktop documentation](https://ubuntu.com/desktop/docs)
