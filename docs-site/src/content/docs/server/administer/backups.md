---
title: Backups
description: "Back up a Nubo OS Server with restic: create a repository, run a backup, schedule it, restore files and test that restores work."
sidebar:
  order: 100
---

**Applies to:** Server, Virtualization, Containers, Edge

A backup you have never restored is a hope, not a backup. This page uses **restic**, a free backup program, as one reasonable choice. restic is in Ubuntu's `universe` repository, so it installs through the same sources as everything else. Nubo OS does not ship a backup tool of its own. A Nubo Backup product is planned but not built.

:::caution[Planned]
Nubo Backup is not available yet. Use the steps below, or any other backup tool you trust.
:::

The commands below are restic's standard commands. Run them on a test machine first, and always finish with a test restore.

## What to back up

| Back up | Why |
|---|---|
| `/etc` | Your configuration, including `/etc/ssh`, `/etc/netplan` and `/etc/fstab`. |
| `/home` | User files. |
| `/srv`, `/var/lib/<service>` | Data of the services you run. For databases, dump them first (for example `pg_dump`), because copying a live database's files can give a broken backup. |
| A list of installed packages | `dpkg --get-selections > /root/packages.txt` makes it simple to rebuild. |

You do not need to back up `/usr`, `/var/cache` or `/tmp`. Reinstalling Nubo OS Server restores them.

Keep one copy **off the machine**: another disk, another computer or object storage. A backup on the same disk does not protect against a failed disk.

## Before you begin

- Logged in as a user with `sudo`.
- A place for the repository: a mounted disk (the example uses `/mnt/backup`), or an SFTP or S3-compatible address (see restic's documentation).
- Enough space: the first backup is about the size of your data; later ones add only changes.

## Steps

### 1. Install restic

```bash
sudo apt update
sudo apt install restic
restic version
```

### 2. Create a password file and a repository

The repository is encrypted with a password. **Store the password somewhere other than this server.** Without it the backup cannot be read.

```bash
sudo mkdir -p /root/.config
sudo sh -c 'umask 077; head -c 32 /dev/urandom | base64 > /root/.config/restic-password'
sudo cat /root/.config/restic-password
```

Copy the printed password to your password manager now. Then create the repository:

```bash
sudo mkdir -p /mnt/backup/repo
sudo restic -r /mnt/backup/repo --password-file /root/.config/restic-password init
```

### 3. Run a backup

```bash
sudo restic -r /mnt/backup/repo --password-file /root/.config/restic-password \
  backup /etc /home /srv --exclude-caches
```

### 4. List snapshots

```bash
sudo restic -r /mnt/backup/repo --password-file /root/.config/restic-password snapshots
```

### 5. Test a restore

Restore the newest snapshot into a scratch folder and compare:

```bash
sudo restic -r /mnt/backup/repo --password-file /root/.config/restic-password \
  restore latest --target /tmp/restore-test --include /etc/hostname
cat /tmp/restore-test/etc/hostname
sudo rm -r /tmp/restore-test
```

To restore a whole path instead, drop `--include` and choose a target with room.

### 6. Schedule it with a systemd timer

```ini title="/etc/systemd/system/restic-backup.service"
[Unit]
Description=Restic backup

[Service]
Type=oneshot
ExecStart=/usr/bin/restic -r /mnt/backup/repo --password-file /root/.config/restic-password backup /etc /home /srv --exclude-caches
ExecStartPost=/usr/bin/restic -r /mnt/backup/repo --password-file /root/.config/restic-password forget --keep-daily 7 --keep-weekly 4 --keep-monthly 6 --prune
```

```ini title="/etc/systemd/system/restic-backup.timer"
[Unit]
Description=Daily restic backup

[Timer]
OnCalendar=*-*-* 02:30:00
Persistent=true
RandomizedDelaySec=15m

[Install]
WantedBy=timers.target
```

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now restic-backup.timer
systemctl list-timers restic-backup.timer
```

`forget --prune` deletes snapshots older than the keep rules (7 daily, 4 weekly, 6 monthly) and frees the space. Choose numbers that fit how far back you may need to go.

### 7. Check the repository now and then

```bash
sudo restic -r /mnt/backup/repo --password-file /root/.config/restic-password check
```

## Verify

```bash
sudo systemctl start restic-backup.service
journalctl -u restic-backup.service -n 20 --no-pager
sudo restic -r /mnt/backup/repo --password-file /root/.config/restic-password snapshots
```

A new snapshot appears with the current time. Then do the restore test in step 5. Repeat the restore test from time to time, and once on a different machine, to prove you can recover without the original server.

## Troubleshooting

**`Fatal: unable to open config file` or `repository does not exist`.** The path is wrong, or the disk is not mounted. Check `findmnt /mnt/backup`.

**`wrong password or no key found`.** The password file does not match the repository. Use the password you saved when you created it.

**`Fatal: unable to create lock in backend: repository is already locked`.** Another restic run is active, or one died. If you are sure that none is running, remove stale locks with `restic unlock`.

**The backup takes long or is large.** Add `--exclude` patterns for caches and large files you do not need, and check `du -sh /home/*`.

**The timer did not run.** `systemctl list-timers` shows the next run. `journalctl -u restic-backup.service` shows the last result.

## See also

- [Disks and LVM](/server/administer/disks-and-lvm/)
- [restic documentation](https://restic.readthedocs.io/)
- [Ubuntu Server: backups](https://ubuntu.com/server/docs/how-to/backups/)
