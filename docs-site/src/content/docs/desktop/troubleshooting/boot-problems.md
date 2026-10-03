---
title: Boot problems
description: Fix a computer that does not start Nubo OS, shows a black screen, or boots the wrong system.
sidebar:
  order: 90
---

**Applies to:** Desktop

Nubo OS keeps Ubuntu's signed boot loader and kernel, so most start-up problems are the same as on Ubuntu. This page covers the first things to check and the Nubo-specific points. For deep boot repair, use [Ubuntu's documentation](https://ubuntu.com/desktop/docs).

## Before you begin

- A Nubo OS USB stick. You can use its live session to inspect the disk. See [Try Nubo OS from a USB stick](/desktop/get-started/try-from-usb/).
- Know whether Nubo OS is the only system on the computer or shares it with Windows.
- Back up your data before you try repairs that write to the disk.

## What a normal start looks like

1. The firmware logo appears.
2. The GRUB boot menu is hidden on a normal start, so you usually do not see it.
3. The Nubo boot screen shows while the system starts. It is a Plymouth screen with the Nubo mark.
4. The login screen appears. See [Your first login](/desktop/get-started/first-login/).

## Steps

### The computer starts the wrong system

1. Open the firmware's boot menu at start (a key such as <kbd>F12</kbd>, <kbd>F10</kbd>, <kbd>F2</kbd>, <kbd>Esc</kbd> or <kbd>Del</kbd>, depending on the maker).
2. Choose the entry for Nubo OS. It may be named **Ubuntu**. That is expected, because the signed boot loader keeps that name. See [Dual boot with Windows](/desktop/get-started/dual-boot-with-windows/).
3. To make it the default, change the boot order in the firmware settings.

### A black screen or a stuck boot screen

1. Wait a minute or two. The first boot can take longer.
2. Press <kbd>Esc</kbd> during the boot screen to see the start-up text instead of the picture. The text can show what it is waiting for.
3. In a virtual machine, try a different virtual display. See [Display flickers or resizes in a VM](/desktop/troubleshooting/display-flickers-or-resizes-in-a-vm/).
4. Check that you have free disk space. A full disk can stop a start.

### Show the GRUB menu

Hold <kbd>Shift</kbd> (on BIOS machines) or tap <kbd>Esc</kbd> (on UEFI machines) right after the firmware logo to open the GRUB menu. From there you can choose an older kernel under the advanced options, or the recovery mode.

### Read the log of the failed start

Once you can reach a text console or the live session, read the previous boot's log:

```bash
journalctl -b -1 -p err --no-pager | tail -n 80
```

`-b -1` means the last boot before this one. In the live session, mount your installed system first and use `journalctl --directory=/mnt/var/log/journal -b -1`. <!-- verify -->

### The system does not start after an update

1. Open the GRUB menu as above.
2. Choose Advanced options, and then an older kernel.
3. If the older kernel works, report the problem with the log. See [Collect logs for support](/desktop/troubleshooting/collect-logs-for-support/).

### The system installs but will not boot with Secure Boot on

The signed boot loader should work. If your firmware refuses it, check that Secure Boot is set to the standard mode and that the date and time in the firmware are right. Try the install again from a freshly written stick.

### Repair the boot loader

If the boot entry vanished, boot the live session from the USB stick and use Ubuntu's boot repair steps. Do not rename `EFI/ubuntu` on the EFI partition. Nubo keeps that name because the signed boot loader finds its files there.

## Verify

The computer reaches the login screen on a normal start, and the Nubo OS entry is first in the boot order.

## Troubleshooting

- **The USB stick does not boot.** See [Write the installer to a USB stick](/desktop/get-started/write-the-installer-usb/).
- **The firmware does not list Nubo OS.** The installation may not have finished. Reinstall. See [Install Nubo OS on a PC](/desktop/get-started/install-on-a-pc/).
- **The boot screen shows Ubuntu, not Nubo OS.** The boot menu entry reads "Ubuntu" internally and is hidden on a normal start. The repository lists this as a known gap.
- **A disk error message at start.** The disk may be failing. Back up your data from the live session first.
- **You cannot get any further.** Collect what you can and write to support. See [Getting help](/start/getting-help/).

## See also

- [Login problems](/desktop/troubleshooting/login-problems/)
- [Collect logs for support](/desktop/troubleshooting/collect-logs-for-support/)
