# Ubuntu 26.04 LTS Desktop (GNOME 50): security defaults, gaps, rollback, passkeys (as of Oct 2026)

Note: about 20 searches/fetches. Many fetches were summarised by a small model, so exact wording should be spot-checked. Secondary sources are marked (secondary).

## Firewall and default open ports/services

### Takeaway
ufw is reported as installed but disabled by default on 26.04 Desktop, so there is no active firewall out of the box (secondary sources only; no Canonical primary found). GNOME Remote Desktop (RDP) is shipped, but the sources found do not say whether it is on by default. Avahi, cups-browsed and SSH defaults were not verified.

### Cited Findings
- ufw ships on Desktop and Server but is disabled by default; when enabled it denies incoming and allows outgoing. gufw is not installed. (secondary; linuxconfig search snippet, page itself returned 403) — [LinuxConfig](https://linuxconfig.org/default-firewall-configuration-guide-on-ubuntu-26-04)
- GNOME Remote Desktop is included in a standard 26.04 desktop install. Remote Login uses RDP 3389 and Desktop Sharing uses 3390. Settings > System > Remote Desktop. The sources describe it as available, not as enabled by default. (secondary) — [Server World](https://www.server-world.info/en/note?os=Ubuntu_26.04&p=desktop&f=7); [Hypertext Dispatches](https://tenthirtyam.org/dispatches/2026/05/14/setting-up-rdp-on-ubuntu-2604-lts/)
- Docker 29 in 26.04 has an experimental nftables backend. This is irrelevant to desktop defaults. — [26.04 release notes](https://documentation.ubuntu.com/release-notes/26.04/changes-since-previous-interim/)

### Inferences
- A derivative that wants a default-deny inbound posture must enable ufw (or firewalld) itself, with rules for mDNS/KDE Connect-style needs as required.
- Because ufw is off, the exposure of avahi, cups-browsed and RDP depends on their service state, which must be audited with `ss -tulpn` on a real 26.04 image.

### Gaps
- Primary-source confirmation (Ubuntu docs, a Launchpad bug) that ufw is disabled by default on Desktop. Only secondary sources were found.
- Default state of avahi-daemon (UDP 5353), cups-browsed (UDP 631), sshd (not installed on Desktop historically) and gnome-remote-desktop. Not verified.

## Installer: TPM-backed FDE, LUKS, Secure Boot, Security Center

### Takeaway
26.04 offers TPM-backed FDE (snap/FDE-based, Beta in the 26.04 docs) with a recovery key shown at install, optional PIN/passphrase, and several documented limitations. Standard LUKS2 is also offered. A recovery key is mandatory insurance because firmware or boot-setting changes trigger recovery prompts.

### Cited Findings
- The installer supports TPM-backed FDE. The key is sealed in TPM 2.0 and bound to Secure Boot measurements, and the disk unlocks automatically if integrity is intact. — [Ubuntu Desktop docs 26.04](https://ubuntu.com/desktop/docs/en/26.04/how-to/encrypt-your-disk-with-tpm/); [26.04 summary](https://documentation.ubuntu.com/release-notes/26.04/summary-for-lts-users/)
- The docs page marks the feature as Beta. At the end of install the installer shows a recovery key (save to USB, QR code, photo), and losing it may cost the data in some scenarios. — [Ubuntu Desktop docs 26.04](https://ubuntu.com/desktop/docs/en/26.04/how-to/encrypt-your-disk-with-tpm/)
- Recovery key is requested after hardware changes, BIOS/UEFI/firmware updates, boot setting changes, authentication failures and TPM resets. Retrieve it later with `sudo snap recovery --show-keys`. The earlier plan was to integrate recovery key creation into the installer and Security Center by 26.04, with automated remote backup still only "on the roadmap". — [Ubuntu Discourse](https://discourse.ubuntu.com/t/hardware-backed-encryption-and-recovery-keys-in-ubuntu-desktop/58243)
- 26.04 adds readiness checks, and PIN support is "fully integrated". Known limitations: some eligible systems are detected as ineligible, and a forgotten PIN/passphrase cannot be removed or replaced once booted with the recovery key. Disk re-encryption is unsupported. It uses a specific kernel snap (for example NVMe RAID needing `vmd` may be missing). Only NVIDIA out-of-tree drivers are supported (no other DKMS). The PIN prompt keyboard layout bug is fixed by snapd 2.75. — [Release notes 26.04](https://documentation.ubuntu.com/release-notes/26.04/changes-since-previous-interim/); known-issues roundup (secondary) [search result summarising beta notes]
- A beta known issue: TPM FDE is incompatible with Absolute security software. (secondary summary of beta notes)
- Ubuntu documents LUKS2 as the default standard encryption, enabled via "Encrypt the installation" in Advanced features. (secondary) — [ubuntu.fan](https://ubuntu.fan/en/docs/ops/security/disk-encryption)
- A Security Center app exists (added in 24.10). It hosts the experimental permissions-prompting feature for Home directory access. — [26.04 summary](https://documentation.ubuntu.com/release-notes/26.04/summary-for-lts-users/)
- Other hardening in 26.04: new AppArmor profiles (may break unanticipated uses), OpenSSH 10.2p1 (mlkem768x25519 post-quantum KEX, DSA removed), OpenSSL 3.5 with ML-KEM/ML-DSA, glycin sandboxed image loading, rust-coreutils default, sudo-rs. rust-coreutils had known CVEs listed (CVE-2026-35341 to 35377). — [26.04 summary](https://documentation.ubuntu.com/release-notes/26.04/summary-for-lts-users/); [changes since 25.10](https://documentation.ubuntu.com/release-notes/26.04/changes-since-previous-interim/)

### Inferences
- A derivative inheriting the Ubuntu installer inherits the Beta FDE caveats and its snap-based kernel dependency. That conflicts with DKMS-based drivers and custom kernel modules.
- The recovery key must be treated as a first-class UX item (print or password-manager flow), given firmware updates trigger recovery prompts.

### Gaps
- Exact PCR set and exact behaviour after Secure Boot dbx/shim updates. The docs only say firmware/boot changes may require recovery; whether fwupd dbx updates are auto-handled via re-sealing was not verified. The TPM explanation article was not fetched.
- Whether the Security Center in 26.04 offers recovery-key management. Not verified.

## Rollback and snapshots

### Takeaway
Ubuntu 26.04 defaults to ext4, with no built-in snapshot-before-upgrade; Timeshift (rsync mode) works on ext4 and btrfs snapshot tooling needs a btrfs install. Fedora Atomic/Bazzite use rpm-ostree deployments and Vanilla OS uses ABRoot A/B.

### Cited Findings
- Ubuntu desktop and server still default to ext4. Timeshift 25.12.x is in the 26.04 repos and its RSYNC mode works on ext4. BTRFS mode requires an `@`/`@home` layout; Snapper works on btrfs. (secondary) — [LinuxCapable](https://linuxcapable.com/how-to-install-timeshift-on-ubuntu-linux/)
- A btrfs setup guide for 26.04 exists. (secondary) — [Niladic Podcast](https://www.niladicpodcast.com/2026/05/23/how-to-setup-ubuntu-26.04-btrfs/)
- rpm-ostree (Fedora Atomic, Bazzite) keeps two deployments with GRUB entries, and `rpm-ostree rollback` switches back; Bazzite has a rollback helper. (secondary/primary mix) — [Bazzite docs](https://docs.bazzite.gg/Installing_and_Managing_Software/Updates_Rollbacks_and_Rebasing/bazzite_rollback_helper/); [secondary comparison](https://www.opensourcefeed.org/insights/immutable-linux-distros-review/)
- Vanilla OS ABRoot is an A/B partition scheme with automatic fallback if the new partition fails to boot. (secondary) — [Botmonster](https://botmonster.com/self-hosting/immutable-linux-distros-fedora-silverblue-nixos-vanilla-os/)

### Inferences
- Snapper-style pre-upgrade snapshots are not feasible on ext4 (no CoW snapshots). Alternatives are LVM thin snapshots (needs the installer layout), rsync-based Timeshift hooks (slow, and not atomic), or installing on btrfs by default and adding an apt pre/post hook (snapper's apt plugin or grub-btrfs). That last option is a default-filesystem decision for the derivative. This is inference, not verified against an Ubuntu 26.04 implementation.
- The TPM FDE option and btrfs were not verified to be combinable in the installer.

### Gaps
- Whether the 26.04 installer offers btrfs or ZFS in the GUI by default. Not verified. ZFS-on-root with zsys was previously removed or deprecated; the current state was not checked.
- Kernel fallback via GRUB (older kernels retained) is standard behaviour but was not re-verified for 26.04. apt has no native rollback. Not verified.

## Passkeys, FIDO2, fingerprint

### Takeaway
GNOME 50 on 26.04 has no native passkey login. GDM FIDO2/passkey login arrives in GNOME 51 (September 2026) and will not be backported to the LTS. Browser support on Linux is partial: Chrome/Brave are best, Firefox is limited to security keys for login.

### Cited Findings
- GNOME 51 (Sept 2026) adds GDM unified authentication with web login (QR/URL) and FIDO2/passkey support, aimed mainly at corporate/remote setups. — [OMG Ubuntu](https://www.omgubuntu.co.uk/2026/09/gnome-51-released) (secondary)
- 26.04 stays on GNOME 50 and no GNOME 51 backport is planned. (secondary, search snippet) — [byteiota](https://byteiota.com/gnome-51-coruna-passkeys-mutter-nvidia/)
- Ubuntu discourse thread on passkey support in 26.04 shows only in-progress GNOME work needing backend support, with pam_u2f and authd as workarounds; no Ubuntu roadmap. — [Ubuntu Discourse](https://discourse.ubuntu.com/t/passkey-support-in-ubuntu-26-04-lts/72553)
- Chrome/Brave on Linux: YubiKey login works, creating passkeys on YubiKey works with Bitwarden extension, phone QR hybrid works. Firefox: YubiKey login works, creating on YubiKey not supported, phone hybrid not supported. (secondary vendor doc; Firefox 150 ships in 26.04, so verify) — [Bitdefender](https://www.bitdefender.com/business/support/en/77212-1457219-passkey-support-on-linux-browsers.html)
- credentialsd reportedly works only on demo sites. (secondary search summary) — [search summary of byteiota/other]
- libfprint gained additional drivers and devices via SDCP in 26.04. — [changes since 25.10](https://documentation.ubuntu.com/release-notes/26.04/changes-since-previous-interim/)

### Inferences
- A derivative wanting passkeys needs a password-manager-based path (Bitwarden or similar extension) and Chrome/Chromium, or must wait for credentialsd/libwebauthn and a newer GNOME. Backporting GNOME 51's GDM stack is nontrivial.

### Gaps
- Status of libwebauthn/credentialsd releases and any Firefox integration timeline. Only a secondary mention found.
- fprintd hardware support list and GDM fingerprint login on 26.04. Not verified beyond the SDCP note.

## Updates, livepatch, Pro

### Takeaway
unattended-upgrades is on by default for security updates, but 26.04 shipped with the update-notifier tray icon disabled (fixed in 26.04.1). Ubuntu Pro is free for personal use on up to 5 machines and provides ESM and Livepatch; a derivative cannot redistribute this entitlement and would need its own mechanism.

### Cited Findings
- 26.04 does not show update notifications by default (tray icon disabled), but security updates still install through unattended-upgrades. Software & Updates is no longer installed by default. update-notifier 3.207.2 for 26.04.1 removes the tray dependency. (secondary) — [OMG Ubuntu](https://www.omgubuntu.co.uk/2026/07/ubuntu-26-04-update-notifications-disabled); [It's FOSS](https://itsfoss.com/news/ubuntu-26-04-update-notifier-fix/)
- Ubuntu Pro: free for personal use on up to 5 machines (50 for community members); ESM 10 years, 15 with the Legacy add-on; Livepatch included. — [ubuntu.com/pro](https://ubuntu.com/pro)
- Livepatch supports ARM64 in 26.04 and kernel is Linux 7.0 with crash dumps enabled by default. — [26.04 summary](https://documentation.ubuntu.com/release-notes/26.04/summary-for-lts-users/)
- Release 26.04.1 was announced on the Ubuntu blog. — [Canonical blog](https://ubuntu.com/blog/upgrade-your-desktop-ubuntu-26-04-lts)

### Inferences
- Free-tier livepatch for personal use exists, but commercial or distributed derivative use is not covered by the personal terms, and no derivative-specific terms were found.

### Gaps
- Kernel update cadence (HWE point releases) not verified. Whether the free tier restricts non-Ubuntu derivatives not verified. Unattended-upgrades origins (security only vs. ESM) not verified.

## Sandboxing: snaps, Flatpak, userns, Flathub policy

### Takeaway
Ubuntu restricts unprivileged user namespaces via AppArmor (default 1 since 24.04) and ships per-app AppArmor profiles. Flathub banned AI-generated/assisted submissions from 29 May 2026.

### Cited Findings
- Ubuntu kernel with AppArmor restricts unprivileged userns by default (`kernel.apparmor_restrict_unprivileged_userns=1`), with profiles for common apps like Chrome and Discord. Researchers found bypasses in 2025. (24.04 documented; 26.04 same per secondary source) — [Ubuntu 24.04 release notes](https://documentation.ubuntu.com/release-notes/24.04/); [AppArmor wiki](https://gitlab.com/apparmor/apparmor/-/wikis/unprivileged_userns_restriction); [LinuxCapable](https://linuxcapable.com/how-to-enable-or-disable-apparmor-on-ubuntu-linux/) (secondary)
- Flathub policy effective 29 May 2026 bans AI-generated or AI-assisted code, docs, metadata and PR text (exceptions possible for mature projects). 656 rejected submissions reportedly overwhelmed three volunteer reviewers. — [GamingOnLinux](https://www.gamingonlinux.com/2026/05/flathub-moves-to-ban-nearly-all-apps-and-submissions-made-with-generative-ai/) (secondary); [Linuxiac](https://linuxiac.com/flathub-now-rejects-ai-assisted-apps-and-submissions/) (secondary)
- Firefox is delivered as a snap in Ubuntu (Firefox 150 in 26.04). Firefox in this project comes from Flathub instead (from git log; not a research finding).

### Inferences
- A derivative using Flathub inherits Flathub's moderation policy but not a strong default sandbox beyond what each app's permissions declare.

### Gaps
- Flatpak default permissions and Flathub verification (verified badge) policy changes for 2025-2026 were not checked beyond the AI policy. Snap strict confinement vs. Flatpak comparison not verified. Primary Flathub docs not fetched.

## Privacy and telemetry

### Takeaway
26.04 replaces ubuntu-report with Ubuntu Insights, opt-in with a one-week delay before sending. Crash reporting (apport/whoopsie), motd-news and popularity-contest defaults were not verified from a primary source.

### Cited Findings
- Ubuntu Insights in 26.04 is opt-in (Settings > Privacy & Security > Telemetry), reports are delayed one week, and prior consent from earlier releases is re-requested on upgrade. Collects CPU, RAM, display resolution and install choices. — [OMG Ubuntu](https://www.omgubuntu.co.uk/2025/12/ubuntu-insights-telemetry-26-04-lts) (secondary); [OSTechNix](https://ostechnix.com/ubuntu-telemetry/) (secondary)
- Apport/whoopsie crash reports, motd-news (outbound on login) and popularity-contest are described as separate components. Opt-out defaults not confirmed. (secondary) — [OSTechNix search snippet](https://ostechnix.com/ubuntu-telemetry/)
- Snap refresh checks run about four times daily. — [OSTechNix](https://ostechnix.com/ubuntu-telemetry/)

### Inferences
- A derivative should disable motd-news and whoopsie/apport upload by default and verify with a clean-image network capture.

### Gaps
- Exact enablement of whoopsie, apport, motd-news, popularity-contest on a fresh 26.04 Desktop and the opt-out steps. Not verified from primary sources.
