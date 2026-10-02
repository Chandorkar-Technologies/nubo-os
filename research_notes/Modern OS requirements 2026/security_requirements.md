# Security requirements and best practices for a consumer desktop OS, state of October 2026

Scope note: research used ~25 searches/fetches. Several claims come from search-engine summaries of secondary sources and are flagged "(secondary)". Dates given are 2026 unless stated. Audience: vendor shipping Ubuntu 26.04 / GNOME 50 base, Flatpak, Stalwart accounts, authd OIDC, to EU/India/Gulf consumers.

## 1. Platform security baseline in 2026 (boot, disk, immutability, kernel, MAC, sandboxing) and what Ubuntu 26.04 ships vs. what must be added

### Takeaway
Ubuntu 26.04 LTS (kernel 7.0) ships a credible baseline: TPM-backed FDE now GA with installer option, Rust sudo/coreutils, AppArmor with expanded hooks and restricted unprivileged user namespaces, hybrid post-quantum SSH, and a Security Center. It is NOT an immutable/atomic-updates OS, ufw is off by default, and desktop-specific items (USB policy, DNS-over-TLS, anti-theft, passkey platform authenticator) must be added by the vendor. Linux's Secure Boot trust chain is under live maintenance pressure in 2026 (Microsoft 2011 UEFI CA expiry, shim revocations).

### Cited Findings
**Ubuntu 26.04 ships by default**
- TPM-backed full disk encryption moved from experimental to general availability with a first-class installer option; recovery-key handling during firmware updates made predictable and surfaced before a breaking reboot; known incompatibilities documented (e.g. Absolute/Computrace) — [Canonical blog: What's new in security for 26.04](https://ubuntu.com/blog/ubuntu-26-04-lts-security-updates)
- rust-coreutils is default provider and sudo-rs replaces sudo; GNU versions remain available — [Canonical blog](https://ubuntu.com/blog/ubuntu-26-04-lts-security-updates). Per a secondary source, cp/mv/rm remain GNU for now due to unresolved TOCTOU bugs — [msbiro / search summary](https://www.msbiro.net/posts/ubuntu-2604-lts-security-container-workloads/) (secondary)
- Hybrid post-quantum key exchange (mlkem768x25519-sha256) available by default with OpenSSH 10.2; DSA removed — [Canonical blog](https://ubuntu.com/blog/ubuntu-26-04-lts-security-updates)
- Security Center: post-deployment visibility/management of TPM FDE state, recovery mechanisms, Secure Boot status — [Canonical blog](https://ubuntu.com/blog/ubuntu-26-04-lts-security-updates)
- Kernel 7.0 baseline (upgrade from 6.8 in 24.04 = nine kernel releases of accumulated hardening); AppArmor gained hooks for io_uring, user-namespace creation, message queues, abstract Unix sockets, SHA-256 policy hashes — [Mondoo](https://mondoo.com/blog/whats-new-in-ubuntu-2604-security) / [Help Net Security](https://www.helpnetsecurity.com/2026/04/24/ubuntu-26-04-lts-resolute-raccoon-released/) (secondary)
- Unprivileged user namespaces restricted via AppArmor profiles (introduced 2024); this has been bypassed repeatedly (research published June 2025) — [DEVCORE 2025](https://devco.re/blog/2025/06/26/the-journey-of-bypassing-ubuntus-unprivileged-namespace-restriction-en/); [Phoronix on AppArmor issues](https://www.phoronix.com/news/Ubuntu-AppArmor-Security-Issues)
- AppArmor user-facing permission prompting for snaps exists but is experimental — [Canonical blog](https://ubuntu.com/blog/ubuntu-26-04-lts-security-updates)
- SSSD runs as non-root user; authd now in the Ubuntu archive (universe), brokers distributed as snaps — [Canonical blog](https://ubuntu.com/blog/ubuntu-26-04-lts-security-updates); [heise](https://www.heise.de/en/news/Ubuntu-26-04-LTS-Authd-officially-available-for-cloud-authentication-11206312.html)
- NX enabled across Secure Boot variants; legacy strictnx removed — [Canonical blog](https://ubuntu.com/blog/ubuntu-26-04-lts-security-updates)
- Ubuntu's long-standing policy: ufw ships but is disabled by default (rationale: no open service ports) — [Ubuntu Security FAQ](https://wiki.ubuntu.com/SecurityTeam/FAQ) (older policy, 2008-era rationale; not re-verified for 26.04)
- usbguard is available but is a package/ESM-tier "platform protection", not default-enabled — [Ubuntu security docs search summary](https://documentation.ubuntu.com/security/security-features/security-features-overview/) (secondary)
- Livepatch covers only high/critical kernel CVEs, no userspace; requires Ubuntu Pro (free for up to 5 machines for personal use is not verified here) — [Pro client docs](https://documentation.ubuntu.com/pro-client/en/v30/howtoguides/enable_livepatch/)
- ESM: esm-infra covers main/restricted extended to 10 years; esm-apps covers universe — [Ubuntu Pro docs](https://documentation.ubuntu.com/pro/services-overview/). (A 15-year "Legacy" add-on exists in Canonical marketing; not verified in this session.)

**Secure Boot trust chain: 2026 events**
- Microsoft UEFI CA 2011 expired ~June 26-27, 2026; existing signed shims keep booting because firmware checks db/dbx, not expiry; future shims only signed by the 2023 CA (valid to 2038); Microsoft began returning dual-signed shims Oct 2025 — [LWN](https://lwn.net/Articles/1079808/); [Microsoft Tech Community](https://techcommunity.microsoft.com/blog/linuxandopensourceblog/what-it-teams-need-to-know-about-linux-secure-boot-certificates-expiring-in-2026/4530725); [Red Hat](https://access.redhat.com/articles/7128933)
- Eleven old Microsoft-signed shims (<= 0.9) revoked via dbx in the June 9, 2026 Patch Tuesday; CVE-2026-8863 and CVE-2026-10797 are shim Secure Boot bypasses; Linux gets dbx updates via fwupd/LVFS; older GRUB2 on install media remains bypassable — [Help Net Security/ESET](https://www.helpnetsecurity.com/2026/07/14/eset-uefi-secure-boot-bypass/); [The Hacker News](https://thehackernews.com/2026/07/11-old-microsoft-signed-linux-uefi.html)

**Competitor baselines**
- Windows 11: TPM 2.0 + UEFI Secure Boot + BitLocker device encryption + Defender + Windows Hello as baseline; Pluton acts as TPM 2.0; Administrator Protection (just-in-time isolated admin token via Hello); 25H2 supports third-party passkey providers — [Microsoft Learn: Secured-core](https://learn.microsoft.com/en-us/windows-hardware/design/device-experiences/oem-highly-secure-11); [Thurrott 25H2 passkeys](https://www.thurrott.com/books/windows-11-field-guide/security/331586/passkeys-25h2). Administrator Protection enterprise rollout was reported delayed — [WindowsForum](https://windowsforum.com/threads/windows-11-25h2-administrator-protection-delayed-for-enterprise-rollout.382922/) (low-quality source)
- macOS 26 Tahoe: FileVault enabled by default, recovery key now stored in Passwords app (not iCloud); Gatekeeper + XProtect; "Background Security Fixes" for urgent patches without full OS update — [Intego](https://www.intego.com/mac-security-blog/macos-tahoe/); [Apple security content 26.7](https://support.apple.com/en-us/149042) (secondary summary; verify before quoting)
- ChromeOS: Verified Boot with rollback to clean state; 10-year update guarantee for devices from 2021 on (through ~2034); ChromeOS being rebuilt on Android kernel/frameworks — [Google blog](https://blog.google/products-and-platforms/products/education/automatic-update-extension-chromebook/); [Chrome Enterprise help](https://support.google.com/chrome/a/answer/16634428?hl=en)

**Sandboxing: Flatpak status**
- Flatpak CVE-2026-34078: CVSS 10.0 complete sandbox escape via app-controlled symlinks in portal sandbox-expose options; fixed in 1.16.4 (April 2026); Flatpak 1.18.1 (Aug 11, 2026) fixed 10 vulnerabilities — [GitHub advisory](https://github.com/flatpak/flatpak/security/advisories/GHSA-cc2q-qc34-jprg); [Help Net Security](https://www.helpnetsecurity.com/2026/04/08/flatpak-1-16-4-released-fixes-sandbox-escape/); [Phoronix](https://www.phoronix.com/news/Flatpak-1.16.4-Released); 1.18.1 count from [secondary summary](https://latesthackingnews.com/2026/08/02/pipewire-sandbox-escape-cve-2026-5674/) (that article is dated Aug 2, so the Aug 11 claim comes from a different unnamed result in the search; verify)
- CVE-2026-5674: PipeWire/PulseAudio auth check flaw allowing Flatpak app escape — [Latest Hacking News](https://latesthackingnews.com/2026/08/02/pipewire-sandbox-escape-cve-2026-5674/) (secondary)

### Inferences
- "Default-shipped" in Ubuntu 26.04 = TPM FDE (opt-in at install), sudo-rs, AppArmor profiles, Security Center, kernel 7.0 hardening. Vendor must add: default-on firewall, USB policy, DNS privacy, passkey platform authenticator, anti-theft, Flatpak-first app policy with hardened Flatpak version pinning, and recovery-key UX.
- Flatpak sandbox is not a hard security boundary in 2026; 10 CVEs in one release and a CVSS-10 escape mean updates must be fast and apps with broad permissions (filesystem=home, device=all) should be treated as unsandboxed.
- Ubuntu is not immutable; "verified/atomic" must be approximated (TPM-measured boot + FDE + snapshot/rollback via btrfs/ZFS or A/B). Ubuntu Core Desktop is the immutable option but was not researched here.
- Because Secure Boot revocations (dbx) flow via LVFS/fwupd, shipping fwupd with dbx updates enabled and a UI for them is a baseline requirement; a TPM-FDE system can require recovery key after dbx/firmware updates (PCR changes), so recovery-key escrow UX is critical.

### Gaps
- Not verified: whether 26.04 desktop installer enables TPM-FDE by default or opt-in with which UX; whether ufw is enabled in 26.04 desktop; Ubuntu Core Desktop status; Rust-in-kernel status in 7.0; fwupd/LVFS statistics; GNOME 50-specific security features (Wayland-only, portals, USB protection via USBGuard integration in GNOME Settings); systemd-cryptenroll / FIDO2 unlock details; Windows 11 market-share/feature specifics beyond secondary sources; Apple primary platform security guide not fetched.

## 2. Identity and authentication

### Takeaway
authd (OIDC login) is mature enough to ship as Ubuntu 26.04 supports it with a generic OIDC broker, but a desktop passkey/FIDO2 platform authenticator is still not standardized on Linux. Himmelblau adds Entra/Intune compliance if enterprise customers matter.

### Cited Findings
- authd supports Entra ID and Google IAM; 26.04 adds a generic OIDC broker (Okta, Auth0, Keycloak etc.); authd package in Ubuntu archive (universe); brokers delivered as snaps — [heise](https://www.heise.de/en/news/Ubuntu-26-04-LTS-Authd-officially-available-for-cloud-authentication-11206312.html); [authd docs](https://documentation.ubuntu.com/authd/edge-docs/howto/configure-authd/)
- authd plugs into PAM and NSS; users need no local adduser — [SSD Nodes](https://www.ssdnodes.com/learn/authd-cloud-logins-on-ubuntu-server). Open design issue: using the IdP password instead of a local password (Discussion #688) — [GitHub](https://github.com/canonical/authd/discussions/688)
- FOSDEM 2026 (Feb 1): "the Linux desktop still has no standard FIDO2 platform APIs for browsers and native apps"; projects: libwebauthn (Rust) and credentialsd (D-Bus service / proposed XDG portal, Firefox integration); roadmap includes TPM-backed platform authenticators — [FOSDEM 2026](https://archive.fosdem.org/2026/schedule/event/838A8N-credentials-for-linux-bringing-passkeys-to-linux/)
- One secondary source claims GNOME 51 (released Sept 16, 2026) ships FIDO2 passkey login in GDM — [byteiota](https://byteiota.com/gnome-51-coruna-passkeys-mutter-nvidia/). Low-quality source; not corroborated, and it concerns GNOME 51 not 50.
- Himmelblau 3.0 (2026): Entra ID login with first-class OIDC, Linux Hello TOTP, Intune compliance evaluated at authentication time; packages for Ubuntu, Debian, Fedora, SUSE, NixOS — [heise](https://www.heise.de/en/news/Entra-ID-for-Linux-Himmelblau-3-0-extends-enterprise-features-11200189.html); [Himmelblau docs](https://himmelblau-idm.org/docs/intune/)
- Windows 11 25H2 allows third-party passkey providers — [Thurrott](https://www.thurrott.com/books/windows-11-field-guide/security/331586/passkeys-25h2)

### Inferences
- For a Stalwart + authd OIDC stack, the Nubo IdP becomes the single point of failure and compromise; MFA and passkeys must be enforced at the IdP (WebAuthn at IdP) because the Linux login path cannot yet rely on a platform authenticator.
- Offline login/cached credentials behavior and revocation latency on authd should be tested; not covered by sources.

### Gaps
- Not researched: fprintd maturity and security (fingerprint does not unlock TPM-bound keyring securely), GNOME Keyring/libsecret security limits (any app in the user session can read secrets unless portal/sandboxed), systemd-homed, Bitwarden/KeePassXC integration, authd offline behavior and security audit status, Stalwart passkey support.

## 3. Anti-theft and fleet management

### Takeaway
No first-party find-my-device equivalent exists for desktop Linux; only third-party/commercial tools (Prey, Absolute, MDM). A vendor must build or integrate it; TPM FDE plus remote revocation at the IdP is the practical core.

### Cited Findings
- Prey is open source and runs on Linux (locate, lock, alarm, webcam photo, wipe) from a web dashboard; Pombo and FindMyDevice (FMD, Android-focused) are open-source alternatives; Absolute supports select Linux devices — [Linuxaria](https://linuxaria.com/pills/prey-open-source-anti-theft-software); [Make Tech Easier](https://www.maketecheasier.com/remote-wipe-linux-computer/); [AlternativeTo](https://alternativeto.net/category/security/device-tracking/) (low-quality aggregators)
- Himmelblau brings Linux devices into Intune and applies compliance at authentication — [Himmelblau docs](https://himmelblau-idm.org/docs/intune/)
- Ubuntu 26.04 Security Center manages TPM FDE state post-deployment — [Canonical blog](https://ubuntu.com/blog/ubuntu-26-04-lts-security-updates)

### Inferences
- Consumer "find my laptop" on Linux has no radio-based offline finding network; location relies on Wi-Fi/IP while online. Realistic minimum: remote session revocation at IdP, remote lock on next check-in, remote wipe of keys (destroy TPM-sealed LUKS keyslot/ user data), and TPM FDE as the primary anti-theft control.
- Locating via GeoClue/BeaconDB-type services has privacy implications under GDPR.

### Gaps
- Not researched: Landscape, FleetDM, osquery, Intune for Linux (Microsoft's own agent) current state, compliance posture standards; maturity and security of Prey; legal consent requirements for location tracking.

## 4. Network and privacy

### Takeaway
Little hard evidence collected; Ubuntu does not enable a firewall by default and relies on no-listening-services. Needs vendor decisions.

### Cited Findings
- ufw installed but disabled by default in Ubuntu — [Ubuntu Security FAQ](https://wiki.ubuntu.com/SecurityTeam/FAQ)
- Regulatory breach clocks: India CERT-In 6 hours from noticing a cyber incident (2022 Directions) and DPDP Rules 2025 (notify Data Protection Board without delay, detailed report within 72 hours); Saudi PDPL 72 hours to SDAIA; UAE PDPL requires notice to UAE Data Office (secondary sources say 72 hours, with executive regulations unpublished at time of those sources) — [KS&K](https://ksandk.com/data-protection-and-data-privacy/cert-in-vs-dpdp-dual-breach-notification-duties-explained/); [Legal500](https://www.legal500.com/intelligence/india/privacy/data-breach-response-legal-steps-every-business-should-take); [DLA Piper KSA](https://www.dlapiperdataprotection.com/index.html?t=breach-notification&c=SA); [Lexology UAE](https://www.lexology.com/library/detail.aspx?g=48a6dd3c-34c1-4a35-9ed3-98a23e4e5280). Law-firm blogs; confirm with counsel.

### Inferences
- Vendor processing personal data via Stalwart mail/accounts and authd is a data controller/processor in all three regions; a unified 6-hour (India) / 24-hour (CRA) / 72-hour (GDPR, KSA, UAE) incident clock is the binding design constraint.

### Gaps
- Not researched: DoH/DoT in systemd-resolved/NetworkManager defaults, WireGuard/Tailscale integration state, GNOME 50 privacy dashboard and portal permission prompts, telemetry practices of Ubuntu (ubuntu-report, apport/whoopsie) vs Windows/macOS, Gulf data-localization rules.

## 5. Malware and threat landscape against Linux desktops, 2025-2026

### Takeaway
Linux desktop threat is dominated by (a) supply-chain compromise of developer ecosystems (npm/PyPI), (b) store account hijacking and fake apps (Snap Store crypto wallets), (c) trojanized installers, and (d) a steady flow of local privilege escalation kernel CVEs with public exploits. Classic desktop ransomware on Linux remains server/ESXi-focused per available evidence.

### Cited Findings
**Supply chain**
- Sonatype 2026 report: 454,600 new malicious packages in 2025; cumulative 1.233M blocked across npm, PyPI, Maven, NuGet, Hugging Face; over 99% of open-source malware on npm; Shai-Hulud first self-replicating npm worm (500+ packages) — [Sonatype](https://www.sonatype.com/state-of-the-software-supply-chain/2026/open-source-malware). Report gives no Linux-specific figures.
- 2026 incidents: Mini Shai-Hulud worm (May 12; TanStack, Mistral AI, UiPath, 160+ npm/PyPI packages; credential theft, self-propagation, possible destructive daemon wiping home directories) — [Orca](https://orca.security/resources/blog/tanstack-npm-supply-chain-worm/); TrapDoor (from May 22; 34+ packages, 384+ versions across npm, PyPI, crates.io) — [The Hacker News](https://thehackernews.com/2026/05/trapdoor-supply-chain-attack-spreads.html); Miasma worm (June 1; 32+ @redhat-cloud-services npm packages) — [GitGuardian summary via search](https://blog.gitguardian.com/shai-hulud-npm-pypi-supply-chain-attacks/); further waves through July — [Security Boulevard](https://securityboulevard.com/2026/07/the-streak-continues-four-more-supply-chain-attacks-hit-npm-and-pypi/)
- Targets are developer secrets: API keys, cloud creds, SSH keys, registry tokens — [GitGuardian](https://blog.gitguardian.com/shai-hulud-npm-pypi-supply-chain-attacks/)

**Stores**
- Snap Store: fake and hijacked crypto-wallet snaps; one reported ~$490,000 bitcoin loss (fake Exodus), another $10,000 (fake Ledger Live); attackers re-register expired publisher domains to take over email and Snapcraft accounts and push malicious updates (storewise.tech, vagueentertainment.com); removals sometimes took days; Canonical announced manual review of new snaps and publisher background checks — [Help Net Security, Jan 21 2026](https://www.helpnetsecurity.com/2026/01/21/linux-malware-snap-store/); [TechRadar](https://www.techradar.com/pro/security/canonical-announces-snap-store-crackdown-after-crypto-scam-apps-overload); [Cybernews](https://cybernews.com/security/hackers-target-linux-snap-packages-with-malware/). Claims come from Alan Pope (ex-Canonical, now Anchore), a critic.
- Flathub: verified badge means the developer proved ownership of the app ID; reviewers added an "AI slop" label (~Jan 2026) for suspicious submissions; ~5,764 apps — [FOSSLinux](https://www.fosslinux.com/159134/flathub-vibe-coded-ai-slop-linux.htm); [GridinSoft summary](https://gridinsoft.com/online-virus-scanner/url/flathub-org) (low quality). I found no documented Flathub malware incident comparable to Snap Store in this session (absence of evidence from limited search).

**Trojanized installers / backdoors**
- Daemon Tools website supply-chain compromise from April 8, 2026, signed with valid developer certificate (Windows-focused) — [Kaspersky](https://www.kaspersky.com/about/press-releases/kaspersky-identifies-ongoing-supply-chain-attack-on-official-daemon-tools-website-distributing-backdoor-malware); [TechCrunch](https://techcrunch.com/2026/05/05/kaspersky-suspects-chinese-hackers-planted-a-backdoor-into-daemon-tools-in-widespread-attack/)
- Free Download Manager Linux backdoor ran undetected for ~3 years (Kaspersky, reported 2024, older data) — [Kaspersky](https://www.kaspersky.com/about/press-releases/kaspersky-reveals-three-year-long-suspected-supply-chain-attack-targeting-linuxx)

**Kernel/desktop vulnerabilities and exploitation**
- Copy Fail, CVE-2026-31431 (disclosed April 29, 2026): AF_ALG/algif_aead flaw giving unprivileged 4-byte page-cache write to root; works on kernels 4.14 (2017) to 6.19.12 across Debian, Ubuntu, SUSE, RHEL; "10 lines of Python"; mitigation by disabling algif_aead or MAC restricting AF_ALG; disclosure preceded availability of patches on several distros — [Wikipedia](https://en.wikipedia.org/wiki/Copy_Fail); [CERT-EU 2026-005](https://cert.europa.eu/publications/security-advisories/2026-005/); [UC Berkeley](https://security.berkeley.edu/news/cve-2026-31431-linux-kernel-local-privilege-escalation)
- Ubuntu response to Copy Fail: secondary sources say a kmod-based mitigation first and kernel patch rolling out; one says patched April 2 — conflicting on timing — [OSTechNix](https://ostechnix.com/fix-copy-fail-cve-2026-31431-ubuntu-linux-mint/); [Security Arsenal](https://securityarsenal.com/blog/usn-8278-1-linux-kernel-copy-fail-cve-2026-31431-detection-and-hardening-guide). Reported broken embargo on related "Dirty Frag" bugs forced rushed patches — [Infosecurity Magazine](https://www.infosecurity-magazine.com/news/dirty-frag-linux-kernel/)
- Other 2026 kernel LPEs: DirtyClone CVE-2026-43503 (JFrog, June), CVE-2026-46333 ptrace local root and credential disclosure (Qualys, May 20) — [Rescana](https://www.rescana.com/post/dirtyclone-cve-2026-43503-critical-linux-kernel-vulnerability-enables-local-privilege-escalation-to-root-on-major-distri); [Qualys](https://blog.qualys.com/vulnerabilities-threat-research/2026/05/20/cve-2026-46333-local-root-privilege-escalation-and-credential-disclosure-in-the-linux-kernel-ptrace-path)
- CISA KEV additions (Sept 2026): kernel CVE-2025-39682 (TLS), CVE-2026-53266 (ebtables OOB write), CVE-2025-39964 (AF_ALG race); federal remediation deadline Sept 21, 2026 — [The Hacker News](https://thehackernews.com/2026/09/cisa-flags-three-linux-kernel.html). (The fetched summary's CVSS 9.8/"memory disclosure" description looks internally inconsistent; verify in KEV.)
- CVE-2024-1086 (2024 flaw) confirmed by CISA as used in ransomware campaigns by RansomHub and Akira — [search summary of CISA data](https://thehackernews.com/2026/09/cisa-flags-three-linux-kernel.html) (secondary; ransomware on Linux = server/ESXi context)
- Claim that Ubuntu kernels moved to weekly cadence due to an "AI-driven CVE surge" — [WebProNews](https://webpronews.com/ubuntu-kernels-go-weekly-as-ai-driven-cve-surge-overwhelms-traditional-update-cadence) (unverified, low-quality source; only a headline seen)

**What mainstream OSs offer vs. Linux**
- macOS: Gatekeeper (signature/notarization) + XProtect signature scanning with automatic remediation — [Intego](https://www.intego.com/mac-security-blog/macos-tahoe/); Windows: SmartScreen/Defender (not researched in detail). Linux: signed repos, Flathub verification, ClamAV (not researched in this session beyond general knowledge).

### Inferences
- The most likely consumer-harm vectors for a non-developer Linux desktop user: malicious store apps (especially wallet/finance), phishing-driven installer scripts ("curl | bash"), browser-based credential theft, and local-privilege-escalation chains after a user-level compromise. Developer-targeted npm/PyPI worms matter only if Nubo markets to developers or preinstalls dev tooling.
- Kernel LPE cadence (several public-exploit LPEs in April-September 2026) argues for: automatic security updates by default, Livepatch-like or fast reboot flow, restricting AF_ALG/unused modules through MAC or module blacklist, and an unprivileged-user-namespace policy. Local LPE becomes more severe on a shared-consumer desktop because any user-level malware can escalate.
- A third-party store policy (Flathub only; no snap store open submission; verified publishers only) cuts Snap-style account hijack risk. If shipping Snap-delivered authd brokers or Firefox snap, the store trust model still matters.

### Gaps
- No Linux desktop-specific malware prevalence statistics (ESET/Kaspersky Q1 2026 report page found but not read: [Securelist](https://securelist.com/malware-report-q1-2026-pc-iot-statistics/119828/)); no figures for Linux ransomware on desktops; XZ-style backdoor follow-ups in 2025-2026 not found; ClamAV maturity, Flathub malware incidents, reproducible-builds status (Debian/Ubuntu coverage), AV-Comparatives Linux tests not researched; NVD/CVE trend numbers not obtained.

## 6. Vulnerability response, updates, and regulatory obligations for an OS vendor

### Takeaway
As of Sept 11, 2026 the EU Cyber Resilience Act's Article 14 reporting obligations are live: 24h early warning, 72h notification, 14-day final report for actively exploited vulnerabilities to ENISA's Single Reporting Platform. A consumer-OS vendor in the EU is a manufacturer under the CRA, with full obligations (SBOM, vulnerability handling, security updates) from Dec 11, 2027.

### Cited Findings
- CRA Art. 14: effective Sept 11, 2026; early warning within 24h, notification within 72h, final report within 14 days of fix availability (vulnerabilities) or one month (incidents); reports via ENISA Single Reporting Platform, authorized representatives, EU Login with MFA; designate CSIRT coordinator by main establishment; remainder of CRA applies Dec 11, 2027 — [Crowell](https://www.crowell.com/en/insights/client-alerts/its-live-the-cyber-resilience-act-reporting-is-mandatory-as-of-today-11-september-2026); [Exterro](https://www.exterro.com/resources/eu-cyber-resilience-act-reporting-obligations-begin-september-2026); [European Commission](https://digital-strategy.ec.europa.eu/en/policies/cyber-resilience-act)
- Reporting applies to products already on the market and continues after end of support — [Exterro](https://www.exterro.com/resources/eu-cyber-resilience-act-reporting-obligations-begin-september-2026) (secondary)
- Open Source Initiative / ORC WG tracking the CRA's treatment of open-source "stewards" — [ORC WG](https://orcwg.org/cra/) (not read in detail)
- India CERT-In 6-hour incident reporting; DPDP Rules 2025 breach notice; Saudi/UAE PDPL 72-hour — see section 4 sources.
- Ubuntu security process: Ubuntu Security Notices (USN), ESM 10 years via Pro — [Ubuntu Security FAQ](https://wiki.ubuntu.com/SecurityTeam/FAQ); [Ubuntu Pro docs](https://documentation.ubuntu.com/pro/services-overview/)
- Operational lesson from Copy Fail: upstream fix April 1, public disclosure April 29, patch availability uneven across distros at disclosure — [Wikipedia](https://en.wikipedia.org/wiki/Copy_Fail)

### Inferences
- Nubo (as a downstream distro vendor with its own packages and authd/Stalwart integration) needs: security.txt and a coordinated disclosure policy, CVE tracking of Ubuntu USNs for the packages it ships, an internal 24-hour triage path to meet CRA Art. 14 for vulnerabilities in Nubo-specific code, SBOM generation (SPDX/CycloneDX) per release, and a documented support period (CRA expects security updates for the expected product lifetime, typically 5 years unless shorter lifetime justified; this duration detail is from general knowledge, not verified here).
- Dual-clock design: India 6h (incident) and EU 24h (CRA) are stricter than GDPR/Gulf 72h.

### Gaps
- Not researched: bug bounty norms/budgets, patch SLA benchmarks (Windows 30-day vs Apple background security fixes), CRA default vs important/critical product class for operating systems (important Class I/II includes OSes per Annex III, from general knowledge, not verified in session), CRA requirement text for SBOM, security.txt RFC 9116, Canonical's CRA stance, Gulf regulators' cybersecurity rules (UAE, Saudi NCA ECC), ENISA/CISA guidance documents.
