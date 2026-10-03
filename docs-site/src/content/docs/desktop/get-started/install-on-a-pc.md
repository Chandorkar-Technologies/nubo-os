---
title: Install Nubo OS on a PC
description: Install the Nubo OS desktop on a computer's disk from a USB stick.
sidebar:
  order: 20
---

**Applies to:** Desktop

This guide installs Nubo OS 1 on a computer. The installer is Ubuntu's desktop installer, branded Nubo OS. Every screen stays interactive, so you answer the usual questions yourself. After the last screen, the installer adds the Nubo packages. See [What the installer does](/desktop/get-started/what-the-installer-does/) for details.

:::caution
Installing can erase data. Back up everything you want to keep before you start. Nubo OS 1 is in beta, and the desktop image has not been tested on every kind of hardware.
:::

## Before you begin

- A USB stick with the installer written to it. See [Write the installer to a USB stick](/desktop/get-started/write-the-installer-usb/).
- A backup of your files, on a different disk or another machine.
- A network connection is recommended. The installer gets Ubuntu's packages through Nubo Cumulus, and falls back to the packages on the stick if Cumulus cannot be reached. After the install, the first boot downloads several apps from Flathub and needs a network.
- Power: plug laptops into mains power.
- If Windows is on the computer and you want to keep it, read [Dual boot with Windows](/desktop/get-started/dual-boot-with-windows/) first.

## Steps

1. Shut the computer down, plug in the USB stick and start it, pressing the boot menu key. See [Try Nubo OS from a USB stick](/desktop/get-started/try-from-usb/) for how.
2. Choose the USB stick (the UEFI entry) and start the installer. The boot menu entries say Nubo OS.
3. Choose your language and keyboard layout on the first screens.
4. Connect to a network if the installer asks. Choosing a wired or Wi-Fi network is optional but helpful.
5. Choose the type of installation. The choices are Ubuntu's installer choices, shown under the Nubo name. <!-- verify label -->
6. Choose where to install:
   - To use the whole disk, choose to erase the disk. Everything on it is lost.
   - To keep another system, choose the option that installs alongside it, or do the partitioning yourself.
7. Create your account: your name, the computer's name, a user name and a password.
8. Choose your time zone. The installer guesses it from your location. This is one of the few remaining contacts with a Canonical server (`geoip.ubuntu.com`). If you prefer, set it by hand.
9. Check the summary, then start the install. A slideshow with Nubo's illustrations runs while it copies files.
10. When the installer says it is done, restart. Remove the USB stick when asked.

## What happens after you start the install

1. The installer sets up the disk and installs the base system.
2. As its last step, it copies the Nubo packages from the stick (`/cdrom/nubo/pool`) into the new system and installs them. This is what turns the base system into the Nubo OS desktop.
3. The system restarts.
4. On the first boot, two background jobs run: the first-boot cleanup and the Nubo account setup. They need a network and retry on the next boot if you are offline. See [Your first login](/desktop/get-started/first-login/).

## Verify

1. After the restart, you reach a login screen with the Nubo wallpaper and your user name.
2. Sign in, then open Settings and About. The operating system reads "Nubo OS 1". <!-- verify label -->
3. In a terminal, run:

```bash
dpkg -l nubo-desktop
```

The first column shows `ii` when the package is installed.

## Troubleshooting

- **The installer stops at "installing packages" or a network step.** The installer tries Nubo Cumulus first. If your network blocks it, the installer should fall back to the packages on the stick. Wait a few minutes, then check the network and restart the install.
- **The computer boots into the old system, not Nubo OS.** Open the firmware boot menu and select the entry for Nubo OS. On a normal start the boot menu is hidden, and the boot loader entry is still named Ubuntu internally, because the signed boot loader looks for its files there. This is expected.
- **Wi-Fi is not found in the installer.** Use a wired connection, or continue offline and set up Wi-Fi after the install. See [Wi-Fi and network problems](/desktop/troubleshooting/wifi-and-network/).
- **The first boot shows plain apps and no Firefox.** The first-boot app downloads need a network. Connect, restart, and wait. See [Apps not opening](/desktop/troubleshooting/apps-not-opening/).
- **Anything else at boot.** See [Boot problems](/desktop/troubleshooting/boot-problems/).

## See also

- [Your first login](/desktop/get-started/first-login/)
- [What the installer does](/desktop/get-started/what-the-installer-does/)
- [Ubuntu's install tutorial](https://ubuntu.com/tutorials/install-ubuntu-desktop) for the generic installer screens
