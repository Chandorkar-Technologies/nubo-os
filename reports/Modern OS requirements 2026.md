# Nubo OS can close its security gaps cheaply

Report date: 1 October 2026. Audience: Nubo OS product owner. Basis: nine research-note files in `research_notes/Modern OS requirements 2026/`. The "what Nubo has" side comes from the product owner's inventory, not from the notes. This is research, not legal advice.

## Executive summary

**Bottom line.** A consumer desktop OS in October 2026 is judged on three things: (1) a secure-by-default install (encrypted disk, verified boot, automatic patches, a firewall, a stated vulnerability process), (2) "my stuff follows me" (one account, mail, files, photos, passwords, phone), and (3) the apps and language support people already use (Chrome, WhatsApp, Office files, YouTube/Netflix, local-language input). Ubuntu 26.04 already gives Nubo most of (1) at platform level, and Nubo's own work is strongest on (2) and on polish. The biggest gaps are not technology gaps. They are *defaults and process* gaps (firewall, passkeys, a CRA-grade vulnerability process, telemetry policy) and *locale* gaps (Arabic and Indic input, fonts, translations). Most of those are days-to-weeks of work.

**Four findings that should change decisions.**

1. **Regulation is the nearest hard deadline, not market share.** EU CRA vulnerability reporting has applied since 11 Sep 2026, and it applies to products already on the market. If Nubo's OS is downloadable by EU users today, the question "are we a CRA manufacturer?" is live now, not in 2027. Counsel is needed.
2. **Popularity data is weak.** Linux is about 4-5% of desktop traffic in the EU, UAE and KSA on StatCounter, and the India figure (10.45% in Sept 2026) is unreliable. The best target persona is the Windows 10 user on ageing hardware (Windows 10 was still 27.83% of Windows desktops in Sept 2026), not the existing Linux user. Everything here is a range, not a point.
3. **The "cloud account" is Nubo's real differentiator and its real exposure.** The identity provider becomes a single point of compromise, and the backend (mail, accounts) triggers GDPR, India DPDP/CERT-In and Gulf data-law duties regardless of how the OS is licensed.
4. **Do not promise** platform passkeys, laptop find-my with offline tracking, WhatsApp calling in the Gulf, 4K streaming, or kernel-anti-cheat games. The notes show each is either not available on Linux or not under Nubo's control.

**Scorecard (my judgement from the notes).**

| Area | Status for Nubo |
|---|---|
| Disk encryption, Secure Boot, kernel hardening, auto security updates | Mostly inherited from Ubuntu 26.04 (see caveats on TPM-FDE beta label and update notifier) |
| Single account, mail/calendar/contacts/files, phone link, nearby share, notifications | Built or backend running; some pieces only tested against a fake server |
| Default firewall, passkeys, find-my/remote wipe, rollback, telemetry policy | Not planned; firewall, telemetry and policy items are cheap, passkeys and offline find-my are not |
| Arabic/Indic input, fonts, translations, voice typing | Not planned; input and fonts cheap, translations and voice medium |
| CRA, DPDP, CERT-In, Gulf law, accessibility (EAA) | No process yet; needs counsel plus a small compliance workstream |

## Prioritised backlog

Ranking logic: items are ordered by combined popularity impact (P) and security impact (S), each rated High/Med/Low, then by effort. Ratings are my inference from the notes unless the evidence column says otherwise. Effort bands: **have**, **cheap** (days/weeks), **medium** (weeks to a couple of months), **hard/partnership** (needs third parties, hardware or upstream).

| # | Item | P | S | Status | Evidence basis |
|---|---|---|---|---|---|
| 1 | Automatic security updates plus visible update notices | High | High | **Have** (inherited). Check update-notifier fix is in the image | 26.04 shipped with the tray notice disabled, fixed in 26.04.1 (secondary) |
| 2 | Encrypted disk with recovery-key UX | Med | High | **Have** (inherited), but make recovery key a first-class screen: **cheap** | Canonical says TPM-FDE is GA; Ubuntu Desktop docs still label it Beta (conflict, see caveats) |
| 3 | Verified boot via Canonical-signed shim, dbx updates via fwupd | Low | High | **Have**. Cheap to confirm fwupd dbx updates are on | Sourced (LWN, Microsoft, Red Hat) |
| 4 | Default-on firewall (deny inbound, rules for LAN features) | Low | High | **Cheap** | ufw off by default is secondary-sourced only; enabling is trivial, rule design for GSConnect/LocalSend/mDNS needs testing |
| 5 | Vulnerability-response process: security.txt, disclosure policy, 24h triage path, advisory page | Low | High | **Cheap** (process, not code) | CRA Art. 14 sourced; the process content is inference |
| 6 | Chrome/Chromium, WhatsApp, Telegram, Zoom, Teams as one-click or preinstalled | High | Low | **Cheap**. Firefox **have** | Chrome is 78-91% of browsing in India/KSA/UAE (StatCounter, mixed scope); per-app Linux status is mostly unverified |
| 7 | Arabic/Indic input defaults (IBus typing-booster plus m17n), Noto fonts, Hijri extension | High (for Gulf/India) | Low | **Cheap** | Fedora precedent sourced; Arabic/Indic defaults on 26.04 unverified |
| 8 | Telemetry and crash-report policy: Ubuntu Insights stays opt-in; disable motd-news and apport/whoopsie upload; verify by network capture | Med | Med | **Cheap** | Defaults for apport/motd-news not confirmed from primary sources |
| 9 | SBOM per release (Syft/Grype, not Trivy) | Low | Med | **Cheap** | Trivy supply-chain compromise in Mar 2026 (secondary-to-primary mix) |
| 10 | Passwords and passkeys via password manager (Bitwarden/Vaultwarden or KeePassXC) plus Chromium | High | High | **Medium** | No platform passkey API on Linux (FOSDEM 2026); Firefox passkey support limited |
| 11 | Real-server test and deploy of the "Nubo" GNOME Online Accounts provider and @nubo.email signup | High | Med | **Medium** (built, not proven) | Inventory only |
| 12 | Backup with restore (Pika/Déjà Dup to Nubo Drive) and settings roaming | High | High | **Medium** (Nubo Backup/Drive not built) | Windows 11 backs up by default; restic/Kopia are mature (repo metrics) |
| 13 | Rollback / snapshots (btrfs plus snapper-style hook) | Med | High | **Medium** | Ubuntu defaults to ext4; combination with TPM-FDE not verified |
| 14 | Online-only remote lock/wipe and session revocation via IdP plus a device agent | Med | High | **Medium** | No first-party Linux find-my exists; Prey/Fleet are options (low-quality aggregator sourcing) |
| 15 | Arabic and Indic translation work, installer RTL test | High | Low | **Medium** | GNOME 50 Hindi ~87%, Tamil/Telugu/Marathi ~34-38%, Urdu ~0% (model-summarised, verify) |
| 16 | Offline voice typing (whisper.cpp-based) | Med | Low | **Medium** | Windows/macOS ship dictation; Indic model quality unverified |
| 17 | Migration app and cloud-synced app list ("tap to install") | High | Low | **Medium** (designed) | No OSS migration assistant exists (notes) |
| 18 | Verified-publisher-only app policy in Nubo Store | Low | High | **Cheap to Medium** | Snap Store hijack incidents 2026; Flathub verified badge is domain proof |
| 19 | Own apt archive and update-signing process | Low | High | **Medium** (designed) | CRA expects signed update channel (inference) |
| 20 | Accessibility baseline (screen reader on Wayland, keyboard-only, accessible installer) | Med | Low | **Medium to hard** | EAA in force; Orca/Wayland gaps documented |
| 21 | Fingerprint and face unlock | High | Med | **Hard/partnership** | Most modern readers unsupported by libfprint (Tedium Apr 2026) |
| 22 | Platform passkey authenticator and passkey login at GDM | Med | High | **Hard** (upstream) | GNOME 51 claim is from a low-quality source, and 26.04 stays on GNOME 50 |
| 23 | Offline-capable find-my network | Med | Med | **Hard/impossible** for a small vendor | Inference |
| 24 | OEM certification and preload | High | Med | **Hard/partnership** | Certified lists exist for Framework, ThinkPad, Dell |
| 25 | Atomic/A-B image updates | Low | High | **Hard**. Ubuntu Core Desktop not planned until after 28.04 | The Register Q&A; bootc Ubuntu images are community-run |
| 26 | MDM/enterprise compliance (Intune via Himmelblau, Landscape) | Low (consumer) | Med | **Hard**. Not needed for consumers | Himmelblau 3.0 sourced |
| 27 | Native MS Office/Adobe, 4K DRM streaming, kernel anti-cheat games | High | n/a | **Not solvable by Nubo**; position honestly | Sourced as limits (BGR, DEV, GamingOnLinux) |

Reading the table: rows 1-9 are the "ship this quarter" set. They cost little and close the largest default-security and locale gaps. Rows 10-19 are the real roadmap. Rows 20-27 need partners, upstream releases or an honest "not supported" label.

## What a modern consumer desktop OS requires in October 2026

### The baseline is secure-by-default plus "it just works"

Reviewers frame the table stakes as reliable hardware support on arbitrary laptops (Wi-Fi, sleep, fingerprint, HiDPI, docking), fast system search with actions, encrypted-by-default storage, long support with painless updates, and app and game compatibility ([How-To Geek](https://www.howtogeek.com/linux-isnt-ready-for-laptops/); [Learn Linux TV](https://www.learnlinux.tv/ubuntu-26-04-lts-review-is-it-worth-the-upgrade/)). The notes found no survey ranking must-have versus nice-to-have features, so this ranking is an inference from reviews and pain-point coverage. What the evidence does show is that **AI features are not table stakes**: Microsoft is dialling back Copilot UI integration and made Recall opt-in on Copilot+ PCs only ([gHacks](https://www.ghacks.net/2026/01/31/microsoft-starts-dialing-back-windows-11-ai-features-after-user-backlash/)). That supports a privacy-first, no-forced-AI position, with Newelle as an opt-in assistant.

The competitor baselines are now concrete. Windows 11 requires TPM 2.0, Secure Boot and BitLocker device encryption, with Windows Hello and, since 25H2, third-party passkey providers ([Microsoft Learn](https://learn.microsoft.com/en-us/windows-hardware/design/device-experiences/oem-highly-secure-11); [Thurrott](https://www.thurrott.com/books/windows-11-field-guide/security/331586/passkeys-25h2)). macOS 26 enables FileVault by default and ships urgent "Background Security Fixes" without a full OS update ([Intego](https://www.intego.com/mac-security-blog/macos-tahoe/), secondary). ChromeOS offers Verified Boot and a 10-year update guarantee for devices from 2021 on ([Google](https://blog.google/products-and-platforms/products/education/automatic-update-extension-chromebook/)). Google is merging ChromeOS and Android into "Aluminium OS"; launch timing rests on press and leak reports, not a primary Google source ([Forbes](https://www.forbes.com/sites/paulmonckton/2026/01/31/goodbye-chromeos-leaked-aluminium-os-reveals-googles-android-desktop-future/)).

### Ecosystem features that people use are mostly invisible and default-on

No source in the notes gives per-feature usage percentages. The best indirect evidence is that Windows 11 backs up folders and settings to OneDrive by default when a Microsoft account is used, so high usage is largely passive ([Windows Backup doc](https://support.microsoft.com/en-us/windows/experience/backup-recovery/back-up-and-restore-with-windows-backup)). Free tiers set the price baseline: Google Photos 15 GB, iCloud 5 GB, OneDrive 5 GB ([Internxt](https://blog.internxt.com/google-photos-vs-icloud/)). The research note's own priority order (inference, not measured) is: one sign-in everywhere, photo and file cloud, mail/calendar/contacts, password and passkey sync, nearby file send, backup and settings restore, desktop notifications and calls, find-my, search, then assistants. Nubo already covers items 1, 3, 5 and 7 in that list in some form. Photos (Immich is a very mature open-source option, 115k stars per GitHub on 1 Oct 2026) and backup are the visible holes ([Immich](https://github.com/immich-app/immich)).

### Security requirements: threats are local escalation and store abuse, not desktop ransomware

The notes show a steady flow of public-exploit Linux kernel local-privilege-escalation bugs in 2026: Copy Fail (CVE-2026-31431, working across kernels 4.14 to 6.19.12 on Debian, Ubuntu, SUSE and RHEL) ([CERT-EU](https://cert.europa.eu/publications/security-advisories/2026-005/)), DirtyClone and a ptrace flaw disclosed by Qualys ([Qualys](https://blog.qualys.com/vulnerabilities-threat-research/2026/05/20/cve-2026-46333-local-root-privilege-escalation-and-credential-disclosure-in-the-linux-kernel-ptrace-path)), plus two snap-confine/snapd escalations and the "CrackArmor" AppArmor flaws ([Qualys](https://blog.qualys.com/vulnerabilities-threat-research/2026/03/12/crackarmor-critical-apparmor-flaws-enable-local-privilege-escalation-to-root)). Flatpak had a CVSS 10.0 sandbox escape (CVE-2026-34078, fixed in 1.16.4) ([GitHub advisory](https://github.com/flatpak/flatpak/security/advisories/GHSA-cc2q-qc34-jprg)). The consequence for a consumer product is plain: **automatic patching and fast reboot flow matter more than any added security tool**, and a Flatpak app with broad permissions should be treated as unsandboxed.

Store abuse is the most plausible consumer harm. The Snap Store saw fake and hijacked crypto-wallet apps (one reported loss of about $490,000), with attackers re-registering expired publisher domains to hijack accounts ([Help Net Security](https://www.helpnetsecurity.com/2026/01/21/linux-malware-snap-store/)). That evidence comes from a former Canonical engineer who is a critic, so weigh it accordingly. The notes found no comparable documented Flathub malware incident, but the search was limited, so absence of evidence is weak. Developer-targeting npm/PyPI worms (Sonatype counted 454,600 new malicious packages in 2025) matter only if Nubo markets to developers ([Sonatype](https://www.sonatype.com/state-of-the-software-supply-chain/2026/open-source-malware)).

### Identity is the highest-leverage and highest-risk design choice

authd is in the Ubuntu archive (universe), with a generic OIDC broker added in 26.04 ([heise](https://www.heise.de/en/news/Ubuntu-26-04-LTS-Authd-officially-available-for-cloud-authentication-11206312.html)). That fits Nubo's design. But authd has only 311 GitHub stars and no GitHub "latest release", and offline login and revocation latency are untested in the notes. Linux still has **no standard FIDO2 platform API** for browsers and native apps, per the FOSDEM 2026 talk on credentialsd and libwebauthn ([FOSDEM 2026](https://archive.fosdem.org/2026/schedule/event/838A8N-credentials-for-linux-bringing-passkeys-to-linux/)). So MFA and WebAuthn must be enforced at Nubo's IdP, because the Linux login path cannot rely on a platform authenticator. That is inference, but a direct consequence of the sourced facts.

## What Nubo already has, and how the evidence maps

### Inherited from Ubuntu 26.04 (strong, with three caveats)

Ubuntu 26.04 LTS (kernel 7.0, GNOME 50, Wayland-only) ships TPM-backed full-disk encryption in the installer, sudo-rs and rust-coreutils, expanded AppArmor hooks, hybrid post-quantum SSH, a Security Center, VRR and fractional scaling, and five years of standard support ([Canonical](https://ubuntu.com/blog/ubuntu-26-04-lts-security-updates); [release notes](https://documentation.ubuntu.com/release-notes/26.04/summary-for-lts-users/)). GNOME 50 adds redesigned parental controls ([debugpoint](https://www.debugpoint.com/ubuntu-26-04-lts/)). Because Nubo layers `nubo-*` debs on top of Ubuntu, these keep flowing.

Caveats to carry forward. First, Canonical's blog says TPM-FDE moved from experimental to general availability, while the Ubuntu Desktop how-to page still marks it Beta and lists limits: no re-encryption, a kernel snap dependency, and only NVIDIA out-of-tree drivers supported ([docs](https://ubuntu.com/desktop/docs/en/26.04/how-to/encrypt-your-disk-with-tpm/)). Nubo should assume the Beta caveats apply until it tests. Second, "ufw ships but is disabled" rests on a secondary source plus an older Ubuntu FAQ and was not confirmed for 26.04 ([LinuxConfig](https://linuxconfig.org/default-firewall-configuration-guide-on-ubuntu-26-04)). Third, the 26.04 update notice was disabled at release and fixed in 26.04.1, though unattended security updates still installed ([OMG Ubuntu](https://www.omgubuntu.co.uk/2026/07/ubuntu-26-04-update-notifications-disabled)).

A further point the product owner should check: the notes say esm-apps covers the *universe* repository, which is where authd lives ([Ubuntu Pro docs](https://documentation.ubuntu.com/pro/services-overview/)). The notes do not say who patches universe packages for a derivative without Ubuntu Pro, and they say the personal free-tier Pro entitlement (5 machines) is not verified to cover redistribution. "Ubuntu security updates keep flowing" may be true for main only. This is on the verify list.

### Built by Nubo (maps well to popularity criteria)

The inventory covers the visible layer: theme, icons, sounds, glass widgets, installer art, branding, search launcher, notification centre, Flathub-based Nubo Store, Firefox, Collabora Office, VLC, Spotify, LocalSend, GSConnect with scrcpy, and Newelle. Against the notes: LocalSend is a very mature nearby-share option (93k stars, Apache-2.0) ([LocalSend](https://github.com/localsend/localsend)); GSConnect covers perhaps 80% of phone-link utility over LAN (my inference), but needs ongoing security attention, since v73 fixed an authenticated path traversal in its Share and Notification plugins ([release](https://github.com/GSConnect/gnome-shell-extension-gsconnect)). Collabora Office desktop is a credible LibreOffice-based option, though Word/Excel fidelity as a barrier for EU/India/Gulf users is an inference, not evidenced in the notes. The notification agent that keeps messaging apps running is a good fit for the reality that WhatsApp has no official Linux desktop app (unverified general knowledge, check on Flathub).

Two further cautions. Vicinae-based search is amd64 only, and global-hotkey behaviour on Wayland is a documented weak point for third-party launchers (the notes recommend GNOME search providers or a compositor-bound shortcut) ([Ulauncher #1347](https://github.com/Ulauncher/Ulauncher/discussions/1347)). And the GNOME Online Accounts "Nubo" provider has been tested only against a fake server, so its popularity value (one email and password for mail, calendar, contacts and files) is unproven until a real-server test.

### Backend assets that competitors cannot easily copy

Stalwart (14.9k stars, but still a 0.x version tag and an unconfirmed licence field), Authentik, Zammad, OnlyOffice server and nubo-admin with migration connectors for Google, Microsoft and Zoho are strong. Nubo's one-account data plane (mail, calendar, contacts, files) is exactly the part the notes call OSS-feasible and realistic as a differentiator ([Stalwart](https://github.com/stalwartlabs/stalwart)). The notes call a migration assistant a gap with no OSS equivalent, so Nubo's planned Migration app is a real differentiator against the "my stuff doesn't follow me" failure mode. The same backend is also where the regulatory exposure lives (next sections).

## Market and popularity: who the realistic customer is

### Linux is a single-digit niche; the target pool is Windows 10 holdouts

On StatCounter in September 2026, Linux desktop share was 4.54% worldwide, 4.61% in Europe, 5.55% in the UAE, 4% in Saudi Arabia and 10.45% in India ([worldwide](https://gs.statcounter.com/os-market-share/desktop/worldwide); [Europe](https://gs.statcounter.com/os-market-share/desktop/europe); [UAE](https://gs.statcounter.com/os-market-share/desktop/united-arab-emirates); [KSA](https://gs.statcounter.com/os-market-share/desktop/saudi-arabia); [India](https://gs.statcounter.com/os-market-share/desktop/india)). Windows 10 still held 27.83% of Windows desktops globally, with Windows 11 at 71.44% ([StatCounter](https://gs.statcounter.com/windows-version-market-share/desktop/worldwide)). Windows 10 mainstream support ended 14 Oct 2025. Zorin OS 18 reported 3.3M downloads in six months with 78% from Windows PCs, per Zorin's own figures relayed by secondary sources ([Zorin OS](https://en.wikipedia.org/wiki/Zorin_OS)), which is the best available proxy for the switcher persona. Downloads overstate installs.

**Caveats that must stay attached to these numbers.**

| Claim | Why it is weak |
|---|---|
| StatCounter Linux share | Measures page views, not installs, and has a large "Unknown" bucket since 2025-26. A June 2026 snapshot put Windows at 56.61% and Unknown at 21.45%, versus 76.36% Windows in Sept 2026. One snippet even showed Linux at 8.88% in Aug 2026. Treat all figures as ranges |
| India Linux share | 10.45% (Sept 2026), 12.56% (a snippet for Aug 2026), 5.33% (May 2026, with nearly half of traffic "Unknown"), 16.21% (July 2024, via a low-quality aggregator). It likely reflects developers, education and traffic-classification noise. **Do not use it as a consumer-demand signal** |
| Steam survey Linux share | 5.33% in March 2026, falling to 3.69% in June and 4.01% in July, with swings attributed partly to Steam Deck counting |
| Windows 11/10 split | Single aggregator for June 2026 (69.9/28.2); StatCounter shows 71.44/27.83 for Sept. Directionally consistent, volatile |
| France moving "2.5M workstations" to Linux | Not verified as stated. DINUM announced on 8 Apr 2026 that it is moving its own workstations (about 250 deployed by 18 Apr) and ordered ministries to submit plans by autumn 2026; the "2.5 million" figure appears only in a Wikipedia summary with no primary source. See *Government and enterprise OS demand* |

No data were found for Qatar, Kuwait, Oman or Bahrain desktop share, for EU country splits, or for how many PCs are Windows 11-ineligible. Apple share is meaningfully higher in the Gulf (about 19% UAE, 15% KSA) than India, so Gulf users likely expect iCloud/AirDrop-like flows (inference).

### Apps: messaging, Chrome and video dominate; per-app Linux status is mostly unverified

WhatsApp is the key app: roughly 535.8M users in India, used by 98% of Indian internet users per a DataReportal summary relayed by an aggregator ([Hyperleap](https://hyperleap.ai/blog/whatsapp-statistics-india-2026)), and used by 92.2% of internet users in Saudi Arabia per another aggregator ([Saudi Times](https://thesauditimes.net/en/saudi-internet-and-social-media-statistics-2026-40-plus-key-numbers/)). Chrome is 91.29% of desktop browsing in India (Nov 2025) and 84.65% in Saudi Arabia (May 2026) ([StatCounter India](https://gs.statcounter.com/browser-market-share/desktop/india); [KSA](https://gs.statcounter.com/browser-market-share/desktop/saudi-arabia)), while Firefox is 1-2%. The practical implication is that a one-click Chrome or Chromium path should sit beside Firefox, since sites are tested against Chrome. This is inference from the data. ChatGPT is a top-five website in India (Similarweb snippet); AI assistants are web-first, so web-app integration suffices.

Verified on Flathub: Telegram (verified), Discord (verified), Spotify (community package, not verified by Spotify, x86_64 only). Everything else, including WhatsApp (likely web or third-party wrappers only), Signal, Zoom, Teams (Microsoft deprecated its Linux client, so PWA) and Slack, is unverified general knowledge. The notes explicitly tell the report writer to check Flathub before asserting. For banking and government, one positive was found: the Income Tax e-filing DSC utility supports Windows, Mac, Ubuntu and RedHat ([incometax.gov.in](https://www.incometax.gov.in/iec/foportal/downloads/dsc-management-utility)). UAE Pass, Nafath, Absher and Tawakkalna are phone-app-centred, so a desktop browser plus phone should work, but no Linux-specific testing was found. GST, MCA, Emirates ID readers and bank portals are unchecked.

### Hard limits Nubo cannot fix

Linux browsers get Widevine L3, capping Netflix-class streaming near 1080p (forum source, lower reliability) ([LinuxCommunity.io](https://linuxcommunity.io/t/drm-the-final-barrier-to-linux-desktop-adoption/3760)). Microsoft Office desktop and Adobe CC have no native Linux versions ([BGR](https://www.bgr.com/2070270/essential-windows-apps-not-on-linux/)). Kernel-level anti-cheat (Fortnite, Valorant, Battlefield 6 as of the notes) blocks competitive games, although Proton 11 and EAC/BattlEye opt-ins cover much else ([GamingOnLinux](https://www.gamingonlinux.com/guides/view/anticheat-check-which-competitive-games-actually-work-on-linux-steamos/)). **Gulf VoIP:** WhatsApp and FaceTime voice and video calls are reported blocked in the UAE (TDRA policy, July 2026), restricted in Qatar and Oman, and in Saudi Arabia the reports conflict (a 2025 Gulf News piece said calls were reportedly activated without regulator confirmation). Every one of these claims comes from secondary or travel and eSIM-seller blogs, and no regulator text was retrieved ([Simology](https://simology.io/blog/uae-voip-app-calling-what-works-what-doesnt-2026-traveller-guide); [Gulf News](https://gulfnews.com/world/gulf/saudi/whatsapp-calls-reportedly-activated-in-saudi-arabia-permanent-change-or-temporary-test-1.500027288)). Do not market VPN or "unblock calls" features in the Gulf.

### Languages: input is solvable, translation is the measurable gap

For Indian languages, IBus with ibus-typing-booster and m17n is the working path on GNOME Wayland; Fedora has defaulted to typing-booster for Indic languages since 2019 ([Fedora wiki](https://fedoraproject.org/wiki/Changes/Ibus_typing_booster_default_for_indian_languages)). Fcitx5 on GNOME Wayland has open candidate-window position bugs and should not be the default ([fcitx5 #1672](https://github.com/fcitx/fcitx5/issues/1672)). GNOME 50 translation completeness on the release set, per a model-summarised Damned Lies page: **Hindi 87%, Malayalam 42%, Tamil 38%, Telugu 37%, Gujarati 35%, Kannada 34%, Marathi 34%, Bengali 30%, Urdu 0%** ([l10n.gnome.org](https://l10n.gnome.org/releases/gnome-50/)). For Arabic, the only figure is about 32% on the gnome-shell module alone (main branch, not the release set), and the GNOME 50 release page returned no Arabic row ([gnome-shell module](https://l10n.gnome.org/module/gnome-shell/)). So the Arabic number is a different scope from the Indic numbers and unsafe to compare. The notes found no confirmed GNOME 50 RTL layout regression, but that is absence of evidence, and nobody tested the installer in Arabic. Hijri dates have no native GNOME Shell support; third-party extensions exist ([extensions.gnome.org](https://extensions.gnome.org/extension/5995/hijri-date-extension/)).

Windows 11 and macOS 26 both ship integrated phonetic/transliteration keyboards for ten Indian languages and first-party dictation for several (Windows list from user-facing Q&A pages, not an official table) ([Microsoft Q&A](https://learn.microsoft.com/en-us/answers/questions/4025816/these-languages-support-voice-typing-in-windows-11); [Apple](https://www.apple.com/lae/macos/feature-availability/)). GNOME has no first-party voice typing; third-party offline tools exist (Speech Note, Vocalinux, Voxtype) but Indic quality is unconfirmed.

## Regulatory timeline and where counsel is needed

### Dated timeline

| Date | Item | Status as of 1 Oct 2026 | Source quality |
|---|---|---|---|
| 28 Apr 2022 | India CERT-In Directions: 6-hour incident reporting, 180-day log retention within India, applies to domestic and foreign providers serving Indian users | **In force** | Primary PDF plus law-firm guides ([CERT-In](https://www.cert-in.org.in/PDF/CERT-In_Directions_70B_28.04.2022.pdf)) |
| 10 Dec 2024 | EU CRA entered into force | In force | Commission ([summary](https://digital-strategy.ec.europa.eu/en/policies/cra-summary)) |
| 12 Sep 2025 | EU Data Act application (cloud switching/portability) | Applies | **Background knowledge only, not verified in the notes** |
| 28 Jun 2025 | European Accessibility Act enforceable. Consumer general-purpose computer hardware **and their operating systems** are in scope, standard EN 301 549 | **In force** | Law-firm and secondary sources ([Travers Smith](https://www.traverssmith.com/knowledge/knowledge-container/a-new-milestone-for-accessibility-the-european-accessibility-act-now-applies/)) |
| Oct 2025 | Microsoft begins returning dual-signed (2011+2023 CA) shims | Done | LWN |
| 13 Nov 2025 | India DPDP Rules notified; Phase 1 (Data Protection Board framework) | In force. The Board still had no Chair or members as of Sept 2026 (single secondary source) | Secondary |
| 5 Feb 2026 | Oman PDPL fully enforceable | In force | Law-firm sources |
| 11 Jun 2026 | CRA conformity-assessment-body provisions | Applied | Commission |
| 26-27 Jun 2026 | Microsoft UEFI CA 2011 expired; existing signed shims keep booting; new shims signed with the 2023 CA only (valid to 2038) | **Occurred.** KEK CA 2011 also June 2026 | LWN, Red Hat, Microsoft ([LWN](https://lwn.net/Articles/1079808/)) |
| 9 Jun 2026 | Eleven old Microsoft-signed shims revoked via dbx; shim bypass CVEs reported | Occurred | Help Net Security/ESET |
| 27 Jul 2026 | Digital Omnibus on AI in force (as Regulation (EU) 2026/1744, per secondary sources); Annex III high-risk moved to 2 Dec 2027 | In force | Secondary |
| **11 Sep 2026** | **CRA Art. 14: 24h early warning, 72h notification, 14-day final report for actively exploited vulnerabilities; applies to products already on the market** | **Applies now** | Commission ([reporting page](https://digital-strategy.ec.europa.eu/en/policies/cra-reporting)) |
| Oct 2026 | Windows Production PCA 2011 expiry | This month | Fedora Magazine |
| 13 Nov 2026 | DPDP Phase 2 (consent manager provisions). MeitY proposed pulling Significant Data Fiduciary obligations to this date; **not gazetted** | Upcoming | Secondary |
| 2 Dec 2026 | EU AI Act Art. 50 transparency/watermarking date unchanged by the Omnibus | Upcoming. Relevance to Newelle/Nubo depends on whether Nubo is a "provider" (counsel) | Secondary |
| Early 2027 | GDPR/ePrivacy part of the Digital Omnibus expected to conclude | Pending, **not yet law** | Secondary |
| 13 May 2027 | DPDP Phase 3: notices, security safeguards, breach notification, children's data, erasure | Upcoming, the operative deadline | Secondary |
| **11 Dec 2027** | **CRA full application: CE marking, conformity assessment, SBOM/technical documentation, security-update duties** | Upcoming | Commission |
| UAE, date unknown | UAE federal PDPL executive regulations not issued as of June 2026; a six-month grace window is expected after issue | Pending | Weak secondary ([TCSA](https://www.tcsa.in/frameworks/pdpl)) |

Other Gulf and breach-clock facts: Saudi PDPL is actively enforced by SDAIA, with transfer rules, SCCs and BCR guidance but no adequacy list; Qatar's PDPPL is 2016; Bahrain's PDPL has been in force since 1 Aug 2019; Kuwait has sector regulation only (CITRA Decision 26 of 2024) ([DLA Piper KSA](https://www.dlapiperdataprotection.com/?c=SA); [Securiti](https://securiti.ai/oman-personal-data-protection-law-pdpl/)). The practical clock stack is India 6 hours (CERT-In), EU CRA 24 hours, and GDPR, KSA and UAE at 72 hours. The shortest clock is the binding design constraint for incident response (inference), and these law-firm sources should be confirmed by counsel.

### Is a free OS plus a monetised cloud service a CRA "manufacturer"? Ask counsel now

The CRA distinguishes manufacturers (full obligations: risk assessment, due diligence on third-party components, technical documentation, CE marking, a declared support period) from open-source stewards (lighter obligations, no fines) ([Commission](https://digital-strategy.ec.europa.eu/en/policies/cra-summary)). The notes' inference, which I share but cannot verify, is that a for-profit company shipping a free OS alongside a monetised cloud service is likely acting "in the course of a commercial activity", and that running the update servers and repository supports the same reading. Nubo's business model (free OS, cloud accounts as the revenue) is close to the textbook case counsel will need to rule on. **The notes did not verify:** the Annex III text on whether operating systems are Class I/II "important" products, the minimum support period (five years is background knowledge), the SBOM format rules, or Canonical's own CRA stance. Questions for counsel:

1. Does Nubo qualify as a manufacturer of the whole distribution, including unmodified Ubuntu components, or only of the `nubo-*` code?
2. Is Nubo, as an India-based company, required to appoint an EU authorised representative or importer (the notes mention authorised representatives only in the reporting context)?
3. What is the operative class for an OS, and does the self-assessment route for FOSS apply?
4. Does 11 Sep 2026 reporting already attach to the images Nubo has made downloadable to EU users?
5. What support period must Nubo declare, and can it align with Ubuntu's five-year standard window?

Counsel is also essential for: GDPR transfers from an India-based processor (no EU-India adequacy known per the notes), Saudi/UAE cross-border transfers, EU Accessibility Act scope for the cloud web UI (and whether a microenterprise exemption applies to Nubo, which depends on size and does not cover product requirements), NIS2 scope for a mail provider, and the Canonical trademark position. On trademarks, Canonical's policy requires a licence for commercial redistribution of modified Ubuntu unless the marks are removed and the affected packages are rebuilt ([Canonical IP policy](https://canonical.com/legal/intellectual-property-policy)). Whether Nubo can keep Canonical's signed shim after de-branding is also unverified. Keeping Canonical's shim shifts the Secure Boot CA transition to Canonical, which is the lower-risk path, but only if the trademark arrangement allows it (inference).

## What to verify first

These are the unverified items that would change a decision, in the order I would check them.

1. **CRA manufacturer status and Annex III class** (counsel). Changes whether Nubo needs CE marking, a technical file and an EU representative by 11 Dec 2027, and whether reporting duties apply today.
2. **Who patches universe packages** that Nubo depends on (authd, others) and whether Ubuntu Pro entitlement can cover a derivative. Changes the "security updates keep flowing" claim and the CRA support story.
3. **Canonical trademark and shim position** after de-branding. Changes whether Nubo can keep the Canonical-signed shim or must run its own shim review.
4. **Is ufw actually off on a fresh 26.04 Desktop?** Run `ss -tulpn` on a clean image and check avahi, cups-browsed and GNOME Remote Desktop state. Changes the firewall item from "cheap" to "audit first".
5. **Does the 26.04 installer let TPM-FDE and btrfs coexist, and does a fwupd dbx update force a recovery-key prompt?** Changes rollback plans and recovery-key UX priority.
6. **Flathub status of WhatsApp wrappers, Signal, Zoom, Teams, Slack, Brave, Chrome, Edge, WPS.** The notes tagged all of these unverified. Changes the preinstall list.
7. **Passkey path.** Confirm what Chromium plus a password-manager extension actually delivers on 26.04, and discard the unsupported claim that GNOME 51 gives passkey login at GDM (a low-quality source, and 26.04 stays on GNOME 50).
8. **Arabic and Indic reality on a 26.04 image**: installer in Arabic (RTL), default Noto and input packages, Urdu Nastaliq font, GNOME 50 Arabic translation percentage on the live l10n page. The percentages in this report are model-summarised and need re-reading.
9. **GOA "Nubo" provider against the real Stalwart server**, plus Stalwart's licence (the GitHub licence field returned null) and its pre-1.0 version status.
10. **Gulf VoIP and device rules** from regulator text (TDRA, CST, Qatar CRA), not blogs. Also check TDRA/CST type-approval if Nubo ever sells hardware.
11. **Apport/whoopsie, motd-news and popularity-contest defaults**, and whether crash reports from a derivative still go to Canonical's ErrorTracker.
12. **Primary-source check of the Digital Omnibus AI regulation number and the Art. 50 date** if Newelle ships by default, and **DPDP/UAE PDPL** dates against gazette text.

## Conclusion

The sharpest insight from the notes is that Nubo's security shortfall is mostly in what it chooses to turn on and document, not in what it must build. A default firewall, a disclosure policy, an SBOM, a telemetry stance, locale defaults and a verified-publisher store policy are all small. They also happen to line up with what the CRA will ask for. What is not small is the cloud identity layer: it is Nubo's differentiator, the place where the strictest incident clocks (India's 6 hours, the CRA's 24) apply, and the one component the Linux login path cannot back with a platform passkey yet.

Equally important, the popularity case is thinner than the headline numbers suggest. Linux desktop share is roughly 4-5% almost everywhere, India's 10% is not trustworthy, and Nubo's real market is Windows 10 holdouts and ineligible PCs who want their phone, mail and files to come with them. That favours finishing the migration app, the real-server account provider, Chrome and WhatsApp-class app coverage, and Arabic and Indic polish before investing in features Nubo cannot control (offline find-my, 4K DRM, platform passkeys, anti-cheat). Counsel on the CRA manufacturer question should come first, because it sets the compliance workload for everything else.
