---
title: Commands
description: Every command Nubo OS adds, with synopsis, options, examples and exit behavior.
sidebar:
  order: 10
---

This page lists the commands that Nubo packages install. The synopsis and the exit behavior were read from the scripts themselves. Commands that belong to Ubuntu, such as `apt` or `ufw`, are not repeated here.

| Command | Edition | Package | Needs `sudo` |
|---|---|---|---|
| [`nubo-channel`](#nubo-channel) | All | `nubo-archive` | Yes |
| [`nubo-get`](#nubo-get) | Desktop | `nubo-apps` | No |
| [`nubo-app-stubs`](#nubo-app-stubs) | Desktop | `nubo-apps` | No |
| [`nubo-search`](#nubo-search) | Desktop | `nubo-search` | No |
| [`nubo-notify-agent`](#nubo-notify-agent) | Desktop | `nubo-notify` | No |
| [`nubo-session-helper`](#nubo-session-helper) | Desktop | `nubo-theme` | No |
| [`nubo-incus-init`](#nubo-incus-init) | Virtualization | `nubo-incus` | Yes |
| [`nubo-podman-init`](#nubo-podman-init) | Containers | `nubo-podman` | Optional |
| [`nubo-server-firewall`](#nubo-server-firewall) | Server editions | `nubo-server-core` | Yes |
| [Internal programs](#internal-programs) | Desktop | several | |

## nubo-channel

Choose which update channel the Nubo packages follow. Installed to `/usr/sbin/nubo-channel`.

```text
nubo-channel [stable|beta]
```

| Argument | Effect |
|---|---|
| none | Print the current channel: `stable` or `beta` |
| `stable` | Set `Suites: resolute` in `/etc/apt/sources.list.d/nubo.sources` |
| `beta` | Set `Suites: resolute-beta` in the same file |

After a change, the command refreshes the package list for the Nubo source only (and falls back to a full `apt-get update` if that fails), then prints `Channel: <name>. Run: sudo apt upgrade`.

Exit behavior: it must run as root and checks that first, even with no argument. Without root it prints `Run with sudo.` to the error output and exits 1. An unknown argument prints `Usage: nubo-channel [stable|beta]` and exits 1. Otherwise it exits 0.

```bash
sudo nubo-channel
sudo nubo-channel beta
sudo nubo-channel stable
```

See [Channels: stable and beta](/updates/channels-stable-and-beta/).

## nubo-get

Download a popular app from Flathub, then open it. This is what the grey placeholder icons run. Installed to `/usr/bin/nubo-get`.

```text
nubo-get FLATPAK_ID [NAME]
```

| Argument | Meaning |
|---|---|
| `FLATPAK_ID` | The Flathub application id, for example `org.videolan.VLC` |
| `NAME` | The name to show in messages. Defaults to the id |

What it does, in order:

1. If the app is not yet installed, adds the Flathub remote for your user (if missing) and installs the app for your user without asking questions. A progress window is shown when `zenity` is available.
2. Runs `/usr/libexec/nubo/nubo-app-stubs` to remove the grey placeholder.
3. Starts the app in the background.

Exit behavior: with no argument it prints its usage text and exits 2. If the download fails it shows an error ("Could not download ..., check your internet connection") and exits 1. If the app starts, it exits 0 without waiting for the app.

```bash
nubo-get org.videolan.VLC VLC
```

## nubo-app-stubs

Writes the grey "click to download" launchers and web launchers for the popular apps. Installed to `/usr/libexec/nubo/nubo-app-stubs`. It runs at login as a user service and again after each `nubo-get`. There is normally no reason to run it by hand.

```text
nubo-app-stubs
```

No arguments. It reads the list at `/usr/share/nubo/apps/popular.list` and writes launchers into `~/.local/share/applications` (`nubo-get-*.desktop` and `nubo-web-*.desktop`). Launchers for apps that are now installed are removed. The environment variable `NUBO_POPULAR_LIST` can point to a different list file.

List format, one entry per line (lines starting with `#` are comments):

```text
kind | id-or-url | name | category | preinstall(yes/no)
```

`kind` is `flatpak` or `web`.

Exit behavior: always 0, even after an error, so that a failure never breaks the session. Errors are printed to the error output.

## nubo-search

Start or control Nubo Search, the launcher opened with <kbd>Super</kbd>+<kbd>Space</kbd>. Installed to `/usr/bin/nubo-search`, a link to `nubo-search.sh`.

```text
nubo-search [ARGUMENTS]
```

The script prepares a settings file on first run, puts the launcher's own libraries on the library path for the process, and then starts Vicinae with your arguments unchanged. Two arguments are used by Nubo:

| Argument | Used by | Effect |
|---|---|---|
| `toggle` | The <kbd>Super</kbd>+<kbd>Space</kbd> shortcut and the application entry | Show or hide the launcher |
| `server` | The autostart entry `nubo-search-server.desktop` | Start the background service at login |

Other arguments are passed to Vicinae. See Vicinae's own documentation for them. Settings are read from `~/.config/vicinae/settings.json`, which on first run imports `/usr/share/nubo/search/nubo.json`.

## nubo-notify-agent

Keep messaging apps running in the background so their notifications arrive when their window is closed. Installed to `/usr/libexec/nubo/nubo-notify-agent` and started with the session.

```text
nubo-notify-agent run | list | enable ID | disable ID
```

| Subcommand | Effect |
|---|---|
| `run` | Run the agent. The default when no subcommand is given. Checks every 30 seconds |
| `list` | Print each known app with its state (`on` or `off`) and `installed` or `not installed` |
| `enable ID` | Remove the app from your disabled list |
| `disable ID` | Add the app to your disabled list |

`ID` is the `id` field in `/usr/share/nubo/notify/background-apps.json`. The supported ids are `geary`, `org.telegram.desktop`, `com.slack.Slack`, `com.discordapp.Discord` and `org.signal.Signal`. Your choices are stored in `~/.config/nubo/notify.json`.

Rules of the agent: only installed apps are started; an app that is already running is left alone; an app that crashes is restarted with a delay that doubles up to 10 minutes; an app that exits cleanly (you chose Quit) stays closed until your next login. It waits about 10 seconds after login before the first check.

Exit behavior: an unknown subcommand, or `enable` or `disable` without an id, prints its usage text and exits 2.

```bash
/usr/libexec/nubo/nubo-notify-agent list
/usr/libexec/nubo/nubo-notify-agent disable com.slack.Slack
```

## nubo-session-helper

Runs at login as a user service. Installed to `/usr/libexec/nubo/nubo-session-helper`. It takes no arguments.

Jobs, in order:

1. Links your GTK 4 settings to the system copy of the Nubo app theme.
2. Adds the <kbd>Super</kbd>+<kbd>Space</kbd> shortcut for Nubo Search, unless you already have custom shortcuts.
3. Adds Nubo's extensions to your list of enabled extensions, once each, so a person who turns one off keeps it off.
4. Gives you the Nubo profile picture if you have none.
5. Keeps the GTK 3, icon and shell themes in step with the light and dark setting, but only while a Nubo theme is selected. It keeps running to watch for changes.

It never runs on installation media.

## nubo-incus-init

Set up Incus with a bridge and a storage pool. Installed to `/usr/bin/nubo-incus-init`.

```text
sudo nubo-incus-init
```

No options. It runs `incus admin init --preseed` with `/usr/share/nubo/incus-preseed.yaml` (a bridge `nubobr0` with automatic IPv4 and IPv6 addresses, a `dir` storage pool named `default`, and a default profile using both). If you ran it with `sudo`, it adds your user to the `incus-admin` group and tells you to log out and in again. It then prints `Try: incus launch images:ubuntu/24.04 first`.

Exit behavior: without root it prints `Run with sudo.` and exits 1. Other errors from `incus` stop the script with that command's status.

## nubo-podman-init

Start the Podman API socket for your user and keep it running after you log out. Installed to `/usr/bin/nubo-podman-init`.

```text
nubo-podman-init
```

No options. It enables lingering for your user (`loginctl enable-linger`) and enables and starts the user unit `podman.socket`. If you run it with `sudo`, it acts for the user who called `sudo`. It prints the socket path, `/run/user/<uid>/podman/podman.sock`, and a test command.

Exit behavior: if it would act for root, it prints `Run as your own user (or with sudo).` and exits 1.

## nubo-server-firewall

Close all incoming connections except SSH. Installed to `/usr/libexec/nubo/nubo-server-firewall`.

```text
sudo /usr/libexec/nubo/nubo-server-firewall
```

It runs these `ufw` steps: reset all rules, deny incoming by default, allow outgoing by default, allow `OpenSSH`, enable the firewall. The package runs it once on first install, and the cloud and image scripts run it while building.

:::caution
The first step is `ufw --force reset`. Running this program again deletes any rules you added. Add your own rules again afterwards.
:::

It has no options and no message of its own on success beyond what `ufw` prints. It stops on the first failing `ufw` step.

## Internal programs

These are started by the system. They are listed so you know what they are.

| Program | Started by | Purpose |
|---|---|---|
| `/usr/libexec/nubo/nubo-first-boot` | `nubo-first-boot.service` (once, until it succeeds) | Removes Ubuntu's store and helper snaps and Pro client, adds Flathub, installs the first-boot apps, removes LibreOffice, sets the profile picture. Never runs on installation media. Writes `/var/lib/nubo/first-boot-done` when finished |
| `/usr/libexec/nubo/nubo-account-setup` | `nubo-account-setup.service` (once, until it succeeds) | Sets up the Nubo account sign-in at the login screen. Writes `/var/lib/nubo/account-setup-done` |
| `/usr/libexec/nubo/nubo-setup` | Autostart at first login, and the "Nubo Account" application entry | The first-run window for signing in or creating a Nubo account |

## See also

- [Files and paths](/reference/files-and-paths/)
- [Packages](/reference/packages/)
- [Updates](/updates/)
