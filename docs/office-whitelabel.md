# Nubo office suite: building Collabora's code under our own name

Status: plan and research (2026-10-06). Nothing is built yet.

Goal: one office engine under Nubo names, used in two places:
- the desktop apps in Nubo OS (today: Collabora Office from Flathub, renamed at launcher level only);
- the document editor behind nubo.email (Collabora Online server, `office.nubo.email`).

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

## What we have not read yet (must be done before the first build)

- The monorepo (`gerrit.collaboraoffice.com/online`, mirror `CollaboraOnline/online.mirror`)
  has `engine/` (the former Collabora Office core) and `qt/` (the desktop app). The public
  build page covers only the web server (CODE). **The desktop build and its branding
  resources are not documented there.** We read the `qt/` and `engine/` sources and the
  branding folders directly, then write the exact steps here.
- Where the product name appears in the web interface (browser/ folder), in desktop files,
  in installer/AppStream data, and in translations. A full search for "Collabora" and
  "LibreOffice" in the checkout gives the list of strings and images to change.

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
