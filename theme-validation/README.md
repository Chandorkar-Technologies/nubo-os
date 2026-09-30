# Nubo OS theme validation

Checks that the chosen look works on Ubuntu 26.04 (GNOME 50) before any fork.

| Layer | Upstream | License |
|---|---|---|
| Apps + shell theme | [Colloid-gtk-theme](https://github.com/vinceliuice/Colloid-gtk-theme) | GPL-3.0 |
| Icons | [Colloid-icon-theme](https://github.com/vinceliuice/Colloid-icon-theme) | GPL-3.0 |
| Cursor | Bibata Modern Classic | GPL-3.0 |
| Glass | Blur my Shell (manual install) | check at adoption |

Variant: `grey` + tweaks `black rimless float`, installed under the name `Nubo`.

## Run

Inside a fresh Ubuntu 26.04 desktop VM, as the normal user:

```bash
chmod +x *.sh
./install.sh
# if told to: log out, log in, then
./apply-shell.sh
```

Revert with `./uninstall.sh`.

Run on Linux only. The icon repo contains filenames that differ only by case,
so a checkout on macOS drops files.

## Screenshots to capture

Take each in dark and light (`Nubo-Grey-Dark`, `Nubo-Grey-Light`):

1. Desktop with top bar and dock
2. Activities overview
3. Quick settings open
4. Notification + calendar popup
5. Files (libadwaita app)
6. Settings (libadwaita app)
7. A GTK3 app (e.g. Synaptic or GIMP)
8. Lock screen

## Pass criteria

- No unstyled or broken widgets in shell popups
- Text contrast readable on every surface
- Overview animation smooth on integrated graphics
- Light/dark switch in Settings still works

## Known gaps

- **GNOME 50 not explicitly handled upstream.** Installer's newest branch is
  "48 and above"; GNOME 50 falls into it. This test is what confirms it.
- **Login screen (GDM) is not themed by Colloid.** Needs separate work.
- **Icon theme ships an Apple logo** as its default start icon, plus other
  distro logos. Replace with the Nubo logo before shipping.
- **Cursor** comes from apt; skipped if the release does not package it.
