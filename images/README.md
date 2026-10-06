# Image builds

One command per CPU architecture builds and uploads everything:

```
sudo ci/build-all.sh 0.8.0-beta5 amd64     # on an amd64 machine
sudo ci/build-all.sh 0.8.0-beta5 arm64     # on an arm64 machine
```

Drone does this on tag pushes (`images-amd64`, `images-arm64`, then `release-images`),
on build VMs prepared with `ci/setup-build-vm.sh`.

| Group | What it makes | Script |
|---|---|---|
| `iso-server` | installer ISOs: server, virt, containers, edge | `iso/build-server-iso.sh` |
| `iso-desktop` | desktop installer ISO (amd64) | `iso/build-iso.sh` |
| `disks` | per server flavour: qcow2, raw.xz, vmdk, ova, vhdx, vhd, vdi, gcp.tar.gz, Incus VM metadata | `images/build-cloud.sh`, `convert.sh`, `make-incus-vm.sh` |
| `pi` | Raspberry Pi images (server, edge), arm64 | `images/build-pi.sh` |
| `containers` | OCI, WSL, Incus container | `images/build-containers.sh` |
| `netboot` | kernel, initrd and iPXE script | `images/make-netboot.sh` |

Files are named `nubo-os-<flavour>-<version>-<arch>.<extension>` and go to
`archive.nubosuite.tech/dl/<version>/` with a `.sha256` and a `.torrent` each
(the torrent lists our download address as a web seed). `ci/publish-release.sh`
then writes `manifest.json`, a signed `SHA256SUMS`, and points
`dl/channels/beta.json` (tag with a dash) at the release. A final tag without a
dash runs `ci/promote-images.sh`, which points `dl/channels/stable.json` at the
beta release: no rebuild. The website reads the two channel files
(`website/tools/make-releases.py`) and shows Stable and Beta tabs.

## Status

Nothing in this folder has run on a real build VM yet. The first runs will need debugging.

Not built, on purpose or not yet:
- Vagrant boxes: they need a `vagrant` user with a published key and passwordless sudo, a standing backdoor.
- UTM bundles: UTM opens the qcow2 directly; a bundle needs a plist generator.
- Public AWS AMI, Azure, Google Cloud and DigitalOcean marketplace listings: they need accounts. The `raw.xz`, `vhd` and `gcp.tar.gz` files are the import files for those.
- Desktop VM disks and the arm64 desktop ISO.
- Cloud images have no login set; users give them one with cloud-init.
