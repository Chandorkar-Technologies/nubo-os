---
title: Logs with journald
description: Read, filter and size the system logs on Nubo OS Server with journalctl.
sidebar:
  order: 80
---

**Applies to:** Server, Virtualization, Containers, Edge

systemd's journal collects logs from the kernel, services and login sessions in one place. You read it with `journalctl`. Nubo does not change the journal's settings. This page shows the queries you will use most and how to stop the journal from using too much disk.

## Before you begin

- Logged in as a user in the `sudo` group. Without `sudo` or membership of the `systemd-journal` or `adm` group you only see your own messages.

## Steps

### Read recent logs

```bash
journalctl -e                 # jump to the end
journalctl -n 100 --no-pager  # the last 100 lines
journalctl -f                 # follow live, like tail -f
```

### Filter by service

```bash
journalctl -u ssh
journalctl -u chrony --since "1 hour ago"
journalctl -u unattended-upgrades
```

### Filter by time

```bash
journalctl --since "2026-10-03 09:00" --until "2026-10-03 10:00"
journalctl --since yesterday
```

### Filter by boot

```bash
journalctl --list-boots
journalctl -b          # this boot
journalctl -b -1       # the previous boot
```

Looking at the previous boot works only if the journal is stored on disk (see below).

### Filter by priority

```bash
journalctl -p err -b           # errors and worse since boot
journalctl -p warning..emerg
```

### Kernel messages and the firewall

```bash
journalctl -k
journalctl -k | grep UFW
```

### Failed logins

```bash
journalctl -u ssh | grep -i 'failed\|invalid'
sudo fail2ban-client status sshd
```

The second command works on editions that include fail2ban (not Edge). See [fail2ban](/server/security/fail2ban/).

### Check how much space the journal uses

```bash
journalctl --disk-usage
ls /var/log/journal
```

If `/var/log/journal` exists, the journal is stored on disk and survives reboots. If it does not exist, the journal lives in memory and is lost at reboot. Create the folder and restart journald to keep logs: `sudo mkdir -p /var/log/journal && sudo systemctl restart systemd-journald`.

### Limit the size

Create a drop-in instead of editing the main file:

```ini title="/etc/systemd/journald.conf.d/50-size.conf"
[Journal]
SystemMaxUse=500M
MaxRetentionSec=1month
```

```bash
sudo systemctl restart systemd-journald
```

To trim the journal once, right now:

```bash
sudo journalctl --vacuum-size=500M
sudo journalctl --vacuum-time=30d
```

### Send logs to another machine

For more than one server, ship the journal to a central place. That is outside this page; see Ubuntu's documentation for `systemd-journal-remote` or rsyslog forwarding.

## Verify

Make a test message and find it:

```bash
logger -t nubo-test "hello from the docs"
journalctl -t nubo-test -n 1 --no-pager
```

The output shows the message with the date and your server's name.

After setting a size limit:

```bash
journalctl --disk-usage
systemctl show systemd-journald -p SystemMaxUse 2>/dev/null
```

<!-- verify: systemctl show output property name -->

## Troubleshooting

**`No journal files were found` or you see only your own messages.** You are not in a group that may read the system journal. Use `sudo`, or add your user to the `systemd-journal` group: `sudo usermod -aG systemd-journal alice` (log out and in).

**Logs from before the reboot are missing.** The journal is not persistent. Create `/var/log/journal` as above.

**`/var/log/auth.log` does not exist.** On a minimal install the traditional text log files may not be present, because the journal is the main log. Use `journalctl -u ssh` for login events.

**The journal fills the disk.** Set `SystemMaxUse` as above, and run `sudo journalctl --vacuum-size=500M` once. Find the cause of a noisy service with `journalctl --since today | awk '{print $5}' | sort | uniq -c | sort -rn | head`.

**Timestamps look wrong.** Check the time zone with `timedatectl` and sync with [Time with chrony](/server/administer/time-with-chrony/). `journalctl --utc` prints UTC.

## See also

- [Services with systemd](/server/administer/services-with-systemd/)
- [Monitoring basics](/server/administer/monitoring-basics/)
- [journalctl manual](https://www.freedesktop.org/software/systemd/man/latest/journalctl.html)
