---
title: Archive internals
description: How repo/publish.sh builds the signed apt archive with reprepro, how the suite lists work, and how the key and the R2 bucket are used.
sidebar:
  order: 90
---

The Nubo archive at `archive.nubosuite.tech` is a set of static files. No server runs: apt only fetches `dists/` and `pool/` files over HTTPS. This page explains how those files are produced and why the scheme is built the way it is. For the steps to release, see [Publishing releases](/developers/publishing-releases/).

## The parts

| Part | Where | Role |
|---|---|---|
| `repo/publish.sh` | repository | Builds the whole archive from scratch and uploads it. |
| `repo/conf/distributions` | repository | Defines the two suites to `reprepro`. |
| `repo/conf/options` | repository | One line: `verbose`. |
| `repo/nubo-archive-keyring.gpg`, `.asc` | repository | The public key, binary and armored. |
| `repo/gen-key.sh` | repository | One-time creation of the signing key. |
| R2 bucket `nubo-archive` | Cloudflare | Holds the files. |
| Custom domain `archive.nubosuite.tech` | Cloudflare | Serves the bucket over HTTPS. |

## The suites

`repo/conf/distributions` has two stanzas.

| Field | Stable | Beta |
|---|---|---|
| `Codename` | `resolute` | `resolute-beta` |
| `Label` | Nubo OS | Nubo OS Beta |
| `Origin` | Nubo | Nubo |
| `Architectures` | amd64 arm64 source | amd64 arm64 source |
| `Components` | main | main |
| `SignWith` | default | default |

`SignWith: default` makes `reprepro` sign with the single secret key in the GnuPG home of the build, which is why CI imports exactly one key. The `Origin: Nubo` value matters on every client: `repo/52-nubo-unattended.conf` allows unattended upgrades from `origin=Nubo,codename=${distro_codename}`, so renaming the origin would stop Nubo package updates from installing automatically.

## How `publish.sh` works

The archive is rebuilt from scratch on every run. There is no state on the build machine and none is kept between runs, apart from what is in the bucket.

1. **Choose a mode.** `publish.sh DEBS_DIR beta` adds packages to the beta suite. `publish.sh --promote` fills stable. Giving any channel other than `beta` for new packages is refused with "new packages go to beta; use --promote for stable".
2. **Start a clean work directory.** `OUT` (default `repo/out`) is deleted, and `conf/` is copied in.
3. **Fetch what is already published.** Unless `SKIP_UPLOAD` or `PREV_DIR` is set, `rclone copy` downloads `pool/` and `suites/` from the bucket into a temporary directory. (`PREV_DIR` lets a test supply a local copy.)
4. **Put back every package each suite carried.** For each suite, `suites/<suite>.list` holds the file names the suite carried last time. The script finds each in the downloaded pool and runs `reprepro includedeb <suite> <file>`.
5. **Add the new files.** In add mode, every `.deb` in the given directory is included in `resolute-beta`. In promote mode, every file named in `suites/resolute-beta.list` is included in `resolute`. Promote stops with "beta carries nothing to promote" if that list is missing.
6. **Write new suite lists.** For each suite, the script reads the `Filename:` lines from `dists/<suite>/main/binary-*/Packages.gz` and writes the base names, sorted and unique, to `suites/<suite>.list`.
7. **Clean up.** It removes `db/` and `conf/` from the output (reprepro's working state is not published) and copies the armored public key to the root.
8. **Upload**, unless `SKIP_UPLOAD` is set, in which case it prints "Archive built in ..." and stops.

Why rebuild and re-add instead of adding to a stored database: the bucket holds only static files and the `reprepro` database is not published. The `.list` files are the memory of the archive, and the pool is its storage. Stable only ever receives what beta already carries, so the two channels never hold different builds of the same version.

## What the bucket looks like

```text
nubo-archive/
  dists/resolute/...             Release, InRelease, Release.gpg, main/binary-*/Packages.gz
  dists/resolute-beta/...
  pool/main/n/nubo-os/...        the .deb files, shared by both suites
  suites/resolute.list           names of the packages each suite carries
  suites/resolute-beta.list
  nubo-archive-keyring.asc       the public key
  iso/<version>/                 server installer images and checksums (from CI)
  _staging/<tag>/                packages waiting between build and publish (removed by cleanup)
```

The exact pool path comes from `reprepro`'s defaults. <!-- verify: pool directory layout -->

Uploads use two `rclone copy` calls with `--checksum`:

```bash
rclone copy "${OUT}/pool" "r2:${BUCKET}/pool" --fast-list --checksum \
  --header-upload "Cache-Control: public, max-age=31536000, immutable"
rclone copy "${OUT}" "r2:${BUCKET}" --exclude "pool/**" --fast-list --checksum \
  --header-upload "Cache-Control: public, max-age=60"
```

`copy` never deletes. A stale file in the bucket stays there until someone removes it. That is intended for the pool and means the indexes alone decide what a suite offers.

The bucket is addressed through an rclone remote named `r2`, configured from environment variables by `ci/rclone-env.sh`. The default bucket is `nubo-archive` (`R2_BUCKET` overrides it). Because the staging area lives in the same bucket and the bucket is served on the custom domain, staged files are reachable by URL until `cleanup` deletes them. <!-- verify: whether _staging is publicly readable -->

## Key handling

`repo/gen-key.sh` creates an Ed25519 signing key with no passphrase and a five-year expiry (`sign 5y`) for the identity "Nubo OS Archive <security@nubosuite.tech>". It works in a temporary `GNUPGHOME`, exports the public half to `repo/` (both `.gpg` and `.asc`) and writes the private half to `repo/PRIVATE-nubo-archive-key.asc`. The script tells you to move that file somewhere safe and delete it from the folder. The `.gitignore` lists the name so it is not committed.

In CI the private key is the Drone secret `nubo_gpg_private_key`. Each of the two pipelines that sign (`publish`, `promote`) runs `echo "$GPG_KEY" | gpg --batch --import` in a fresh container, so the key exists only for the life of that container.

The public key is installed on machines by the package `nubo-archive` as `/usr/share/keyrings/nubo-archive-keyring.gpg`, and the source files point at it with `Signed-By`. The fingerprint is `EE1A4B749E23201501F203360F7401D7AF7D2593`. Because the key expires, plan its rotation before the date: a new key means a new `nubo-archive` package that carries it, and clients need that package before the old key stops working. <!-- verify: key creation date and rotation plan -->

## Client files

| File | Source in the repository |
|---|---|
| `/etc/apt/sources.list.d/nubo.sources` | `repo/nubo.sources` (suite `resolute`) |
| Beta variant | `repo/nubo-beta.sources` (suite `resolute-beta`) |
| `/usr/sbin/nubo-channel` | `repo/nubo-channel` (rewrites the `Suites:` line) |
| `/etc/apt/apt.conf.d/52-nubo-unattended.conf` | `repo/52-nubo-unattended.conf` |
| `/usr/share/nubo/ubuntu-sources/ubuntu.sources.{amd64,arm64}` | `repo/ubuntu/` |

## What the archive does not hold

Ubuntu's own packages. They come from Ubuntu, through Nubo Cumulus; see [The Cumulus Worker](/developers/cumulus-worker/). A full mirror of the `resolute` archive is described in `repo/README.md` as a later step: about 300 GB plus a daily sync, worth it only at real traffic.

## Test it without uploading

```bash
SKIP_UPLOAD=1 OUT=/tmp/nubo-archive repo/publish.sh out beta
```

This needs `reprepro` and your signing key in GnuPG. With `SKIP_UPLOAD` set, the script skips the download of the old pool as well, so the result holds only the packages you pass.

## Verify

```bash
ls /tmp/nubo-archive/dists/resolute-beta
cat /tmp/nubo-archive/suites/resolute-beta.list
gpg --verify /tmp/nubo-archive/dists/resolute-beta/Release.gpg /tmp/nubo-archive/dists/resolute-beta/Release
```

## Troubleshooting

- **`reprepro` says a file is already registered with different checksums.** The version was reused. Use a new version.
- **"`gpg: signing failed: No secret key`".** The key was not imported into the `GNUPGHOME` that `reprepro` uses. Import it before running.
- **A package vanished from a suite after a publish.** Its file name was missing from `suites/<suite>.list` or from the downloaded pool. Check the lists in the bucket.
- **Clients report a signature error after a key change.** They still have the old key. Install the new `nubo-archive` package first.

## See also

- [Publishing releases](/developers/publishing-releases/)
- [The Nubo archive](/updates/)
- [CI with Drone](/developers/ci-with-drone/)
