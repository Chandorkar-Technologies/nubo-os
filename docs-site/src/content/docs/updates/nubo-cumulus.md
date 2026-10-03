---
title: Nubo Cumulus
description: What Nubo Cumulus is, which addresses it serves, how it ranks servers, and how it falls back to Ubuntu.
sidebar:
  order: 50
---

**Applies to:** Desktop, Server, Virtualization, Containers, Edge

Nubo Cumulus is Nubo's cache in front of Ubuntu's package archive and image servers. It lets Nubo OS machines download Ubuntu's packages from a nearby cache instead of from Ubuntu's servers directly. It changes where the bytes come from, not what they are.

## What it is

Cumulus is a small program (a Cloudflare Worker named `nubo-cumulus`) that answers requests at `archive.nubosuite.tech/cumulus*`. When a request arrives it asks Ubuntu's server for the same file, lets Cloudflare keep a copy, and passes the answer on. Nothing is rewritten. The packages are Ubuntu's and stay signed by Ubuntu, so apt checks them against Ubuntu's keys exactly as before. See [Verify signatures and checksums](/updates/verify-signatures-and-checksums/).

## Addresses

| Address | Serves | Copies from |
|---|---|---|
| `https://archive.nubosuite.tech/cumulus` | Ubuntu's package archive, amd64 | `archive.ubuntu.com/ubuntu` |
| `https://archive.nubosuite.tech/cumulus-arm` | Ubuntu's package archive, arm64 | `ports.ubuntu.com/ubuntu-ports` |
| `https://archive.nubosuite.tech/cumulus-images` | Installer images | `cdimage.ubuntu.com` |
| `https://archive.nubosuite.tech/cumulus-releases` | Release images | `releases.ubuntu.com` |
| `https://archive.nubosuite.tech/cumulus-cloud` | Cloud images | `cloud-images.ubuntu.com` |
| `https://archive.nubosuite.tech/check` | The network check | Nubo answers itself |

Only `GET` and `HEAD` requests are answered. Anything else returns "Method not allowed", and an unknown path returns "Not found".

The `/check` address replaces Ubuntu's connectivity-check server. NetworkManager asks it whether the machine is online and receives `NetworkManager is online`.

## How apt uses it

On a Nubo OS machine, `/etc/apt/sources.list.d/ubuntu.sources` is replaced by a Nubo version, installed by the `nubo-archive` package. The original is kept as `ubuntu.sources.ubuntu` beside it. The Nubo version uses a mirror list instead of a single address:

```text title="/etc/apt/sources.list.d/ubuntu.sources (amd64)"
Types: deb
URIs: mirror+https://archive.nubosuite.tech/cumulus/mirrors.txt
Suites: resolute resolute-updates resolute-backports resolute-security
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg
```

On arm64 the address is `.../cumulus-arm/mirrors.txt`. The `Signed-By` line is Ubuntu's key.

The mirror list at that address contains two lines, each with the address and a priority separated by a tab. For amd64 it reads:

```text
https://archive.nubosuite.tech/cumulus    priority:1
https://archive.ubuntu.com/ubuntu         priority:2
```

On arm64 the lines are `https://archive.nubosuite.tech/cumulus-arm` and `https://ports.ubuntu.com/ubuntu-ports`. Without priorities, apt picks among equal mirrors at random, so the list ranks Cumulus first and Ubuntu second.

## Fallback

If Cumulus cannot be reached, apt tries the next mirror in the list, which is Ubuntu's own server. You do not need to do anything. This is also why a Cumulus outage does not stop a build or an installation.

## Caching

| What | How long a copy is kept |
|---|---|
| Package files and `by-hash` index files (anything under `pool/` or `by-hash/`, and `.deb`, `.udeb`, `.dsc`, source tarballs) | 7 days |
| Image files (`.iso`, `.img`, `.qcow2`, `.squashfs`, `.vmdk` and similar) | 1 hour |
| Everything else, such as index files | 2 minutes |
| "Not found" answers | 30 seconds |
| Server errors | not kept |
| The mirror list | 5 minutes |

Published package files never change, which is why they are kept for days. Index files change often and so are kept briefly.

## What else uses Cumulus

- The server installer image uses Cumulus as its package source. Installation falls back to the media if Cumulus cannot be reached.
- The Nubo build system fetches Ubuntu's packages and the base images for Nubo's installer images through Cumulus.
- Nubo's cloud and Raspberry Pi image scripts download their base images through `cumulus-cloud` and `cumulus-images`.

## Privacy

Requests to Cumulus reach Cloudflare and Nubo as web requests to `archive.nubosuite.tech`, in the same way they would reach Ubuntu's servers if you used them directly. The repository does not state a log-retention policy for these requests. See [Privacy and network endpoints](/updates/privacy-and-network-endpoints/). If you prefer to fetch from Ubuntu directly, see [Use Ubuntu's servers directly](/updates/use-ubuntus-servers-directly/).

## See also

- [Use Ubuntu's servers directly](/updates/use-ubuntus-servers-directly/)
- [The Nubo archive](/updates/the-nubo-archive/)
- [Network ports and endpoints](/reference/network-ports-and-endpoints/)
