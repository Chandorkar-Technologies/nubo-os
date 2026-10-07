---
title: "Update and remove"
description: "Keep Nubo Office up to date, and remove it without touching your documents."
sidebar:
  order: 50
---

## Update

- **Nubo OS:** the launchers and the suite update with the system.
- **Flatpak from the Nubo repository:**

  ```bash
  flatpak update tech.nubosuite.Office
  ```

## Remove

Your documents are separate files in your own folders. Removing Nubo Office does not delete them.

- **Flatpak from the Nubo repository:**

  ```bash
  flatpak uninstall tech.nubosuite.Office
  ```

- **The suite that Nubo OS downloads on first use** is a Flatpak too. List it with `flatpak list --app` and remove it with `flatpak uninstall`.
- **The launchers on Nubo OS** belong to the package `nubo-office`. Removing it takes the launchers out of the app grid.

## Verify

`flatpak list --app` no longer lists the suite.

## See also

- [Linux and Nubo OS](/office/install/linux/)
