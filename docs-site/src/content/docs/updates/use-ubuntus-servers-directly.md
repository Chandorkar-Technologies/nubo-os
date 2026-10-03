---
title: Use Ubuntu's servers directly
description: Stop fetching Ubuntu's packages through Nubo Cumulus and use Ubuntu's own servers instead.
sidebar:
  order: 60
---

**Applies to:** Desktop, Server, Virtualization, Containers, Edge

By default, Ubuntu's packages on Nubo OS come through [Nubo Cumulus](/updates/nubo-cumulus/). The packages are identical and signed by Ubuntu either way. If you would rather your machine talk to Ubuntu's servers directly, for example because of a company rule, you can switch. This page does that.

This changes only where Ubuntu's packages come from. The Nubo packages still come from `archive.nubosuite.tech`, because Ubuntu does not carry them.

## Before you begin

- A Nubo OS machine with administrator rights (`sudo`).
- A terminal.
- Nubo's `nubo-archive` package installed, which is the case on every edition.

:::caution
The repository documents the marker file `/etc/nubo/no-cumulus` and says to reinstall `nubo-archive` after creating it. Reading the package's install script shows that, on a machine that already uses Cumulus, the marker only stops the Nubo file from being installed again. It does not put Ubuntu's file back. The steps below do both. They were traced from the scripts and have not been tested on a running machine.
:::

## Steps

1. Create the marker. The package looks for it and leaves your choice alone from now on, including on later updates:

   ```bash
   sudo mkdir -p /etc/nubo
   sudo touch /etc/nubo/no-cumulus
   ```

2. Check that Ubuntu's original source file is still beside the Nubo one:

   ```bash
   ls -l /etc/apt/sources.list.d/ubuntu.sources*
   ```

   You should see `ubuntu.sources` and `ubuntu.sources.ubuntu`. The second is Ubuntu's own file, kept by the package when it put the Nubo file in its place.

3. Put Ubuntu's file back. Keep the Nubo version under another name in case you want to return:

   ```bash
   sudo mv /etc/apt/sources.list.d/ubuntu.sources /root/ubuntu.sources.cumulus
   sudo cp /etc/apt/sources.list.d/ubuntu.sources.ubuntu /etc/apt/sources.list.d/ubuntu.sources
   ```

   Files that do not end in `.sources` are ignored by apt, so the `.ubuntu` copy beside it does no harm.

4. Refresh the lists:

   ```bash
   sudo apt update
   ```

## Return to Nubo Cumulus

1. Remove the marker and put the Nubo file back:

   ```bash
   sudo rm /etc/nubo/no-cumulus
   sudo mv /root/ubuntu.sources.cumulus /etc/apt/sources.list.d/ubuntu.sources
   ```

   If you no longer have that file, run `sudo apt install --reinstall nubo-archive` instead. With the marker gone, the package installs its Cumulus file again.

2. Run `sudo apt update`.

## Verify

```bash
grep -h '^URIs' /etc/apt/sources.list.d/ubuntu.sources
```

Direct use shows an Ubuntu address (`http://archive.ubuntu.com/ubuntu` or similar, depending on Ubuntu's file). Cumulus use shows `mirror+https://archive.nubosuite.tech/cumulus/mirrors.txt`. Then:

```bash
sudo apt update
apt-cache policy bash
```

The `update` output lists each address apt contacted, and the `policy` output lists the source each version comes from.

## Troubleshooting

**`ubuntu.sources.ubuntu` does not exist.**
The machine never switched to Cumulus, or the file was removed. In that case `ubuntu.sources` already holds whatever Ubuntu's installer wrote and you only need the marker from step 1. If the file is missing and `ubuntu.sources` points at Cumulus, edit the `URIs:` line by hand to `http://archive.ubuntu.com/ubuntu/` on amd64 or `http://ports.ubuntu.com/ubuntu-ports/` on arm64.

**After an update the file points at Cumulus again.**
The marker is missing. Check `ls /etc/nubo/no-cumulus`. Create it again and repeat steps 2 and 3.

**`apt update` fails with a signature error.**
The file you copied back is damaged or from another release. Copy it again from `ubuntu.sources.ubuntu`. Ubuntu's file already names Ubuntu's own key, so no extra key is needed.

**Can I just remove `nubo-archive`?**
Do not. Other Nubo packages depend on it, so removing it would also remove them, along with the Nubo source and the key they need to update.

## See also

- [Nubo Cumulus](/updates/nubo-cumulus/)
- [Privacy and network endpoints](/updates/privacy-and-network-endpoints/)
- [Files and paths reference](/reference/files-and-paths/)
