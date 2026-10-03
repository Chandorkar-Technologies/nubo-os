---
title: What contacts the internet
description: Every outside address a Nubo OS Server uses, what Nubo has switched off, what still talks to Canonical, and how to check it yourself.
sidebar:
  order: 50
---

**Applies to:** Server, Virtualization, Containers, Edge

A server should do only the network traffic you expect. This page lists the places a Nubo OS Server contacts by itself, the Ubuntu services that Nubo has switched off or redirected, and the contacts that remain. It is based on the repository file `docs/ubuntu-endpoints.md`, written after searching a running Nubo OS machine for Ubuntu and Canonical addresses (3 October 2026), and rewritten here for server administrators. The research was done on a desktop virtual machine; the server packages apply the same switches. <!-- verify: re-run the address search on a server install -->

## Explanation: what Nubo Cumulus is

Nubo Cumulus is a small service running on Cloudflare that sits in front of Ubuntu's archive and image servers. When your server downloads Ubuntu's packages, the request goes to https://archive.nubosuite.tech/cumulus (amd64) or `/cumulus-arm` (arm64). Cumulus fetches the file from Ubuntu, caches it and returns it unchanged. The files stay signed by Ubuntu, and `apt` verifies those signatures as always. If Cumulus is not reachable, `apt` falls back to Ubuntu's own servers.

This does not make your traffic anonymous. Ubuntu's servers see requests from Cloudflare, not from you. Nubo's service (on Cloudflare) can see the address and requested package names of each request, as any web server can. We do not describe here what is kept in logs, and you should not assume none are. <!-- verify: logging and retention policy for archive.nubosuite.tech -->

## What the server contacts

### Through Nubo

| Purpose | Address | Replaces | Set by |
|---|---|---|---|
| Nubo packages and updates | https://archive.nubosuite.tech (suites `resolute`, `resolute-beta`) | (none) | `nubo-archive` |
| Ubuntu packages (amd64) | https://archive.nubosuite.tech/cumulus | archive.ubuntu.com, security.ubuntu.com | `nubo-archive`, installer answer file |
| Ubuntu packages (arm64) | https://archive.nubosuite.tech/cumulus-arm | ports.ubuntu.com | `nubo-archive`, installer answer file |
| Network connectivity check (only if NetworkManager runs) | https://archive.nubosuite.tech/check | connectivity-check.ubuntu.com | `nubo-base` |
| Installer images | https://archive.nubosuite.tech/iso/ | (none) | CI uploads; see [Choose an image](/server/install/choose-an-image/) |

Other Cumulus paths exist for Ubuntu's image servers (`/cumulus-images`, `/cumulus-releases`, `/cumulus-cloud`). They are used by Nubo's image build scripts and CI, not by an installed server.

### Time servers

| Address | Protocol | Set by |
|---|---|---|
| time.cloudflare.com | NTP with NTS (TCP 4460 for key setup, UDP 123 for time) | `nubo-base`, in the chrony sources file |
| pool.ntp.org | Plain NTP (UDP 123) | `nubo-base` |

These replace `ntp.ubuntu.com`. See [Time with chrony](/server/administer/time-with-chrony/).

### Ubuntu's own servers, as a fallback

If Cumulus fails, `apt` uses Ubuntu's archive servers. Those are listed in `/etc/apt/sources.list.d/ubuntu.sources` through the mirror list at https://archive.nubosuite.tech/cumulus/mirrors.txt, where Cumulus has priority 1 and Ubuntu's server priority 2.

## What is switched off

| Address | What it did | How Nubo switches it off |
|---|---|---|
| motd.ubuntu.com | Login "news" | `nubo-base` masks `motd-news`; `nubo-server-core` sets `ENABLED=0` and removes the login scripts |
| daisy.ubuntu.com | Crash reports (whoopsie, apport) | `nubo-base` masks them and sets `enabled=0` for apport |
| changelogs.ubuntu.com | Release-upgrade check | `nubo-base` sets `Prompt=never` |
| debuginfod.ubuntu.com | Debug symbol server | `nubo-base` installs an empty server list |
| esm.ubuntu.com, contracts.canonical.com, landscape.canonical.com | Ubuntu Pro adverts and services | `nubo-base` masks the timers; `nubo-server-core` conflicts with `ubuntu-pro-client`, `ubuntu-advantage-tools` and `landscape-common` |
| The snap store (Canonical's) | Snap packages and refreshes | `nubo-server-core` conflicts with `snapd`; the installer installs no snaps |

The installer answer file also turns off the installer update check, the geo-IP lookup for mirrors and the featured snaps list (`refresh-installer: update: false`, `geoip: false`, `snaps: []`).

## What still contacts the outside

| Address | Why | Notes |
|---|---|---|
| Ubuntu's base ISO, on first download | Nubo's images are built from Ubuntu's live server image, which is downloaded from Canonical through Cumulus when Nubo builds a release | This happens at build time, not on your server. The file is signed by Canonical and its checksum is verified in the build. |
| keyserver.ubuntu.com | Only when you run a key-fetch command yourself | Leave it, or use another keyserver. |
| Documentation links such as www.ubuntu.com, help.ubuntu.com and launchpad.net | Text inside Ubuntu's own packages and man pages | Cosmetic; the server does not fetch them. Nubo's own pages use docs.nubosuite.tech. |
| Ubuntu's archive servers | When Cumulus is unreachable | See above. |
| Whatever you install | Every package you add may contact its own services | Check each one. |

Two items from the desktop list do not apply to a server: the desktop sign-in broker, which is a snap, and the desktop installer's time zone lookup. The server's `nubo-server-core` conflicts with `snapd`, and the server answer file turns geo-IP off.

## Before you begin

- A running server and `sudo`.
- A second window to read output while you change nothing.

## Steps: check it yourself

### See which servers `apt` uses

```bash
apt-cache policy | grep -E 'http|mirror' | sort -u
cat /etc/apt/sources.list.d/ubuntu.sources
```

### See open connections and listeners

```bash
sudo ss -tunp
sudo ss -tlnp
```

`-t` is TCP, `-u` UDP, `-n` numbers, `-p` the program. Run the first command a few times, and again just after an `apt update`.

### See name lookups

```bash
sudo resolvectl statistics
sudo tcpdump -ni any port 53
```

`tcpdump` is not installed by default (`sudo apt install tcpdump`). Press <kbd>Ctrl</kbd>+<kbd>C</kbd> to stop. You see the names the server looks up.

### Check that the masked units are masked

```bash
systemctl is-enabled motd-news.timer whoopsie.service apport.service ua-timer.timer
```

Each line prints `masked`.

### Check that the unwanted packages are absent

```bash
dpkg -l snapd ubuntu-pro-client landscape-common 2>&1 | grep -E '^ii|no packages'
```

No line starting with `ii` means they are not installed.

### Restrict outgoing traffic if you need to

The default firewall allows all outgoing connections. To allow only what you need, change the default and add rules for DNS, NTP, NTS and the archive:

```bash
sudo ufw default deny outgoing
sudo ufw allow out 53
sudo ufw allow out 123/udp
sudo ufw allow out 4460/tcp
sudo ufw allow out 443/tcp
```

Test with `sudo apt update` before you log out. This is a starting point, not a complete policy. Keep console access in case you lock out something that you need.

## Opt out of Cumulus

`nubo-archive` checks for a marker file when it is configured. If `/etc/nubo/no-cumulus` exists, Ubuntu's sources file is left alone and Ubuntu's own servers are used directly:

```bash
sudo mkdir -p /etc/nubo
sudo touch /etc/nubo/no-cumulus
```

Create the marker before the first install of `nubo-archive` to get this behavior cleanly. Switching an already-installed machine back is not a tested path; the original file is kept as `/etc/apt/sources.list.d/ubuntu.sources.ubuntu`. The Nubo archive itself (Nubo's own packages) still comes from archive.nubosuite.tech.

## Verify

Run `sudo apt update` and look at the addresses it fetches: they should be archive.nubosuite.tech paths only. Run `sudo ss -tunp` while idle and compare with the tables above.

## Troubleshooting

**`apt` fetches from archive.ubuntu.com.** Cumulus may be unreachable and `apt` is using its fallback, or the marker `/etc/nubo/no-cumulus` is set. Check `https://archive.nubosuite.tech/cumulus/` with `curl -I`.

**You see a connection to an address that is not in the tables.** It may come from a package you installed. Find the program with `sudo ss -tunp` and check its documentation. If it is part of Nubo's packages, report it to support@nubo.email.

**`apt update` fails after you restricted outgoing traffic.** Allow outgoing 443/tcp and DNS, and the fallback servers if you want them.

**The time does not sync after you restricted outgoing traffic.** Allow outgoing 123/udp and 4460/tcp.

## See also

- [What the defaults do](/server/security/what-the-defaults-do/)
- [Time with chrony](/server/administer/time-with-chrony/)
- [Updates](/updates/)
