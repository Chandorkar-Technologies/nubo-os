---
title: Nubo Drive and backup
description: What Nubo plans for cloud storage and backup, and how to back up your files today with the Backup app.
sidebar:
  order: 80
---

**Applies to:** Desktop

:::caution[Planned]
Nubo Drive and Nubo Backup are not built yet. This page says what is intended and what you can do today. Nothing described under "Planned" is part of Nubo OS 1 "Flow".
:::

## Planned

- **Nubo Drive:** cloud file storage tied to your Nubo account.
- **Nubo Backup:** backups of your computer to your Nubo account.
- **A Nubo Store with its own login,** which would remember your installed apps so a new machine can offer them again. See [Nubo Store](/desktop/apps/nubo-store/).

No dates are given. The project keeps these as plans only.

## What exists today

### Files over WebDAV

If you add your Nubo account in [Online Accounts](/desktop/account/online-accounts/) (preview), the provider also connects a WebDAV folder at `davs://mail.nubo.email/dav/file`. This is the only file area that the Nubo account exposes at the moment. Whether it opens in the way you expect (as the root, or as a folder per user) has not been confirmed with a real account.

### The Backup app

The desktop recommends the `deja-dup` package. In the launcher it is named **Backup**, with the description "Back up your files". It is a standard GNOME app that backs up a folder to a drive or to a network location on a schedule. In the app grid it is inside the **Utilities** folder.

Because `deja-dup` is a recommended package, it is installed by default but can be removed.

## Back up your files now

### Before you begin

- An external drive, or a network folder you can reach, with enough free space.
- The Backup app installed. Check by opening the launcher and typing "Backup".

### Steps

1. Open **Backup** from the Utilities folder or from the launcher.
2. Choose the folders to include. Your home folder is the usual choice. <!-- verify label -->
3. Choose where to store the backup: a connected drive, or a network location.
4. Turn on automatic backups, if you want them. <!-- verify label -->
5. Start the first backup. If you set a password for encryption, store it somewhere safe. Without it you cannot restore.

### Verify

Open Backup after the first run. It lists the last backup time. To prove it works, restore a single test file to a different folder.

### Troubleshooting

**The drive is not offered as a location.** Mount it first by opening it in Files.

**The backup is slow.** The first run copies everything. Later runs copy only changes.

**The password is lost.** There is no recovery. The backup cannot be opened without it.

**Backup is not in the launcher.** Install it: `sudo apt install deja-dup`.

## See also

- [Account security](/desktop/account/account-security/)
- [Updates](/updates/)
