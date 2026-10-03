---
title: Publishing releases
description: Release a new version of Nubo OS to the beta channel with a tag, then promote it to stable, including the version rule and cache behaviour.
sidebar:
  order: 80
---

A release moves in two steps. A beta tag builds the packages and publishes them to the beta channel. A plain tag later promotes exactly those packages to stable, without rebuilding. Stable therefore never carries a build that beta did not carry first.

| Channel | apt suite | Who follows it |
|---|---|---|
| Stable | `resolute` | Every machine by default. Automatic installs of Nubo packages come from this channel only. |
| Beta | `resolute-beta` | Testers who ran `sudo nubo-channel beta`. |

## Before you begin

- Write access to the repository and its tags.
- A Drone setup with the four secrets from [CI with Drone](/developers/ci-with-drone/).
- The public key file `repo/nubo-archive-keyring.gpg` committed.
- The checks in [Testing checklist](/developers/testing-checklist/) done on a build of the current code.

## The version rule

Every release needs a new version in `debian/changelog`. The package pool is shared by both channels, and `reprepro` refuses a file whose name matches one in the pool but whose contents differ. Reusing a version is the most common reason a publish fails.

1. Add a new entry at the top of `debian/changelog`. Betas use a tilde: `0.8.0~beta5`, then `0.8.0~beta6`. The tilde makes each sort below `0.8.0`.
2. The tag name is the version with a `v` and the tilde replaced by a dash: version `0.8.0~beta5` is tag `v0.8.0-beta5`. The existing tags follow this pattern (`v0.8.0-beta1` and so on).

## Steps: publish a beta

1. Edit `debian/changelog` with the new version and a one-line summary of the change.
2. Commit and push to `master`.
3. Create and push the tag:

   ```bash
   git tag v0.8.0-beta5
   git push origin v0.8.0-beta5
   ```

4. Watch Drone. Four pipelines run: `debs-amd64`, then `publish` and `isos` together, then `cleanup`. The beta channel updates when `publish` finishes.
5. Test on a machine on the beta channel:

   ```bash
   sudo nubo-channel beta
   sudo apt update
   apt-cache policy nubo-base
   ```

## Steps: promote to stable

1. When the beta has passed testing, tag the same commit without a dash:

   ```bash
   git tag v0.8.0
   git push origin v0.8.0
   ```

2. Drone runs only the `promote` pipeline. It calls `repo/publish.sh --promote`, which re-indexes the stable suite from what the beta suite carried.
3. Check that stable now lists the packages (see Verify).

Promotion copies package files. It does not change their versions, so stable carries whatever version beta carried, for example `0.8.0~beta5`. A tag named `v0.8.0` does not create a package version `0.8.0`. <!-- verify: whether a final 0.8.0 build is intended before the first stable release -->

## Cache headers

The archive is static files served by a Cloudflare R2 bucket on a custom domain. `repo/publish.sh` sets these headers on upload:

| Files | `Cache-Control` | Why |
|---|---|---|
| `pool/**` (the `.deb` files) | `public, max-age=31536000, immutable` | A package file never changes, because every release has a new version. |
| Everything else (`dists/`, `suites/`, the key) | `public, max-age=60` | The indexes change on every publish. |
| Installer images (`iso/<version>/`) | `public, max-age=3600` | Set by `ci/build-isos.sh`. |
| Image checksums | `public, max-age=300` | Same. |

## Stale caches

After a publish, a client or an edge cache may see the old index for up to 60 seconds, so a machine that runs `apt update` immediately may not see a new package yet. Wait a minute and try again.

The repository has no script that purges Cloudflare's cache, and none is needed for packages (their names are new each release). If an index is still wrong after several minutes, purge the URL in the Cloudflare dashboard for the zone, or check that `publish` really finished. <!-- verify: no purge procedure is documented in the repo -->

## Verify

```bash
curl -fsSL https://archive.nubosuite.tech/suites/resolute-beta.list
curl -fsSL https://archive.nubosuite.tech/suites/resolute.list
curl -fsSL https://archive.nubosuite.tech/dists/resolute-beta/Release | head -12
```

- After a beta, the beta list names the new `.deb` files.
- After a promote, the two lists carry the same file names.
- The `Release` file shows `Origin: Nubo`, `Label: Nubo OS Beta` and `Codename: resolute-beta` for beta (`Label: Nubo OS`, `Codename: resolute` for stable).

On a test machine:

```bash
sudo nubo-channel stable
sudo apt update
apt-cache policy nubo-desktop
```

## Troubleshooting

- **`publish` fails: a package file already exists with different contents.** The version was reused. Bump `debian/changelog` and use a new tag. Do not delete the file from the bucket by hand unless you are sure no machine has installed it.
- **The tag started nothing.** The tag pipelines match `refs/tags/*-*` (beta) and the opposite (promote). A tag in another form, or one pushed before Drone knew the repository, does not trigger.
- **A plain tag promoted nothing new.** It promotes what beta carries now. If beta does not yet carry your change, publish a beta first.
- **Promote fails with "beta carries nothing to promote".** `suites/resolute-beta.list` is missing from the bucket. Publish a beta.
- **Machines do not see the update.** Check their channel with `sudo nubo-channel`, then wait out the 60-second index cache.
- **arm64 machines lack a new `nubo-search`.** The arm64 build is uploaded by hand until an arm64 runner exists; see [CI with Drone](/developers/ci-with-drone/).

## See also

- [Archive internals](/developers/archive-internals/)
- [Updates and the archive](/updates/)
- [Packaging notes](/developers/packaging-notes/)
