---
title: The Nubo archive
description: What is stored at archive.nubosuite.tech, how it is laid out, and which key signs it.
sidebar:
  order: 20
---

**Applies to:** Desktop, Server, Virtualization, Containers, Edge

The Nubo archive is the place your machine downloads the `nubo-*` packages from. This page describes what is in it, so you can read the files yourself, check them, or point a tool at them.

## What it is

- A static apt archive, built with a tool called reprepro and signed with the Nubo archive key.
- Stored in a Cloudflare R2 bucket and served at **https://archive.nubosuite.tech**.
- No server program runs behind it. apt only needs to read files, so a plain file host is enough.

The same address also carries the Nubo Cumulus cache (paths starting with `/cumulus`), the network check (`/check`) and the server installer images (`/iso/`). Those are separate from the package archive and are described in [Nubo Cumulus](/updates/nubo-cumulus/).

## Suites, components and architectures

| Item | Values |
|---|---|
| Suites (channels) | `resolute` (stable), `resolute-beta` (beta) |
| Origin field | `Nubo` |
| Label field | `Nubo OS` (stable), `Nubo OS Beta` (beta) |
| Component | `main` |
| Architectures | `amd64`, `arm64`, `source` |

"resolute" is the code name of Ubuntu 26.04 LTS. The suite name says which Ubuntu release the packages are built for.

## Layout

```text
archive.nubosuite.tech/
  dists/
    resolute/                 stable channel
      Release, Release.gpg, InRelease   signed index of the channel
      main/binary-amd64/Packages(.gz)
      main/binary-arm64/Packages(.gz)
      main/source/Sources(.gz)
    resolute-beta/            beta channel, same structure
  pool/
    main/...                  the .deb and source files (shared by both channels)
  suites/
    resolute.list             file names stable carried last time
    resolute-beta.list        file names beta carried last time
  iso/<version>/              server installer images and their .sha256 files
  nubo-archive-keyring.asc    the public signing key, armoured
  cumulus, cumulus-arm, ...   Nubo Cumulus (a Worker, not files in the archive)
  check                       network check (a Worker)
```

- **`dists/`** holds one folder per suite. The signed `Release` file lists the checksum of every index file, and each index lists the checksum of every package. That chain is what lets apt trust a download from a plain web address.
- **`pool/`** holds the package files themselves. Both channels share one pool, which is why a new version number is needed for every release. Package files never change once published, so they are served with a one-year cache header. Index files change on every publish, so they are cached for only a minute.
- **`suites/`** holds a plain list of the files each suite carried. The publishing script reads it to rebuild the archive from scratch each time and to know what beta carries when it is promoted.
- **`iso/<version>/`** holds server images named `nubo-os-<flavour>-<version>-<arch>.iso`, each with a matching `.sha256` file. See [Verify signatures and checksums](/updates/verify-signatures-and-checksums/).

:::note
The exact list of signature files in `dists/<suite>/` (`Release.gpg`, `InRelease`) and the folder names under `pool/main/` come from the tool's defaults and were not read from a live copy of the archive. Open the address in a browser to see them.
:::

## The signing key

| Item | Value |
|---|---|
| Name | Nubo OS Archive <security@nubosuite.tech> |
| Type | ed25519 (sign and certify) |
| Fingerprint | `EE1A 4B74 9E23 2015 01F2 0336 0F74 01D7 AF7D 2593` |
| Created | 2 October 2026 |
| Expires | 1 October 2031 |

On your machine the key is `/usr/share/keyrings/nubo-archive-keyring.gpg`, installed by the `nubo-archive` package. The apt source file names it in its `Signed-By` line, which means this key is trusted for the Nubo archive only and for nothing else. The armoured public key is also published at https://archive.nubosuite.tech/nubo-archive-keyring.asc.

The key expires in October 2031. Before then, a new key has to be published through an update of `nubo-archive`. No rotation procedure is documented yet.

## The source file on your machine

`/etc/apt/sources.list.d/nubo.sources` reads:

```text title="/etc/apt/sources.list.d/nubo.sources"
Types: deb
URIs: https://archive.nubosuite.tech
Suites: resolute
Components: main
Signed-By: /usr/share/keyrings/nubo-archive-keyring.gpg
```

`nubo-channel` changes only the `Suites:` line. See [Channels: stable and beta](/updates/channels-stable-and-beta/).

## What is not in the archive

Ubuntu's own packages. Mirroring all of Ubuntu's resolute archive (main, universe, both architectures) is noted in the repository as a later step: it would need hundreds of gigabytes and daily synchronisation, and would only pay off with real traffic. Ubuntu's packages are fetched through [Nubo Cumulus](/updates/nubo-cumulus/) instead.

## Publishing

The archive is built by a script in the repository (`repo/publish.sh`), run by the build system on each tagged release. It always rebuilds the indexes from the package files already published plus the new ones, signs them, and uploads. Adding packages only ever goes to beta; stable is filled only by copying what beta carries. See [How updates work](/updates/how-updates-work/).

## See also

- [Verify signatures and checksums](/updates/verify-signatures-and-checksums/)
- [Build a private mirror](/updates/build-a-private-mirror/)
- [Network ports and endpoints](/reference/network-ports-and-endpoints/)
