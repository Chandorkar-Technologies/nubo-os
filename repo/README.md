# Package archive (os.nubosuite.tech/apt)

Static apt archive built with reprepro, signed with the Nubo archive key,
served from a Cloudflare R2 bucket (custom domain os.nubosuite.tech, path /apt).
No server runs: apt only needs `dists/` and `pool/` files.

## One-time setup
1. `repo/gen-key.sh` creates the signing key; keep the private half out of git.
2. Create the R2 bucket `nubo-os`, attach the custom domain `os.nubosuite.tech`.
3. `rclone config`: remote `nubo-r2`, type s3, provider Cloudflare.
4. CI secrets: `NUBO_GPG_PRIVATE_KEY`, `R2_ACCESS_KEY_ID`, `R2_SECRET_ACCESS_KEY`, `R2_ENDPOINT`.

## Publishing
`repo/publish.sh DIR_WITH_DEBS` (CI does this on every tagged release).

## What is NOT mirrored
Ubuntu's own archive. Machines keep using Ubuntu's mirrors for those packages.
A full mirror of resolute (main, universe, both arches) is a later step: about
300 GB plus daily sync, which R2 can hold, but it only pays off at real traffic.

## Client side
Package `nubo-archive` installs `/etc/apt/sources.list.d/nubo.sources` and the keyring.
