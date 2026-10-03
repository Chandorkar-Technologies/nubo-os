---
title: Installer screens explained
description: What each screen of the Nubo OS Server installer asks, what to choose, and which screens Nubo skips and why.
sidebar:
  order: 50
---

**Applies to:** Server, Virtualization, Containers, Edge

The Nubo OS Server installer is Ubuntu Server's text installer (Subiquity) with an answer file added to the image. The answer file is `iso/server-user-data` in the repository. It decides which screens you see. This page walks through the screens in order, then explains what Nubo skips.

The screen titles below are the ones Ubuntu's installer uses; exact wording can differ by installer version. <!-- verify label -->

## Screens you answer

The answer file marks six sections as interactive: `locale`, `keyboard`, `network`, `storage`, `identity` and `ssh`.

### 1. Language

Choose the language for the installer and the installed system. This sets the system locale.

### 2. Keyboard

Choose the keyboard layout and variant. The installer offers to detect it by asking you to press certain keys. On a headless virtual machine, pick it from the list.

### 3. Network

The installer shows each network interface and its address. For most installs, accept DHCP. Choose a manual (static) address only if you know the address, gateway and DNS servers.

The installer needs the network to fetch Ubuntu's packages. It reaches them through Nubo Cumulus at https://archive.nubosuite.tech/cumulus (amd64) or /cumulus-arm (arm64). If that is unreachable, the answer file sets `fallback: offline-install`, which installs from what is on the media. Whatever you choose here is written to Netplan on the installed system; see [Networking with Netplan](/server/administer/networking-with-netplan/).

### 4. Storage

The default is a guided layout on the whole disk, using LVM. The installer proposes:

| Mount point | Size | Purpose |
|---|---|---|
| `/boot/efi` | 1 GB | The EFI system partition, where the UEFI firmware finds the boot loader |
| `/boot` | 2 GB | Kernels and boot files, outside LVM so the boot loader can read them |
| `/` | the rest of the LVM volume group | The root file system on a logical volume |

<!-- verify label: partition sizes and order, from the installer screens seen in the test install -->

The exact numbers come from Ubuntu's installer, not from Nubo, and can change with the installer version. Check them on the review screen before you confirm.

Two options sit on this screen:

- **Set up this disk as an LVM group.** Selected by default. LVM lets you grow or add volumes later. See [Disks and LVM](/server/administer/disks-and-lvm/). <!-- verify label -->
- **Encrypt the LVM group with LUKS.** Off by default. If you turn it on, the installer asks for a passphrase that you must type at every boot. Read [Disk encryption](/server/security/disk-encryption/) first, because you cannot add encryption later without reinstalling. <!-- verify label -->

Choose **Custom storage layout** if you need separate partitions, RAID or a specific disk. The installer shows a summary and asks you to confirm before it erases anything. This is the last point where you can go back.

### 5. Profile

Enter your name, the server's name, a user name and a password. This user becomes the administrator: it is in the `sudo` group, and the root account has no password. See [Users and sudo](/server/administer/users-and-sudo/).

Pick a strong password even if you plan to switch to SSH keys, because the password is what `sudo` asks for.

### 6. SSH

Choose to install the OpenSSH server if you want to log in remotely. The screen can also import public keys from GitHub or Launchpad. If you import a key, you can later turn off password login; see [SSH keys and hardening](/server/administer/ssh-keys-and-hardening/).

Nubo's package `nubo-server-core` depends on `openssh-server`, so the SSH server is installed on every Nubo server regardless of this choice. The screen controls whether the installer sets up the SSH service and imports keys during the install.<!-- verify: behaviour when "Install OpenSSH server" is not ticked -->

### 7. Installing

A progress screen shows the installer's steps. The last of them is Nubo's: the Nubo packages on the media are installed. When it finishes you see **Installation complete** and a **Reboot Now** button. Remove the installation medium before you reboot.

## Screens Nubo skips, and why

| Screen | What Ubuntu does | Why Nubo skips it |
|---|---|---|
| Installer update | Offers to download a newer installer from Canonical's servers (`refresh-installer: update: false`) | Contacting the snap store at install time. The image already contains a working installer. |
| Type of installation | Lets you choose normal or minimized | The answer file fixes it to the minimal server (`source: id: ubuntu-server-minimal`). Nubo adds only what its edition needs. |
| Third-party drivers | Offers to search for proprietary drivers (`search_drivers: false`) | Servers rarely need them; you can install them later. |
| Mirror | Asks for an Ubuntu mirror | The answer file points to Nubo Cumulus for Ubuntu's packages, with geo-IP guessing turned off (`geoip: false`). |
| Ubuntu Pro | Offers to attach a Pro subscription | Nubo OS Server does not include the Pro client; `nubo-server-core` conflicts with it. |
| Featured snaps | Offers a list of snap packages | `snaps: []`. Nubo OS Server does not use snaps; `nubo-server-core` conflicts with `snapd`. |

The packages from Ubuntu are unchanged and are still verified with Ubuntu's own signing keys. Cumulus only caches them. The full list of network contacts is in [What contacts the internet](/server/security/what-contacts-the-internet/).

The answer file does not set a time zone or a user, so you see the same defaults as on Ubuntu Server and the time zone is whatever the installed system picks. Check it after install with `timedatectl` and change it with `sudo timedatectl set-timezone Region/City`.

## What happens at the end

After the base system is installed, the answer file runs four commands (its `late-commands`):

1. Create a temporary folder in the new system.
2. Copy the Nubo `.deb` packages from the installer media (`/cdrom/nubo/pool`) into it.
3. Install them without recommended packages, keeping Nubo's configuration files if a conflict arises (`--force-confnew`).
4. Delete the temporary folder.

On the Virtualization image there is an extra step that installs QEMU, `qemu-utils` and the matching firmware package (`ovmf` on amd64, `qemu-efi-aarch64` on arm64).

## Troubleshooting

**You expected a screen that is not there (for example Ubuntu Pro).** It is skipped on purpose, as the table shows.

**The install fails while fetching packages.** The network or archive.nubosuite.tech may be unreachable. Go back to the Network screen and check the address; then check that you can reach https://archive.nubosuite.tech/check from another machine.

**You chose the wrong disk layout.** Go back before the final confirmation. After the install starts, the only fix is to reinstall.

**You forgot to select SSH.** Install it after the first boot: `sudo apt install openssh-server`, then check `systemctl status ssh`.

## See also

- [First boot checklist](/server/install/first-boot-checklist/)
- [Automated installs](/server/autoinstall/)
- [Ubuntu's installer documentation](https://canonical-subiquity.readthedocs-hosted.com/)
