---
title: "Web browser: Firefox"
description: How Firefox is provided on Nubo OS, why there can be two copies, and how to keep it updated.
sidebar:
  order: 60
---

**Applies to:** Desktop

Firefox is the default browser in Nubo OS and the first icon in the dock. It does not come as a snap. This page states exactly how Firefox is provided, because the project currently uses two routes and a fresh install can end up with both.

## What the project does

1. **A regular package from Mozilla.** The `nubo-desktop` package recommends `firefox`. The Nubo branding package adds Mozilla's apt repository (`https://packages.mozilla.org/apt`, suite `mozilla`) and gives it priority 1000 with an apt preference. That makes apt pick Mozilla's package instead of Ubuntu's `firefox` package, which is only a wrapper for a snap. The signing key is stored in `/etc/apt/keyrings/packages.mozilla.org.asc`. The files are:
   - `/etc/apt/sources.list.d/mozilla.sources`
   - `/etc/apt/preferences.d/mozilla.pref`
2. **A Flatpak from Flathub.** The first-boot cleanup also installs `org.mozilla.firefox` from Flathub, for the whole system, if there is a network.

The first-boot service also removes the Firefox snap if one exists. The dock has an entry for both ids (`firefox.desktop` and `org.mozilla.firefox.desktop`), so the dock icon works for whichever copy you have.

:::note
Both routes are in the project. Which copy ends up on your machine depends on the install. The installer image carries the Mozilla repository, so the package route is available when the system is installed from it. The Flatpak is added at first boot if you are online. If you see Firefox twice in the app grid, this is why. <!-- verify: confirm on a real install which copy(ies) appear -->
:::

## Which one am I using?

```bash
apt list --installed 2>/dev/null | grep '^firefox/'
flatpak list --app | grep -i firefox
snap list firefox 2>/dev/null
```

- The first line prints a line if the Mozilla package is installed.
- The second prints a line if the Flatpak is installed.
- The third should print nothing. Nubo OS removes the snap.

## Before you begin

- A terminal.
- For updating: an internet connection.

## Keep Firefox up to date

- **Package copy:** it updates with the rest of the system through apt. See [Updates](/updates/).
- **Flatpak copy:** it updates with other Flatpak apps. See [Update apps](/desktop/apps/update-apps/).

```bash
sudo apt update && sudo apt install --only-upgrade firefox
flatpak update org.mozilla.firefox
```

## Use only one copy

Two copies keep separate profiles. Your bookmarks and passwords are in the profile of the copy you used.

1. Decide which copy you want. The package copy gets access to your whole home folder. The Flatpak copy is sandboxed.
2. Use that copy for a while, and import bookmarks into it if needed (**Bookmarks**, then import, in Firefox's menus). <!-- verify label -->
3. Remove the other:

```bash
flatpak uninstall org.mozilla.firefox      # keep the package copy
sudo apt remove firefox                    # keep the Flatpak copy
```

The package copy keeps its profile in `~/.mozilla/firefox`. The Flatpak copy keeps it in `~/.var/app/org.mozilla.firefox`.

## Verify

- Open Firefox, then visit the address `about:support`. It lists the version and the profile folder, which tells you which copy runs.

## Troubleshooting

**Firefox is missing from the dock.** The dock lists `firefox.desktop` and `org.mozilla.firefox.desktop`. If neither copy is installed, the icon is not shown. Install one.

**apt wants the snap version of Firefox.** The Mozilla repository or its preference file is missing. Check that `/etc/apt/preferences.d/mozilla.pref` exists. It is part of the `nubo-branding` package.

**Updates fail with a signature error.** The key in `/etc/apt/keyrings/packages.mozilla.org.asc` must match Mozilla's. Reinstall `nubo-branding` to restore it.

**Video or audio does not play in the Flatpak copy.** Run `flatpak update` and restart Firefox.

## See also

- [Install and remove apps](/desktop/apps/install-and-remove-apps/)
- [Flatpak basics](/desktop/apps/flatpak-basics/)
