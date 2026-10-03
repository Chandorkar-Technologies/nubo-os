---
title: What the defaults do
description: A complete reference of every file, setting and unit that the Nubo OS Server packages configure, and the reason for each.
sidebar:
  order: 10
---

**Applies to:** Server, Virtualization, Containers, Edge

This page lists what the Nubo packages put on a server. It is a reference: one table per package, with paths, values and reasons. Every entry comes from the package contents in the source repository (`debian/*.install`, `debian/*.postinst`, and the files under `server/`, `base/` and `repo/`). Where a value is a choice Nubo made, the reason says so.

## Package map

| Package | On which editions | Role |
|---|---|---|
| `nubo-archive` | all | Apt sources, signing key, automatic update settings, `nubo-channel` |
| `nubo-base` | all | Time servers, switches off Canonical reports and adverts, release-upgrade prompt off |
| `nubo-server-core` | all | Identity, SSH, firewall, kernel hardening, message of the day |
| `nubo-server-base` | Server, Virtualization, Containers | Core plus unattended-upgrades, fail2ban, needrestart and basic tools |
| `nubo-edge` | Edge | Core plus unattended-upgrades |
| `nubo-podman` | Containers | Server plus Podman tools |
| `nubo-incus` | Virtualization | Server plus Incus |

Dependencies: `nubo-server-core` depends on `nubo-archive`, `nubo-base`, `openssh-server`, `ufw`, `chrony` and `apparmor`. `nubo-server-base` adds `unattended-upgrades`, `fail2ban`, `needrestart`, `curl`, `ca-certificates`, `htop`, `less` and `vim-tiny`. `nubo-edge` adds only `unattended-upgrades`.

## nubo-server-core

### Files installed

| Path | Setting | Why |
|---|---|---|
| `/etc/ssh/sshd_config.d/90-nubo-sshd.conf` | `PermitRootLogin no`, `MaxAuthTries 4`, `LoginGraceTime 30`, `X11Forwarding no` | No root over SSH, fewer attempts and less time per connection, no X11 forwarding on a server. Password login is not changed. See [SSH keys and hardening](/server/administer/ssh-keys-and-hardening/). |
| `/usr/lib/sysctl.d/90-nubo-server.conf` | Kernel network and memory settings, listed below | Standard hardening values. |
| `/usr/libexec/nubo/nubo-server-firewall` | Runs ufw: reset, deny incoming, allow outgoing, allow OpenSSH, enable | A closed firewall except SSH. Run once at first install. See [Firewall with ufw](/server/administer/firewall-ufw/). |
| `/etc/update-motd.d/99-nubo-motd` | Prints "Nubo OS Server", docs address and support address at login | A short, local login message in place of Ubuntu's news and adverts. |
| `/usr/lib/os-release` | `PRETTY_NAME="Nubo OS Server 1"`, `NAME="Nubo OS Server"`, `VERSION_ID="26.04"`, `VERSION="1"`, `ID=ubuntu`, `ID_LIKE=debian`, `VERSION_CODENAME=resolute`, `UBUNTU_CODENAME=resolute` | Shows the Nubo identity while `ID=ubuntu` keeps software that checks for Ubuntu working. |
| `/etc/issue`, `/etc/issue.net`, `/etc/lsb-release` | "Nubo OS Server 1" banner; `DISTRIB_ID=NuboOS`, `DISTRIB_RELEASE=1`, `DISTRIB_CODENAME=resolute`, `DISTRIB_DESCRIPTION="Nubo OS Server 1"` | Same identity for the console banner and `lsb_release`. Copied from `/usr/share/nubo/server-os/` at install. |
| `/etc/default/grub.d/grub-nubo.cfg` | `GRUB_DISTRIBUTOR="Nubo OS"` | The boot menu says "Nubo OS". |

Ubuntu's original identity files are kept beside the new ones with the suffix `.ubuntu` (`dpkg-divert`), and return if `nubo-server-core` is removed.

### Kernel settings (`90-nubo-server.conf`)

| Setting | Value | What it does |
|---|---|---|
| `net.ipv4.conf.all.rp_filter` | 1 | Drops packets whose source address could not come from the interface they arrived on (reverse path filtering), which blunts address spoofing. |
| `net.ipv4.conf.default.rp_filter` | 1 | Same, for new interfaces. |
| `net.ipv4.conf.all.accept_redirects` | 0 | Ignores ICMP redirects, which could be used to change your routes. |
| `net.ipv4.conf.all.send_redirects` | 0 | The server does not send redirects (it is not a router). |
| `net.ipv4.icmp_echo_ignore_broadcasts` | 1 | Does not answer broadcast pings, which prevents the server from being used in amplification (smurf) attacks. |
| `net.ipv4.tcp_syncookies` | 1 | Uses SYN cookies when the connection queue is full, which helps against SYN floods. |
| `net.ipv6.conf.all.accept_redirects` | 0 | Ignores IPv6 redirects. |
| `kernel.kptr_restrict` | 2 | Hides kernel addresses even from privileged users. |
| `kernel.dmesg_restrict` | 1 | Only privileged users can read the kernel log with `dmesg`. |
| `fs.protected_hardlinks` | 1 | Users cannot create hard links to files they do not own. |
| `fs.protected_symlinks` | 1 | Restricts following symbolic links in world-writable sticky folders. |

Check a value with `sysctl net.ipv4.tcp_syncookies`. Another file that sorts later, such as one in `/etc/sysctl.d/`, can override these values.

### Post-install actions

| Action | Why |
|---|---|
| Copies `issue`, `issue.net`, `lsb-release` to `/etc` | Identity. |
| Sets `ENABLED=0` in `/etc/default/motd-news` | Stops fetching Ubuntu news. |
| Removes the execute bit from `/etc/update-motd.d/` scripts `10-help-text`, `50-motd-news`, `91-contract-ua-esm-status`, `91-release-upgrade`, `95-hwe-eol` | No help links, news, Ubuntu Pro adverts or release announcements at login. |
| Runs `update-grub` | Applies the boot menu name. |
| Runs the firewall helper on first install only (`$2` is empty) | A closed firewall from the start; later upgrades do not reset your rules. |

### Conflicts

`nubo-server-core` conflicts with `nubo-branding` (the desktop identity: a machine is a desktop or a server), `snapd`, `landscape-common`, `lxd-installer`, `ubuntu-pro-client` and `ubuntu-advantage-tools`. These are not installed on a Nubo server because they contact Canonical's services or are replaced by Nubo's choices (no snap store; Incus instead of the LXD installer stub).

## nubo-server-base, nubo-edge

| Item | Setting | Why |
|---|---|---|
| `unattended-upgrades` (both) | Configured by `nubo-archive` (below) | Security fixes without waiting for you. |
| `fail2ban` (server-base only) | Package defaults; Nubo ships no jail files. See [fail2ban](/server/security/fail2ban/) | Slows down password guessing. |
| `needrestart` (server-base only) | Package defaults | Tells you which services need a restart after updates. |
| `curl`, `ca-certificates`, `htop`, `less`, `vim-tiny` (server-base only) | Package defaults | Everyday tools. |

## nubo-base

### Files installed

| Path | Setting | Why |
|---|---|---|
| `/etc/chrony/sources.d/ubuntu-ntp-pools.sources` | `pool time.cloudflare.com iburst maxsources 2 nts` and `pool pool.ntp.org iburst maxsources 3` | Time from Cloudflare with authentication (NTS) and from the public pool, instead of Ubuntu's servers. See [Time with chrony](/server/administer/time-with-chrony/). |
| `/etc/systemd/timesyncd.conf.d/nubo-timesyncd.conf` | `NTP=time.cloudflare.com`, `FallbackNTP=pool.ntp.org` | The same servers if systemd-timesyncd is used. |
| `/etc/NetworkManager/conf.d/20-connectivity-ubuntu.conf` | Check address `https://archive.nubosuite.tech/check`, expected reply `NetworkManager is online`, every 300 seconds | The connectivity check goes to Nubo, not Canonical. Applies only if NetworkManager runs. |
| `/etc/debuginfod/elfutils.urls` | Empty | No debug-symbol server is contacted. |
| `/etc/update-manager/release-upgrades` | `Prompt=never` | No release-upgrade prompts. See [Upgrading between releases](/server/administer/upgrading-between-releases/). |

Ubuntu's originals of the chrony, debuginfod and release-upgrade files are kept with a `.ubuntu` suffix and return if `nubo-base` is removed.

### Units masked

The post-install script links these units to `/dev/null`, so they can never run:

| Unit | What it did |
|---|---|
| `motd-news.timer`, `motd-news.service` | Fetched login news from Canonical. |
| `whoopsie.service`, `whoopsie.path` | Sent crash reports. |
| `apport.service`, `apport-autoreport.path`, `apport-autoreport.timer`, `apport-autoreport.service` | Collected and reported crashes. |
| `ua-timer.timer`, `ua-timer.service` | Ubuntu Pro status checks. |
| `apt-news.service` | Fetched adverts to show in `apt` output. |
| `esm-cache.service` | Ubuntu Pro extended maintenance cache. |
| `ubuntu-advantage.service`, `ubuntu-advantage-desktop-daemon.service` | Ubuntu Pro services. |

It also sets `enabled=0` in `/etc/default/apport` and `ENABLED=0` in `/etc/default/motd-news` if those files exist.

## nubo-archive

| Path | Setting | Why |
|---|---|---|
| `/etc/apt/sources.list.d/nubo.sources` | `URIs: https://archive.nubosuite.tech`, `Suites: resolute`, `Components: main`, signed by `/usr/share/keyrings/nubo-archive-keyring.gpg` | Nubo's own packages, signed with the archive key. `sudo nubo-channel beta` changes the suite to `resolute-beta`. |
| `/usr/share/keyrings/nubo-archive-keyring.gpg` | Archive public key, fingerprint EE1A4B749E23201501F203360F7401D7AF7D2593 | Verifies the Nubo archive. |
| `/etc/apt/sources.list.d/ubuntu.sources` | `URIs: mirror+https://archive.nubosuite.tech/cumulus/mirrors.txt` (amd64) or `.../cumulus-arm/mirrors.txt` (arm64), suites `resolute`, `-updates`, `-backports`, `-security`, components `main restricted universe multiverse`, signed by Ubuntu's keyring | Ubuntu's packages through Nubo Cumulus, with Ubuntu's own servers as a fallback. Ubuntu's file is kept as `ubuntu.sources.ubuntu`. |
| `/etc/apt/apt.conf.d/52-nubo-unattended.conf` | Daily list refresh and unattended upgrade; no automatic reboot; origins Ubuntu security, Ubuntu updates, Nubo | See [Updates and reboots](/server/administer/updates-and-reboots/). |
| `/usr/sbin/nubo-channel` | Switches between `stable` and `beta` | See [Updates](/updates/). |
| `/etc/nubo/no-cumulus` (marker, not created) | If present when `nubo-archive` is configured, Ubuntu's sources file is left alone | Opt out of Cumulus. |

Ubuntu's own package signatures are not modified. Cumulus caches files; it does not rewrite them.

## nubo-podman and nubo-incus

| Package | File or command | Setting | Why |
|---|---|---|---|
| `nubo-podman` | `/etc/containers/registries.conf.d/50-nubo.conf` | `unqualified-search-registries = ["docker.io"]` | Short image names such as `alpine` are looked up on Docker Hub. |
| `nubo-podman` | `nubo-podman-init` | Enables linger and the Podman socket for your user | Rootless containers that keep running after you log out. |
| `nubo-incus` | `/usr/share/nubo/incus-preseed.yaml`, `nubo-incus-init` | A bridge named `nubobr0` and a `dir` storage pool named `default` | A working Incus after one command; adds the invoking user to `incus-admin`. |

## What is not changed

Nubo does not alter the kernel or boot loader (they are Ubuntu's signed packages), AppArmor profiles, PAM settings, the password policy, `sudo` rules, or fail2ban jails. Any behavior not in the tables above is Ubuntu 26.04 LTS behavior.

## Verify

To see which files a package installed on your machine:

```bash
dpkg -L nubo-server-core
dpkg -L nubo-base
dpkg -L nubo-archive
```

To check that the masked units are in place:

```bash
systemctl is-enabled motd-news.timer apport.service
```

Both print `masked`.

## Troubleshooting

**A file in the tables is missing on your machine.** The package may not be installed or may be on another edition. `dpkg -l | grep nubo` lists what is installed.

**A setting does not have the documented value.** A later file overrides it. For kernel settings, `sudo sysctl --system` shows the files in the order that they are read. For SSH, `sudo sshd -T` shows the effective values.

**You want to undo a default.** Prefer a drop-in file or an override instead of editing a Nubo file. Files that `nubo-base` copies from `/usr/share/nubo/base/` in its post-install script are rewritten whenever the package is configured.

## See also

- [Security](/server/security/)
- [What contacts the internet](/server/security/what-contacts-the-internet/)
- [Reference](/reference/)
