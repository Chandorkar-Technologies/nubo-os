---
title: Privacy and network endpoints
description: Which addresses a Nubo OS machine contacts, what was routed through Nubo, what was switched off, and what still reaches Canonical.
sidebar:
  order: 90
---

**Applies to:** Desktop, Server, Virtualization, Containers, Edge

Ubuntu, the base of Nubo OS, contacts several Canonical servers by default: for news at login, crash reports, time, connectivity checks and adverts for a paid service. Nubo OS changes this. This page lists what changed, and what is still contacted. The list comes from searching a running Nubo OS desktop (arm64 virtual machine) and reading the packages, not from guesses. It is accurate as of 3 October 2026.

:::note
This page is about network contacts made by the system itself. It does not describe what Nubo services, Cloudflare or other companies do with the requests they receive. No privacy policy for these services is in the repository.
:::

## Sent to Nubo instead of Canonical

The `nubo-archive` and `nubo-base` packages route these requests through Nubo.

| Ubuntu's address | Nubo OS uses | Purpose |
|---|---|---|
| `archive.ubuntu.com`, `ports.ubuntu.com`, `security.ubuntu.com` | `archive.nubosuite.tech/cumulus` and `/cumulus-arm`, with Ubuntu's servers as fallback | Package downloads. See [Nubo Cumulus](/updates/nubo-cumulus/) |
| `cdimage.ubuntu.com` | `archive.nubosuite.tech/cumulus-images` | Installer images (used by Nubo's own image builds) |
| `cloud-images.ubuntu.com` | `archive.nubosuite.tech/cumulus-cloud` | Cloud images (used by Nubo's own image builds) |
| `releases.ubuntu.com` | `archive.nubosuite.tech/cumulus-releases` | Release images; available, used by the server image builds |
| `connectivity-check.ubuntu.com` | `archive.nubosuite.tech/check` | NetworkManager asks every 300 seconds whether you are online |
| `ntp.ubuntu.com` | `time.cloudflare.com` (with NTS), `pool.ntp.org` | Clock synchronisation |

`nubo-base` ships settings for both time services Ubuntu can use. systemd-timesyncd is set to `time.cloudflare.com` with `pool.ntp.org` as fallback. chrony is set to `time.cloudflare.com` with NTS (authenticated time) and `pool.ntp.org`. The server editions run chrony.

## Switched off

| Ubuntu feature | Address | How it is switched off |
|---|---|---|
| Login "news" | `motd.ubuntu.com` | The motd-news service and timer are masked and disabled in its settings |
| Crash reports | `daisy.ubuntu.com` | The whoopsie and apport services are masked; apport is disabled in its settings |
| Release-upgrade check | `changelogs.ubuntu.com` | The `Prompt` setting is `never` |
| Debug symbol server | `debuginfod.ubuntu.com` | The server list is empty |
| Ubuntu Pro adverts and services | `esm.ubuntu.com`, `contracts.canonical.com`, `landscape.canonical.com` | The Pro timers and services are masked. The desktop's first boot removes the Pro client. The server editions conflict with it, so it cannot be installed |
| Snap store on the server | Canonical's snap store | The server packages conflict with `snapd`, so it is not installed |

"Masked" means the system links the unit to nothing, so it cannot start, even by accident. The links are removed if you remove the `nubo-base` package.

## Still contacted

These are known gaps, listed so you can decide.

| Address | Why | Applies to | What would fix it |
|---|---|---|---|
| The snap store, `api.snapcraft.io` | The Nubo account sign-in service (`authd-oidc`) is distributed as a snap, so `snapd` stays on the desktop | Desktop | Package the sign-in service as a regular package |
| `geoip.ubuntu.com` | Ubuntu's desktop installer guesses your time zone | Desktop installer | Patch the installer or pre-set the time zone |
| `keyserver.ubuntu.com` | Only when a person fetches a key by hand | Any | None needed |
| Documentation links (`www.ubuntu.com`, `help.ubuntu.com`, `launchpad.net`) | Text inside Ubuntu's own packages | Any | Cosmetic; Nubo's own pages use `docs.nubosuite.tech` |
| Ubuntu's base images on first download | The file itself comes from Canonical, signed by Canonical | Build and download | Could be copied into Nubo's own storage later |
| `packages.mozilla.org` | Firefox is installed as a package from Mozilla instead of Ubuntu's snap | Desktop | Not a gap: this is by design |
| `dl.flathub.org` | The Nubo Store and first boot download apps from Flathub | Desktop | Not a gap: this is by design |
| `mail.nubo.email` | Sign-in and account services | Desktop | Not a gap: this is by design |

Other contacts depend on what you choose to do. For example, the Weather widget on the desktop looks up weather and may use your location (the setting `weather-auto-location` is on by default). You can turn the weather off with the `show-weather` key. See [Configuration keys](/reference/configuration-keys/).

## Verify

Use these to look at what your own machine does:

```bash
cat /etc/apt/sources.list.d/*.sources | grep -E '^URIs'
cat /etc/NetworkManager/conf.d/20-connectivity-ubuntu.conf
systemctl is-enabled motd-news.timer whoopsie.service apport.service
```

The first shows every package source. The second shows the connectivity check address. The third prints `masked` for each unit that is switched off.

## Troubleshooting

**`motd-news.timer` shows `static` or `enabled`, not `masked`.**
The `nubo-base` package is not installed or was removed. Reinstall it: `sudo apt install nubo-base`.

**I see connections to an Ubuntu address not listed here.**
Please tell support@nubo.email with the address and what you were doing. The list was built by searching one desktop, so it may miss a rarely used program.

**I want to avoid Nubo's own servers too.**
You can: [use Ubuntu's servers directly](/updates/use-ubuntus-servers-directly/) for packages. The connectivity check and time servers can be changed in the NetworkManager and chrony or timesyncd settings. The Nubo archive itself is needed for `nubo-*` updates.

## See also

- [Network ports and endpoints](/reference/network-ports-and-endpoints/)
- [Nubo Cumulus](/updates/nubo-cumulus/)
- [Known issues](/reference/known-issues/)
