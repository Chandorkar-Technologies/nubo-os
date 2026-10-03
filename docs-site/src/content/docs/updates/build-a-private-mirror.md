---
title: Build a private mirror
description: An outline for running your own copy of the Nubo archive for offline or controlled networks. Not a supported setup yet.
sidebar:
  order: 100
---

**Applies to:** Server, Virtualization, Containers, Edge

:::caution[Planned]
Running your own mirror of the Nubo archive is not documented as supported. The repository has no mirror tool, no mirror instructions and no tested procedure. This page is an outline of what would be involved, based on how the archive is built. Treat it as a starting point for an experiment, not as a tested guide.
:::

## Why you might want one

- Machines on a network with no internet access.
- A company rule that all packages come from servers you control.
- Reducing repeated downloads for many machines.

## What there is to mirror

Two separate things:

1. **The Nubo archive** (`https://archive.nubosuite.tech`, suites `resolute` and `resolute-beta`). It is small: only the `nubo-*` packages. See [The Nubo archive](/updates/the-nubo-archive/).
2. **Ubuntu's packages.** These are not in the Nubo archive. Nubo Cumulus only caches them. A private copy of Ubuntu's archive is a separate project, with standard tools such as `apt-mirror` or `debmirror`. See the [Ubuntu Server documentation](https://ubuntu.com/server/docs).

## Outline: copy the Nubo archive

The archive is a set of static files, so any web server that can serve a directory can host a copy. In principle:

1. Make a directory that will be served over HTTPS, for example on an internal host.
2. Copy `dists/` and `pool/` from `https://archive.nubosuite.tech` into it, keeping the folder layout, for example with `rclone` (HTTP backend) or `wget --mirror`. The `suites/` folder is only used by Nubo's publishing script and is not needed by apt.
3. Keep the files exactly as downloaded. The signed `Release` file lists the checksum of every index file, so any change breaks the signature.
4. Serve the directory without redirects that change the path.

### Point a machine at the copy

Because the original signatures are untouched, a machine only needs a new address in its source file. Keep the key.

```text title="/etc/apt/sources.list.d/nubo.sources"
Types: deb
URIs: https://mirror.example.internal/nubo
Suites: resolute
Components: main
Signed-By: /usr/share/keyrings/nubo-archive-keyring.gpg
```

(`mirror.example.internal` is a placeholder for your host.) The `nubo-archive` package owns this file. After editing it, `dpkg` may ask whether to keep your version when the package updates. Keep yours.

### Keep it current

Run the copy again on a schedule. Package files in `pool/` never change once published, so a repeat copy mainly downloads new files and the changed indexes. Indexes carry a one-minute cache header at the source, so copy them last, after the packages, so that a machine never sees an index that lists a file you have not copied yet.

## Open questions

These are not answered anywhere in the repository:

- Whether a mirror that is a plain copy keeps working when a new signing key is introduced.
- Whether the Nubo packages work with a private copy of Ubuntu's archive from another date. Nubo packages depend on Ubuntu packages, so the two copies must be recent enough to match.
- Whether Nubo will publish a mirror tool or an official mirror programme.
- How to mirror the server installer images: the `iso/` folder is separate from the apt archive, and the images fetch Ubuntu packages through Cumulus while installing.

## What does not need a private mirror

If your only goal is to avoid sending package requests to Nubo, you can [use Ubuntu's servers directly](/updates/use-ubuntus-servers-directly/). Nubo packages still come from `archive.nubosuite.tech` in that case.

## See also

- [The Nubo archive](/updates/the-nubo-archive/)
- [Nubo Cumulus](/updates/nubo-cumulus/)
- [Verify signatures and checksums](/updates/verify-signatures-and-checksums/)
