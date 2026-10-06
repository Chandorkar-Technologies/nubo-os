# Popular apps, grey placeholders, and the Nubo store

Status: design. Catalog is `data/apps/popular.list`. Nothing below is built yet.

## Grey "tap to get" icons

Every `flatpak` row in the catalog gets a launcher entry that looks like the
app but greyed, with a small download badge.

1. Placeholder `.desktop` entry per app, id `nubo-get-<flatpak-id>`, grey icon,
   `Exec=nubo-get <flatpak-id>`.
2. `nubo-get`: if the app is installed, launch it. Otherwise show a small
   progress window, run `flatpak install --user flathub <id>`, then launch.
3. Hide the placeholder once the real app exists. A user service
   (`nubo-app-stubs`) regenerates placeholders in `~/.local/share/applications`
   at login and whenever the Flatpak export directory changes (systemd path
   unit). Installed apps get no placeholder, so there are no duplicates.
4. Pinned dock items: pin the placeholder id. After install, the stub service
   swaps the dock favourite to the real app id.

Grey icons: pull each app's icon from Flathub metadata at build time and
desaturate it. Do not redraw other companies' logos.

## Web apps

`web` rows become launchers that open the site as an app window (own window,
own icon, no tabs). Candidate engine: GNOME Web's application mode, or
Chromium's `--app=`. Decide after a test on the ARM VM. No install step.

## What is not bundled

Spotify, Slack, Zoom, Discord, Steam, Chrome and Dropbox are proprietary. The
image carries only placeholders. The person downloads them from Flathub, so
the image never redistributes their binaries.

## Store with cloud login

Goal: sign in once, see "your apps", restore them on a new machine.

- **Catalog and installs**: Flathub, through Flatpak. Flathub has no end-user
  login in the client, so sign-in is ours.
- **Account**: the Nubo account (identity provider plan). The store stores one
  record per account: installed app ids, favourites, dock order.
- **Restore**: first sign-in on a new machine shows those apps as grey
  placeholders; one click each, or "Restore all".
- **Front end**: first version is a curated "Popular" page over the Flathub
  API, not a general Flathub browser. Choose between customizing GNOME
  Software and a small own app (GTK4/libadwaita) once the placeholder flow works.
- **Paid Nubo apps** (later): entitlements on the same account.

## Open questions

- Which web-app engine (see above).
- Does Ubuntu 26.04 ship Flatpak + Flathub enabled by default? Verify on the VM.
- Account storage: new table in nubo-admin, or the identity provider's user attributes.

## Default app set (proposal)

Rule: the first screen should show Nubo apps and apps people already know.
Stock GNOME tools stay installed but are tucked into a "Utilities" folder.

Dock, left to right: Nubo Mail, Nubo Chat, Nubo Meet, Firefox, Files,
Calendar, Photos, Music (Spotify, grey), Notes, Nubo Search, App Store, Settings.

| Role | Ships by default | Replaces |
|---|---|---|
| Mail | Geary (GTK4, native), provisioned from the Nubo account | Thunderbird. Nubo Mail is not installed by default. |
| Chat, calls | Nubo Chat, Nubo Meet (web app) | none |
| Browser | Firefox (Flathub) | Ubuntu's Firefox snap |
| Calendar, Contacts | Calendar, Contacts (GNOME, renamed) wired to the Nubo account | |
| Documents | Collabora Office as Nubo Write, Cells, Present and Draw (package nubo-office) | LibreOffice |
| Photos | Nubo Photos (new) over Loupe for viewing | Shotwell |
| Music, video | Spotify (grey), VLC (grey) | Rhythmbox, Totem |
| Notes, reminders | Nubo Notes (new), Reminders | |
| Store | Nubo Store | App Center, Software |

Hidden in Utilities: Terminal, Logs, Disk Usage, Fonts, Characters, Backup,
Archive Manager, Document Scanner.
Removed: Transmission, Remmina, Rhythmbox, Thunderbird, Shotwell, Ubuntu
tooling (Software Updater branding, Ubuntu Pro, Apport prompts).

"New" rows (Photos, Notes, Chat client) do not exist yet. Until they do, ship
the web app or a renamed existing app in that slot.

## Migration app ("Nubo Migration", first-run and Settings)

Goal: someone switching from Windows, macOS, Google or Microsoft 365 brings
their stuff over without a terminal.

Already exists (server side, in nubo-admin): connectors for Google, Microsoft
365, Zoho and generic IMAP, drive copy through rclone, queue and progress.
`nubo-migrate-cli` drives them from a terminal. The OS app is a front end.

Two halves:

1. **Cloud accounts** (mail, calendar, contacts, Drive/OneDrive): sign in to the
   old account in the app, pick what to move, a server job copies it into the
   Nubo account. Progress shown in the app; keep working meanwhile.
2. **This computer** (files and settings): scan an old Windows or macOS disk
   or folder (external drive, dual-boot partition), copy Documents, Pictures,
   Music into the home folder; import browser bookmarks (HTML export) and
   Thunderbird/Outlook mail where readable.

First version: cloud half only, as a GTK4 app that calls a nubo-admin API with
the Nubo account token. Local half next. Passwords are never read from old
disks; people re-enter or export from their old password manager.

Open: the API surface nubo-admin must expose to a signed-in desktop client
(today's migration endpoints assume an organization admin).
