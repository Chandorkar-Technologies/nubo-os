---
title: Choose an image
description: Pick the right Nubo OS Server installer image for your CPU and use case, download it and verify the checksum.
sidebar:
  order: 10
---

**Applies to:** Server, Virtualization, Containers, Edge

Nubo OS Server is distributed as eight installer images: four editions, each built for two kinds of CPU. This page helps you pick one, download it, and check that the file arrived intact.

## The eight images

Every image is a normal installer ISO that boots on UEFI machines and virtual machines.

| Edition | amd64 file | arm64 file |
|---|---|---|
| Server | `nubo-os-server-<version>-amd64.iso` | `nubo-os-server-<version>-arm64.iso` |
| Virtualization | `nubo-os-virt-<version>-amd64.iso` | `nubo-os-virt-<version>-arm64.iso` |
| Containers | `nubo-os-containers-<version>-amd64.iso` | `nubo-os-containers-<version>-arm64.iso` |
| Edge | `nubo-os-edge-<version>-amd64.iso` | `nubo-os-edge-<version>-arm64.iso` |

The word in the file name (`server`, `virt`, `containers`, `edge`) is the edition. Each file has a companion checksum file with the same name plus `.sha256`.

### Which CPU type

- **amd64**: nearly all PCs and servers with an Intel or AMD processor, and virtual machines on those.
- **arm64**: Arm servers that boot a UEFI installer, and virtual machines on Apple silicon Macs (M1 and later). The [UTM guide](/server/install/install-in-utm/) uses this image.

The CPU type of the image must match the CPU your virtual machine uses. On an Apple silicon Mac, the fast path is an arm64 guest.

### Which edition

| If you want... | Choose |
|---|---|
| A general purpose server with automatic security updates, brute-force protection and everyday tools | Server |
| To run virtual machines and system containers with Incus | Virtualization |
| To run containers with Podman | Containers |
| The smallest system for a small board, old hardware or an appliance | Edge |

The editions share one core, so you can add another edition's package later. For example, you can install `nubo-podman` on a Server machine. See [Server flavours](/server/flavours/) for the full comparison.

## Before you begin

- A computer with a browser or `curl`, and enough free space for the file.
- A command line with a SHA-256 tool: `sha256sum` on Linux, `shasum` on macOS, `Get-FileHash` in Windows PowerShell.

## Download

Images are published at this address pattern:

```text
https://archive.nubosuite.tech/iso/<version>/nubo-os-<flavour>-<version>-<arch>.iso
https://archive.nubosuite.tech/iso/<version>/nubo-os-<flavour>-<version>-<arch>.iso.sha256
```

`<version>` is the release number without the leading `v`. For a release tagged `v0.8.0-beta3` the version is `0.8.0-beta3`. <!-- verify: which version is the current download -->

1. Pick your edition and CPU type from the table above.
2. Set shell variables so the commands below stay short. Replace the values with yours:

   ```bash
   VERSION=0.8.0-beta3
   FLAVOUR=server
   ARCH=arm64
   BASE=https://archive.nubosuite.tech/iso/$VERSION
   ```

3. Download the image and its checksum file:

   ```bash
   curl -fLO "$BASE/nubo-os-$FLAVOUR-$VERSION-$ARCH.iso"
   curl -fLO "$BASE/nubo-os-$FLAVOUR-$VERSION-$ARCH.iso.sha256"
   ```

## Verify the checksum

The `.sha256` file is written in the standard `sha256sum` format, with the file name next to the hash, so you can check it directly. Keep both files in the same folder.

On Linux:

```bash
sha256sum -c "nubo-os-$FLAVOUR-$VERSION-$ARCH.iso.sha256"
```

On macOS:

```bash
shasum -a 256 -c "nubo-os-$FLAVOUR-$VERSION-$ARCH.iso.sha256"
```

Expected output:

```text
nubo-os-server-0.8.0-beta3-arm64.iso: OK
```

On Windows PowerShell, print the hash and compare it by eye with the contents of the `.sha256` file:

```powershell
Get-FileHash .\nubo-os-server-0.8.0-beta3-arm64.iso -Algorithm SHA256
```

:::note
The checksum shows that your download is complete and matches the file Nubo published. It does not prove who made the file, because the checksum is served from the same place as the image. We have not found a separate signature file for the images in the repository. If that matters to you, build the image yourself from the repository (`iso/build-server-iso.sh`).
:::

## Troubleshooting

**`curl` reports 404.** The version, edition or CPU type in the address does not match a published file. Check the spelling of the edition (`virt`, not `virtualization`) and that the version has no leading `v`.

**The checksum check says `FAILED`.** The download is incomplete or damaged. Delete the ISO and download it again. If it fails twice, report it to support@nubo.email with the file name.

**`No such file or directory` when checking.** The `.sha256` file names the ISO without a path, so the ISO must be in the folder where you run the command.

**The image will not boot because of the CPU type.** An arm64 image does not boot on an Intel or AMD machine, and the other way around. Download the matching image.

## See also

- [Install in UTM on a Mac](/server/install/install-in-utm/)
- [Install on bare metal](/server/install/install-on-bare-metal/)
- [Server flavours](/server/flavours/)
- [Images](/server/images/)
