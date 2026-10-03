---
title: Verify signatures and checksums
description: Check the Nubo archive key on your machine and the checksum of a downloaded server image.
sidebar:
  order: 70
---

**Applies to:** Desktop, Server, Virtualization, Containers, Edge

Two things can be checked: the key that signs Nubo's packages, and the checksum of an installer image you downloaded. This page shows both, and says plainly where the checks stop.

## What is signed

| Item | Signed by | Checked with |
|---|---|---|
| Nubo packages (`nubo-*`) | Nubo archive key | `/usr/share/keyrings/nubo-archive-keyring.gpg`, used automatically by apt |
| Ubuntu packages, also when fetched through [Nubo Cumulus](/updates/nubo-cumulus/) | Ubuntu archive key | `/usr/share/keyrings/ubuntu-archive-keyring.gpg` |
| Server installer image | A SHA-256 checksum published beside it | `sha256sum` |
| Desktop installer image | No checksum is published yet | not available |

## Before you begin

- For the key check: a Nubo OS machine, and a terminal. `gpg` is installed on Ubuntu systems by default.
- For the image check: the `.iso` file and its `.sha256` file in the same folder. On Linux, `sha256sum` is already installed. On macOS use `shasum -a 256`. On Windows use `Get-FileHash` in PowerShell.

## Check the archive key

The correct fingerprint of the Nubo archive key is:

```text
EE1A 4B74 9E23 2015 01F2  0336 0F74 01D7 AF7D 2593
```

1. Print the fingerprint of the key installed on your machine:

   ```bash
   gpg --show-keys --with-fingerprint /usr/share/keyrings/nubo-archive-keyring.gpg
   ```

2. Compare it, character by character, with the line above. The output also shows the key's owner, `Nubo OS Archive <security@nubosuite.tech>`, its type `ed25519`, and an expiry date of 1 October 2031.

3. To compare with a second source, download the public key from the archive and print its fingerprint the same way:

   ```bash
   curl -fsSL https://archive.nubosuite.tech/nubo-archive-keyring.asc | gpg --show-keys --with-fingerprint
   ```

:::caution
The archive and this documentation are both published by Nubo, so they can confirm each other but cannot protect you if both were changed together. The strongest check is to compare the fingerprint with one you got another way, for example by asking support@nubo.email or by reading it from the source repository on GitHub (`repo/nubo-archive-keyring.asc`).
:::

## Check that apt trusts only that key for Nubo

```bash
cat /etc/apt/sources.list.d/nubo.sources
```

The line `Signed-By: /usr/share/keyrings/nubo-archive-keyring.gpg` means the key is used for the Nubo archive and is not added to the system-wide list of trusted keys.

## Check a server image

Server images are published at `https://archive.nubosuite.tech/iso/<version>/`. Each image has a file with the same name plus `.sha256`, in the form `nubo-os-<flavour>-<version>-<arch>.iso`. The flavour is `server`, `virt`, `containers` or `edge`.

1. Download both files into one folder.
2. Run:

   ```bash
   sha256sum -c nubo-os-server-0.8.0-beta10-amd64.iso.sha256
   ```

   Use the name of your own file. The `.sha256` file was written by `sha256sum` next to the image, so it names the image file it belongs to.

3. The command prints the file name and `OK`.

If you cannot run `sha256sum -c`, compute the value and compare it by eye with the one inside the `.sha256` file:

```bash
sha256sum nubo-os-server-0.8.0-beta10-amd64.iso
cat nubo-os-server-0.8.0-beta10-amd64.iso.sha256
```

:::note
The checksum proves that your download is complete and matches the file Nubo published. It does not prove who published it. The `.sha256` file is not itself signed.
:::

### What was checked while the image was built

When the image is built, the build script first downloads Ubuntu's own server image and compares it with the SHA256SUMS list that Ubuntu publishes next to it. The build stops if they differ. Nubo then repackages that image with its own files.

## Verify

- Key: the fingerprint printed on your machine equals `EE1A 4B74 9E23 2015 01F2 0336 0F74 01D7 AF7D 2593`.
- Archive: `sudo apt update` finishes without a line saying a signature could not be verified.
- Image: `sha256sum -c` prints `OK`.

## Troubleshooting

**`sha256sum: WARNING: 1 computed checksum did NOT match`.**
The download is damaged or incomplete. Download the image again, preferably with a tool that can resume (`curl -C - -O`). If it fails twice, write to support@nubo.email with the file name.

**`No such file or directory` from `sha256sum -c`.**
The `.sha256` file names an image that is not in the current folder, or you renamed the image. Put both files in the same folder under their original names.

**`apt update` says `The following signatures couldn't be verified because the public key is not available`.**
The key file is missing or damaged. Reinstall the package that ships it: `sudo apt install --reinstall nubo-archive`. If apt cannot reach the archive at all, download the package file from a working machine and install it with `sudo dpkg -i`.

**`gpg: no valid OpenPGP data found`.**
The path is wrong or the file is empty. A development build made without a signing key installs an empty key file and a disabled source (`Enabled: no`). Released builds always contain the key.

**The fingerprint differs.**
Stop. Do not install packages from this archive on that machine. Write to security@nubosuite.tech.

## See also

- [The Nubo archive](/updates/the-nubo-archive/)
- [Nubo Cumulus](/updates/nubo-cumulus/)
- [Ubuntu's own verification instructions](https://ubuntu.com/tutorials/how-to-verify-ubuntu) for the base image
