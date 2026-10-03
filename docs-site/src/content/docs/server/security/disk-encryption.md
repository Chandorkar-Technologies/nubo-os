---
title: Disk encryption
description: Encrypt the disk of a Nubo OS Server with LUKS in the installer, and learn what it protects, how to manage the passphrase, and what to watch out for.
sidebar:
  order: 40
---

**Applies to:** Server, Virtualization, Containers, Edge

Disk encryption protects the data on a disk when the machine is switched off: if someone steals the disk or the whole server, they cannot read the data without the passphrase. Nubo OS Server offers it through the installer's storage screen, which uses LUKS, the standard Linux disk encryption. Nubo adds nothing of its own here; this is Ubuntu's installer and Ubuntu's tools. This page explains what you get, how to look after the passphrase, and the trade-offs that matter on a server.

:::caution
Encryption must be chosen **during installation**. You cannot turn it on later for the root file system without reinstalling. If you lose all passphrases and have no header backup, the data is gone. Nobody, including Nubo, can recover it.
:::

## What it protects, and what it does not

| It protects against | It does not protect against |
|---|---|
| Someone reading the disk after theft or after you dispose of it | Someone who logs in to the running server (the disk is unlocked while it runs) |
| Reading the data by moving the disk to another computer | Attacks on running services, or a stolen SSH key |
| | Data in memory, or data you copy elsewhere (backups need their own protection) |

Encryption does not replace the firewall, updates or key-only SSH. See [Security](/server/security/).

## How it is laid out

With the default layout ([Disks and LVM](/server/administer/disks-and-lvm/)), the installer creates a small EFI partition, a `/boot` partition and one large partition for LVM. If you tick **Encrypt the LVM group with LUKS**, the large partition is encrypted and the LVM volume group lives inside it. <!-- verify label -->

- `/boot/efi` and `/boot` are **not** encrypted. They hold the boot loader and the kernel, which the firmware must read before it can ask for the passphrase.
- The root file system and everything else in the volume group is encrypted.
- At every boot, the system asks for the passphrase on the console before it can start.

## Before you begin

- Decide whether you can type the passphrase at every boot. A server in a rack needs a console, a virtual console, or remote unlock. A virtual machine needs its console window.
- A way to keep the passphrase safe and separate from the machine: a password manager or a sealed paper copy.
- Time to read the caveats below.

## Steps

### Encrypt during installation

1. Start the installer ([Installer screens explained](/server/install/installer-screens-explained/)).
2. On the storage screen, keep the guided layout with LVM, and tick **Encrypt the LVM group with LUKS**. <!-- verify label -->
3. Enter a long passphrase twice. A sentence of several unrelated words is better than a short complex password.
4. Confirm the layout and continue the installation.
5. At first boot, type the passphrase when asked.

### Check that the disk is encrypted

```bash
lsblk -f
```

An encrypted setup shows a partition with the file system type `crypto_LUKS`, and below it a mapped device (often named `dm_crypt-0`) holding the LVM volume group. <!-- verify: device mapper name on 26.04 -->

```bash
sudo cryptsetup status dm_crypt-0
```

Use the mapped name that `lsblk` shows. The output says `type: LUKS2` (or LUKS1) and the cipher in use.

### Add a second passphrase

A second key slot lets you rotate passphrases or hand a recovery passphrase to a colleague. Find the encrypted partition with `lsblk -f` (it shows `crypto_LUKS`), then:

```bash
sudo cryptsetup luksDump /dev/vda3
sudo cryptsetup luksAddKey /dev/vda3
```

Replace `/dev/vda3` with your partition. The second command asks for an existing passphrase, then for the new one. Test the new one at the next boot.

### Remove an old passphrase

```bash
sudo cryptsetup luksRemoveKey /dev/vda3
```

It asks for the passphrase you want to remove. Make sure another one still works first.

### Back up the LUKS header

The header holds the encrypted master key. If it is damaged, the data cannot be opened even with the right passphrase.

```bash
sudo cryptsetup luksHeaderBackup /dev/vda3 --header-backup-file ~/luks-header-vda3.img
```

Copy the file to a safe place off the machine. Anyone who has the header and an old passphrase can open the disk, so store the backup as carefully as the passphrase.

## Recovery keys

The installer's LUKS option asks for a passphrase. As far as we can tell from the installer and the repository, it does not create a separate recovery key for you. <!-- verify: installer behavior --> The passphrase is the key. That is why the second passphrase and the header backup above matter: they are your recovery plan. Write down where each is stored and who can reach it.

## Caveats on a server

- **Reboots need a person.** After a power cut, a kernel panic or a planned restart, the server waits for the passphrase on the console. Do not turn on automatic reboot after updates on such a machine (see [Updates and reboots](/server/administer/updates-and-reboots/)). Remote unlock over the network is possible with extra tools, such as those described in [Ubuntu's Clevis and TPM documentation](https://ubuntu.com/server/docs/how-to/security/tpm-backed-luks/). We have not tested them on Nubo OS Server.
- **Performance.** On current CPUs with AES hardware support, encryption costs little, but we have not measured it on Nubo OS Server and make no claim.
- **Backups are not encrypted by this.** The data in a backup is no longer inside the encrypted volume. Use a backup tool that encrypts, such as restic ([Backups](/server/administer/backups/)).
- **Cloud and virtual machines.** In a public cloud, the provider can see the running VM's memory and disk key path in ways you cannot control. Check what threat you are protecting against.
- **You cannot change your mind later.** Moving to an encrypted root means reinstalling and restoring from a backup.

## Verify

After a reboot, the console asks for the passphrase and the system comes up. Then run `lsblk -f` and confirm `crypto_LUKS` appears. Test the second passphrase at least once, ideally before you need it.

## Troubleshooting

**The server does not boot and waits at a passphrase prompt.** That is the expected behavior; type the passphrase on the console. On a virtual machine, open its console window.

**The passphrase is rejected.** Check the keyboard layout. At this early stage the layout is the one you chose in the installer, which can differ from your daily one. Typing the passphrase in a plain text field first may help you see what you type.

**`cryptsetup luksDump` says the device is not a valid LUKS device.** You pointed at the wrong partition. Use the one that `lsblk -f` shows as `crypto_LUKS`.

**You lost the passphrase.** Without another key slot or a header backup that matches an old passphrase you remember, the data cannot be recovered. Reinstall and restore from backup.

**A disk has a damaged header.** Restore it with `sudo cryptsetup luksHeaderRestore /dev/vda3 --header-backup-file ~/luks-header-vda3.img`, from a rescue system. Do this only on the disk the header backup came from.

## See also

- [Disks and LVM](/server/administer/disks-and-lvm/)
- [Installer screens explained](/server/install/installer-screens-explained/)
- [Backups](/server/administer/backups/)
- [Ubuntu Server: security](https://ubuntu.com/server/docs/)
