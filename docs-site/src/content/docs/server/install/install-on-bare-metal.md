---
title: Install on bare metal
description: Write a Nubo OS Server image to a USB stick, boot a physical machine from it with UEFI, and install.
sidebar:
  order: 30
---

**Applies to:** Server, Virtualization, Containers, Edge

This how-to installs Nubo OS Server on a physical computer from a USB stick.

:::caution
The Nubo OS Server images are not yet tested on physical hardware. The boot loader and kernel on the images are Ubuntu's own signed ones, so they should behave like Ubuntu Server's installer on the same machine, but we have not confirmed this on real machines.
:::

## Before you begin

- A verified image for your CPU type. See [Choose an image](/server/install/choose-an-image/).
- A USB stick that is larger than the image. **Everything on the stick will be erased.**
- A machine that boots in **UEFI** mode. The images are built for UEFI. Old BIOS-only (legacy) boot is not covered.
- A screen and keyboard attached to the machine.
- Back up anything you want to keep on the machine's disk. The default install uses the whole disk.

## Steps

### 1. Write the image to the USB stick

The image is a hybrid ISO, so you copy it to the stick byte for byte. Do not extract its files onto the stick by hand.

**On Linux.** Find the stick's device name with `lsblk`, then write the image. Double-check the name: `dd` overwrites whatever you point it at.

```bash
lsblk -o NAME,SIZE,MODEL,TRAN
sudo dd if=nubo-os-server-0.8.0-beta3-amd64.iso of=/dev/sdX bs=4M status=progress conv=fsync
sync
```

**On macOS.** Find the stick with `diskutil list`, unmount it, then write to the raw device (the `rdisk` name is faster):

```bash
diskutil list
diskutil unmountDisk /dev/diskN
sudo dd if=nubo-os-server-0.8.0-beta3-arm64.iso of=/dev/rdiskN bs=4m
diskutil eject /dev/diskN
```

**On Windows.** Use a tool that can write a raw disk image, such as Rufus (choose **DD Image** mode if it asks) or balenaEtcher. <!-- verify label -->

### 2. Boot from the stick

1. Plug the stick into the machine and turn it on.
2. Open the one-time boot menu. The key depends on the maker: often <kbd>F12</kbd>, <kbd>F11</kbd>, <kbd>F10</kbd> or <kbd>Esc</kbd>.
3. Choose the entry for the USB stick that mentions UEFI.
4. In the Nubo OS boot menu, choose "Install Nubo OS Server" (the name follows the edition) and press <kbd>Enter</kbd>.

### 3. Run the installer

Follow [Installer screens explained](/server/install/installer-screens-explained/). On a physical machine, pay attention to two screens:

- **Network.** Use a wired connection if you can. Wi-Fi support in the text installer is limited.
- **Storage.** The installer shows the disks it found. Make sure the guided layout targets the disk you intend to erase. If the machine has more than one disk, check the name and size.

### 4. Remove the stick and reboot

When the installer says it is finished, choose **Reboot Now**. The installer asks you to remove the installation medium and press <kbd>Enter</kbd>. Remove the stick when asked.

## Secure Boot

The repository's build notes say the boot loader and kernel on the images stay Ubuntu's signed ones, so Secure Boot is expected to work. The Nubo image builder only adds files and edits the boot menu text; it does not replace the signed boot binaries. Secure Boot on physical machines has not yet been tested. If the machine refuses to boot the stick with Secure Boot enabled, try again with it disabled in the firmware settings, and tell us at support@nubo.email.

## Verify

After the first boot from the disk:

```bash
grep PRETTY_NAME /etc/os-release
lsblk
```

`PRETTY_NAME` shows `Nubo OS Server 1`. `lsblk` shows the installer's layout. If you used the default layout, you see a small EFI partition, a `/boot` partition and one large partition holding the LVM volume group. See [Disks and LVM](/server/administer/disks-and-lvm/).

Continue with the [first boot checklist](/server/install/first-boot-checklist/).

## Troubleshooting

**The machine does not list the stick in the boot menu.** The stick may not be written correctly, or the firmware may hide it. Write it again with the commands above. In the firmware settings, make sure USB boot is enabled.

**The machine boots straight into its old system.** The boot order puts the disk first. Use the one-time boot menu, or move USB above the disk in the firmware settings.

**You see a message about a security violation or an invalid signature.** Secure Boot rejected something. See the Secure Boot section above.

**Black screen after the boot menu on a machine with a graphics card.** Add the `nomodeset` option for this boot: in the boot menu press <kbd>e</kbd>, add `nomodeset` at the end of the line that begins with `linux`, and press <kbd>F10</kbd>. This is a generic Linux technique and is not specific to Nubo OS.

**The installer says it cannot reach the network.** Check the cable, then see the Network screen in [Installer screens explained](/server/install/installer-screens-explained/).

## See also

- [Choose an image](/server/install/choose-an-image/)
- [Installer screens explained](/server/install/installer-screens-explained/)
- [Ubuntu Server: basic installation](https://ubuntu.com/server/docs/tutorial/basic-installation/)
