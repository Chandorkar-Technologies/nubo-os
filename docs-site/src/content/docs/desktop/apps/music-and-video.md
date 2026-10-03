---
title: Music and video
description: Play music and video with VLC, Spotify, Shortwave and Videos on Nubo OS.
sidebar:
  order: 70
---

**Applies to:** Desktop

Music and video apps on Nubo OS are mostly Flatpaks from Flathub, plus the GNOME video player. This page lists what is there and how to get what is missing.

| App | What it is | Where from | Installed at first boot |
|---|---|---|---|
| VLC | Plays almost any audio and video file | Flathub, `org.videolan.VLC` | Yes |
| Spotify | Music streaming | Flathub, `com.spotify.Client` | Yes, on x86 computers only |
| Shortwave | Internet radio | Flathub, `de.haeckerfelix.Shortwave` | Yes |
| Videos | The GNOME video player (Showtime). In the launcher it is named **Videos**, with the comment "Play videos" | Package `showtime` (recommended by the desktop) | With the system |
| YouTube Music | A website | Web launcher | On the popular list, but no launcher is made for it today |

"Installed at first boot" means the first-boot service downloads them from Flathub if you are online. If you were offline, it retries on each boot. An app that does not exist for your processor is skipped.

:::note
Spotify is not available for arm64 computers. On those, the first-boot service skips it. This is a Spotify limit, not a Nubo choice.
:::

YouTube, YouTube Music and Netflix are on the [popular list](/desktop/apps/popular-apps-click-to-download/) as web apps. Only the rows marked as preinstalled get a launcher.

## Before you begin

- An internet connection for streaming and for downloading apps.
- For Spotify, a Spotify account.

## Play a local file

1. Open **Files** and find the music or video.
2. Double-click it. Videos opens video files by default. <!-- verify behavior: default handlers -->
3. To use VLC instead, right-click the file, choose **Open With**, and pick VLC. <!-- verify label -->

## Listen to Spotify

1. Open **Spotify** from the app grid. If its icon is grey, click it once to download it. See [Popular apps: click to download](/desktop/apps/popular-apps-click-to-download/).
2. Sign in to your Spotify account.

## Listen to radio with Shortwave

1. Open **Shortwave**.
2. Search for a station and press play.

## Verify

- Play a short file in each app you use. Sound should come out of the speakers.
- `flatpak list --app` lists VLC, Spotify and Shortwave if installed.

## Troubleshooting

**No sound.** Open **Settings**, then **Sound**, and check the output device. <!-- verify label --> The system uses PipeWire, with `pipewire-pulse` and `wireplumber`.

**A video plays without picture or fails.** Try VLC. It brings its own codecs.

**Spotify is missing on an ARM computer.** There is no Spotify build for arm64. Use the web player in Firefox instead.

**The apps are not installed.** You were probably offline at first boot. Connect and restart, or install them from the [Nubo Store](/desktop/apps/nubo-store/).

**Notifications from Spotify never come.** Spotify is not in the list of background apps. See [Messaging and background apps](/desktop/apps/messaging-and-background-apps/).

## See also

- [Flatpak basics](/desktop/apps/flatpak-basics/)
- [Update apps](/desktop/apps/update-apps/)
