# Ubuntu Desktop and flavour documentation: structure research for Nubo OS

Researched 2026-10-03 with WebFetch only. Content is paraphrased; titles and headings are quoted from the pages listed. Anything that could not be loaded is marked **NOT LOADED**.

## 0. Sources and load status

| Source | URL | Status |
|---|---|---|
| Ubuntu Desktop docs (redirects to ubuntu.com) | https://documentation.ubuntu.com/desktop/ -> https://ubuntu.com/desktop/docs/en/latest/ | Loaded (nav tree) |
| Ubuntu Desktop docs, page "Install an application" | https://ubuntu.com/desktop/docs/en/latest/how-to/install-or-remove-software/install-an-application/ | 404 (guessed path wrong); page format inferred from section tree only |
| Ubuntu Desktop Guide (help.ubuntu.com) | https://help.ubuntu.com/stable/ubuntu-help/ (also /index.html, /26.04/..., PDF) | **NOT LOADED** (HTTP 503 on every variant) |
| Ubuntu Community Help wiki | https://help.ubuntu.com/community/ | **NOT LOADED** (503) |
| GNOME Help portal | https://help.gnome.org/ | Loaded |
| GNOME Help (the guide Ubuntu Help is derived from) | https://help.gnome.org/users/gnome-help/stable/ plus net.html, a11y.html, prefs.html, files.html, hardware.html, shell-overview.html, net-wireless-connect.html, shell-keyboard-shortcuts.html | Loaded |
| Ubuntu tutorials | https://ubuntu.com/tutorials | Loaded |
| Tutorial: install Ubuntu Desktop | https://ubuntu.com/tutorials/install-ubuntu-desktop | Loaded |
| Ubuntu download page | https://ubuntu.com/download/desktop | Loaded |
| Ubuntu wiki | https://wiki.ubuntu.com/ | Loaded (top level only) |
| Xubuntu docs | https://docs.xubuntu.org/ and https://docs.xubuntu.org/user/C/index.html | Loaded |
| Lubuntu manual | https://manual.lubuntu.me/ , /stable/ | **NOT LOADED** (403). Site list taken from https://lubuntu.me/ (loaded). docs.lubuntu.me does not resolve |
| Kubuntu | https://kubuntu.org/ , https://kubuntu.org/community/ | Loaded (no docs found) |
| Ubuntu Studio | https://ubuntustudio.org/ , https://ubuntustudio.org/help/ | Loaded |
| Ubuntu MATE | https://ubuntu-mate.org/ , https://guide.ubuntu-mate.org/ | Loaded. ubuntu-mate.community not fetched separately |
| Ubuntu Budgie | https://ubuntubudgie.org/ | Loaded (no docs found) |
| Ubuntu Cinnamon | https://ubuntucinnamon.org/ | Loaded (no docs found) |
| Edubuntu | https://edubuntu.org/ | Loaded (no docs found) |
| Ubuntu Unity | https://ubuntuunity.org/ | Loaded (links only) |
| macOS User Guide | https://support.apple.com/guide/mac-help/welcome/mac ; https://support.apple.com/guide/mac-help/keyboard-shortcuts-mchlp2262/mac | Loaded |
| Windows support | https://support.microsoft.com/en-us/windows | Loaded (landing page only; Windows 11 specific guide tree not fetched) |

Not attempted or not available: WebSearch (quota exhausted), per-page reads of most Ubuntu Desktop docs pages, Kubuntu's separate wiki pages, Ubuntu MATE community forum and FAQ pages.

Important gap: because help.ubuntu.com was down, section 2 (Ubuntu Desktop Guide TOC) is reconstructed from GNOME Help, which Ubuntu Help is a rebranded copy of. Treat the Ubuntu-specific extras as unverified. Re-fetch when the server is back.

---

## 1. Ubuntu Desktop documentation (documentation.ubuntu.com/desktop)

### 1.1 Framework

- Sphinx project hosted on Read the Docs, Furo theme, in the Canonical docs style (the "Canonical Sphinx" starter pack look).
- Organised strictly by the Diataxis framework: four top-level buckets, Tutorials, How-to guides, Reference, Explanation.
- Versioned URL (`/en/latest/`), language segment (`/en/`). Canonical canonical URL is now under ubuntu.com/desktop/docs/ (301 redirect from documentation.ubuntu.com/desktop).
- The old tutorial on ubuntu.com carries a banner saying the content is migrating into this docs site.

### 1.2 Full section tree seen

**Tutorials**
- Try Ubuntu Desktop
- Install Ubuntu Desktop
- Get started with the screen reader
- The Linux command line for beginners

**How-to guides**
- Create a bootable USB stick
- Upgrade Ubuntu Desktop
- Switch between an LTS and interim release
- Install or remove software
  - Install an application
  - Remove an application
  - Install languages
  - Add a software repository
- Record the screen
- Change the default terminal
- Share your desktop remotely
- Access a remote desktop
- Start an application at login
- Log in using a smart card
- Enable smart cards in snapped browsers
- Reconfigure Windows to use AHCI
- Turn off BitLocker in Windows
- Encrypt your disk with TPM
- Configure hardware-backed disk encryption
- Recover data from hardware-backed disk encryption
- Graphics
  - Install NVIDIA drivers
  - Build your own NVIDIA modules using the DKMS package
  - Troubleshoot your NVIDIA GPU and drivers
- Accessibility (large subsection, 18+ pages: screen readers, contrast, magnification, keyboard and mouse adjustments)
- Common problems
  - Bluetooth
  - Improve screen reader usability

**Reference**
- Accessibility
  - Screen reader preferences (10 preference categories)
  - Orca structural navigation commands
  - AT-SPI D-Bus XML interfaces (30+ specification pages)
- Keyboard navigation shortcuts
- Advanced disk setup features
- Hardware-backed disk encryption requirements
- Intel RST during Ubuntu installation
- BitLocker during Ubuntu installation

**Explanation**
- About Ubuntu Desktop
- Snap and deb packages
- Hardware stack
- Accessibility stack
- Why we use the terminal on Linux
- What is the Menu key?
- Hardware-backed disk encryption

### 1.3 Observations

- Size is small (roughly 100 pages, with ~50 of them accessibility or AT-SPI). It is an admin/enterprise-flavoured doc more than an everyday user manual; everyday how-to content lives in the separate Ubuntu Desktop Guide and the community wiki.
- Installation-centric: install, USB, dual-boot with Windows, BitLocker, AHCI, Intel RST, TPM encryption.
- Missing from the docs site: Wi-Fi, printing, Bluetooth pairing basics (only troubleshooting), backups, settings pages, files, notifications, app-by-app help. These are delegated to the GNOME-derived guide.
- ubuntu.com/desktop also hosts marketing pages (features, developers, enterprise, Ubuntu Pro Desktop) beside the docs.

### 1.4 Release and download page (https://ubuntu.com/download/desktop)

- Release headline (Ubuntu 26.04.1 LTS "Resolute Raccoon"), two architecture downloads with file sizes, support promise (five years, extendable with Ubuntu Pro).
- "What's new" block with highlights (GNOME 50, kernel 7.0, new default apps, accessibility).
- System requirements block (dual-core 2 GHz, 6 GB RAM, 25 GB disk, USB or DVD).
- Three-step install: download, make bootable USB, boot. Each step links to a tutorial.
- Support block pointing to docs, Discourse, Ask Ubuntu, Launchpad Answers.
- Release notes live on Discourse, not in the docs site.

### 1.5 Tutorials portal (https://ubuntu.com/tutorials)

- A filterable catalogue. Tags include Desktop, Server, Cloud, IoT, Containers, Raspberry Pi, Security, Community and more. Sort by difficulty, 1 to 5 scale.
- Each card shows: title, one-line description, topic tags, difficulty rating, pagination.
- Examples: "How to run an Ubuntu Desktop virtual machine using VirtualBox 7", "The Linux command line for beginners".
- Install tutorial (https://ubuntu.com/tutorials/install-ubuntu-desktop) has 13 numbered steps starting with Overview and ending with "(Additional) Installing Ubuntu alongside Windows with BitLocker". Opens with requirements (25 GB disk, 12 GB flash drive, certified hardware link, back up data), uses a screenshot per installer screen, closes with a friendly "that's it, welcome" step and "next steps" (Ubuntu Pro, data sharing choice, getting apps from Ubuntu Software).

### 1.6 Community wiki (https://wiki.ubuntu.com/)

- MoinMoin wiki. Home highlights six audience areas: Desktop, Server, WSL, Dev, AI, History.
- "Getting started" (installation methods, platform references), "Software and applications" (packages, containers, gaming, window managers), "Specialist topics" (guides not in official docs, for example memory compression, media streaming, AI).
- Positions itself as "built by the community" next to canonical docs; links out to docs for Desktop, Server, WSL, Core, Developer, Project, Security, Hardware.
- Lesson: wiki is the long tail; official docs are curated. Nubo should do the same with a clearly labelled community tier later, not at launch.

---

## 2. Desktop Guide table of contents

### 2.1 Ubuntu Desktop Guide (help.ubuntu.com/stable/ubuntu-help/) - NOT LOADED

Ubuntu's guide is a Mallard (GNOME Yelp) document, a fork of GNOME Help adapted for Ubuntu. The 12 top-level chapters in GNOME Help are the best proxy; Ubuntu Help historically adds Ubuntu-specific topics (Ubuntu Software, Ubuntu Pro, snaps) to the same layout. Unverified until the site returns.

### 2.2 GNOME Help (https://help.gnome.org/users/gnome-help/stable/), 12 chapters

1. Visual overview of GNOME (desktop, top bar, Activities overview)
2. Log out, power off or switch users
3. Start applications
4. Your desktop
5. Networking, web and email
6. Sound and media
7. Files, folders and search
8. User and system settings
9. Hardware and drivers
10. Accessibility
11. Tips and tricks
12. Get more help

### 2.3 Sub-structure (from each chapter page)

**Your desktop** (https://help.gnome.org/users/gnome-help/stable/shell-overview.html)
- Customize your desktop: calendar management, automatic app startup, notifications, pinning favourite applications, screen time.
- Applications and windows: window switching, lock screen, keyboard shortcuts, status-bar icon meanings, windows and workspaces.

**Networking, web and email** (net.html)
- Wireless networking (including hidden networks, phone tethering)
- Contacts
- Email and email software
- Internet security (firewalls, viruses)
- Network problems
- Networking fundamentals (IP addresses, proxies)
- Sharing (desktop, files, media)
- Web browsers (default browser)

**Files, folders and search** (files.html)
- Common tasks: browse, copy or move, delete, preview, rename, rename multiple, rename music files by metadata, search, sort.
- More file tasks: browse files on a server or share, file manager preferences, file properties, find a lost file, open with other applications, purge trash and temporary files, recover from Trash, share files by email, show path as text, turn off or limit file history, write to CD or DVD.
- Removable drives and external disks: open applications for devices, safely remove a drive.
- Backing up: back up your important files, check your backup, frequency of backups, restore a backup, where to find files to back up.
- Tips and questions: folder bookmarks, hide a file, select by pattern, file permissions, templates, "what is a file ending with ~".

**User and system settings** (prefs.html), 17 pages
About; Color management; Date and time; Display and screen; Keyboard; Mouse, touchpad and touchscreen; Multitasking; Online accounts; Power and battery; Privacy; Quick Settings; Region and language; Search results; Sharing; Sound; User accounts; Wacom tablet.

**Hardware and drivers** (hardware.html)
Bluetooth; Color management; Disks and storage; Fingerprints and smart cards; Keyboard; Mouse, touchpad and touchscreen; Power and battery; Printing; Wacom tablet; plus cell phone connections, driver definitions, and "Common problems" (Bluetooth, card readers, power, printing, graphics, sound, wireless).

**Accessibility** (a11y.html)
- Visual: Blindness (read screen aloud, in Braille); Low vision (contrast, text size, magnify, blinking cursor).
- Hearing: flash the screen for alert sounds.
- Mobility: mouse movement (speed, keypad pointer), clicking and dragging (double-click speed, simulated right click, hover click), keyboard (navigation, repeat keys, bounce keys, slow keys, sticky keys, on-screen keyboard), See also "What is the Menu key?".

**Keyboard shortcuts page** (shell-keyboard-shortcuts.html)
Four groups: Getting around the desktop (Super, Alt+F2, Super+Tab), Common editing shortcuts, Capturing from the screen (Print, screencast shortcut), More information / See also.

**GNOME portal app guides** (https://help.gnome.org/)
Core app guides: Calculator, Clocks, Connections, Disk Usage Analyzer, Document Scanner, Text Editor, Image Viewer, Logs, Music, Papers, Software, System Monitor, Web Browser. Dev tools: Boxes, Sysprof. Circle apps. Games (11). Also Email/Calendar, Passwords and Keys, Terminal, Orca. Version-specific guides for GNOME 50 and 52. 16+ languages.

Takeaway: two parallel axes, "desktop concepts" chapters and "per-app" guides. Settings are one page per Settings panel.

---

## 3. Flavours

### 3.1 Per flavour

**Xubuntu** - https://docs.xubuntu.org/ (user guide at /user/C/index.html)
- Own full user manual, 16 chapters + 2 appendices: What is Xubuntu; Installation; Introduction (startup, desktop, session); Default Applications (by category); Software Management; Settings - Personalization; Settings - Hardware; Settings - Connectivity; Printing and Scanning; User Management; Hardware Devices; File Management; Media Applications; Migrating (from Windows); Troubleshooting; Upgrading; Appendix A Application table; Appendix B licence.
- 8 extra languages (de, en-GB, es, fi, fr, pt, pt-BR, ru). Separate contributor docs. IRC chat. Notes that general Ubuntu help also applies.
- Strengths: complete manual, task-and-app structure, translations, "Migrating" chapter for Windows users. Gaps: Troubleshooting only covers network; old Mallard/Yelp look, no search emphasis, no tutorials.

**Lubuntu** - https://manual.lubuntu.me/ (403 to the fetcher; contents unverified)
- Links from https://lubuntu.me/: Manual, blog, forum (discourse.ubuntu.com/c/flavors/lubuntu), wiki (git.lubuntu.me/lubuntu-wiki/wiki/wiki), links directory, downloads.
- Strengths: dedicated manual site, git-hosted wiki. Gaps: could not verify structure; forum is generic Ubuntu Discourse.

**Kubuntu** - https://kubuntu.org/
- Navigation: Discover, Download, Contact, About, Community, News, Donate; Archives for pre-24.04 site. No documentation section found.
- Support routes: Kubuntu Discourse, KDE forums, Ask Ubuntu, kubuntuforums.net, Matrix.
- Strengths: leans on KDE's own docs (UserBase / docs.kde.org, not fetched). Gaps: no own manual; users are sent to forums.

**Ubuntu Studio** - https://ubuntustudio.org/ and /help/
- Help page sections: Quick Start (setup guides, tips), Support Resources ("Introduction to audio on Ubuntu Studio", "Handbook for audio and music production", hardware compatibility, Ubuntu Studio Installer, real-time kernel details), Contact and Community (Discourse as preferred, Matrix), Common Questions (finding help, finding software, terminal use, troubleshooting). Also Audio Configuration page, Installer page, wiki, support page, release notes on Discourse.
- Strengths: domain-specific audio handbook, installer docs, release notes per version. Gaps: page itself admits much documentation is out of date.

**Ubuntu MATE** - https://ubuntu-mate.org/ , guide at https://guide.ubuntu-mate.org/
- Guide sections: Overview; MATE's applications (Caja, Pluma, Calculator, Engrampa, Eye of MATE, Atril, Baobab, System Monitor, Terminal, Control Center); Ubuntu MATE's applications (Welcome, productivity, Bluetooth, notifications and date/time, Caffeine, printing/scanning/PDF, entertainment, games, security (backups, updater, firewall), accessibility, installing more apps).
- Also: FAQ, support page, community forum (ubuntu-mate.community), get-involved.
- Format: one long page with figures, numbered steps, note callouts, cross-references, shortcuts, menu-path navigation ("Menu > Category > App").
- Strengths: app-by-app friendly guide, FAQ, a community forum. Gaps: single long page style, no tutorial/reference separation.

**Ubuntu Budgie** - https://ubuntubudgie.org/
- Only a Discourse forum (discourse.ubuntubudgie.org), GitHub, Buddies of Budgie desktop site, Budgie Extras. No manual found.

**Ubuntu Cinnamon** - https://ubuntucinnamon.org/
- Blog, Reddit, GitHub, Telegram, YouTube, Patreon, Cinnamon Spices (applets and themes catalogue). No manual or wiki.

**Edubuntu** - https://edubuntu.org/
- Download, news/release notes, team, contribute, social. No docs portal, no FAQ.

**Ubuntu Unity** - https://ubuntuunity.org/
- Downloads, Support, FAQ, press, unityd.org (desktop stack docs), GitLab and issue tracker, Telegram, Discord, Matrix, Reddit. Version shown is 24.04.4 LTS (older than the 26.04 flavours).

### 3.2 Comparison

| Flavour | Own manual | URL | Organisation | Tutorials | FAQ | Translated | Release notes | Verdict |
|---|---|---|---|---|---|---|---|---|
| Xubuntu | Yes, full | docs.xubuntu.org | 16 chapters by topic and app | No | No | 9 languages | News | Best flavour manual |
| Lubuntu | Yes (unverified) | manual.lubuntu.me | Unknown (403) | Unknown | Unknown | Unknown | Blog | Likely good, not verified |
| Kubuntu | No | kubuntu.org | Community links only | No | No | No | News | Forum-driven |
| Ubuntu Studio | Partial | ubuntustudio.org/help | Quick start, support resources, FAQ | Audio handbook | Yes | No | Discourse | Domain-specific, stale |
| Ubuntu MATE | Yes | guide.ubuntu-mate.org | Overview, desktop apps, distro apps | Inline | Yes | Not seen | Blog | Friendly, long page |
| Ubuntu Budgie | No | ubuntubudgie.org | Forum only | No | No | No | Blog | Gap |
| Ubuntu Cinnamon | No | ubuntucinnamon.org | Blog/social | No | No | No | Blog | Gap |
| Edubuntu | No | edubuntu.org | None | No | No | No | News | Gap |
| Ubuntu Unity | Minimal | ubuntuunity.org | Support + FAQ pages | No | Yes | No | Press | Minimal |

Pattern: most flavours have no real user documentation and rely on Ubuntu Help, the Ubuntu wiki and Discourse. Only Xubuntu and Ubuntu MATE ship a real manual. None have Diataxis structure, versioned release-aware docs, or integrated search beyond the site search of the CMS. This is the opening for Nubo OS.

---

## 4. What ordinary users look for

### 4.1 Reference table of contents

**macOS User Guide** (https://support.apple.com/guide/mac-help/welcome/mac), 18 top-level sections:
About your Mac model; What's new in macOS (current release); Find your way around your new Mac (desktop, menu bar, Dock, Control Center, Spotlight, notifications, Finder, brightness/volume, keyboard/trackpad); Get things done on a Mac (browsing, preview, screenshots, printing, shortcuts, app downloads); Apps; Files and folders (including backup and restore); Personalize your Mac (settings, wallpapers, widgets, screen savers, accounts, language); Siri; Apple Intelligence; Use Apple devices together (Continuity, AirDrop, Handoff, iPhone control, clipboard); Screen Time; Apple Account and iCloud; Watch, play and learn; Family Sharing; Use accessories and hardware (displays, camera, wireless devices, printers, battery); Accessibility (vision, hearing, mobility, speech); Restart, update, reset and restore; Privacy and security.

**Windows support** (https://support.microsoft.com/en-us/windows), 8 categories: Installation and updates; Drivers and devices; Network and internet; Files and storage; Security and privacy; Troubleshoot and repair; Accessibility; Hardware. Plus feature spotlights (Copilot, etc.) and "Get more done" groups: Explore/install/activate; Windows update (patches, FAQs, release notes); Personalisation and everyday tasks (taskbar, keyboard shortcuts, themes, BitLocker recovery); Troubleshooting (PC Health Check, Bluetooth, printing, Quick Assist).

### 4.2 Ranked 40 common tasks

Ranking is my synthesis from the three guides above (how prominently each task appears in macOS, Windows and GNOME TOCs, plus general support-demand knowledge). It is not measured traffic data. Rank 1 = most sought.

1. Connect to Wi-Fi
2. Fix "no internet" or Wi-Fi dropping
3. Install an app
4. Update the system and apps
5. Set up a printer / scan
6. Change the wallpaper
7. Pair a Bluetooth device (headphones, mouse)
8. Back up files and restore them
9. Take a screenshot or record the screen
10. Change the volume, pick the sound output and input
11. Add a user account / change password
12. Reset a forgotten password
13. Find a file / search the computer
14. Use keyboard shortcuts
15. Switch between windows and workspaces
16. Connect an external monitor or change display scaling
17. Change screen brightness, night light
18. Check and save battery, set power mode
19. Set the date, time, time zone
20. Change language, region, keyboard layout
21. Set up email, calendar and contacts accounts
22. Sign in to cloud account / sync files
23. Open, move, copy, delete, restore deleted files (Trash)
24. Use a USB drive, safely eject
25. Set default apps and web browser
26. Uninstall an app
27. Manage notifications and Do Not Disturb
28. Lock the screen, set auto-lock, log out, shut down, restart
29. Dark mode / change theme / text size
30. Make text larger, magnify, high contrast (accessibility)
31. Use a screen reader
32. Share the screen or desktop / remote help
33. Link your phone (notifications, file transfer, clipboard)
34. Use touchpad gestures and mouse settings
35. Install or fix drivers (graphics, Wi-Fi card)
36. Free up disk space
37. Encrypt the disk, privacy and security settings
38. Start an app at login / manage background apps
39. Install on a PC, dual boot, upgrade to a new release
40. Report a problem, get more help

Observation: items 1 to 10 are all solved by the Settings app or the top-bar menu. A "Popular tasks" tile row on the docs home page should cover them.

---

## 5. Page patterns

### 5.1 Task page (GNOME Help / Ubuntu Help / macOS)

- Title is an imperative verb phrase: "Connect to a wireless network", "Use macOS keyboard shortcuts".
- One or two sentence intro that says what you can do and why.
- Numbered steps, each begins with the UI location ("Open the system menu on the right side of the top bar", "choose Apple menu"). Names of controls are in the UI's own wording.
- Inline notes for the most common variants (hidden networks, where to find the router password).
- Dedicated troubleshooting short section on the same page for the most likely failures.
- "See also" list of 3 to 6 related pages, sometimes "More information".
- Mallard topics are tagged by `type` (guide / topic / task / problem), which drives the grouped index pages ("Common tasks", "More tasks", "Tips and questions", "Common problems").

### 5.2 Index (guide) pages

- Short blurb per link (GNOME: "Connect to wireless and wired networks. Stay safe with a VPN.").
- Groups: Common tasks; More tasks; Tips and questions; Common problems.
- Windows: category tiles; macOS: numbered sections with an expandable page list and "What's new in X" near the top.

### 5.3 Screenshots

- Ubuntu install tutorial: one screenshot per installer screen. MATE guide: figures with captions. macOS: captions describe what the picture shows ("The Edit menu is open in the Finder..."). GNOME Help: mostly text, few images, which keeps them evergreen.
- Ubuntu Desktop docs: screenshots used sparingly, steps mostly textual.

### 5.4 Keyboard shortcuts

- GNOME: grouped lists, key in brackets followed by a description, groups by purpose (desktop, editing, capture).
- Ubuntu Desktop docs: Reference page "Keyboard navigation shortcuts" plus Orca command pages.
- macOS: bulleted lists, a link to per-app shortcuts, and a how-to for customising or disabling shortcuts.
- No flavour or distro found with a printable cheat sheet or a search-by-key lookup.

### 5.5 Troubleshooting formats

- GNOME: "Common problems" topic grouping per hardware area plus inline "if that does not work" sections.
- Ubuntu Desktop docs: how-to pages titled "Troubleshoot your NVIDIA GPU and drivers" and "Common problems -> Bluetooth".
- Windows: troubleshooting is a top-level category with named tools (PC Health Check, Quick Assist).
- Xubuntu: Troubleshooting chapter (network only).

### 5.6 Other conventions worth copying

- Diataxis four-way split (Ubuntu Desktop docs).
- Difficulty rating and tags on tutorials (ubuntu.com/tutorials).
- Release-aware docs: "What's new in macOS N", Windows release notes, GNOME version-specific guides.
- Language switcher and version switcher in the header.
- Explanation pages that answer "what is X" (Menu key, snap vs deb).

---

## 6. Gaps a new OS could do better

1. Ubuntu Desktop docs and the Ubuntu Desktop Guide are two disconnected sites with different looks, and the guide was unreachable during this research. Nubo should have one site, one search.
2. Few pages show real UI. Use light and dark screenshots, consistent window crops, annotated callouts, and keep a screenshot manifest tied to releases so images can be regenerated.
3. Task-first entry: a home page with "I want to..." tiles for the top 10 tasks (Wi-Fi, install, print, back up, Bluetooth, wallpaper, screenshot, phone link, sign in, search).
4. In-product help: Nubo Search should return documentation pages (Super+Space), Settings panels should have a "Learn more" link to the matching doc page. Neither Ubuntu nor flavours link from Settings to docs by stable URL.
5. "What changed in this release" per version, with a "what moved" table for settings that changed place. Ubuntu keeps release notes on Discourse; macOS puts "What's new" at the top of the guide.
6. Printable and searchable shortcuts cheat sheet (one page, PDF, with search-by-key).
7. Troubleshooting organised by symptom ("my Wi-Fi keeps dropping"), not by component, with a diagnostic decision flow and copyable commands, and with a "collect logs for support" page.
8. Light and dark documentation theme matching Nubo themes, accessible by default (the OS's accessibility story should be visible in its docs).
9. Versioned docs (26.04 vs later) with a banner when reading old versions; flavours rarely do this and Studio admits out-of-date pages.
10. Explain Nubo-specific concepts that no other doc covers: account sign-in, Nubo as Online Account provider, store curation, notification history.
11. Windows/macOS switcher pages ("Coming from Windows", "Coming from macOS"). Xubuntu has a Migrating chapter, no one else does.
12. Short video or GIF for gesture-heavy actions (drag a widget, link a phone).
13. Page-level feedback ("Was this helpful?") and last-updated date per page; contributors guide for community fixes.
14. Translations from day one structure (Xubuntu has 9 languages; most others have none).
15. Docs delivered offline as an app page (Yelp-style) plus website, from the same source.

---

## 7. Recommended documentation outline for Nubo OS Desktop

Assumed stack: Nubo OS (Ubuntu 26.04 + GNOME 50) with Nubo menu in the top bar, Nubo Settings with first-run sign-in, Nubo as a GNOME Online Accounts provider (mail, calendar, contacts, files), Nubo Store (Flathub-based, grey "click to download" popular apps), Geary, Collabora Office, notification history panel with background-app agent, glass widgets (clock, weather, system, calendar; draggable), Nubo Search (Super+Space), phone link (GSConnect), light and dark themes. Verify each UI label against the build before writing.

### 7.1 Site architecture

- Static site generator: a docs framework with built-in search, versioning and dark mode (Sphinx + Furo as Ubuntu does, or Docusaurus, MkDocs Material or Astro Starlight; choose by team skills). Source in the nubo-os repo as Markdown, built in Drone alongside the images.
- Navigation: 13 top-level sections below, each with an index page that has "Common tasks / More tasks / Tips and questions / Common problems" groups (GNOME model).
- Page types, front-matter tagged: `task`, `concept`, `reference`, `troubleshooting`, `tutorial`, `release-notes`. Diataxis mapping: task = how-to, concept = explanation, reference, tutorial.
- Home: search box, "I want to..." tiles, "What's new in 0.8" link, download/upgrade link.
- Every page: last updated, applies-to version, "open in Settings" deep link where possible, feedback buttons, edit-on-git link.
- Screenshots: light and dark pair, 1x and 2x, alt text with description, regenerated per release from a script.

### 7.2 Page outline (approximately 125 pages)

**1. Get started (12)**
1. Welcome to Nubo OS (what it is, what is included)
2. System requirements
3. Download Nubo OS (flavours, architectures, checksums)
4. Verify your download
5. Create a bootable USB drive (Windows, macOS, Linux)
6. Try Nubo OS without installing
7. Install Nubo OS (tutorial)
8. Install alongside Windows (dual boot)
9. First-run setup and sign in to your Nubo account
10. Take the tour: desktop, top bar, Nubo menu
11. Upgrade from a previous release
12. Coming from Windows or macOS (quick map of familiar tasks)

**2. Using the desktop (14)**
13. Desktop overview
14. The top bar
15. The Nubo menu
16. Quick settings panel
17. Activities and the app grid
18. Open and switch applications
19. Windows: move, resize, tile, maximise
20. Workspaces
21. The dock and favourites
22. Lock screen, log out, switch user
23. Power off, restart, sleep
24. Multi-monitor and display scaling basics
25. Touchpad and touch gestures
26. Tips: ten things to try on day one

**3. Nubo account and cloud (10)**
27. What is a Nubo account
28. Create or sign in to your Nubo account
29. Sign out or switch accounts
30. Mail, calendar, contacts and files from your Nubo account (overview)
31. Nubo account in GNOME Online Accounts (add, remove, reauthorise)
32. Sync files with Nubo cloud storage
33. Share files and links
34. Change your password and secure your account (two-step)
35. Recover your account
36. Privacy: what data is stored and how to delete it

**4. Apps (22)**
37. Apps included with Nubo OS (list with purpose)
38. Nubo Store: browse, search and categories
39. Install an app from Nubo Store (including grey "click to download" popular apps)
40. Update and remove apps
41. Where Store apps come from (Flathub, verified apps, snap vs deb vs flatpak)
42. App permissions and sandboxing
43. Install apps from .deb files or the command line
44. Set default applications
45. Web browser
46. Geary: set up an account
47. Geary: read, write, search and organise mail
48. Geary: signatures, folders, troubleshooting sync
49. Calendar and Contacts
50. Collabora Office: Writer, Calc, Impress basics
51. Collabora Office: open and save Microsoft formats
52. Files app basics (see section 6 for detail)
53. Text Editor, Image Viewer, Papers (document viewer)
54. Photos, Music and Video players
55. Terminal basics
56. Calculator, Clocks, Weather, Maps
57. Start an app at login
58. Background apps: see and manage

**5. Settings (20)**
59. Nubo Settings overview
60. Wi-Fi and wired networks
61. Hidden networks, VPN and proxy
62. Mobile hotspot and phone tethering
63. Bluetooth
64. Displays and night light
65. Wallpaper and appearance
66. Light and dark themes (and automatic switch)
67. Accent colour and fonts
68. Sound
69. Power and battery
70. Keyboard and input sources
71. Mouse and touchpad
72. Date and time
73. Region and language
74. Users and passwords
75. Privacy and security (location, camera, microphone, screen lock)
76. Default apps
77. Printers and scanners
78. About, system updates and software sources

**6. Files and backup (10)**
79. Browse, search and open files
80. Copy, move, rename, delete, Trash
81. Preview and file properties
82. Compress and extract archives
83. USB drives and external disks: connect, eject, format
84. Network shares and cloud folders
85. Back up your files (Nubo cloud and local disk)
86. Restore from a backup
87. Check disk space and free up storage
88. Encrypt your drive

**7. Phone link (7)**
89. What phone link does
90. Install the companion app on Android
91. Pair your phone with Nubo OS (GSConnect)
92. See and reply to phone notifications on the desktop
93. Send and receive files, share clipboard, remote input
94. Find my phone and ring it
95. Troubleshoot pairing (firewall, same network, unpair and re-pair)

**8. Notifications and widgets (9)**
96. Notification centre and history panel
97. Do Not Disturb and per-app settings
98. Background-app agent: what it is and what it does
99. Notifications from apps and from your phone
100. Glass widgets: add, remove and arrange
101. Widgets: clock, weather, system, calendar
102. Drag and position widgets, reset layout
103. Widgets and notifications on the lock screen
104. Troubleshoot notifications and widgets

**9. Nubo Search (6)**
105. Open Nubo Search (Super+Space)
106. What you can search: apps, files, settings, mail, calendar, docs
107. Search operators and quick actions (calculator, units, web)
108. Search privacy and sources, turn sources on or off
109. Reindex and fix missing results
110. Tips to use Nubo Search faster

**10. Accessibility (8)**
111. Accessibility overview and the quick toggle
112. Vision: screen reader, text size, contrast, magnifier, cursor
113. Hearing: visual alerts, captions, mono audio
114. Mobility: keyboard, sticky/slow/bounce keys, on-screen keyboard, pointer
115. Voice and switch control options
116. Reduce motion and animations
117. Keyboard navigation reference
118. Report an accessibility issue

**11. Troubleshooting (10)**
119. Start here: how to find help and collect logs
120. Cannot connect to Wi-Fi
121. No sound or wrong audio device
122. Display problems (black screen, wrong resolution, external monitor)
123. Cannot sign in to Nubo account
124. App will not install or open
125. System is slow or battery drains fast
126. Printer not found
127. Bluetooth device will not connect
128. Recover from a failed update or boot problem (recovery mode)

**12. Reference (8)**
129. Keyboard shortcuts cheat sheet (also printable PDF)
130. Super+Space and Nubo-specific shortcuts
131. Important files and folders (home, config, caches, Flatpak data)
132. Command-line essentials for Nubo OS
133. Nubo-specific commands and services (agent, search, settings tools)
134. Glossary
135. Supported hardware and known issues
136. Package map: what ships in which Nubo meta package

**13. Release notes (3 plus archive)**
137. Release notes: current version (what's new, what moved, known issues)
138. Upgrade notes between versions
139. Release archive index (one page per release)

Count is 139 pages, which fits the 80 to 140 target; if scope must shrink, merge 53 to 56, 61 to 62, 112 to 116 and drop 30 to 34 duplicates.

### 7.3 Writing conventions for the team

- Title format: verb phrase for tasks; noun phrase for references; question for explanations.
- Steps: start with where to go, for example "Open the Nubo menu in the top bar", use exact UI labels, bold the control.
- Each task page ends with "If this does not work" (max 3 causes) and "See also" (3 to 6 links).
- Include the keyboard path where one exists.
- Name the version the page is verified against.
- Screenshot only the key screen of a procedure; describe the rest in text.
- Dark and light screenshots in a `<picture>` pair.

### 7.4 Priority order for writing

Phase 1 (launch, about 35 pages): 1 to 12, 28, 38 to 41, 46 to 48, 59 to 65, 79 to 80, 85 to 86, 91, 96 to 97, 105, 111 to 112, 119 to 120, 129, 137.
Phase 2: remaining sections 2, 3, 5, 6, 7.
Phase 3: reference, explanation pages, translations, community contributions.

### 7.5 Next steps for verification

1. Retry https://help.ubuntu.com/stable/ubuntu-help/ and https://manual.lubuntu.me/ and record the real TOCs.
2. Fetch individual Ubuntu Desktop docs pages (for example the Bluetooth common-problems page and keyboard shortcuts reference) to document the exact how-to template.
3. Fetch Windows 11 task-level pages and KDE UserBase for Kubuntu if a deeper comparison is wanted.
