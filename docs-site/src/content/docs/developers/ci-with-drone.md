---
title: CI with Drone
description: The Drone pipelines that build, publish and promote Nubo OS releases and deploy this documentation, with triggers, order and secret names.
sidebar:
  order: 70
---

Releases are built by Drone on the instance at `ci.hostingduty.com`. The pipelines are defined in `.drone.yml` at the root of the repository, and the shell scripts they call live in `ci/`. Almost every pipeline runs in an `ubuntu:26.04` container on amd64 and starts by pointing apt at Nubo Cumulus with `ci/use-cumulus.sh`.

## Pipelines at a glance

| Pipeline | Trigger | Runs after | What it does |
|---|---|---|---|
| `debs-amd64` | tag whose name contains a dash (`v0.8.0-beta1`) | nothing | Builds every package and stages the `.deb` files in R2. |
| `publish` | same | `debs-amd64` | Collects staged packages and publishes the signed archive to the beta channel. |
| `isos` | same | `debs-amd64` | Builds the 8 server installer images and uploads them. |
| `cleanup` | same | `publish` and `isos` | Deletes the staged packages. |
| `promote` | tag without a dash (`v0.8.0`) | nothing | Copies what beta carries into stable. No rebuild. |
| `docs` | push to `master` that changes `docs-site/**` or `ci/deploy-docs.sh` | nothing | Builds this site and uploads it to R2. |

The tag rule is in the `ref` filter: `refs/tags/*-*` selects beta builds and an `exclude` of the same pattern selects the plain tags.

## What each pipeline runs

### `debs-amd64`

1. Installs `ca-certificates`, then runs `ci/use-cumulus.sh` and refreshes apt.
2. Installs `git curl ca-certificates build-essential devscripts equivs rclone`.
3. Runs `vendor/fetch.sh` to get the pinned upstream sources.
4. Installs build dependencies with `mk-build-deps -i -r -t 'apt-get -y' debian/control`.
5. Builds with `dpkg-buildpackage -us -uc -b`, with `NUBO_RELEASE=1` so a missing archive key fails the build.
6. Moves the `.deb` files to `out/` and runs `ci/stage-upload.sh amd64 out`.

`ci/stage-upload.sh` copies the files to `r2:<bucket>/_staging/<tag>/`. The amd64 run uploads every `.deb`, the architecture-independent packages included; an arm64 run would upload only `*_arm64.deb`.

### `publish`

Installs `reprepro rclone gnupg`, imports the signing key from the secret `nubo_gpg_private_key` with `gpg --batch --import`, then runs `ci/publish-staged.sh <tag>`. That script downloads `_staging/<tag>` and calls `repo/publish.sh debs beta`. See [Archive internals](/developers/archive-internals/).

### `isos`

Installs `xorriso squashfs-tools rclone curl` and runs `ci/build-isos.sh`. The script downloads the staged packages, downloads Ubuntu's live-server ISO for each CPU through Cumulus, checks it against Ubuntu's `SHA256SUMS`, then builds the four flavours with `iso/build-server-iso.sh`. Each image is uploaded to `iso/<version>/` with a `.sha256` file; the image gets `Cache-Control: public, max-age=3600` and the checksum file `max-age=300`. The `<version>` is the tag without the leading `v`. Image names look like `nubo-os-<flavour>-<version>-<arch>.iso`. Because the server packages are architecture-independent, the amd64 machine builds the arm64 images too. See [Building the server images](/developers/building-server-images/).

### `cleanup`

Runs `ci/purge-staging.sh`, which runs `rclone purge` on `_staging/<tag>`. It depends on both `publish` and `isos`, so the staged files stay until both have used them.

### `promote`

Imports the key and runs `ci/promote.sh`, which calls `repo/publish.sh --promote`. Nothing is built.

### `docs`

Runs in a `node:24-slim` image, installs `rclone` and `ca-certificates`, and runs `ci/deploy-docs.sh`: `npm ci`, `npm run build` in `docs-site/`, then `rclone sync dist r2:nubo-docs`. Because it uses `sync`, files that no longer exist in the build are removed from the bucket. See [Contributing to these docs](/developers/docs-contributing/).

## Secrets

Names only. Set them in the Drone repository settings; never put values in the repository.

| Secret | Used by | Purpose |
|---|---|---|
| `nubo_gpg_private_key` | `publish`, `promote` | Private archive signing key, imported into the build container. |
| `r2_access_key_id` | all pipelines that touch R2 | Cloudflare R2 access key id. |
| `r2_secret_access_key` | same | Cloudflare R2 secret key. |
| `r2_endpoint` | same | R2's S3 endpoint URL. |

`ci/rclone-env.sh` turns the three R2 values into an rclone remote named `r2`, with the bucket check turned off (`NO_CHECK_BUCKET=true`) because the access key only allows reading and writing objects. The bucket name is `nubo-archive` unless `R2_BUCKET` is set.

## The arm64 runner

The file `ci/debs-arm64.drone.yml` defines a `debs-arm64` pipeline and its first line says "Not active". It needs a Drone runner on an arm64 machine, and none exists. Until one does:

- Only `debs-amd64` runs, so a beta build holds the architecture-independent packages and the amd64 `nubo-search`.
- The `.drone.yml` header says to upload arm64 builds by hand; they stay in the archive, because `repo/publish.sh` puts back everything the suites already carried before it adds new files.
- When a runner exists, merge the pipeline into `.drone.yml` and add `debs-arm64` to the `publish` pipeline's `depends_on`.

:::caution[Planned]
An arm64 CI runner is planned, not built. See the [Roadmap](/developers/roadmap/).
:::

## An older workflow in the repository

`.github/workflows/release.yml` is a GitHub Actions workflow that triggers on tags matching `v*`. It builds on GitHub's amd64 and arm64 runners, publishes to the archive (beta for a dash tag, stable otherwise) and builds a desktop ISO and cloud images. The `.drone.yml` header describes the Drone pipelines as the release path. Confirm that the GitHub workflow is disabled in the repository settings, or a tag could start two publishes. <!-- verify: whether release.yml is still enabled -->

## Verify

After a beta tag:

1. All of `debs-amd64`, `publish`, `isos` and `cleanup` show as passed in Drone.
2. The archive index carries the new version:

   ```bash
   curl -fsSL https://archive.nubosuite.tech/suites/resolute-beta.list
   ```

3. The images exist:

   ```bash
   curl -fsSI https://archive.nubosuite.tech/iso/0.8.0-beta4/nubo-os-server-0.8.0-beta4-amd64.iso.sha256
   ```

   Replace the version with your tag, without the `v`.

## Troubleshooting

- **`debs-amd64` fails with `repo/nubo-archive-keyring.gpg missing`.** The public key file is missing from the commit. It must be committed.
- **A package is refused by `reprepro` in `publish`.** The version was reused with different contents. Add a new entry to `debian/changelog` and tag again. See [Packaging notes](/developers/packaging-notes/).
- **`isos` fails with "checksum mismatch for <arch> base image".** The download did not match Ubuntu's `SHA256SUMS`. Run the pipeline again; if it persists, check whether the path in `ci/build-isos.sh` still matches Ubuntu's layout.
- **`promote` fails with "beta carries nothing to promote".** `suites/resolute-beta.list` is missing from the bucket. Publish a beta first.
- **A bucket error mentioning permissions.** The access key only allows object operations. Do not add commands that list or create buckets.
- **`docs` does not run.** The pipeline runs only on pushes to `master` that change `docs-site/**` or `ci/deploy-docs.sh`.

## See also

- [Publishing releases](/developers/publishing-releases/)
- [Archive internals](/developers/archive-internals/)
