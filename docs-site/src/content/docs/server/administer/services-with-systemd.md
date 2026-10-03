---
title: Services with systemd
description: Start, stop, enable and inspect services on Nubo OS Server, and write a small service of your own.
sidebar:
  order: 70
---

**Applies to:** Server, Virtualization, Containers, Edge

Nubo OS Server uses systemd to start and supervise services, exactly as Ubuntu does. This page covers the commands you use every day and shows how to turn a program into a service. It also lists the units Nubo switches off on purpose.

## Before you begin

- Logged in as a user with `sudo`.
- A service you want to manage. The examples use `ssh` and `chrony`, which are present on every Nubo OS Server.

## Steps

### Check the state of a service

```bash
systemctl status ssh
systemctl is-active ssh
systemctl is-enabled ssh
```

`active` means it is running now. `enabled` means it starts at boot. They are independent.

### Start, stop and restart

```bash
sudo systemctl start name
sudo systemctl stop name
sudo systemctl restart name      # stop then start
sudo systemctl reload name       # re-read the configuration without stopping, if the service supports it
```

### Start at boot

```bash
sudo systemctl enable name
sudo systemctl enable --now name     # enable and start in one step
sudo systemctl disable --now name
```

### List what is running or broken

```bash
systemctl list-units --type=service --state=running
systemctl --failed
systemctl list-timers
```

### Find out what is slow at boot

```bash
systemd-analyze
systemd-analyze blame | head
```

### Change a service without editing the packaged file

Create an override. It lives in `/etc/systemd/system/<name>.service.d/override.conf` and survives package updates.

```bash
sudo systemctl edit ssh
```

An editor opens. For example, to restart a service if it ever fails:

```ini
[Service]
Restart=on-failure
RestartSec=5
```

Save and close. systemd reloads its configuration by itself when you use `systemctl edit`. To see the combined result: `systemctl cat ssh`.

### Write your own service

Say you have a program at `/opt/hello/hello.sh` that should run all the time as an unprivileged user.

1. Create a dedicated user without a login:

   ```bash
   sudo adduser --system --group --no-create-home hello
   ```

2. Create the unit file:

   ```ini title="/etc/systemd/system/hello.service"
   [Unit]
   Description=Hello example service
   After=network-online.target
   Wants=network-online.target

   [Service]
   Type=simple
   User=hello
   Group=hello
   ExecStart=/opt/hello/hello.sh
   Restart=on-failure
   RestartSec=5
   NoNewPrivileges=true
   ProtectSystem=strict
   ProtectHome=true
   PrivateTmp=true

   [Install]
   WantedBy=multi-user.target
   ```

   `NoNewPrivileges`, `ProtectSystem`, `ProtectHome` and `PrivateTmp` limit what the program can touch. Add `ReadWritePaths=/var/lib/hello` if it must write somewhere.

3. Load and start it:

   ```bash
   sudo systemctl daemon-reload
   sudo systemctl enable --now hello.service
   ```

### Run a job on a schedule

A timer replaces cron for most jobs. Create `hello.timer` next to the service, with a matching name:

```ini title="/etc/systemd/system/hello.timer"
[Unit]
Description=Run hello every day

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target
```

```bash
sudo systemctl enable --now hello.timer
systemctl list-timers hello.timer
```

For a timer, enable the `.timer` and not the `.service`.

## Units that Nubo masks

`nubo-base` masks (links to `/dev/null`) these units so that nothing is sent to Canonical and no adverts appear:

`motd-news.timer`, `motd-news.service`, `whoopsie.service`, `whoopsie.path`, `apport.service`, `apport-autoreport.path`, `apport-autoreport.timer`, `apport-autoreport.service`, `ua-timer.timer`, `ua-timer.service`, `apt-news.service`, `esm-cache.service`, `ubuntu-advantage.service`, `ubuntu-advantage-desktop-daemon.service`.

A masked unit cannot be started, even by hand. To undo one, remove the link in `/etc/systemd/system/`, for example `sudo rm /etc/systemd/system/apt-news.service`, then run `sudo systemctl daemon-reload`. The full list with reasons is in [What the defaults do](/server/security/what-the-defaults-do/).

## Verify

```bash
systemctl status hello.service --no-pager
journalctl -u hello.service -n 20 --no-pager
```

The status shows `active (running)`. To prove that it survives a reboot, run `sudo reboot` and check again.

## Troubleshooting

**`Failed to start ... Unit not found`.** The file name or path is wrong, or you did not run `sudo systemctl daemon-reload` after creating it.

**`status=203/EXEC`.** `ExecStart` points to a file that does not exist or is not executable. Check the path and `chmod +x`.

**`status=217/USER`.** The `User=` name does not exist.

**The service starts and exits straight away.** `Type=simple` expects the program to stay in the foreground. A program that forks into the background needs `Type=forking`, or better, a foreground option.

**`Unit ... is masked`.** Someone masked it. Nubo masks the units listed above. Use `systemctl status name` to confirm and the removal step above to undo.

**Reading why something fails.** `journalctl -u name -b` shows the log for this boot. See [Logs with journald](/server/administer/logs-with-journald/).

## See also

- [Logs with journald](/server/administer/logs-with-journald/)
- [Monitoring basics](/server/administer/monitoring-basics/)
- [systemd documentation: systemd.service](https://www.freedesktop.org/software/systemd/man/latest/systemd.service.html)
