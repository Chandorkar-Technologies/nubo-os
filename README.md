# Nubo OS

Desktop operating system for the Nubo suite. Ubuntu 26.04 LTS underneath,
own look and identity on top, delivered as packages so Ubuntu security updates
keep flowing unchanged.

## Packages

| Package | Contents | Built from |
|---|---|---|
| `nubo-theme` | App, shell and login screen theme | Colloid GTK theme, grey + black tweak |
| `nubo-icons` | Grey folders, Nubo mark as logo | Thin layer over Papirus (from Ubuntu archive) |
| `nubo-sounds` | System sounds | Ocean sound theme (from Ubuntu archive) |
| `nubo-glass` | Frosted blur on top bar, dock, menus, overview, lock screen | Blur my Shell 73 |
| `nubo-branding` | Logo, wallpapers, boot screen, desktop defaults, system name, first-run setup | Own |
| `nubo-installer` | Installer illustrations, slides, colours, window title | Own, over the installer's white-label support |
| `nubo-account` | Sign in with a Nubo account; sets itself up on first boot with network | Own, over Ubuntu's authd |
| `nubo-desktop` | Installs all of the above | |

Upstream sources fetched at build time are pinned in `vendor/fetch.sh`.
Papirus and Ocean are ordinary dependencies and update with Ubuntu.

## Layout

| Path | Purpose |
|---|---|
| `brand/` | Logo, wallpaper generator (`wallpapers/generate.py`), icon layer builder, login theme builder, sound audition |
| `installer/` | Installer white-label files: page illustrations, slides |
| `data/` | Files shipped as-is: desktop defaults, boot screen, system identity |
| `debian/` | Package definitions |
| `iso/` | Installer image build |
| `account/` | Sign-in with a Nubo account |
| `vendor/` | Pinned upstream sources (fetched, not committed) |
| `vm/` | Development VMs: create, provision, build, screenshot, click, type |
| `screenshots/` | Review captures, one folder per build |

## Development VMs

On a Proxmox host, private network only. Point the scripts at it once:

```bash
mkdir -p ~/.config/nubo-os && echo 'PVE_HOST=root@your-proxmox-host' > ~/.config/nubo-os/env
```

| VM | Purpose |
|---|---|
| 301 `nubo-os-dev` | Builds packages and the installer image, shows the desktop |
| 302 `nubo-os-install-test` | Empty machine that boots the installer image |

```bash
vm/sync-and-build.sh                      # build packages in VM 301 and install
vm/capture-set.sh screenshots/<name>      # desktop, Files, Settings, menus
vm/capture-boot.sh screenshots/<name>/boot

# installer image, inside VM 301
sudo iso/build-iso.sh ubuntu-26.04.1-desktop-amd64.iso out/ nubo-os-1-amd64.iso
```

Packages must be built on Linux. Some upstream sources contain filenames
that differ only by case, which macOS drops silently.

Snapshots on VM 301: `desktop_clean` (stock Ubuntu), `nubo_v0_2`, `nubo_v0_3`.
Roll back with `qm rollback 301 <name>` on the Proxmox host.

## Installer image

Built from the official Ubuntu Desktop image rather than from scratch.

- Nubo packages and their dependencies ride on the media under `/nubo/pool`
- The installer installs them as its final step (`iso/autoinstall.yaml`)
- The live session has them preinstalled
- Boot menu, volume name and install choices say Nubo OS
- Boot loader and kernel stay Ubuntu's signed ones, so Secure Boot works

## Sign-in with a Nubo account

`nubo-account` connects the login screen to Nubo SSO (`https://mail.nubo.email`).
On the first boot with a network connection it fetches Ubuntu's OIDC
connector and configures it; until then it retries every boot. The login
screen then offers "Nubo Account": a QR code and a short code, approved from
a phone or another computer. The first account to sign in owns the machine.

## Installer app

The installer's product name ("Welcome to Ubuntu", "Install Ubuntu") is a
fixed list compiled into the app, so `installer/build-installer-snap.sh`
rebuilds the app from the exact upstream sources and Flutter version the
shipped snap used, with the name changed to Nubo OS, and repacks the snap.
`iso/build-iso.sh` swaps it in when `INSTALLER_SNAP` points at the result.

## Wallpapers

Four procedural monochrome designs, each in dark and light: Flow (default),
Contours, Beam, Shards. Generated at 3840x2160 during the package build from
`brand/wallpapers/generate.py`; no external artwork.

## Known gaps

- Terminal in the live session still uses Ubuntu's purple palette in some
  profiles
- Boot menu entry reads "Ubuntu" (hidden on a normal start)
- Sign-in via Nubo account not yet approved end to end with a real account
- Dark mode for modern apps is libadwaita's own dark grey, not pure black


<!-- Security scan triggered at 2026-10-07 11:18:08 -->

<!-- Security scan triggered at 2026-10-07 14:37:17 -->