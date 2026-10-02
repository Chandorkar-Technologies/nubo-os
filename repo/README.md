# Package archive (archive.nubosuite.tech)

Static apt archive built with reprepro, signed with the Nubo archive key,
served from a Cloudflare R2 bucket (custom domain archive.nubosuite.tech).
No server runs: apt only needs `dists/` and `pool/` files.

## One-time setup
1. `repo/gen-key.sh` creates the signing key; keep the private half out of git.
2. Create the R2 bucket `nubo-archive`, attach the custom domain `archive.nubosuite.tech`.
3. `rclone config`: remote `r2`, type s3, provider Cloudflare.
4. CI secrets: `NUBO_GPG_PRIVATE_KEY`, `R2_ACCESS_KEY_ID`, `R2_SECRET_ACCESS_KEY`, `R2_ENDPOINT`.

## Publishing
`repo/publish.sh DIR_WITH_DEBS` (CI does this on every tagged release).

## What is NOT mirrored
Ubuntu's own archive. Machines keep using Ubuntu's mirrors for those packages.
A full mirror of resolute (main, universe, both arches) is a later step: about
300 GB plus daily sync, which R2 can hold, but it only pays off at real traffic.

## Client side
Package `nubo-archive` installs `/etc/apt/sources.list.d/nubo.sources` and the keyring.

## Channels
- `resolute` is stable, `resolute-beta` is for testers. A tag like `v0.8.0-beta1` publishes to beta, `v0.8.0` to stable.
- Promote by tagging the same build as stable once beta is fine.
- On a machine: `sudo nubo-channel beta` / `sudo nubo-channel stable`.
- Nubo packages install automatically (unattended upgrades) from the stable channel only.

## Known gap
`lsb_release` still reports Ubuntu. Renaming it must be paired with the
unattended-upgrades origin patterns, otherwise security updates stop. Not done.

## Cumulus (Ubuntu packages through Nubo)
`archive.nubosuite.tech/cumulus` (x86-64) and `/cumulus-arm` (arm64) are a Cloudflare
Worker (`nubo-cumulus`, route `archive.nubosuite.tech/cumulus*`) that caches Ubuntu's
archive at the edge. Packages stay Ubuntu's and signed by Ubuntu. `mirrors.txt` lists
Cumulus first and Ubuntu second, so apt falls back by itself. `nubo-archive` points
`ubuntu.sources` at it (opt out: `sudo touch /etc/nubo/no-cumulus`, reinstall `nubo-archive`).
Worker source: `repo/cumulus-worker.js`.
