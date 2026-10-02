# Ecosystem and cloud-account features (Apple/Microsoft/Google) vs open-source equivalents, as of Oct 2026

Method note: repo metrics below were pulled live from the GitHub REST API (api.github.com) on 2026-10-01; "last push" = pushed_at, "latest release" = /releases/latest. GitHub's licence field is quoted as returned; where it says NOASSERTION/null I flag it, and any licence detail beyond that is my own background knowledge (marked unverified).

## Which ecosystem features do consumers actually use most?

### Takeaway
I found no rigorous 2026 usage dataset ranking ecosystem features. Indirect evidence says the heavy-use features are the "invisible by default" ones: photo backup/sync, settings and folder backup tied to the OS account, file sharing between nearby devices, and phone-to-PC continuity. Power features (passkey sync, Find My, assistants) are visible but less demonstrated by usage data.

### Cited Findings
- Windows 11 backs up folders and settings to OneDrive by default when a Microsoft account is used; 26H2 makes settings backup on by default on eligible non-EU devices. Default-on behaviour means high "usage" is largely passive — [Windows 11 OneDrive Backup 2026](https://techjournal.org/turn-off-onedrive-backup-windows-11); [Microsoft Windows Backup doc](https://support.microsoft.com/en-us/windows/experience/backup-recovery/back-up-and-restore-with-windows-backup)
- Free tiers set the baseline: Google Photos 15 GB free, iCloud 5 GB free; OneDrive free 5 GB. Entry paid: $1.99/mo (Google, 100 GB), $0.99/mo (iCloud 50 GB) — [Internxt comparison](https://blog.internxt.com/google-photos-vs-icloud/); [Microsoft Q&A](https://learn.microsoft.com/en-us/answers/questions/5809498/how-to-back-up-files-on-ms365)
- Average smartphone user takes over 2,000 photos/month (GSMA Intelligence 2025, via secondary source), explaining why photo storage is the main paid-storage driver — [Internxt](https://blog.internxt.com/google-photos-vs-icloud/)
- Reviews rank Google Photos (AI search/organisation, cross-platform) as the best all-round photo backup and iCloud as best for deep-Apple users — [Internxt](https://blog.internxt.com/google-photos-vs-icloud/)
- macOS 26 Tahoe headline items: Apple Intelligence (live translation, shortcuts), Phone app and Live Activities via Continuity/iPhone Mirroring, biggest-ever Spotlight update with actions (send email from Spotlight); available in 16 languages in 190+ countries — [Apple Newsroom](https://www.apple.com/newsroom/2025/06/macos-tahoe-26-makes-the-mac-more-capable-productive-and-intelligent-than-ever/)
- Windows 2026: 26H1 is a platform release only for new Arm silicon (Snapdragon X2); 26H2 is the broad consumer update. Copilot+ features (Click to Do, taskbar pill mixing local index and generative answers, Explorer Copilot pane experiments) are rolling out; Phone Link adds call-audio routing and cross-device "Resume" — [Windows Central](https://www.windowscentral.com/microsoft/windows-11/microsofts-first-windows-11-preview-build-of-2026-brings-more-copilot-pc-features-to-everyone); [WindowsForum 26H1/26H2](https://windowsforum.com/news/windows-11-2026-roadmap-26h1-snapdragon-platform-and-26h2-ai-first-features.398217/); [Wikipedia Phone Link](https://en.wikipedia.org/wiki/Phone_Link)
- Google: Android + ChromeOS merging into "Aluminium OS" (Android 16 base, Gemini built in, desktop windowing, Linux terminal), launch targeted 2026 — [Android Authority](https://www.androidauthority.com/aluminium-os-android-for-pcs-3619092/); [Android Central](https://www.androidcentral.com/apps-software/first-look-at-google-android-desktop-interface) (launch date unclear in sources; secondary/leak-based)
- Nearby sharing is now cross-vendor: Quick Share <-> AirDrop interoperability launched on Pixel 10 (late 2025) and by June 2026 reached Samsung, Xiaomi, OPPO, vivo, Honor, OnePlus — [MacRumors Feb 2026](https://www.macrumors.com/2026/02/11/airdrop-quick-share-interoperability-more-phones/); [PBX Science (secondary)](https://pbxscience.com/googles-june-2026-android-feature-drop-brings-quick-share-airdrop-interoperability-to-flagships-across-the-ecosystem/)

### Inferences
- Priority by likely real-world use (my judgement, not measured): (1) sign-in + one identity everywhere; (2) photo/file cloud with phone auto-upload; (3) mail/calendar/contacts sync; (4) password/passkey sync; (5) nearby file send; (6) device backup/settings restore; (7) notifications/SMS/call on desktop; (8) Find My; (9) search; (10) AI assistant (high awareness, unclear retention); (11) family/parental, legacy, VPN relay (niche, but compliance/purchase drivers).
- For Nubo, the "default-on, zero-config" pattern (Windows Backup) matters more than feature count.

### Gaps
- No credible per-feature usage percentages (e.g. % of iPhone owners using iCloud Keychain, Continuity, Find My) were found; vendor figures are not published at this granularity. Do not quote any share without a new source.
- Aluminium OS launch status as of Oct 2026 not confirmed by a primary Google source.

## Which have mature, actively maintained open-source equivalents (stars / last release)?

### Takeaway
Most data-plane features have strong, alive OSS building blocks (files, photos, mail/cal/contacts, passwords, sync, backup, VPN mesh, local AI, device sharing). Weakest are: seamless OS-level integration (on-demand files on Linux), recovery/legacy/family, Find My, messaging bridges, and parental controls.

### Cited Findings (repo metrics, GitHub API, 2026-10-01)
- Immich (photos, face/object/CLIP search): 115,419 stars; 7,117 forks; AGPL-3.0; latest v3.2.4 (2026-09-28); pushed 2026-10-01 — [repo](https://github.com/immich-app/immich) ([API](https://api.github.com/repos/immich-app/immich))
- Nextcloud server (Drive, Notes, Calendar, Contacts, Talk, Photos): 36,970 stars; AGPL-3.0; latest v35.0.1 (2026-09-24) — [repo](https://github.com/nextcloud/server)
- Nextcloud desktop client (sync, has virtual-files on Windows/macOS): 3,887 stars; GPL-2.0; pushed 2026-10-01 — [repo](https://github.com/nextcloud/desktop)
- Stalwart (IMAP/JMAP/SMTP/CalDAV/CardDAV/WebDAV): 14,899 stars; latest v0.16.24 (2026-09-27); GitHub licence field is null (my unverified background: AGPL-3.0 core plus a paid Enterprise licence; verify before relying) — [repo](https://github.com/stalwartlabs/stalwart). Note version is 0.x, i.e. pre-1.0 per tag.
- Vaultwarden (Bitwarden-compatible server; passkey and Send support is in the clients): 68,383 stars; AGPL-3.0; v1.37.3 (2026-09-13) — [repo](https://github.com/dani-garcia/vaultwarden)
- KeePassXC: 29,039 stars; pushed 2026-09-30; licence NOASSERTION in API (multi-licence GPL, unverified) — [repo](https://github.com/keepassxreboot/keepassxc)
- Syncthing (peer-to-peer sync): 89,079 stars; MPL-2.0; v2.1.5 (2026-09-08) — [repo](https://github.com/syncthing/syncthing)
- rclone (cloud mount/sync, on-demand via `mount`): 60,043 stars; MIT; pushed 2026-09-30 — [repo](https://github.com/rclone/rclone)
- Cryptomator (client-side vault over any cloud): 16,229 stars; GPL-3.0; pushed 2026-10-01 — [repo](https://github.com/cryptomator/cryptomator)
- restic: 36,368 stars; BSD-2-Clause; pushed 2026-10-01. Kopia: 14,233 stars; Apache-2.0; pushed 2026-10-01 — [restic](https://github.com/restic/restic); [kopia](https://github.com/kopia/kopia)
- Joplin (notes/todo, sync via Nextcloud/WebDAV): 56,552 stars; pushed 2026-10-01; licence NOASSERTION (my unverified background: mixed MIT client / AGPL server) — [repo](https://github.com/laurent22/joplin). Standard Notes: 6,636 stars; AGPL-3.0; pushed 2026-09-30 — [repo](https://github.com/standardnotes/app)
- Ente (E2EE photos/auth): 29,185 stars; AGPL-3.0; pushed 2026-10-01 — [repo](https://github.com/ente-io/ente)
- GSConnect (KDE Connect protocol for GNOME): 3,730 stars; GPL-2.0; v73 (2026-09-23) incl. GNOME 51 support and a security fix (authenticated path traversal in Share/Notification plugins) — [repo](https://github.com/GSConnect/gnome-shell-extension-gsconnect)
- Valent (GTK4/libadwaita KDE Connect implementation): 911 stars; pushed 2026-09-27; licence NOASSERTION — [repo](https://github.com/andyholmes/valent). KDE Connect itself is hosted on KDE Invent (not queried).
- LocalSend (AirDrop-style): 93,141 stars; Apache-2.0; v1.18.2 (2026-08-21) — [repo](https://github.com/localsend/localsend)
- Ollama: 182,010 stars; MIT; v0.35.0 (2026-09-28). llama.cpp: 130,064 stars; MIT. whisper.cpp (local STT): 54,078 stars; MIT; pushed 2026-09-28. Open WebUI: 153,729 stars; v0.11.4 (2026-09-21); licence "Other" (custom, branding-restricted; verify) — [ollama](https://github.com/ollama/ollama); [llama.cpp](https://github.com/ggml-org/llama.cpp); [whisper.cpp](https://github.com/ggml-org/whisper.cpp); [open-webui](https://github.com/open-webui/open-webui)
- Identity: Zitadel 15,147 stars, AGPL-3.0; authentik 25,805 stars, licence NOASSERTION (my unverified background: MIT core, separate enterprise features); Canonical authd 311 stars, LGPL-3.0, pushed 2026-10-01 — [zitadel](https://github.com/zitadel/zitadel); [authentik](https://github.com/goauthentik/authentik); [authd](https://github.com/canonical/authd). (authd /releases/latest returned 404, i.e. no GitHub "latest release" object; check tags/Ubuntu archive.)
- VPN/relay: Tailscale client 37,071 stars, BSD-3; Headscale (self-hosted control server) 44,276 stars, BSD-3, pushed 2026-10-01 — [tailscale](https://github.com/tailscale/tailscale); [headscale](https://github.com/juanfont/headscale)
- Find My Device: FindMyDevice (FMD, SMS + FMDServer), Onloc, Nextcloud PhoneTrack, Traccar are listed OSS options — [AlternativeTo](https://alternativeto.net/software/android-device-manager/?license=opensource); [Traccar](https://github.com/traccar/traccar). Star/release data not pulled.

### Inferences — feature map (assessment for Nubo; effort = Linux desktop integration on Ubuntu 26.04/GNOME 50)
| Feature | Best building block | Maturity | Licence | Effort |
|---|---|---|---|---|
| SSO (OS + apps) | Zitadel or authentik (OIDC) + authd (Ubuntu login) | IdPs high; authd young (311 stars) | AGPL / mixed / LGPL | Medium; authd is the risk, but it is Canonical-supported on Ubuntu |
| Account creation/recovery, family | IdP self-service + custom flows; no OSS "family" product | Low | n/a | High (product work: recovery codes, guardian roles) |
| Cloud files, on-demand sync | Nextcloud + GNOME Online Accounts WebDAV/Files; rclone mount; Nextcloud desktop VFS is Win/macOS-first | Server very high; Linux placeholder files weak | AGPL/GPL/MIT | Medium-high (Nautilus integration, FUSE/placeholder) |
| Device backup/restore | restic/Kopia (+Pika Backup/Déjà Dup UI) to Nubo Drive/S3; settings via dconf export | High (tools); "bare-metal restore + settings roaming" is custom | BSD/Apache | Medium |
| Photos + face/object search | Immich | Very high | AGPL | Low-medium (server container, mobile app exists) |
| Notes/reminders | Nextcloud Notes/Tasks (CalDAV VTODO via Stalwart), Joplin | High | various | Low (GNOME apps read CalDAV tasks) |
| Mail/cal/contacts | Stalwart + GOA | High (0.x tag) | verify | Low (already planned) |
| Passwords/passkeys | Vaultwarden (+Bitwarden clients) or KeePassXC | Very high | AGPL | Medium (OS-level passkey/browser integration) |
| Find My / lock / wipe | FMD / Traccar / PhoneTrack | Low-medium for phones; no OSS for laptops with offline crowd network | various | High |
| Nearby share/continuity | LocalSend, GSConnect/Valent (clipboard, SMS, notifications, phone files) | High (LocalSend), medium (GSConnect: security fix v73, small community) | Apache/GPL | Low (already planned) |
| Phone mirroring | scrcpy/KDE Connect remote input (not queried) | Medium | - | Medium |
| Messaging (iMessage-like) | Matrix/Signal-style apps; Stalwart JMAP chat none | Medium | - | High, product decision |
| Notification centre | custom (GNOME 50 shell) fed by GSConnect + Nubo push | custom | - | Already planned |
| Local AI | Ollama/llama.cpp, whisper.cpp, Open WebUI | Very high | MIT / custom | Low-medium; hardware-dependent (no NPU parity) |
| Search across files/cloud | GNOME Tracker/LocalSearch + Nextcloud unified search/Immich | Medium | GPL | Medium |
| Parental controls | GNOME Parental Controls (malcontent), no cloud policy | Low | LGPL | High for family-wide policy |
| App store + accounts/purchase | Flathub/GNOME Software; payments custom | Medium | - | High for purchases |
| Migration assistant | none OSS; build on Nextcloud/IMAP import + backup restore | Low | - | High |
| VPN/privacy relay | Tailscale+Headscale for private mesh; WireGuard; no Private Relay clone | High (mesh) / none (relay) | BSD | Low (mesh), very high (relay = needs ASN/ops) |
| Legacy/recovery contacts | Vaultwarden emergency access; otherwise none | Low | AGPL | Medium (policy/legal) |
| Enterprise/school mgmt | Zitadel/authentik + authd + Landscape-alike; Ubuntu tooling (not queried) | Medium | - | Medium-high |

(Unqueried items such as scrcpy, malcontent, Tracker, Matrix are from background knowledge; no repo metrics collected.)

### Gaps
- No metrics gathered for KDE Connect itself, FMD, Pika Backup, Matrix/Element, scrcpy, Tracker/LocalSearch.
- Stalwart, Joplin, authentik, KeePassXC, Open WebUI licences were not confirmed from LICENSE files (API returned NOASSERTION/null); check before shipping or redistributing.
- Nextcloud on-demand (VFS) support on Linux desktop was not verified from a primary source.

## What is hard to replicate without controlling the vendor's cloud and hardware?

### Takeaway
The hard parts are those that depend on vendor-owned silicon, radios, identity roots or global networks, not on software: Find My crowd network, silent cross-device pairing/handoff, secure-enclave-backed recovery, carrier/iMessage-class messaging, and NPU-tier on-device AI.

### Cited Findings
- Apple's Continuity features (Phone app on Mac, Live Activities via iPhone Mirroring) rely on first-party iPhone + Mac pairing under one Apple Account — [Apple Newsroom](https://www.apple.com/newsroom/2025/06/macos-tahoe-26-makes-the-mac-more-capable-productive-and-intelligent-than-ever/)
- Windows Copilot+ features are gated to NPU hardware and a hardware divide is explicitly discussed; 26H1 is only for new Arm silicon — [WindowsForum](https://windowsforum.com/threads/windows-11-in-2026-one-serviced-platform-copilot-divide-and-26h1-explained.426093/); [4sysops](https://4sysops.com/archives/download-and-install-windows-11-26h1/)
- Interop shows that even closed protocols get opened under pressure: Quick Share <-> AirDrop works through a Play Store APK extension, reaching many OEMs by June 2026 — [MacRumors](https://www.macrumors.com/2026/02/11/airdrop-quick-share-interoperability-more-phones/); [PBX Science](https://pbxscience.com/googles-june-2026-android-feature-drop-brings-quick-share-airdrop-interoperability-to-flagships-across-the-ecosystem/)
- OSS Find My options (FMD, PhoneTrack, Traccar) are server-based/SMS-based — [AlternativeTo](https://alternativeto.net/software/android-device-manager/?license=opensource)
- GSConnect v73 fixed an authenticated path traversal in Share/Notification plugins, showing the LAN-device-trust surface needs ongoing security attention — [release](https://github.com/GSConnect/gnome-shell-extension-gsconnect)

### Inferences (background knowledge, not source-verified here)
- Find My offline finding: needs hundreds of millions of devices relaying BLE beacons; a small OS cannot replicate it. Online-only locate/lock/wipe via MDM-style agent + Nubo server is feasible for laptops (Wi-Fi/ethernet), weak when offline or stolen.
- Account recovery with hardware roots (iCloud Keychain escrow in HSMs, device passcode recovery, Microsoft TPM-bound Windows Hello): Nubo can do recovery codes/keys + optional guardian recovery, but not TPM-attested cloud trust at vendor level; passkey sync on Linux depends on browser/OS passkey APIs (Vaultwarden/KeePassXC) rather than platform authenticator.
- iMessage/Messages-for-web: depends on carrier SMS/RCS and phone number identity; Nubo can only relay SMS via GSConnect from an Android phone. iPhone users cannot be bridged officially.
- Privacy relay (iCloud Private Relay) needs global egress partners; self-host mesh VPN (Headscale) only covers own devices/exit nodes.
- On-device AI parity: local models via Ollama/llama.cpp run fine on 16 GB+ machines but lack Apple's system-level app intents/OS index and NPU-gated perf; best Nubo play is privacy-first local STT/LLM plus optional self-hosted inference on the Nubo server.
- Phone-to-PC "just works" pairing (Bluetooth proximity, Resume, Handoff) will stay per-platform; KDE Connect/GSConnect over LAN with a Nubo Android companion gets ~80% of utility.
- Realistic differentiator: one-account data plane (mail, calendar, contacts, files, photos, passwords) with default-on setup, since those are all OSS-feasible.

### Gaps
- No primary-source verification of Apple Find My network scale, TPM/HSM recovery architecture, or Windows Hello details in this pass; treated as background inference only.
- No data on whether Android's Quick Share can interoperate with LocalSend/Linux (e.g. RQuickShare); not researched.
