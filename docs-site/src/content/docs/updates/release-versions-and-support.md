---
title: Release versions and support
description: How Nubo OS versions and release tags are named, and how long updates last.
sidebar:
  order: 80
---

**Applies to:** Desktop, Server, Virtualization, Containers, Edge

This page explains the numbers you see in package versions and release tags, and what is promised about support.

## The release name

Nubo OS 1 "Flow" is the first release line. It is built on Ubuntu 26.04 LTS, code name "resolute". The name `Nubo OS 1` appears in the top bar of the desktop and in the system's identity files. The server shows `Nubo OS Server 1`.

## Package versions

All Nubo packages are built from one source package, `nubo-os`, and share one version number. The current line is 0.8.0.

| Version | Meaning |
|---|---|
| `0.8.0~beta1`, `0.8.0~beta2`, `0.8.0~beta3` | Beta builds of 0.8.0 |
| `0.8.0` | The final build of 0.8.0 |
| `0.7.0` and earlier | Development releases before the archive existed |

The `~` (tilde) is part of Debian's version rules: a version with `~beta3` sorts **before** the same number without it. So `0.8.0~beta3` is older than `0.8.0`, and when `0.8.0` is published your machine upgrades to it as a normal update.

You can see your version with:

```bash
apt-cache policy nubo-base
dpkg -s nubo-base | grep '^Version'
```

Every release needs a new version number in the package changelog, because both channels share one package pool and a file with the same name but different contents is refused.

## Release tags

The build system reacts to tags in the source repository.

| Tag form | Example | What happens |
|---|---|---|
| Contains a dash | `v0.8.0-beta1` | Build the packages and server images, publish to the beta channel |
| No dash | `v0.8.0` | Copy what the beta channel carries into stable, with no rebuild |

The number in a tag and the version inside the packages are set by hand, so they are not guaranteed to match. For example, the tag `v0.8.0-beta10` was set on a commit whose package version is `0.8.0~beta3`. Use the package version to tell which build you have. Use the tag only to find the matching installer images at `https://archive.nubosuite.tech/iso/<tag without the v>/`.

## Channels and versions

A new build becomes visible on the beta channel first. It reaches stable only when a no-dash tag is pushed. See [Channels: stable and beta](/updates/channels-stable-and-beta/).

## Support window

- **Base system.** Ubuntu 26.04 LTS has five years of standard security maintenance from its release, which means until April 2031. Nubo OS receives Ubuntu's updates through the same package system, so this window applies to the base system. For Ubuntu's own details see [Ubuntu's release cycle](https://ubuntu.com/about/release-cycle).
- **Nubo packages.** No separate support window for the `nubo-*` packages is stated in the repository. Nubo updates are published to the archive as new versions; the repository does not state for how long a release line receives them. This page will be updated when that is decided.
- **Nubo's archive key.** It expires on 1 October 2031. See [The Nubo archive](/updates/the-nubo-archive/).

:::caution[Planned]
There is no extended or paid support offering. Nubo Pro is planned and not built. Canonical's Ubuntu Pro client is not part of Nubo OS.
:::

## Moving to a later release

Release upgrades with `do-release-upgrade` are switched off in Nubo OS (the `Prompt` setting is `never`). The Nubo base configuration says release upgrades are to be delivered through the Nubo archive, but there is only one release line so far and no upgrade procedure exists yet.

## See also

- [Release notes](/reference/release-notes/)
- [Known issues](/reference/known-issues/)
- [How updates work](/updates/how-updates-work/)
