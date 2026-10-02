# Open-source building blocks for a consumer desktop OS on Ubuntu 26.04 LTS / GNOME 50 (state as of 1 Oct 2026)

Method note: roughly 45 searches and 4 page fetches, most answered from search-result summaries rather than full pages. Items marked [unverified] come from background knowledge or a single weak aggregator. Many per-component fields the brief asked for (stars, OpenSSF Scorecard, exact last-release dates) were NOT retrievable. They are listed under Gaps rather than guessed. Aggregator and SEO blogs (fosslinux, tech-insider, etc.) are lower reliability than primary sources and are flagged where used.

## 1. Base platform facts (Ubuntu 26.04 / GNOME 50) that constrain every other choice

### Takeaway
Ubuntu 26.04 LTS (23 Apr 2026) ships Linux 7.0, GNOME 50 (Wayland-only), systemd 259, APT 3.1, sudo-rs and rust-coreutils by default, and TPM-backed FDE in the installer. The default store (App Center) is snap-centric and does not manage Flatpaks. A Flatpak-first derivative must replace or augment the store itself.

### Cited Findings
- Ubuntu 26.04 LTS released 23 April 2026, codename Resolute Raccoon, GNOME 50, Wayland-only session — [Ubuntu 26.04 summary](https://documentation.ubuntu.com/release-notes/26.04/summary-for-lts-users/); [Computing for Geeks](https://computingforgeeks.com/ubuntu-2604-snap-flatpak-apt-guide/)
- Release notes list: Linux 7.0, systemd 259 (cgroup v2 only), APT 3.1 with new solver, sudo-rs as default sudo, rust-coreutils primary, Dracut replaces initramfs-tools, /tmp as tmpfs, post-quantum crypto (ML-KEM, ML-DSA, SLH-DSA), livepatch on ARM64, CUDA in archive, ROCm 7.1 — [Ubuntu 26.04 summary](https://documentation.ubuntu.com/release-notes/26.04/summary-for-lts-users/)
- New default apps: Showtime, Papers, Loupe, Ptyxis, Resources. The Software & Updates app is removed by default. GNOME Shell has search providers for snaps and web search — [Ubuntu 26.04 summary](https://documentation.ubuntu.com/release-notes/26.04/summary-for-lts-users/)
- GNOME 50 ("Tokyo") released March 2026: X11 session removed from GDM/mutter (about 27,540 lines of X11 code cut), XWayland remains for X11 apps, VRR and fractional scaling are stable, parental controls with screen-time and bedtime added — [The Register](https://www.theregister.com/2026/03/19/gnome_50/); [OMG Ubuntu](https://www.omgubuntu.co.uk/2026/03/gnome-50-released); [XDA](https://www.xda-developers.com/x11-on-gnome-is-finally-dead-as-its-newest-version-goes-all-in-on-wayland/)
- Default Ubuntu store is App Center (a snap), showing snaps and debs but not Flatpaks. Flatpak is not preinstalled; `gnome-software-plugin-flatpak` plus `flatpak` give Flatpak support. Firefox is still a snap by default — [Computing for Geeks](https://computingforgeeks.com/ubuntu-2604-snap-flatpak-apt-guide/)
- GNOME 51 is already in development ("This Week in GNOME #266 Fifty One", Sept 2026) — [TWIG 266](https://thisweek.gnome.org/posts/2026/09/twig-266/)
- Ubuntu 26.10 will use Linux 7.3 and adds early Snapdragon X2 support — [OMG Ubuntu](https://www.omgubuntu.co.uk/2026/09/ubuntu-2610-snapdragon-x2); [Ubuntu Discourse concept thread](https://discourse.ubuntu.com/t/ubuntu-concept-snapdragon-x-elite/48800)

### Inferences
- Because the GNOME session is Wayland-only and mutter ≥49 ignores XWayland global key grabs, any Nubo component that relied on X11 behaviour (global hotkeys, screen capture, input injection) must use portals or compositor APIs.
- Ubuntu's Rust coreutils and sudo-rs are new defaults, so deb-level scripts that assume GNU behaviour need testing.

### Gaps
- Exact GNOME 50.x point-release status and the Ubuntu 26.04.1 date (expected Aug 2026) were not confirmed.
- No source confirmed whether Ubuntu's Flatpak policy changed in 26.04 (it appears unchanged; evidence is indirect).

## 2. OS delivery and updates

### Takeaway
No supported image-based Ubuntu desktop exists in 2026. Ubuntu Core Desktop is effectively shelved, and Ubuntu bootc images are community or experimental (maintained by a Red Hat engineer and the Bootcrew project, not Canonical). The pragmatic choice for a deb-layer OS on Ubuntu is classic apt plus Flatpak, with snapshot-based rollback (not found in sources; see Gaps) and fwupd/LVFS for firmware. Bootc is the most credible future path.

### Cited Findings
**Canonical-native image approaches**
- Ubuntu Core Desktop: no daily builds since 26 Jan 2026. Canonical leadership said it will not ship for 26.04 or 28.04, described as a "five to ten year" effort with a dedicated team to be assembled post-26.04. Status: DEAD or indefinitely delayed for planning purposes — [The Register Q&A with Canonical](https://www.theregister.com/2025/11/03/canonical_jon_seager_qa/); search summary cites [Ubuntu Discourse "Immutable or Not?"](https://discourse.ubuntu.com/t/immutable-or-not/74072) (not directly fetched)
- Ubuntu Core 26 (embedded/IoT, not desktop) released 14 May 2026: live kernel patching, 90% smaller OTA updates, up to 15 years of maintenance — [Canonical blog](https://canonical.com/blog/canonical-launches-ubuntu-core-26); [9to5Linux](https://9to5linux.com/canonical-launches-ubuntu-core-26-with-live-kernel-patching-optimized-updates)

**bootc / ostree**
- Ubuntu 26.04 bootc images (desktop, server, minimal) exist. The "ubuntu-bootc" repo is an experimental image by Red Hat's Joseph Marrero Corchado, described as 26.04 with cloud-init and podman for use with bootc/bcvk. The Bootcrew team maintains a collection of bootc images (Ubuntu, SteamOS, Debian, openSUSE). Canonical's official position is not stated — [The Register, 15 Jun 2026](https://www.theregister.com/software/2026/06/15/red-hat-gives-ubuntu-a-bootc-up-the-backside-at-canonical-shindig/5255608); [ubuntu-bootc GitHub](https://github.com/ubuntu-bootc); [Ubuntu Summit 26.04 talk](https://discourse.ubuntu.com/t/bootc-use-your-container-knowledge-and-infrastructure-to-build-and-deploy-your-ubuntu-hosts/79498)
- bootc has graduated to a CNCF incubating project; SteamOS uses bootc — [The Register](https://www.theregister.com/software/2026/06/15/red-hat-gives-ubuntu-a-bootc-up-the-backside-at-canonical-shindig/5255608)
- Other community Ubuntu-on-bootc desktop attempts: [yeetypete/bootc-ubuntu](https://github.com/yeetypete/bootc-ubuntu), [fredIV/bootc-ubuntu-image](https://github.com/fredIV/bootc-ubuntu-image). Treat as hobby-grade.

**Fedora Atomic / Universal Blue / Bazzite**
- Bazzite 44 (Fedora 44 base) launched; the Deck images followed the desktop images (described as the largest update in project history, over 700 commits). Latest stable 44.20260928 (late Sept 2026). June 2026 update shipped kernel 7.0.9, Mesa 26.1, Bazaar 0.8.1 and Nvidia-open 610 — [AlternativeTo](https://alternativeto.net/news/2026/8/bazzite-deck-44-launches-with-the-largest-update-in-project-history-for-gaming-handhelds/); [LinuxCompatible](https://www.linuxcompatible.org/story/bazzite-linux-4420260928-stable-release-now-available-with-anbernic-win600-support); [Bazzite June 2026 update](https://universal-blue.discourse.group/t/bazzite-june-2026-update/12226)
- Bluefin LTS is built on CentOS with bootc — [Universal Blue GitHub](https://github.com/ublue-os)
- Bazaar is the Flathub-first app store used by Bazzite; version 0.8.1 as of June 2026 (see above)

**Vanilla OS / ABRoot**
- Vanilla OS 3 "Reunion" released Aug 2026: GNOME 50, ARM64, reproducible builds, ABRoot 2.4+ required for upgrades, Apx and VSO subsystems, Vanilla Continuity (snapshot backup) — [Linuxiac](https://linuxiac.com/vanilla-os-3-reunion-released-with-gnome-50-and-arm64-support/); [It's FOSS](https://itsfoss.com/news/vanilla-os-3-release/); [Tux Machines](https://news.tuxmachines.org/n/2026/08/24/Vanilla_OS_3_Reunion_Released_with_Reproducible_Builds_ARM64_Su.shtml)
- Vanilla OS 2 to 3 gap was two years, so cadence is slow and it is a small team (cadence inference).

**KDE Linux**
- Alpha Sept 2025. By Feb 2026 developers reported about 62% progress toward a beta. Uses plasma-setup, Plasma Login Manager, Zen kernel. Latest status after Feb 2026 not confirmed — [Linuxiac](https://linuxiac.com/kde-linux-reaches-62-percentage-toward-beta-release/); [Pointieststick Feb 2026](https://pointieststick.com/2026/02/06/busy-months-in-kde-linux/)

**GNOME OS**
- 100% immutable, sealed /usr images, updates via systemd-sysupdate or GNOME Software, apps Flatpak-only, nightly images available — [Wikipedia GNOME OS context via search; GNOME TWIG](https://thisweek.gnome.org/posts/2026/03/twig-241/) (secondary, thin). Intended as a development and testing platform, not a general consumer OS (background knowledge, [unverified]).

**NixOS** — not researched; see Gaps.

**Snap vs Flatpak vs deb**
- Flathub 2026: about 4.3 billion cumulative downloads, 3,542 apps, 2,092 verified. 435M downloads in 2025 (+21% vs 360.4M in 2024). Over 1M active users reported earlier — [FOSSLinux (aggregator)](https://www.fosslinux.com/157752/flathub-flatpak-complete-guide.htm); [Linuxiac](https://linuxiac.com/flathub-sees-over-435-million-downloads-in-2025/); [Flathub blog](https://docs.flathub.org/blog/over-one-million-active-users-and-growing). The 4.3B and 3,542 figures come from a single aggregator, so treat as approximate.
- Snap security record 2026: CVE-2026-3888 (snapd and systemd-tmpfiles LPE, Qualys, March 2026, fixed in snapd 2.74.1+ubuntu26.04.1) and CVE-2026-8933 (snap-confine race LPE, Qualys, July 2026, affects 24.04, 25.10, 26.04) — [Qualys CVE-2026-3888](https://blog.qualys.com/vulnerabilities-threat-research/2026/03/17/cve-2026-3888-important-snap-flaw-enables-local-privilege-escalation-to-root); [Qualys CVE-2026-8933](https://blog.qualys.com/vulnerabilities-threat-research/2026/07/21/cve-2026-8933-snap-confine-local-privilege-escalation)
- AppArmor "CrackArmor" flaws (Qualys, March 2026): LPE to root and userns-restriction bypass on Ubuntu — [Qualys](https://blog.qualys.com/vulnerabilities-threat-research/2026/03/12/crackarmor-critical-apparmor-flaws-enable-local-privilege-escalation-to-root)
- Flatpak security record 2026: CVE-2026-34078 complete sandbox escape via portal `sandbox-expose` symlinks. Affected < 1.16.4, advisory published 7 Apr 2026, found by Codean Labs — [GitHub advisory GHSA-cc2q-qc34-jprg](https://github.com/flatpak/flatpak/security/advisories/GHSA-cc2q-qc34-jprg). Press reports Flatpak 1.18.1 on 11 Aug 2026 fixed 10 vulnerabilities, but this conflicts in detail with the advisory's version data and comes from a secondary source — [Cybernews](https://cybernews.com/security/emergency-flatpak-fixes-released-sandbox-escape/). Also a PipeWire sandbox-escape CVE-2026-5674 affecting Flatpak apps (Aug 2026) — [Latest Hacking News](https://latesthackingnews.com/2026/08/02/pipewire-sandbox-escape-cve-2026-5674/)
- Method to remove snaps on 26.04 is documented and still workable (July 2026) — [UbuntuHandbook](https://ubuntuhandbook.org/index.php/2026/07/how-to-completely-remove-block-snap-apps-in-ubuntu-26-04/)

**Firmware**
- fwupd: latest stable on 27 Jul 2026 was 2.1.7 (2.1.x series); 2.0 branding was reached earlier. LVFS premier sponsors: Dell, Lenovo, HP and NVIDIA (each $100k+/yr). A fair-use quota (50,000 monthly downloads per vendor firmware before an over-quota warning) was introduced. Over 145 million updates served. Framework and OSFF are startup sponsors — [Phoronix LVFS archive](https://www.phoronix.com/linux/LVFS); [It's FOSS](https://itsfoss.com/news/lvfs-consumption-quota/); [9to5Linux HP sponsor](https://9to5linux.com/hp-is-the-latest-to-sponsor-the-linux-vendor-firmware-service-lvfs); [FOSSLinux fwupd 2.1.4](https://www.fosslinux.com/157532/fwupd-2-1-4-released-how-to-update-linux-firmware-safely.htm)

**SBOM / reproducibility**
- Syft (Anchore, about 9.1k stars per one aggregator) and Grype are the main OSS SBOM and scanner pair, covering dpkg. Trivy was compromised twice in March 2026 (supply-chain incident) and was removed from at least one downstream project's CI. Flag Trivy as RISKY pending your own verification — [AppSecSanta Syft](https://appsecsanta.com/syft); [sbomify comparison](https://sbomify.com/2026/01/26/sbom-generation-tools-comparison/); [sbomify-action issue 264](https://github.com/sbomify/sbomify-action/issues/264); [OX Security](https://www.ox.security/blog/sbom-tools/)

### Inferences
- Ranking for fit with Ubuntu base (deb OS layer + Flatpak apps): (1) classic apt + Flatpak + fwupd (mature, nothing to port); (2) bootc-ubuntu images (promising, CNCF-backed tool, but Ubuntu images are community-run; effort high; reassess at 26.04.2 or 26.10); (3) Vanilla OS ABRoot as a pattern to borrow (not reusable on Ubuntu without major porting); (4) Ubuntu Core Desktop (do not plan around).
- Snap, snap-confine and AppArmor LPEs occurred twice in 2026, which supports a policy of minimising snap exposure (Firefox from Flathub or a deb, App Center replaced by GNOME Software or Bazaar).
- Flatpak itself had a CVSS-critical sandbox escape this year, so a sandbox claim should be paired with timely Flatpak updates (Flatpak is in the OS layer deb and must be patched via apt).

### Gaps
- No source found for Btrfs/snapper or Timeshift-style apt rollback on Ubuntu 26.04 (zsys is believed dead [unverified]), nor ubuntu-desktop-installer A/B options.
- NixOS 26.05 status, Silverblue/Fedora Atomic 44 specifics, Bazaar licence and star count, GNOME Software vs Discover 2026 release data were not retrieved.
- Delta-update tooling for debs (debdelta etc.), apt mirror/CDN options, and reproducible-builds state for Ubuntu were not searched.
- Per-component GitHub stars, Scorecards and exact release dates for most items were not retrievable.

## 3. Security stack

### Takeaway
Secure Boot/shim and TPM-FDE are available in the Ubuntu base. A key 2026 event is Microsoft's UEFI CA 2011 expiry (June 2026), which affects how derivatives obtain a signed shim. Passkeys are the biggest consumer-facing gap on Linux.

### Cited Findings
- Ubuntu 26.04 installer supports TPM-backed FDE (key sealed to TPM, bound to Secure Boot measurements, recovery key generated). Known fragility: motherboard replacement, TPM clearing, Secure Boot changes or major firmware updates force recovery-key entry. In 25.10 it was labelled experimental; user threads show 26.04 problems on some hardware (Framework forum, Ubuntu Discourse) — [Ubuntu docs](https://documentation.ubuntu.com/desktop/en/26.04/how-to/encrypt-your-disk-with-tpm/); [Phoronix 25.10](https://www.phoronix.com/news/Ubuntu-25.10-TPM-FDE); [Framework forum](https://community.frame.work/t/ubuntu-26-04-hardware-backed-encryption/82110); [Ubuntu Discourse](https://discourse.ubuntu.com/t/i-cant-use-full-disk-encryption-on-ubuntu-26-04-lts/80977)
- Secure Boot: Microsoft UEFI CA 2011 expired 27 June 2026, KEK CA 2011 June 2026, Windows Production PCA 2011 Oct 2026. Expiry alone does not stop booting of existing 2011-signed shims. Since Oct 2025 Microsoft returns shims signed by both 2011 and 2023 CAs. Machines whose firmware lacks the 2023 CA cannot boot new 2023-only shims, which matters for derivatives that ship their own shim — [Fedora Magazine](https://fedoramagazine.org/expiration-of-microsoft-secure-boot-keys/); [Microsoft Linux/OSS blog](https://techcommunity.microsoft.com/blog/linuxandopensourceblog/what-it-teams-need-to-know-about-linux-secure-boot-certificates-expiring-in-2026/4530725); [Red Hat Developers](https://developers.redhat.com/articles/2026/02/04/secure-boot-certificate-changes-2026-guidance-rhel-environments)
- Passkeys: Linux still lacks a standard FIDO2 platform API. The Credentials for Linux project (credentialsd D-Bus service and proposed XDG portal; libwebauthn Rust library with USB, BLE and hybrid/phone transports; Firefox web extension with patched Flatpak; OBS packages for Fedora/openSUSE; roadmap includes TPM-backed platform authenticators) was presented at FOSDEM 2026. Linux browsers mostly prompt for external hardware keys. Status: emerging, not production — [FOSDEM 2026](https://archive.fosdem.org/2026/schedule/event/838A8N-credentials-for-linux-bringing-passkeys-to-linux/); [linux-credentials GitHub](https://github.com/linux-credentials); [TuxCare](https://tuxcare.com/blog/passkeys-on-linux-breaking-free-from-platform-lock-in/)
- fprintd/libfprint: Ubuntu offers fingerprint login in Settings. Known friction with systemd-homed and GDM fingerprint auth; lock screen generally works — [GNOME Discourse homed thread](https://discourse.gnome.org/t/gdm-fingerprint-authentication-with-systemd-homed/9570); [ThinkPenguin](https://www.thinkpenguin.com/gnu-linux/how-use-fingerprint-reader-gnome). systemd-homed is not supported by Ubuntu's installer and has GDM friction; treat as NOT recommended [inference].
- OpenSnitch 1.8.0 released Dec 2025 (PyQt6 UI rewrite, rules table); active — [LinuxCompatible](https://www.linuxcompatible.org/story/opensnitch-180-released/); [GitHub releases](https://github.com/evilsocket/opensnitch/releases)
- USBGuard 1.1.4 released 15 July 2025 (last release I could confirm, 14+ months old as of Oct 2026) — [USBGuard releases](https://github.com/USBGuard/usbguard/releases)
- ClamAV 1.5.4 (Cisco Talos) released 7 Aug 2026 fixing CVE-2026-20337; 1.5.3 fixed multiple parser vulnerabilities. Scanner's own parsers keep producing CVEs — [Linuxiac](https://linuxiac.com/clamav-1-5-3-open-source-antivirus-fixes-multiple-security-vulnerabilities/); [Wikipedia ClamAV](https://en.wikipedia.org/wiki/ClamAV)
- Sudo-rs is default but no sudo-rs-specific CVE turned up in the Qualys searches — [Qualys CrackArmor](https://blog.qualys.com/vulnerabilities-threat-research/2026/03/12/crackarmor-critical-apparmor-flaws-enable-local-privilege-escalation-to-root)

### Inferences
- Shim signing for a derivative: the simplest low-risk path is to keep Canonical's signed shim and GRUB (Nubo only changes branding and packages) rather than apply for its own shim review. The 2023-CA transition then falls on Canonical.
- Passkeys: do not promise platform passkeys. Offer FIDO2 security keys and a password-manager passkey provider (browser extension) now; track credentialsd for GNOME integration.
- ClamAV is of marginal value for a consumer Linux desktop (mainly for scanning files destined for Windows recipients) and brings parser CVEs; it should not be installed by default. Reasoning only; no source evaluated usefulness.
- OpenSnitch fits power users, not mainstream consumers (prompt fatigue). Inference.

### Gaps
- Not covered: Ubuntu 26.04 AppArmor profiles for Flatpak (Flatpak uses bubblewrap not AppArmor), Firejail record, ufw vs firewalld choice, auditd/Wazuh, Linux EDR (CrowdStrike/Falcon, osquery), vulnerability scanners for distros (Ubuntu Pro/OVAL, OpenSCAP), shim-review process requirements.
- systemd-cryptenroll with FIDO2/TPM on Ubuntu not verified.
- No dated release for fprintd or libfprint 2026 found.

## 4. Management, support and crash reporting

### Takeaway
Fleet management is well served by Fleet (osquery-based, active) and Canonical Landscape (proprietary SaaS or self-host). Consumer remote support is split between RustDesk (AGPL, Wayland still maturing) and GNOME Remote Desktop (RDP, built into 26.04).

### Cited Findings
- Fleet (FleetDM): Fleet 4.92.0 released 21 Sept 2026 and 4.91.0 on 2 Sept 2026 (rapid cadence). Linux supported via fleetd agent (osquery plus scripts for install/lock/wipe); Ubuntu, Debian, Fedora, RHEL, openSUSE supported — [Fleet releases](https://github.com/fleetdm/fleet/releases); [Fleet Linux](https://fleetdm.com/linux-management); [Fleet enrolment guide](https://fleetdm.com/articles/enrolling-linux-devices-for-fleet-management). Licence: core MIT with an enterprise directory under a separate licence [unverified in this session].
- Landscape (Canonical): launched 2007, handles patching, grouping, script deployment, audit compliance, managed up to about 40,000 instances (per Wikipedia). Commercial (Ubuntu Pro bundling) — [Wikipedia Landscape](https://en.wikipedia.org/wiki/Landscape_(software))
- RustDesk: licence AGPL-3.0-or-later. Version 1.4.9 listed 20 Sept 2026 (aggregator mirror), 1.4.6 on 5 Mar 2026. Wayland multi-monitor capture arrived in 1.4.3. Unattended Wayland access without per-session approval, including login screen, exists only as a preview build for Debian/Ubuntu x86_64 (Aug 2026 post, not stable) — [GitHub releases](https://github.com/rustdesk/rustdesk/releases); [El Solitario Aug 2026](https://elsolitario.org/en/2026/08/15/rustdesk-unattended-remote-access-wayland-linux/); [Wikipedia](https://en.wikipedia.org/wiki/RustDesk). No third-party security audit was found.
- GNOME Remote Desktop 50.0 ships in 26.04: user-session sharing or system service for headless multi-user via grdctl; supports remote login to GDM. xrdp is no longer supported on 26.04 (Wayland) — [Terrence Miao 26.04 guide](https://terrencemiao.github.io/blog/2026/06/02/Gnome-Remote-Desktop-on-Ubuntu-26-04/); [Server World](https://server-world.info/en/note?f=7&os=Ubuntu_26.04&p=desktop). Blog sources only; no official docs fetched.
- Crash reporting: Apport sends crashes to errors.ubuntu.com for stable releases; settings under Privacy & Security > Telemetry — [Ubuntu docs on Apport](https://documentation.ubuntu.com/project/contributors/debugging/apport/); [ErrorTracker wiki](https://wiki.ubuntu.com/ErrorTracker). A derivative's Apport reports would still go to Canonical's ErrorTracker unless re-pointed (inference; requires hosting your own error tracker).
- Sentry self-hosted: Functional Source License (FSL), converts to Apache 2.0 after 2 years, forbids competing offerings. GlitchTip is a free OSS alternative that is Sentry-SDK compatible and runs on Postgres/Redis (about 1-2 GB RAM) — [Sentry self-hosted docs](https://develop.sentry.dev/self-hosted/); [DEV Community](https://dev.to/selfhostingsh/sentry-2417); [Danube Data comparison](https://danubedata.ro/blog/self-host-sentry-glitchtip-error-tracking-2026)
- Zammad: 7.0 released 4 Mar 2026 with first AI features; AGPL-3.0; Community Edition self-hostable — [Zammad releases](https://zammad.com/en/product/releases); [Wikipedia](https://en.wikipedia.org/wiki/Zammad)

### Inferences
- Support stack with best fit: GNOME Remote Desktop for attended help on Ubuntu (zero extra packages) vs RustDesk for cross-platform consumer help (needs a self-hosted relay; AGPL obligations only matter if modified code is offered as a service). Neither gives attended support on the GDM login screen on Wayland cleanly, aside from GRD remote login.
- GlitchTip is preferable to Sentry for a small vendor (OSI-style licence, lower footprint). Inference.

### Gaps
- Not covered: Foreman/Ansible/Puppet-for-desktops details, Intune/Jamf-style Linux MDM options, in-app help, ABRT, opt-in telemetry frameworks (e.g. Fedora's, Ubuntu's `ubuntu-report`), Zammad GNOME integration.
- Fleet and Landscape pricing/licensing and stars were not confirmed.

## 5. Desktop experience

### Takeaway
GNOME 50 provides grouped notifications, HDR, VRR, parental controls and a native search architecture. Third-party launchers struggle with Wayland global shortcuts. The extension ecosystem is currently healthy at GNOME 50 but breaks per release by design. Input methods work on Wayland via IBus but Fcitx5 has candidate-window gaps on GNOME.

### Cited Findings
- Launchers on GNOME Wayland: Wayland blocks apps listening for keys outside focus. Ulauncher 6.x integrates with GNOME to set the hotkey but reliability on Wayland is poor. Albert does not officially support Wayland and requires a DE-bound shortcut. On GNOME ≥49 mutter no longer honours XWayland key grabs — [Ulauncher discussion 1347](https://github.com/Ulauncher/Ulauncher/discussions/1347); [Albert issue 309](https://github.com/albertlauncher/albert/issues/309); [Albert issue 958](https://github.com/albertlauncher/albert/issues/958); [aaddrick doc on portal shortcuts](https://github.com/aaddrick/claude-desktop-debian/blob/main/docs/learnings/wayland-global-shortcuts-portal.md)
- Vicinae: C++/Qt native launcher with Raycast-compatible extension API; repository updated 19 Sept 2026 (active). Qt on GNOME, Wayland global hotkey constraints equally apply — [Vicinae GitHub org](https://github.com/vicinaehq); [LinuxLinks](https://www.linuxlinks.com/vicinae-native-launcher-desktop/); [OSRepos](https://osrepos.com/repo/vicinaehq-vicinae). Licence not confirmed (believed GPL-3.0 [unverified]).
- GNOME extensions at GNOME 50: Dash to Dock v109 on extensions.gnome.org supports Shell 45 through 51; Blur my Shell supports 46 through 50. Both compatible with GNOME 50 — [EGO Dash to Dock](https://extensions.gnome.org/extension/307/dash-to-dock/); [EGO Blur my Shell](https://extensions.gnome.org/extension/3193/blur-my-shell/); [LinuxLinks list](https://www.linuxlinks.com/top-gnome-shell-extensions/). One summary claims legacy X11-hack extensions broke at 50 (low-quality source) — [FOSSLinux](https://www.fosslinux.com/155753/gnome-50-tokyo-the-wayland-only-era-and-the-death-of-x11.htm)
- Input methods: IBus is the GNOME default on Ubuntu 26.04 and works on Wayland. Fcitx5 works via text-input-v3, but GNOME does not implement the input-method-v2 protocol Fcitx uses for candidate popups; the workaround is the kimpanel extension. One comparative test (Chinese input, low reliability) measured IBus 50-100 ms versus Fcitx5 10-30 ms first-input latency — [Besthub](https://www.besthub.dev/articles/ubuntu-input-method-showdown-2026-ibus-vs-fcitx-5-which-reigns-supreme-for-chinese-typing-972437808957); [58jb Fcitx5 Wayland instability note](https://www.58jb.com/ubuntu26-04-fcitx5-wayland-faq/); [GitHub yazelin notes](https://github.com/yazelin/ubuntu-26.04-setup/blob/main/notes/wayland-vs-xorg.md)
- Printing: Ubuntu 26.04 defaults to driverless IPP via Avahi/mDNS. CUPS 3.x will drop PPD and classic drivers (Printer Applications replace them). cups-filters 2.0.1 was released 15 Aug 2024 and is described as unnecessary under CUPS 3 — [Debian wiki CUPSNewArchitecture](https://wiki.debian.org/CUPSNewArchitecture); [OpenPrinting cups-filters](https://github.com/OpenPrinting/cups-filters); [OpenPrinting drivers page](https://openprinting.github.io/cups/drivers.html). CUPS 3 release date not confirmed.
- Power: power-profiles-daemon 0.30 is available and is the Ubuntu/GNOME default. TLP 1.9.0 (Dec 2025) adds `tlp-pd`, which implements the same D-Bus API so the GNOME power-mode switch still works with TLP. TLP conflicts with ppd and auto-cpufreq — [UbuntuHandbook TLP 1.9](https://ubuntuhandbook.org/index.php/2025/12/tlp-190-graphical-power-mode-settings/); [Linuxiac TLP 1.9](https://linuxiac.com/tlp-1-9-linux-power-management-tool-adds-new-profiles-daemon/)
- Notifications are grouped per app since GNOME 48; HDR since GNOME 49 — [Ubuntu 26.04 summary articles via search](https://itsfoss.com/ubuntu-26-04-release-features/)

### Inferences
- A Spotlight-like launcher is best built on GNOME's own search-provider mechanism (works on Wayland, no global-key problem) or GNOME Shell extension. Vicinae/Ulauncher/Albert are power-user apps that need a compositor-bound shortcut and portal handling.
- Because extension maintainers target specific Shell versions and GNOME 51 is due (~Sept/Oct 2026 but Ubuntu 26.04 stays on 50), Nubo's pinned GNOME 50 limits breakage risk for the LTS lifetime, but any extension must be packaged as a deb with an explicit shell-version list.
- For Hindi, Tamil and Arabic: IBus engines (ibus-m17n, ibus-typing-booster) are the native path on GNOME. Fcitx5 adds risk on GNOME Wayland. [Inference; no Indic-specific source retrieved.]

### Gaps
- Not covered: localsearch/tracker 3 status, clipboard managers (e.g. Clipboard Indicator, GPaste, Pano), screenshot/recording tools (GNOME Shell built-in, Kooha, Gradience), widgets, gestures, theming frameworks (libadwaita limits, Gradience archived [unverified]), icon sets, Orca, on-screen keyboard, SANE status, Albert/Ulauncher exact release dates.
- Indic-specific IBus coverage (Tamil99, Inscript2 in ibus-m17n) was not verified.

## 6. Compatibility layers and office suites

### Takeaway
Wine 11 / Proton 11 are mature and Wayland-capable. Waydroid is alive but Android 13-based with early Android 16 images. Collabora Office desktop is now a credible Flatpak/snap alternative to LibreOffice. Open WebUI-style branding clauses are a licence trap.

### Cited Findings
- Wine 11.0 released Jan 2026 (NTSYNC, new WoW64 mode); Wine 11.7 around April 2026 (Valve rebased Proton on Wine 11); Wine 11.11 (June 2026) brought Wayland improvements. Proton 11.0 released July 2026, 11.0-2 on 21 Aug 2026 — [GamingOnLinux Wine 11](https://www.gamingonlinux.com/2026/01/windows-compatibility-layer-wine-11-arrives-bringing-masses-of-improvements-to-linux/); [GamingOnLinux Wine 11.11](https://www.gamingonlinux.com/2026/06/wine-11-11-brings-more-wayland-improvements/); [GamingOnLinux Proton Experimental to 11](https://www.gamingonlinux.com/2026/04/proton-experimental-upgraded-to-proton-11-for-better-linux-gaming-compatibility/); [Tux Machines](https://news.tuxmachines.org/n/2026/04/19/Release_of_Wine_11_7_Valve_Quietly_Rebased_Proton_on_Wine_11.shtml)
- Waydroid: latest tagged release 1.6.3 (28 May 2026) with Vulkan on Intel Xe and initial Android 16 images; default base Android 13 (LineageOS 20), with images dated 27 Sept 2026 — [XDA](https://www.xda-developers.com/waydroid-runs-android-apps-on-linux-better-than-windows-wsa/); [Tech Insider (aggregator)](https://tech-insider.org/waydroid-setup-linux-steam-deck-2026/). Needs binder kernel modules; check Ubuntu 7.0 kernel config (not verified).
- LibreOffice 26.8 released 26 Aug 2026, with an explicit no-AI stance. Collabora Office 26.04 (desktop, Flatpak and snap) released 2026; Collabora Office Desktop first released Nov 2025 and welcomes AI features — [OMG Ubuntu LibreOffice 26.8](https://www.omgubuntu.co.uk/2026/08/libreoffice-268-released); [It's FOSS](https://itsfoss.com/news/libreoffice-26-8-release/); [FOSS Force Collabora 26.04](https://fossforce.com/2026/07/collabora-office-26-04-takes-on-open-sources-office-disrupter-wannabes/); [FOSS Force Nov 2025](https://fossforce.com/2025/11/collabora-for-desktop-brings-modern-ui-and-new-workflow-to-libreoffice/)

### Inferences
- Proton (Valve) is gaming-oriented; for productivity Windows apps, Bottles/Wine remains the practical path, with high support cost. WinApps and CrossOver were not researched. For a consumer product, document openly that Windows-app support is best effort.
- Collabora Office is a plausible Flatpak "Office" default with branding handled by Collabora; LibreOffice trademark rules for rebranding were not checked (see Gaps).

### Gaps
- Not covered: Bottles 2026 release and health, WinApps, CrossOver, PWA engines (GNOME Web apps, Firefox PWA, Chromium app mode), OnlyOffice Flatpak status and licence (AGPL), LibreOffice/TDF branding rules, Wine stars.

## 7. Hardware enablement

### Takeaway
Ubuntu 26.04 ships a 7.0 kernel, so the HWE story is simpler than 24.04. NVIDIA is now open-kernel-modules-only on recent branches and works on Wayland. Snapdragon X is workable via concept images, not official. Asahi covers M1-M3 and not M4.

### Cited Findings
- 26.04 kernel is 7.0; 26.10 will move to 7.3 — [Ubuntu release notes](https://documentation.ubuntu.com/release-notes/26.04/summary-for-lts-users/); [OMG Ubuntu 26.10 Snapdragon X2](https://www.omgubuntu.co.uk/2026/09/ubuntu-2610-snapdragon-x2)
- NVIDIA: open kernel modules are the only flavour in recent driver branches. On 26.04 `nvidia-open` is installable via apt and `ubuntu-drivers install` installs a Canonical-signed module, so Secure Boot needs no MOK enrolment. Ubuntu recommends -open for GTX 16 / RTX 20 and newer. A bug thread reports `ubuntu-drivers install` not selecting the recommended driver on 26.04 pre-release — [LinuxConfig](https://linuxconfig.org/how-to-install-nvidia-drivers-on-ubuntu-26-04); [LinuxCapable](https://linuxcapable.com/install-nvidia-drivers-on-ubuntu-linux/); [NVIDIA driver docs](https://docs.nvidia.com/datacenter/tesla/driver-installation-guide/kernel-modules.html); [Ubuntu Discourse](https://discourse.ubuntu.com/t/26-04-ubuntu-drivers-install-wont-install-the-recommended-nvidia-driver/79703). Pascal and older need the legacy proprietary branch (background knowledge, unverified).
- Laptop vendors: Framework Laptop 13 Pro has factory Ubuntu 26.04 certification on selected configs; Lenovo ThinkPad T14s Gen 6 AMD certified; Dell Pro Max 14 certified; Tuxedo InfinityBook Pro 15 Gen10 offers 5-year warranty. Ubuntu certified hardware list at [ubuntu.com/certified/laptops](https://ubuntu.com/certified/laptops). Source for the picks is a buyers-guide aggregator — [Starry Hope](https://www.starryhope.com/linux/best-linux-laptops-buyers-guide/); [Linuxblog.io](https://linuxblog.io/best-linux-compatible-laptops/)
- Snapdragon X Elite: Ubuntu Concept images are experimental, unsupported and published irregularly; mainline kernel support has matured (KVM, camera, audio, USB-C display). Canonical is working with Qualcomm on an official certified image for X2 devices "next year" (2027) — [Ubuntu Discourse concept thread](https://discourse.ubuntu.com/t/ubuntu-concept-snapdragon-x-elite/48800); [Phoronix Acer Swift 14 AI on 26.04](https://www.phoronix.com/news/Snapdragon-X-Elite-Ubuntu-26.04); [OMG Ubuntu](https://www.omgubuntu.co.uk/2026/09/ubuntu-2610-snapdragon-x2)
- Apple Silicon: Fedora Asahi Remix 44 available (28 Apr 2026). M1 and M2 fully supported; M3 officially supported since Sept 2026 (webcam, mic, USB 3, Thunderbolt work; sleep does not). M4 is in early bring-up, with no installer or GPU driver. The Asahi distribution is Fedora-based, not Ubuntu — [Asahi blog Sept 2026](https://asahilinux.org/2026/09/m2-episode-1/); [TechTimes](https://www.techtimes.com/articles/325847/20260827/asahi-linux-m3-mac-release-due-weeks-webcam-audio-thunderbolt-now-working.htm); [Botmonster](https://botmonster.com/self-hosting/asahi-linux-apple-m4-daily-linux/)

### Inferences
- Apple Silicon is not a practical Ubuntu-based target (Fedora Asahi Remix is the supported route); Qualcomm is a 2027 option for Ubuntu proper.
- Best certified reference hardware for Nubo testing: Framework 13 Pro, ThinkPad T14s, Dell Pro Max 14.

### Gaps
- No data on Dell/Lenovo/HP programme specifics, Slimbook, HP; TUXEDO's own OS and drivers (tuxedo-drivers is GPL kernel module package [unverified]); Intel Panther Lake support quality; HWE kernel cadence for 26.04 point releases; NVIDIA 5xxx-series Wayland issues; Bluetooth/webcam IPU6/IPU7 status.

## 8. Local AI building blocks

### Takeaway
llama.cpp (MIT, now stewarded by Hugging Face) and Ollama are the pragmatic runtimes. Open WebUI has a branding-restricted licence, so it is risky for a rebranded OS. AMD XDNA2 NPU is usable on Linux via Lemonade and FastFlowLM, and Intel NPU support was not researched.

### Cited Findings
- llama.cpp: about 130,000 GitHub stars (crossed 100k in March 2026); ggml.ai (Georgi Gerganov's team) joined Hugging Face on 20 Feb 2026, project remains MIT. ggml underpins whisper.cpp, Ollama, LM Studio, GPT4All, Jan — [GitHub ggml-org/llama.cpp](https://github.com/ggml-org/llama.cpp); [Groundy](https://groundy.com/articles/ggml-joins-hugging-face-what-it-means-local/); [Tech Insider](https://tech-insider.org/llama-cpp-tutorial-2026/) (aggregator, star count approximate)
- Ollama: v0.34.3 on 19 Sept 2026 and v0.35.1 on 29 Sept 2026 (rapid releases; later release added web search and MLX/llama.cpp bumps). AMD GPU on Linux via ROCm; an aggregator quotes about 172K stars — [Releasebot](https://releasebot.io/updates/ollama); [Tech Insider vLLM vs Ollama](https://tech-insider.org/vllm-vs-ollama-2026/); [Wikipedia](https://en.wikipedia.org/wiki/Ollama). Licence MIT [unverified here].
- Open WebUI: from v0.6.6 (Apr 2025) a custom licence adds a branding-protection clause. Rebranding forbidden for deployments above 50 users unless enterprise licence or written permission. Not OSI-approved, pre-0.6.6 code is BSD-3. RISKY for a shipped, rebranded OS — [Open WebUI license page](https://docs.openwebui.com/license/); [ScanCode LicenseDB](https://scancode-licensedb.aboutcode.org/open-webui-2025.html); [Areebi explainer](https://www.areebi.com/resources/blog/open-webui-enterprise-license-explained)
- Newelle (GNOME-style libadwaita AI assistant): 1.0 in Aug 2025, 1.2 added llama.cpp integration with CPU/Vulkan/device GPU back-ends; on Flathub; supports Ollama and hosted LLMs, voice STT/TTS, terminal commands — [OMG Ubuntu](https://www.omgubuntu.co.uk/2025/08/newelle-ai-assistant-ubuntu-linux-desktop); [Phoronix](https://www.phoronix.com/news/GNOME-AI-Newelle-1.2). Licence (GPL-3.0 [unverified]). Alpaca (Ollama GTK client) also exists [unverified in this session].
- NPU: Lemonade 10.0 (11 Mar 2026) delivers Linux AMD XDNA2 NPU LLM inference via FastFlowLM (requires kernel 7.0+ upstream amdxdna driver or backports and an XDNA 2 chip: Ryzen AI 300/400; XDNA 1 chips unsupported). Lemonade orchestrates llama.cpp, whisper.cpp, stable-diffusion.cpp and Kokoro TTS — [Phoronix](https://www.phoronix.com/news/AMD-Ryzen-AI-NPUs-Linux-LLMs); [Lemonade docs](https://lemonade-server.ai/flm_npu_linux.html); [Agent Wars](https://agent-wars.com/news/2026-03-14-amd-ryzen-ai-npu-linux-lemonade-10-fastflowlm). FastFlowLM's model licence terms were not checked and may be restrictive [unverified].
- Ubuntu 26.04 puts CUDA toolkit, ROCm 7.1 and Intel oneAPI tooling in the archive — [Ubuntu release notes](https://documentation.ubuntu.com/release-notes/26.04/summary-for-lts-users/)

### Inferences
- Shippable stack for a consumer OS: llama.cpp (or Ollama) as a user-level service, whisper.cpp for dictation, Newelle as the assistant (Flatpak), models fetched on demand. Avoid Open WebUI unless a licence is purchased. Vulkan backends avoid ROCm/CUDA dependency pain on consumer GPUs (inference).
- NPU support is real only on AMD XDNA2 with kernel 7.0+, which Ubuntu 26.04 GA includes. Do not market NPU features broadly.

### Gaps
- Intel NPU (Meteor/Lunar/Panther Lake) Linux status, Qualcomm Hexagon on Linux, OpenVINO, Ollama licence and exact GitHub stars from a primary source, whisper.cpp releases, local models' licences, security records (e.g. Ollama CVEs) not researched.

## Cross-cutting flags (alive / dead / risky), with evidence

- DEAD or indefinitely stalled: Ubuntu Core Desktop (no builds since 26 Jan 2026, Canonical says 5-10 years) — [The Register](https://www.theregister.com/2025/11/03/canonical_jon_seager_qa/)
- RISKY, licence: Open WebUI (branding clause), Sentry self-hosted (FSL), RustDesk server obligations (AGPL), Zammad (AGPL, fine if unmodified).
- RISKY, security record: snap-confine/snapd (two Qualys LPEs in 2026), AppArmor (CrackArmor), Flatpak (CVE-2026-34078 sandbox escape), ClamAV (continuing parser CVEs), Trivy (supply-chain compromise Mar 2026).
- POSSIBLY STALE: USBGuard (last confirmed release 1.1.4, 15 Jul 2025); cups-filters (v2.0.1 Aug 2024, superseded by CUPS 3 design); Albert (no official Wayland support).
- ALIVE with dated evidence: Bazzite 44.20260928; Vanilla OS 3 (Aug 2026); Fleet 4.92.0 (21 Sep 2026); Ollama 0.35.1 (29 Sep 2026); RustDesk 1.4.9 (20 Sep 2026, aggregator); fwupd 2.1.7 (27 Jul 2026); Waydroid 1.6.3 (28 May 2026) and images 27 Sep 2026; Proton 11.0-2 (21 Aug 2026); Wine 11.11 (June 2026); LibreOffice 26.8 (26 Aug 2026); ClamAV 1.5.4 (7 Aug 2026); Lemonade 10.0 (11 Mar 2026); Vicinae repo activity 19 Sep 2026; OpenSnitch 1.8.0 (Dec 2025); TLP 1.9.0 (Dec 2025); Zammad 7.0 (4 Mar 2026).

## Overall Gaps for the report writer
- OpenSSF Scorecard values and GitHub star counts were not collected for most components (only llama.cpp about 130k, Ollama about 172k via aggregator, Syft about 9.1k via aggregator).
- No source covered: NixOS, Silverblue 44, systemd-homed adoption by any distro, Firejail, ufw/firewalld, USBGuard alternatives, Linux EDR, OpenSCAP, localsearch, clipboard/screenshot tools, Orca/OSK, SANE, WinApps, CrossOver, PWA engines, OnlyOffice, LibreOffice branding policy, Slimbook/HP/Dell Linux programme details, Intel NPU, Whisper.cpp, in-app help tools, delta updates and apt mirrors.
- Several search-result summaries are AI-generated aggregations; numbers like "4.3 billion Flathub downloads", "172K Ollama stars" and the RustDesk 1.4.9 date should be re-verified against primary pages before publication.
