# Facts sheet (starting point; the repository is the authority)

Verified from the repo on 3 Oct 2026. If a fact here disagrees with the code, trust the code and fix this file.

## Product
- Nubo OS 1 "Flow": Ubuntu 26.04 LTS ("resolute") with GNOME 50, by Chandorkar Technologies. Free download. Five years of security updates (to April 2031) from the base system. Architectures built: amd64 and arm64 (Nubo Search ships for both).
- Desktop installer: Ubuntu's installer, branded Nubo. Server installer: Ubuntu Server's text installer (Subiquity), branded; answer files in `iso/autoinstall.yaml` (desktop) and `iso/server-user-data` (server).
- Images: desktop ISO (`iso/build-iso.sh`, Linux builder); server ISOs for 4 flavours x amd64/arm64 (`iso/build-server-iso.sh`, FLAVOUR=server|virt|containers|edge); cloud/VM images (`images/build-cloud.sh`: qcow2, vhd, vmdk) and Raspberry Pi (`images/build-pi.sh`). CI builds server ISOs and uploads to archive.nubosuite.tech/iso/<version>/. The desktop ISO is not yet built by CI.

## Packages (source package nubo-os, version 0.8.0~beta3 at the time of writing)
Desktop: nubo-desktop (metapackage), nubo-theme, nubo-icons, nubo-sounds, nubo-glass (blur and extensions), nubo-branding (identity, wallpapers, boot screen, default avatar), nubo-installer, nubo-account, nubo-search (amd64, arm64), nubo-notify, nubo-apps, nubo-base, nubo-archive.
Server: nubo-server-core, nubo-server-base, nubo-edge, nubo-podman, nubo-incus, plus nubo-base, nubo-archive. nubo-server-core conflicts with nubo-branding (a machine is desktop or server) and with snapd, landscape-common, lxd-installer, ubuntu-pro-client.

## Desktop features (what is real)
- Top bar 40 px high. Left: the Nubo logo with the text "Nubo OS 1". Clicking it opens the Activities overview (there is no drop-down menu). (menu/extension)
- Dock and app grid with folders (data/dconf/nubo-app-folders). Grey "placeholder" icons for popular apps that are not installed: clicking downloads from Flathub and opens the app (`nubo-get`, `nubo-app-stubs`, list in data/apps/popular.list, kinds: flatpak and web apps).
- First boot installs from Flathub (needs network, retried next boot): Firefox, LocalSend, Newelle, Collabora Office, Shortwave, Spotify (x86 only), VLC. Per-app: an app that does not exist for the CPU is skipped. Geary is the default mail app. LibreOffice is removed in favour of Collabora Office.
- Notification centre: history panel (GNOME Shell extension nubo-notify-center) plus a background agent (`nubo-notify-agent`) that keeps messaging apps (Geary, Telegram, Slack, Discord, Signal; list in /usr/share/nubo/notify/background-apps.json) running so notifications arrive while windows are closed.
- Widgets (extension glass-widgets, Nubo build): draggable cards on the desktop: Clock with weather, System (RAM, CPU), Calendar. Positions saved in ~/.config/nubo/widgets.json. Defaults set in the gsettings override (show-clock, show-weather, show-stats, show-calendar).
- Nubo Search (Vicinae-based launcher): <kbd>Super</kbd>+<kbd>Space</kbd>, command `nubo-search toggle`. Layout switching moved to <kbd>Alt</kbd>+<kbd>Shift</kbd>.
- Phone link: GSConnect (GNOME Shell extension) and scrcpy.
- Theme: Nubo glass theme, dark by default, light supported; follows the system light/dark switch (session helper `nubo-session-helper`). Fonts Inter and JetBrains Mono. Cursor Bibata. Eight wallpapers (photographs) in /usr/share/backgrounds/nubo/, listed in SOURCES.md in brand/wallpapers.
- Default profile picture: the Nubo mark on an orange gradient disc, applied at first boot / first login if the person has none.
- GNOME Online Accounts: a patched provider "Nubo" exists (goa/), tested against a fake server only; patched Settings list not installed by default. Mark as preview.
- Nubo account sign-in at the login screen: `nubo-account` (uses the authd-oidc broker, distributed as a snap, so snapd stays on the desktop). Mail server mail.nubo.email (Stalwart). Treat sign-in as early access.
- Not built yet (say "Planned"): Nubo Drive, Nubo Backup, migration app, Nubo Pro, benchmarks, a Nubo Store with its own cloud login, translations.

## Updates and archive
- Package archive: https://archive.nubosuite.tech (Cloudflare R2), signed with key fingerprint EE1A4B749E23201501F203360F7401D7AF7D2593. Channels: `resolute` (stable) and `resolute-beta`. Switch with `sudo nubo-channel beta|stable`. Package `nubo-archive` installs the source file, the key, and automatic installs of Nubo and Ubuntu security updates.
- Nubo Cumulus (Cloudflare Worker): caches Ubuntu's archive at https://archive.nubosuite.tech/cumulus (amd64) and /cumulus-arm (arm64); also /cumulus-images (cdimage.ubuntu.com), /cumulus-releases (releases.ubuntu.com), /cumulus-cloud (cloud-images.ubuntu.com), /check (network check). apt uses `mirror+` with mirrors.txt: Cumulus priority 1, Ubuntu priority 2 as fallback. Opt out: `sudo touch /etc/nubo/no-cumulus` and reinstall nubo-archive. Ubuntu's signatures are untouched.
- nubo-base: network check to Nubo, time servers time.cloudflare.com (NTS) and pool.ntp.org, masks motd-news, whoopsie, apport reporting, Ubuntu Pro timers, release-upgrade prompt off, debuginfod off. Remaining contacts with Canonical: see docs/ubuntu-endpoints.md in the repo.
- Releases: tag v0.8.0-betaN builds and publishes to beta; tag v0.8.0 promotes beta to stable (no rebuild). Every release needs a new version in debian/changelog.

## Server
- Core (nubo-server-core): identity "Nubo OS Server 1", SSH without root login (password login stays on until a key is installed), ufw closed except SSH (run once by the package on first install), kernel hardening sysctl, chrony, apparmor, GRUB distributor "Nubo OS".
- Server (nubo-server-base): core + unattended-upgrades, fail2ban, needrestart, curl, htop, less, vim-tiny.
- Edge (nubo-edge): core + unattended-upgrades only.
- Containers (nubo-podman): server + podman, buildah, skopeo, uidmap, passt; `nubo-podman-init` (enable linger and the Podman socket for your user); Docker Hub as short-name registry.
- Virtualization (nubo-incus): server + incus, zfsutils-linux, bridge-utils; `nubo-incus-init` (preseed: bridge nubobr0, dir storage pool "default"); the server ISO also installs QEMU for the CPU.
- Server installer: language, keyboard, network, storage, user, SSH screens stay interactive; installer-update, snaps, Pro and mirror screens are skipped; Ubuntu's packages come through Cumulus; the minimal server source is chosen.

## Commands shipped
nubo-get (install an app from Flathub), nubo-app-stubs (writes grey launchers), nubo-search, nubo-notify-agent, nubo-session-helper, nubo-channel, nubo-incus-init, nubo-podman-init, nubo-server-firewall (/usr/libexec/nubo/).

## Paths
/etc/apt/sources.list.d/nubo.sources, ubuntu.sources (points at Cumulus; Ubuntu's kept as ubuntu.sources.ubuntu); /usr/share/keyrings/nubo-archive-keyring.gpg; /etc/nubo/no-cumulus (opt-out marker); ~/.config/nubo/widgets.json; /usr/share/nubo/ (shared data); /usr/share/backgrounds/nubo/; /usr/lib/os-release (diverted).

## Support and contact
support@nubo.email; docs https://docs.nubosuite.tech; code https://github.com/Chandorkar-Technologies/nubo-os; security reports: security@nubosuite.tech.
