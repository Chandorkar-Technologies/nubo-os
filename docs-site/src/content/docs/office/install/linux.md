---
title: "Linux and Nubo OS"
description: "Install Nubo Office as a Flatpak, or use the launchers that come with Nubo OS."
sidebar:
  order: 20
---

**Applies to:** Desktop, and any Linux with Flatpak

## On Nubo OS

Nubo OS includes the launchers **Nubo Office**, **Nubo Write**, **Nubo Cells**, **Nubo Present** and **Nubo Draw**. Open one from the app grid. The first time, the computer must be online: a small window shows the download, then the app opens.

## On other Linux systems

:::caution[Planned]
The Nubo Flatpak repository is set up but not published yet. The commands below work once it is. The download table on [nubosuite.tech/office](https://nubosuite.tech/office/) shows when.
:::

### Before you begin

- Flatpak installed.
- An Intel or AMD computer. Arm follows.

### Steps

1. Add the Nubo repository:

   ```bash
   flatpak remote-add --if-not-exists nubo https://archive.nubosuite.tech/flatpak/nubo.flatpakrepo
   ```

2. Install Nubo Office:

   ```bash
   flatpak install nubo tech.nubosuite.Office
   ```

3. Start it from the app grid, or run:

   ```bash
   flatpak run tech.nubosuite.Office
   ```

The repository is signed, and Flatpak checks every update against its key.

## Verify

```bash
flatpak list --app | grep -i office
```

The suite appears in the list.

## Troubleshooting

- **`flatpak: command not found`.** Install Flatpak from your distribution, then add the repository again.
- **The repository cannot be reached.** It is not published yet, or the computer is offline.
- **The first start shows a download error.** Connect to the internet and open the app again.

## See also

- [Update and remove](/office/install/update-and-remove/)
- [Start an app](/office/use/start-an-app/)
