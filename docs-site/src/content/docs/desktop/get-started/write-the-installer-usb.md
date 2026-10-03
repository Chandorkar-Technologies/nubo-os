---
title: Write the installer to a USB stick
description: Make a bootable Nubo OS USB stick on Linux, macOS or Windows.
sidebar:
  order: 40
---

**Applies to:** Desktop

An ISO file is a disk image. To boot from it you write the image to a USB stick so that the stick looks like the installer's disk. Copying the ISO file onto the stick as a normal file does not work.

:::caution
Writing an image erases everything on the stick. Make sure you pick the right device. Choosing your computer's own disk by mistake destroys your data.
:::

## Before you begin

- The Nubo OS desktop ISO file. Nubo OS 1 is in beta and the desktop ISO is built with `iso/build-iso.sh` from the Ubuntu Desktop image. It is not yet built by the automated pipeline. Check <https://os.nubosuite.tech> for the current download. <!-- verify download location -->
- A USB stick. Nubo has not published a minimum size. Ubuntu's own guide recommends a stick of at least 12 GB for its installer, which is a safe starting point. <!-- verify size -->
- The checksum, if one is published with the download.

### Check the download

Compare the file's SHA-256 checksum with the one published next to the download, if there is one. Server images are published with a `.sha256` file; check the download page for the desktop.

```bash
sha256sum nubo-os-1-amd64.iso
```

On macOS use `shasum -a 256 nubo-os-1-amd64.iso`. On Windows PowerShell use `Get-FileHash nubo-os-1-amd64.iso -Algorithm SHA256`. The file name above is an example from the repository's build instructions, so use your file's name.

## Steps on Linux

1. Plug in the stick and find its device name:

   ```bash
   lsblk
   ```

   Look for the line with your stick's size, for example `sdb`. The device is `/dev/sdb`, not a partition like `/dev/sdb1`.

2. Unmount any mounted partitions of the stick:

   ```bash
   sudo umount /dev/sdb?* 2>/dev/null
   ```

3. Write the image. Replace the file name and the device:

   ```bash
   sudo dd if=nubo-os-1-amd64.iso of=/dev/sdb bs=4M status=progress conv=fsync
   ```

4. Run `sync`, then remove the stick.

If you prefer a graphical tool, the Disks app in GNOME can restore a disk image to a drive. <!-- verify label -->

## Steps on macOS

1. Plug in the stick and list disks:

   ```bash
   diskutil list
   ```

   Find the stick, for example `/dev/disk4`.

2. Unmount it:

   ```bash
   diskutil unmountDisk /dev/disk4
   ```

3. Write the image to the raw device (`rdisk`), which is faster:

   ```bash
   sudo dd if=nubo-os-1-amd64.iso of=/dev/rdisk4 bs=4m
   ```

   The command shows nothing until it finishes. Press <kbd>Ctrl</kbd>+<kbd>T</kbd> to see progress.

4. Eject:

   ```bash
   diskutil eject /dev/disk4
   ```

macOS may say the disk is not readable when it finishes. That is normal, because macOS does not understand the installer's file system. Click Eject.

## Steps on Windows

Windows has no built-in tool. Use a free tool that writes images, such as Rufus or balenaEtcher.

1. Install and open the tool.
2. Choose the Nubo OS ISO file.
3. Choose your USB stick. Check the size and name.
4. If the tool asks whether to write in ISO mode or DD mode, choose **DD**.
5. Start the write and wait for it to finish.

The buttons and labels differ between tools and versions, so the steps above describe the idea. Follow the tool's own instructions.

## Verify

Plug the stick into the computer where you will use it and try booting it. See [Try Nubo OS from a USB stick](/desktop/get-started/try-from-usb/). If you see the Nubo boot menu, the stick is good.

## Troubleshooting

- **`dd: permission denied`.** Add `sudo`. On macOS make sure the terminal has permission to access removable volumes in System Settings. <!-- verify label -->
- **`dd: Resource busy`.** The stick is still mounted. Unmount it and run again.
- **The stick does not boot.** Write it again with a different USB port. Check that the firmware is in UEFI mode and that the stick is first in the boot menu.
- **The checksums do not match.** Download the file again. A mismatch means the file is damaged or has been changed.
- **You wrote to the wrong device.** Stop. If the device held data, stop using it and look for recovery tools before writing anything else.

## See also

- [Try Nubo OS from a USB stick](/desktop/get-started/try-from-usb/)
- [Install Nubo OS on a PC](/desktop/get-started/install-on-a-pc/)
- [Ubuntu Desktop documentation](https://ubuntu.com/desktop/docs), which has a how-to on creating a bootable USB stick
