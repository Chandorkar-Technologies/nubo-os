# Nubo Office on Flathub

This folder is what goes into the Flathub repository for `tech.nubosuite.Office`
(`github.com/flathub/flathub`, a pull request against the `new-pr` branch, then Flathub makes
`github.com/flathub/tech.nubosuite.Office`).

- `tech.nubosuite.Office.json` builds Nubo Office from source, with no network during the build.
  It is Collabora's own Flathub manifest (com.collaboraoffice.Office) plus one step: `office/rebrand.py`
  from this repository, pinned by commit, applies the Nubo names, icons, welcome slides and AppStream file.
- `flathub.json` limits the build to x86_64.

## Before you open the pull request

1. Build it locally and install it (see below); check that it starts and opens a .docx.
2. Run the linters:
   `flatpak-builder-lint manifest tech.nubosuite.Office.json`, `flatpak-builder-lint repo repo` and
   `appstreamcli validate --pedantic tech.nubosuite.Office.metainfo.xml`.
3. Verify the app ID. After the pull request is opened, Flathub shows a token. Put it in
   `https://nubosuite.tech/.well-known/org.flathub.VerifiedApps.txt` (website/public/.well-known/) and press Verify in the
   Flathub developer portal. `tech.nubosuite.Office` is tied to the domain nubosuite.tech.

## Build locally

    flatpak install flathub org.kde.Sdk//6.10 org.kde.Platform//6.10 org.freedesktop.Sdk.Extension.node22//25.08 io.qt.qtwebengine.BaseApp//6.10
    flatpak-builder --user --install --force-clean --ccache build tech.nubosuite.Office.json

The first build takes hours (it compiles LibreOffice's engine). Flathub's builders do it for you.

## Updating

Change the `commit` of the `nubo` source to the new release commit of this repository, and the Collabora
tag and commit when moving to a newer Collabora release. Update `NUBO_RELEASE_DATE` and `--version` in the build commands.

## Pull request text

> Nubo Office: a free office suite (Write, Cells, Present, Draw) built on Collabora Online / LibreOffice
> technology under the MPL-2.0. Rebranded fork of the Collabora Office source already on Flathub as
> com.collaboraoffice.Office, built from the same tag; the only additions are our names, icons and an AppStream file
> (applied by `office/rebrand.py`, pinned by commit). App ID tech.nubosuite.Office matches our domain nubosuite.tech.
> The finish-args are the same as Collabora's. The trademark notice in the description states it is not made or endorsed by Collabora or LibreOffice.
