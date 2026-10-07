# Nubo office suite: building Collabora's code under our own name

Status: plan and research (2026-10-06). Nothing is built yet.

Goal: one office engine under Nubo names, used in two places:
- the desktop apps in Nubo OS (today: Collabora Office from Flathub, renamed at launcher level only);
- the document editor behind nubo.email (`office.nubo.email`, which runs ONLYOFFICE today and
  would move to our Collabora Online build).

## Names (decided 2026-10-06)

Suite **Nubo Office**; **Nubo Write** (documents), **Nubo Cells** (spreadsheets),
**Nubo Present** (presentations), **Nubo Draw** (drawings). Ids `tech.nubosuite.Office|Write|Cells|Present|Draw`.
Still to do before publishing: a trademark search for each name.

## What the licence and trademark rules say

Read: Collabora Online MPLv2 terms, Collabora trademark policy, Collabora Online
SDK theming page, LibreOffice branding notes. Sources at the end.

1. **The code is open.** Collabora Online and the Collabora Office engine are mostly
   MPLv2. Building from source, changing and distributing it is allowed.
2. **Collabora's own binaries carry extra conditions** (executable forms are not under
   plain MPLv2, and the free CODE builds are "not suitable for production in the
   enterprise"). We avoid that by building our own binaries from source.
3. **Marks must be removed from modified builds.** Trademark policy section 7: "remove
   all trademark uses of the Marks from the version of the Collabora Productivity
   software you are modifying." Marks: Collabora, Collabora Office, Collabora Online,
   CODE, the Collabora Productivity logo. The MPL terms add: remove all Marks "except
   those used to identify Collabora's ownership or licensing of the component".
4. **Keep notices.** Copyright notices and licence text stay. We must not "vary, delete
   or obscure any notices of proprietary rights". Modified source we distribute must
   be offered under MPLv2.
5. **No implied endorsement** (section 3). Wording in the About window such as
   "Based on Collabora Online and LibreOffice technology" is the usual way to credit
   without using a Mark as a name; the policy does not prescribe wording, so we ask
   trademark@collaboraoffice.com to confirm ours before release.
6. **CSS theming and UI defaults** can be changed by integrators for Collabora Online
   (variables such as primary-element, body-bg; `ui_defaults` to hide or show parts of the
   interface). That covers colours and layout, not names inside the engine.
7. **LibreOffice's name** may only be used for substantially unmodified software. A
   renamed build must not call itself LibreOffice. The engine's build takes
   `--with-branding=<folder>` (intro, about picture, icons) and `--with-vendor=<name>`.
8. **Flathub** does not accept web wrappers or forks with little change, and the app ID
   must be a domain we control (`tech.nubosuite.*` verified at
   `nubosuite.tech/.well-known/org.flathub.VerifiedApps.txt`). A full, branded build
   with real changes is more likely to be accepted than a renamed launcher, but there is
   no promise. Our own Flatpak repository (archive.nubosuite.tech/flatpak) needs no review.

## What the source shows (read 2026-10-07, tag `coda-26.04.3.3-1`, the version Flathub ships)

Checked out on VM 301 at `~/src/collabora` (2.3 GB, `engine/` is part of it).

**The desktop build is documented in `qt/README.md`:**
1. Engine: `cd engine && ./autogen.sh --with-distro=CPLinux-LOKit --without-package-format --with-system-nss && make`
2. App: from the top, `./autogen.sh && ./configure --enable-qtapp && make -j$(nproc)` gives `qt/coda-qt`.
3. Flatpak: `flatpak-builder ... qt/flatpak/com.collaboraoffice.Office.json` (needs the KDE 6.10
   runtime, node20 extension and the Qt WebEngine base app).
4. Needs GCC 13+ or Clang 17+, Qt6 WebEngine, and optionally the translations repository.

**Built-in branding hooks (use these first):**
- Engine configure: `--with-product-name='Nubo Office'` and `--with-vendor='...'`
  (the name in the About window and in saved files), `--with-branding=<dir>` (intro, about picture).
- Web interface: `--with-app-branding=<dir>` with `branding.css` and files it references;
  the web server reads `user_interface.brandProductName` from `coolwsd.xml`
  (this is what the editor shows in titles, clipboard text, error texts).
- Without a brand pack the interface says "Collabora Online Development Edition (unbranded)".

**The brand pack is proprietary.** Flatpak downloads `collabora-office-brand-26.04.3.3.tar.gz`
(145 files: `branding.js`, `branding*.css`, 81 images, 53 theme files, a welcome slideshow).
Its files are marked "(C) Collabora Productivity 2026, All Rights Reserved". We must not copy
it. We write our own pack with the same layout (`office/brand/`), and where we have no
artwork the unbranded defaults from the repository apply.

**Places that name Collabora and need our changes** (counts are files outside translations):
- `qt/` (44 files): app id and D-Bus name `com.collaboraoffice.Office` (DBusService.cpp), window
  icon name and description text (coda-qt.cpp), the `.desktop`, `.metainfo.xml` (name, summary,
  homepage, screenshots), `Makefile.am` icon file names, the Flatpak manifest.
- `browser/src`: fallback names "Collabora Online Development Edition (unbranded)" (Socket.ts,
  Toolbar.js, Clipboard.js, ProgressOverlay.js, About dialog), help and forum links
  (Control.Menubar.ts, PresenterConsole.js, FormulaErrorHelpSection.ts, server-audit dialogs),
  update message "Your Collabora Online server needs updating" (Map.VersionBar.js), texts in
  Control.Zotero.js and errormessages.js, `browser/html/*.html` titles, `browser/admin/*`.
- `engine/`: product name through configure; icon theme and intro images through the branding folder.
- Translations: the interface files mention the name in every language; the translations
  repository needs a search and replace as well.

**Must stay:** copyright headers ("the Collabora Online contributors"), `COPYING*`,
`THIRDPARTYLICENSES`, `CODA-THIRDPARTYLICENSES.html`, and a credit line in About.

## Rebrand script

`office/rebrand.py CHECKOUT --version X` applies the names to a checkout (tested on a copy of
`coda-26.04.3.3-1`: 103 lines, 12 files renamed, 9 icons redrawn, Flatpak manifest switched to
our brand pack, our own AppStream file). `--report` lists what still names Collabora or
LibreOffice. Known leftovers to handle next: the first-run welcome slides
(`browser/welcome/welcome.html`, text about Collabora), server-admin audit links, and
internal install folder names (`/app/collaboraoffice`), which users never see.
The script is run on every upstream release we take, so the rebrand is a script plus our brand pack,
not a fork to maintain by hand.

## First build result (2026-10-07, VM 301)

The engine and the Qt desktop app built from `coda-26.04.3.3-1` with `rebrand.py` applied, no errors.
Run under a virtual display the app shows "Nubo Office", the Nubo mark and a blue header on the
start screen (it was "Collabora Office" and purple until the `.tsx` files and the editor's `--doc-type`
colours were fixed), and a blank document opens in the editor. `--doc-type` colours now follow the
icon family: text blue, spreadsheet green, presentation orange, drawing violet. Not yet checked:
the other three document types, dark and light themes side by side, dialogs, the About window, the
Flatpak build, file open and save.

## Platforms (checked in the source, 2026-10-07)

| Platform | In the source | Build needs | Status |
|---|---|---|---|
| Linux desktop | `qt/` app, Flatpak and snap | Linux, Qt6 WebEngine; engine build is hours | Pipeline written (`ci/build-office.sh`, tag `office-*`), not run |
| Web (any browser, phones too) | Collabora Online server | Linux; the server build | To do: replaces ONLYOFFICE on `office.nubo.email` |
| Windows desktop | `windows/coda/` Visual Studio project, MSIX/AppX packaging, own README | Windows machine with Visual Studio 2026, WSL, Git Bash (WinGet configs in `windows/.config/`); x64 and ARM64 | Needed. Not started. A Windows runner is a later pipeline stage |
| macOS desktop | `macos/` app, own README | A Mac with Homebrew, Node 20, Xcode tools | Not started |
| Android | `android/` app | Linux with the Android NDK | Not started |
| iOS / iPadOS | `ios/` app | A Mac with Xcode, an Apple Developer membership, a real device (no simulator) | Not started, needs the paid account |
| WebAssembly | `wasm/` | | Immature upstream; ignore |

Order: Linux desktop (proves the rebrand), then the web server, then Windows (needed), Android and
macOS, then iOS. The names, logos, colours and welcome slides live in the shared web interface and apply
everywhere; app ids, icons and store listings are done once per platform.

Windows details: signed MSIX or installer needs a code-signing certificate (cost and lead time), and the
Microsoft Store needs a verified publisher name. A Windows VM or cloud machine around 8 cores, 32 GB RAM,
100 GB disk. Check the trademark search before any store submission.

## Sign-in

- Nubo OS: the Nubo account is the machine login (authd with the Nubo sign-in).
- Desktop apps: no account is needed to open and save files on the computer. It is expected of an office
  suite and it works offline. A forced login is not planned.
- Server files: the desktop apps open server documents through a file picker for a WOPI server, which
  logs in on the server's own page (`qt/RemoteOpen.cpp`, `qt/IntegratorFilePicker.cpp`). We set the
  server address to the Nubo server only, so the picker cannot be pointed at other providers.
- The apps have no Collabora account of their own, so nothing sends people to Collabora.

## Build machine

VM 301 now has 8 cores, 24 GB RAM, 138 GB disk (2026-10-07). The first engine build started there with `--with-product-name="Nubo Office" --with-vendor="Nubo"`.
The first engine build is LibreOffice-sized. Measure on the first run; plan 16+ cores, 32+ GB RAM, 150 GB disk.

## Plan

1. Clone the monorepo at the release branch Collabora Office uses (coda-25.04 or newer).
2. Search for every Mark: names in strings, window titles, logos, icons, about dialog,
   desktop and AppStream files, update checks, telemetry or support links. Replace with
   our names and assets, keep attribution lines.
3. Engine build with our branding folder and vendor name; web server build; Qt app build.
4. Flatpak manifest for the desktop apps (ids `tech.nubosuite.<App>`); Debian packages
   for the web server (office.nubo.email).
5. Build machine: a large one (see below), a pipeline job, results to our archive and
   our Flatpak repository.
6. Send the finished About text and names to trademark@collaboraoffice.com for a yes.
7. Get names cleared (search the trademark registers) before anything is published.

Build machine: the public docs say a first build takes "at least an hour or two,
possibly more". The engine is a LibreOffice-sized build; plan for 16+ cores, 32+ GB of
RAM and 150 GB of disk, and measure on the first run.

## Sources

- https://www.collaboraonline.com/terms/collabora-online-mplv2/
- https://www.collaboraonline.com/trademark-policy/
- https://sdk.collaboraonline.com/docs/theming.html
- https://www.collaboraoffice.org/post/build-code/
- https://github.com/CollaboraOnline/online/tree/distro/collabora/coda-25.04
- https://docs.flathub.org/docs/for-app-authors/requirements
- https://docs.flathub.org/docs/for-app-authors/verification
