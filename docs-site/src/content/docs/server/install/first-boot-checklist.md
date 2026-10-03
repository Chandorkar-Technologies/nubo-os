---
title: First boot checklist
description: Commands to run on a new Nubo OS Server to confirm the identity, firewall, package sources, time sync and automatic updates.
sidebar:
  order: 60
---

**Applies to:** Server, Virtualization, Containers, Edge

Run through this list after the first login on a new server. Each check takes one command and tells you what the machine is configured to do. Items marked *Server and Edge* or *Server only* depend on the edition.

## Before you begin

- A freshly installed Nubo OS Server that you can log in to on the console or over SSH.
- The user you created in the installer. Commands that need administrator rights use `sudo`.

## Steps

### 1. Confirm the system identity

```bash
cat /etc/os-release
```

```text
PRETTY_NAME="Nubo OS Server 1"
NAME="Nubo OS Server"
VERSION_ID="26.04"
VERSION="1"
VERSION_CODENAME=resolute
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://nubosuite.tech/"
SUPPORT_URL="https://docs.nubosuite.tech/"
BUG_REPORT_URL="mailto:support@nubo.email"
UBUNTU_CODENAME=resolute
```

`ID=ubuntu` is deliberate: software that checks for Ubuntu keeps working. Ubuntu's original file is kept as `/usr/lib/os-release.ubuntu`.

### 2. Check the firewall

```bash
sudo ufw status verbose
```

Expected output on a fresh install:

```text
Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), disabled (routed)
New profiles: skip

To                         Action      From
--                         ------      ----
22/tcp (OpenSSH)           ALLOW IN    Anywhere
22/tcp (OpenSSH (v6))      ALLOW IN    Anywhere (v6)
```

Only SSH is open. To open anything else, see [Firewall with ufw](/server/administer/firewall-ufw/).

### 3. Check where packages come from

```bash
apt policy | grep -i nubosuite
```

You should see lines with `archive.nubosuite.tech`: the Nubo archive (suite `resolute`) and the Cumulus cache for Ubuntu's packages. To see the source files:

```bash
cat /etc/apt/sources.list.d/nubo.sources
cat /etc/apt/sources.list.d/ubuntu.sources
```

`nubo.sources` points at the Nubo archive. `ubuntu.sources` points at Nubo Cumulus with Ubuntu's servers as a fallback. Ubuntu's original is kept as `ubuntu.sources.ubuntu`. For channels (stable and beta) see [Updates](/updates/).

### 4. Update the package lists and install updates

```bash
sudo apt update
sudo apt full-upgrade
```

If a new kernel was installed, reboot when it suits you (see [Updates and reboots](/server/administer/updates-and-reboots/)).

### 5. Check time sync

```bash
chronyc tracking
chronyc sources
```

`chronyc tracking` shows `Leap status : Normal` once the clock is synchronized. `chronyc sources` lists `time.cloudflare.com` and servers from `pool.ntp.org`. See [Time with chrony](/server/administer/time-with-chrony/).

Also check the time zone:

```bash
timedatectl
```

### 6. Check automatic updates (Server, Virtualization, Containers and Edge)

```bash
systemctl status unattended-upgrades --no-pager
apt-config dump | grep -i Unattended-Upgrade::Automatic-Reboot
```

The service should be active, and the reboot option shows `"false"`: the machine installs updates but never reboots itself. The configuration is explained in [Updates and reboots](/server/administer/updates-and-reboots/).

### 7. Check the extra security tools (not on Edge)

```bash
systemctl is-active fail2ban
systemctl is-active apparmor
```

Both should print `active`. Edge includes AppArmor but not fail2ban. See [fail2ban](/server/security/fail2ban/) and [AppArmor](/server/security/apparmor/).

### 8. Check SSH

```bash
sudo sshd -T | grep -E 'permitrootlogin|maxauthtries|logingracetime|x11forwarding|passwordauthentication'
```

```text
permitrootlogin no
maxauthtries 4
logingracetime 30
x11forwarding no
passwordauthentication yes
```

Password login is on until you install a key and turn it off yourself. See [SSH keys and hardening](/server/administer/ssh-keys-and-hardening/).

### 9. Set up your first admin tasks

1. Install an SSH key for your user and test it.
2. Turn off password login for SSH.
3. Note the server's address (`ip -br address`) and write it down.
4. Take a first backup plan: see [Backups](/server/administer/backups/).

## Verify

If steps 1 to 8 gave the results above, the machine matches Nubo's documented defaults. You can see every setting Nubo applies in [What the defaults do](/server/security/what-the-defaults-do/).

## Troubleshooting

**`apt policy` shows no `nubosuite` lines.** The `nubo-archive` package may have been removed or the installer's last step failed. Check `dpkg -l | grep nubo`. If the packages are missing, see the installer log in `/var/log/installer/`.

**`ufw status` says `inactive`.** The firewall was not enabled. The package enables it only on first install. Run `sudo /usr/libexec/nubo/nubo-server-firewall`, which closes everything except SSH. Be aware that it resets all existing ufw rules first.

**`chronyc` says `506 Cannot talk to daemon`.** chrony is not running. Check `systemctl status chrony`.

**`/etc/os-release` still says Ubuntu.** The `nubo-server-core` package did not install. Check `dpkg -l nubo-server-core`.

**`sshd -T` shows `passwordauthentication yes`.** That is the expected default. Change it as described in [SSH keys and hardening](/server/administer/ssh-keys-and-hardening/).

## See also

- [Administer](/server/administer/)
- [What the defaults do](/server/security/what-the-defaults-do/)
