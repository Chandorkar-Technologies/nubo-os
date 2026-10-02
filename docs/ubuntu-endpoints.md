# Ubuntu and Canonical addresses in Nubo OS

Status 3 Oct 2026. Found by searching a running Nubo OS desktop (arm64 VM), not by guessing.

## Routed through Nubo
| Was | Now | Where |
|---|---|---|
| archive.ubuntu.com, ports.ubuntu.com, security.ubuntu.com | archive.nubosuite.tech/cumulus, /cumulus-arm (Ubuntu as fallback) | `nubo-archive`, installer answer files, build scripts, CI |
| cdimage.ubuntu.com | archive.nubosuite.tech/cumulus-images | image scripts, CI |
| releases.ubuntu.com | archive.nubosuite.tech/cumulus-releases | available, not used yet |
| cloud-images.ubuntu.com | archive.nubosuite.tech/cumulus-cloud | image scripts |
| connectivity-check.ubuntu.com | archive.nubosuite.tech/check | `nubo-base` |
| ntp.ubuntu.com (time) | time.cloudflare.com (NTS), pool.ntp.org | `nubo-base` |

## Switched off
| Address | What it did | How |
|---|---|---|
| motd.ubuntu.com | login "news" | `nubo-base` masks motd-news |
| daisy.ubuntu.com | crash reports (whoopsie, apport) | `nubo-base` masks them |
| changelogs.ubuntu.com | release-upgrade check | `nubo-base`: Prompt=never |
| debuginfod.ubuntu.com | debug symbol server | `nubo-base`: empty list |
| esm.ubuntu.com, contracts.canonical.com, landscape.canonical.com | Ubuntu Pro adverts and services | timers masked; first boot removes the Pro client (desktop); server conflicts with it |
| snapd on the server | Canonical's snap store | `nubo-server-base` conflicts with it |

## Still contacted (known gaps)
| Address | Why | Fix |
|---|---|---|
| api.snapcraft.io and the snap store (desktop) | `authd-oidc`, the Nubo sign-in broker, is a snap | package the broker as a .deb, then drop snapd |
| geoip.ubuntu.com | the desktop installer guesses the time zone | patch the installer, or pre-seed the time zone |
| keyserver.ubuntu.com | only when a person runs a key fetch | leave |
| Documentation links (www.ubuntu.com, help.ubuntu.com, launchpad.net, ...) | text in Ubuntu's own packages | cosmetic; Nubo's own pages use docs.nubosuite.tech |
| Ubuntu base ISOs on first download | the file itself comes from Canonical, signed by Canonical | can be pinned into our own bucket later |
