---
title: "Linux and Nubo OS"
description: "Install Nubo Office as a Flatpak from the Nubo repository, and what the Nubo OS launchers do today."
sidebar:
  order: 10
---

**Applies to:** Desktop, and any Linux with Flatpak

:::caution[Planned]
The Flatpak repository at `archive.nubosuite.tech/flatpak` is set up in the build pipeline but has not been published yet. The commands below work once the first build is out. Check the download table on [nubosuite.tech/office](https://nubosuite.tech/office/) for the current state.
:::

## Before you begin

- Flatpak installed. Nubo OS has it already.
- An Intel or AMD computer. Arm is planned after that.

## Steps

1. Add the Nubo repository:

   ```bash
   flatpak remote-add --if-not-exists nubo https://archive.nubosuite.tech/flatpak/nubo.flatpakrepo
   ```

2. Install Nubo Office:

   ```bash
   flatpak install nubo tech.nubosuite.Office
   ```

3. Start it from the app grid, or run `flatpak run tech.nubosuite.Office`.

The repository is signed. The `.flatpakrepo` file carries the key, so Flatpak checks every update against it.

## What the Nubo OS launchers do today

Nubo OS includes the package `nubo-office`, which adds the launchers Nubo Office, Nubo Write, Nubo Cells, Nubo Present and Nubo Draw. Until the repository above carries the Nubo build, each launcher downloads Collabora Office from Flathub on first use and opens the matching part of it. Nubo OS hides the original "Collabora Office" entry so you see only the Nubo names. The program inside still shows the Collabora name until the Nubo build replaces it.

## Verify

```bash
flatpak list --app | grep -i office
```

Look for `tech.nubosuite.Office` (Nubo build) or `com.collaboraoffice.Office` (the Flathub build that the launchers use today).

## Troubleshooting

- **`flatpak: command not found`.** Install Flatpak from your distribution, then add the repository again.
- **The repository cannot be reached.** It is not published yet, or the computer is offline.

## See also

- [Start an app](/office/use/start-an-app/)
- [Pipeline for Nubo Office](/office/collabora/pipeline/)
