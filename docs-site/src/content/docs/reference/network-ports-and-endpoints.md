---
title: Network ports and endpoints
description: The addresses Nubo OS machines contact and the network ports the server opens.
sidebar:
  order: 50
---

This page lists the network addresses that Nubo systems use and the ports a Nubo OS machine listens on. For the reasons, and for what was switched off, see [Privacy and network endpoints](/updates/privacy-and-network-endpoints/).

## Ports opened on a server

The server packages configure the firewall (ufw) on first install:

| Direction | Default | Exceptions |
|---|---|---|
| Incoming | Deny | SSH, through the `OpenSSH` profile of ufw (TCP port 22 unless you changed the SSH port) |
| Outgoing | Allow | none |

The firewall is not rebuilt on later updates. If you open more ports (for a web server, for example), they stay open. Running `nubo-server-firewall` again resets everything to the table above. See [Commands](/reference/commands/#nubo-server-firewall).

SSH is installed and enabled on the server editions (`openssh-server`). Root login is refused (`PermitRootLogin no`). Password login stays on until you install an SSH key. Other settings: 4 authentication tries, a 30-second login grace time, no X11 forwarding. The sshd settings file is `/etc/ssh/sshd_config.d/90-nubo-sshd.conf`.

The edition packages open no further ports by themselves. Incus and Podman have their own behavior: for example, the Incus preseed creates a bridge named `nubobr0`. How that bridge interacts with the ufw rules above was not checked. <!-- verify: guest traffic through nubobr0 under ufw -->

On the desktop, no firewall is configured by Nubo packages.

## Addresses Nubo systems use

### Package and image servers

| Address | Used for | Used by |
|---|---|---|
| `https://archive.nubosuite.tech` | The Nubo package archive: `dists/`, `pool/`, the public key | apt, every edition |
| `https://archive.nubosuite.tech/cumulus` and `/cumulus-arm` | Ubuntu packages through Nubo Cumulus (amd64, arm64) | apt, every edition |
| `https://archive.nubosuite.tech/cumulus-images` | Ubuntu installer images | Nubo's image builds |
| `https://archive.nubosuite.tech/cumulus-releases` | Ubuntu release images | Nubo's server image builds |
| `https://archive.nubosuite.tech/cumulus-cloud` | Ubuntu cloud images | Nubo's cloud image builds |
| `https://archive.nubosuite.tech/check` | Network connectivity check | NetworkManager on every machine with `nubo-base` (every 300 seconds) |
| `https://archive.nubosuite.tech/iso/<version>/` | Server installer images and checksums | Downloads by people |
| `archive.ubuntu.com`, `ports.ubuntu.com` | Ubuntu's package servers | apt, as the fallback if Cumulus is down, or all the time if you [use Ubuntu's servers directly](/updates/use-ubuntus-servers-directly/) |
| `https://packages.mozilla.org/apt` | Firefox package | Desktop |
| `https://dl.flathub.org` | Flathub: apps and updates | Desktop (first boot, Nubo Store, `nubo-get`) |

### Accounts and services

| Address | Used for | Used by |
|---|---|---|
| `https://mail.nubo.email` | Nubo account sign-in (the OpenID Connect service), mail server | Desktop sign-in |
| `https://admin.nubo.email/api/personal/signup` | Creating a Nubo account | The first-run sign-in window |
| `mail.nubo.email`, port 993 (IMAP over TLS) | Mail | GNOME Online Accounts "Nubo" provider (preview) |
| `mail.nubo.email`, port 465 (SMTP over TLS) | Sending mail | Same |
| `https://mail.nubo.email/dav/cal`, `/dav/card`, `davs://mail.nubo.email/dav/file` | Calendar, contacts, files | Same |

The online accounts provider is a preview that has only been tested against a test server. See [Known issues](/reference/known-issues/).

### Time

| Address | Used for |
|---|---|
| `time.cloudflare.com` (with NTS) | Primary time server |
| `pool.ntp.org` | Fallback time servers |

### Documentation and contact

| Address | What |
|---|---|
| `https://docs.nubosuite.tech` | This documentation |
| `https://os.nubosuite.tech` | The Nubo OS website |
| `support@nubo.email` | Support |
| `security@nubosuite.tech` | Security reports; also the owner of the archive key |

## Addresses switched off

These Ubuntu and Canonical addresses are not contacted by default on Nubo OS: `motd.ubuntu.com`, `daisy.ubuntu.com`, `changelogs.ubuntu.com`, `debuginfod.ubuntu.com`, `esm.ubuntu.com`, `contracts.canonical.com`, `landscape.canonical.com`, `connectivity-check.ubuntu.com`, `ntp.ubuntu.com`. See [Privacy and network endpoints](/updates/privacy-and-network-endpoints/).

## Still contacted

The snap store (`api.snapcraft.io`) on the desktop, `geoip.ubuntu.com` from the desktop installer, and documentation links. See the same page for the reasons.

## For a restricted network

To allow Nubo OS through a proxy or firewall that blocks by address, allow outgoing HTTPS (port 443) to `archive.nubosuite.tech`, `archive.ubuntu.com` and `ports.ubuntu.com` (the fallback), and outgoing NTP (UDP 123) and NTS (TCP 4460) to the time servers. On the desktop also allow `dl.flathub.org`, `packages.mozilla.org` and `mail.nubo.email`. The NTP and NTS ports are the standard ones for those protocols and were not read from the repository. <!-- verify -->

## See also

- [Privacy and network endpoints](/updates/privacy-and-network-endpoints/)
- [Nubo Cumulus](/updates/nubo-cumulus/)
- [Server](/server/)
