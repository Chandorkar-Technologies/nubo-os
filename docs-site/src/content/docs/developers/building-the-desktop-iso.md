---
title: Building the desktop ISO
description: Build the Nubo OS desktop installer image from Ubuntu's desktop ISO with iso/build-iso.sh, and what each stage does.
sidebar:
  order: 50
---

**Applies to:** Desktop

:::caution[Not yet built by CI]
The Drone pipelines build only the server installer images. The desktop ISO is built by hand with `iso/build-iso.sh`, and `images/README.md` records the script as "built before, needs re-run". The arm64 desktop ISO is written to be architecture-aware but is untested. Treat a first run on any machine as debugging.
:::

The desktop image is not built from scratch. The script starts from the official Ubuntu 26.04 desktop ISO and changes only what is needed. The boot loader, the kernel and Secure Boot signing stay Ubuntu's. The changes:

- The Nubo packages, and everything they depend on, ride on the media under `/nubo/pool`.
- The installer installs them as its last step (`iso/autoinstall.yaml`).
- The live "try it" session has the Nubo packages installed already.
- The boot menu, the volume name and the install choices say Nubo OS.

## Before you begin

- A Linux machine, with root. The script exits with "Run as root." otherwise. It mounts images, uses overlay file systems and runs `chroot`, so a container without those rights will not do.
- The tools `xorriso`, `unsquashfs` and `mksquashfs`. Install them with `sudo apt-get install xorriso squashfs-tools`. The script checks for them first.
- Network access: the script downloads the dependencies of the Nubo packages.
- Ubuntu's desktop ISO for the CPU you target.
- The built Nubo packages in one directory, with file names `nubo-*.deb`. See [Building the packages](/developers/building-packages/).
- Free disk space. The work directory holds an unpacked live layer and the staged media; the script does not state a size. Use at least several tens of gigabytes. <!-- verify: measured disk need not in the repo -->

Usage:

```bash
sudo ARCH=amd64 iso/build-iso.sh UBUNTU_ISO NUBO_DEBS_DIR OUTPUT_ISO
```

| Setting | Default | Meaning |
|---|---|---|
| `ARCH` | `dpkg --print-architecture` | Target architecture; used in the volume name and the disc info line. |
| `WORK` | `/var/tmp/nubo-iso` | Work directory. The script deletes and recreates it. |
| `INSTALLER_SNAP` | unset | Path to a rebuilt installer snap. Unset: the script builds one with `installer/build-installer-snap.sh` (needs Flutter's prerequisites, git and network). `none`: keep Ubuntu's installer app. |

## Steps

Run the script, then read its output. Each stage prints a heading starting with `==>`.

1. **Preparing.** Mounts the source ISO read-only, then the two layers `casper/minimal.squashfs` and `casper/minimal.standard.squashfs`.

2. **Collecting packages the Nubo packages depend on.** Mounts an overlay on the smallest layer, so the result covers every install type. Inside a chroot of it the script:
   - runs `ci/use-cumulus.sh` so Ubuntu's packages come through Nubo Cumulus;
   - adds Mozilla's apt source, pin and key from `data/apt/` so Firefox and its dependencies are also collected;
   - copies in the Nubo packages and runs `apt-get install --download-only`;
   - copies the Nubo packages and every downloaded package into `stage/nubo/pool/`.

   The chroot is made safe first (`enter_prepare`): `/dev`, `/proc`, `/sys` and `resolv.conf` are bound in, a `policy-rc.d` that exits 101 stops services from starting, and `update-initramfs` and `update-grub` are replaced by `/bin/true`.

3. **Installing Nubo into the live session.** Unpacks the live layer `minimal.standard.live.squashfs`, overlays it on the two lower layers, and installs all staged packages with `--force-confnew`. A failure prints the last 40 relevant lines of the log. The script then writes a package manifest for the media.

4. **Rebuilding the media boot files.** The boot screen shown while the media starts lives in the initramfs on the media. The script builds a fresh initramfs for the newest kernel in the live session, copies it to `casper/initrd`, then writes the new initramfs' UUID into `.disk/casper-uuid-*`, because the initramfs only accepts a medium carrying its own UUID. It refuses to continue if the result lacks the `scripts/casper` live-boot scripts.

5. **Replacing the installer app (optional).** If `INSTALLER_SNAP` is set, the script copies it over the `ubuntu-desktop-bootstrap` snap files in the live layer and in the seed.

6. **Packing the live session layer.** Runs `mksquashfs` with the same compression as the original and writes a `.size` file.

7. **Branding the media.** Rewrites `boot/grub/grub.cfg` and `loopback.cfg` ("Try or Install Nubo OS", "Nubo OS (safe graphics)") and adds `loglevel=3 systemd.show_status=false rd.systemd.show_status=false vt.global_cursor_default=0` after `quiet splash`. It writes `.disk/info`, renames the entries in `casper/install-sources.yaml` and copies `iso/autoinstall.yaml` to the root of the media.

8. **Updating checksums.** Drops the entries of replaced files from `md5sum.txt` and adds every staged file.

9. **Writing the image.** `xorriso` copies the staged files into a new image, replays the original boot setup (`-boot_image any replay`) and sets the volume name to `Nubo OS 1 <ARCH>`. A `.sha256` file is written next to the ISO.

## The answer file

`iso/autoinstall.yaml` is read by the installer from the root of the media. Every screen stays interactive (`interactive-sections: ["*"]`); the person installing answers the usual questions. The additions:

| Key | Effect |
|---|---|
| `refresh-installer.update: false` | The installer does not update itself. |
| `apt.fallback: offline-install` | If the network or Cumulus cannot be reached, the installer uses the packages on the media. |
| `apt.geoip: false` | No location lookup for the mirror. |
| `apt.mirror-selection` and `apt.security` | amd64 and i386 use `https://archive.nubosuite.tech/cumulus`; arm64 uses `.../cumulus-arm`. |
| `late-commands` | Copy `/cdrom/nubo/pool/*.deb` into the new system, run `apt-get install` on them inside the target with `--force-confnew`, then delete the copy. |

Doing this in the installer's last step, rather than baking it into Ubuntu's system images, works for every language and install type and survives Ubuntu re-cutting its images.

One detail to keep: `.disk/info` must contain a quoted codename. The installer takes the text before the first quote and crashes on a line without one. The script writes `Nubo OS 1 "Flow" - Release <arch> (<date>)`.

## Verify

1. The script ends with `==> Done` and prints the ISO's size. Check the checksum file against the image:

   ```bash
   sha256sum -c OUTPUT_ISO.sha256
   ```

   Run it from the directory that holds the ISO.

2. Check the volume name and the staged files:

   ```bash
   xorriso -indev OUTPUT_ISO -report_system_area as_mkisofs 2>/dev/null | head -5
   xorriso -indev OUTPUT_ISO -ls /nubo/pool 2>/dev/null | head
   ```

3. Boot the image in a virtual machine. See the checks in [Testing checklist](/developers/testing-checklist/): the boot menu says Nubo OS, the live session shows the Nubo desktop, and after installing, the new system reports Nubo OS.

## Troubleshooting

- **"Run as root."** Use `sudo`.
- **"Missing tool: xorriso" (or `unsquashfs`, `mksquashfs`).** Install `xorriso` and `squashfs-tools`.
- **"No nubo-*.deb files in ...".** The packages directory is empty or wrong. Check the path and file names.
- **Package installation in the live session failed.** Read the lines the script prints. A conflict usually means a server package is in the directory; keep only desktop packages there. (`nubo-server-core` conflicts with `nubo-branding`.)
- **"Rebuilt initramfs has no UUID file" or "lacks the live-boot scripts".** The initramfs was built in a state the script did not expect. Check that the live layer contains the kernel modules for one kernel and that the stubs were unmounted (`umount` of `update-initramfs` happens before the build).
- **Mounts left behind after an error.** The script cleans up on exit with `umount -l`. If a run was killed, check `mount | grep nubo-iso` and unmount by hand before you start again.
- **The installer shows "Ubuntu" in its title.** That text is compiled into the installer app. The image was built with `INSTALLER_SNAP=none`, or by a script version before the build did this itself. Rebuild the image.

## See also

- [Building the server images](/developers/building-server-images/)
- [Testing checklist](/developers/testing-checklist/)
- [Desktop](/desktop/)
