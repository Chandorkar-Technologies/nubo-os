---
title: Monitoring basics
description: "Check the health of a Nubo OS Server with built-in tools: load, memory, disk, failed services, listening ports and logs."
sidebar:
  order: 110
---

**Applies to:** Server, Virtualization, Containers, Edge

You do not need a monitoring platform to answer "is this server healthy?". A handful of built-in commands, run in order, find most problems. This page gives that routine, then suggests when to move to proper monitoring. Nubo OS does not ship a monitoring stack.

:::note
`htop` and `curl` are part of the Server, Virtualization and Containers editions. The Edge edition does not include them; install them with `sudo apt install htop curl` if you want them.
:::

## Before you begin

- Logged in as a user with `sudo`.

## Steps

Run these in order. Each takes a few seconds.

### 1. Uptime and load

```bash
uptime
nproc
```

`uptime` shows how long the machine has run and three load averages (1, 5 and 15 minutes). As a rough guide, a load that stays well above the number of CPUs from `nproc` means work is waiting.

### 2. Memory

```bash
free -h
```

Look at the `available` column, not `free`: Linux uses spare memory for caches. A small `available` together with heavy swap use is a warning.

### 3. Disk space and inodes

```bash
df -h
df -i
```

A file system above about 90 percent is worth attention; a full `/` can stop updates, logs and services. `df -i` shows inodes: millions of tiny files can fill the inodes before the space. To find the largest folders:

```bash
sudo du -xh / --max-depth=2 2>/dev/null | sort -rh | head -15
```

### 4. What uses the CPU and memory

```bash
htop
ps aux --sort=-%mem | head
```

In `htop`, <kbd>F6</kbd> changes the sort column and <kbd>q</kbd> quits.

### 5. Failed services

```bash
systemctl --failed
```

No listed units is the healthy result. For a failed unit, read `journalctl -u name -b`. See [Services with systemd](/server/administer/services-with-systemd/).

### 6. Recent errors in the log

```bash
journalctl -p err -b --no-pager | tail -n 30
```

See [Logs with journald](/server/administer/logs-with-journald/).

### 7. What is listening on the network

```bash
sudo ss -tlnp
```

Compare with what you expect, and with the firewall ([Firewall with ufw](/server/administer/firewall-ufw/)). A service listening on `0.0.0.0` or `[::]` is reachable from outside unless the firewall blocks it; one on `127.0.0.1` is local only.

### 8. Pending updates and reboots

```bash
apt list --upgradable 2>/dev/null | head
test -f /var/run/reboot-required && echo "reboot required"
```

See [Updates and reboots](/server/administer/updates-and-reboots/).

### 9. Time and bans

```bash
chronyc tracking | grep 'Leap status'
sudo fail2ban-client status sshd
```

The second command applies to editions with fail2ban (not Edge).

## A simple check script

Put the routine in one script that you can run by hand or from a timer:

```bash title="/usr/local/bin/health-check"
#!/bin/sh
echo "== uptime";  uptime
echo "== memory";  free -h | sed -n 1,2p
echo "== disk";    df -h / /boot 2>/dev/null
echo "== failed";  systemctl --failed --no-legend
echo "== reboot";  [ -f /var/run/reboot-required ] && echo "reboot required" || echo "no"
```

```bash
sudo chmod +x /usr/local/bin/health-check
health-check
```

## Verify

The routine passes when: load is below the CPU count, `available` memory is more than a fifth of the total, no file system is nearly full, `systemctl --failed` lists nothing, and only the ports you expect are listening.

## When to go further

Checking by hand does not tell you about a problem at 3 a.m. For several servers, or for alerts, consider a metrics tool such as Prometheus with node_exporter, or a service of your choice. Ubuntu's documentation lists options (Logwatch, Munin, Nagios and others). We have not tested any of them on Nubo OS Server.

## Troubleshooting

**`htop: command not found`.** You are on Edge or removed it. `sudo apt install htop`.

**`free -h` shows almost no free memory.** That is normal: Linux fills spare memory with cache. Read `available`.

**`df` shows the disk full but `du` finds less.** A deleted file is still held open by a running program. Find it with `sudo lsof +L1` (install `lsof` first), then restart that program.

**`ss` shows nothing for a service you started.** The service may listen on a Unix socket, not a network port, or it failed. Check `systemctl status name`.

**High load but low CPU use.** Processes may wait for disk. Check `top` for a high `wa` value, and the disk with `iostat` (from the `sysstat` package, not installed by default).

## See also

- [Services with systemd](/server/administer/services-with-systemd/)
- [Logs with journald](/server/administer/logs-with-journald/)
- [Ubuntu Server: observability](https://ubuntu.com/server/docs/)
