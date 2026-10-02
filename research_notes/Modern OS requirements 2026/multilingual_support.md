# Multilingual support on Ubuntu 26.04 LTS / GNOME 50 (Wayland): Arabic and Indian languages (as of Oct 2026)

Scope note: about 13 searches/fetches were used. Several fetched pages were summarised by a small model, so exact numbers should be re-verified on the live l10n.gnome.org pages before they go into a customer-facing document. Evidence on bidi/Indic shaping bugs specific to 2025-2026 was thin: searches returned no specific, citable GNOME 50 Arabic RTL or Indic shaping regressions. That absence is not proof they do not exist.

## Arabic: RTL layout, fonts, Hijri calendar, numerals, bidi, apps, installer

### Takeaway
No primary-source evidence of a current GNOME 50 RTL layout regression was found. The documented gaps are translation completeness and the lack of native Hijri calendar support, which is only filled by third-party GNOME Shell extensions.

### Cited Findings
- GNOME Shell main-branch UI translation for Arabic (ar) is listed at about 32% (Hindi 82%, Bengali 58%, Malayalam 33%). This looks low, so verify it. The page is the main branch, not the GNOME 50 release set, and the summary was model-extracted. — [l10n.gnome.org gnome-shell module](https://l10n.gnome.org/module/gnome-shell/)
- GNOME 50 release-set statistics fetched for ar, hi, ta, te, bn, mr, gu, kn, ml, ur did not return an Arabic row (see Gaps). — [l10n.gnome.org GNOME 50 release](https://l10n.gnome.org/releases/gnome-50/)
- An Arabic translation gap in a GNOME runtime snap: libadwaita.mo was missing for "ar" in the gnome-46-2404 snap, so libadwaita strings fell back to English in snap apps. This is an older (2024-era) packaging issue, not GNOME 50. — [ubuntu/gnome-sdk #358](https://github.com/ubuntu/gnome-sdk/issues/358)
- Hijri date is not shown natively in the GNOME Shell calendar. Several third-party extensions exist: Hijri/Islamic/Arabic Date, Al-Hijri Date, Islamic date/time functions, and Hijri Calendar. A prayer-times extension offers RTL UI and optional Arabic-Indic numerals. — [extensions.gnome.org Hijri Date](https://extensions.gnome.org/extension/5995/hijri-date-extension/), [Al-Hijri Date](https://extensions.gnome.org/extension/8236/al-hijri-date/), [prayer-times-indicator](https://github.com/MohammedAlimoor/prayer-times-indicator)
- Terminal bidi support: Ubuntu Launchpad bug #263822 "RTL support in terminal (BiDi)" for VTE dates from 2008. It is an old long-standing gap (the search result did not show current status). — [Launchpad #263822](https://bugs.launchpad.net/bugs/263822)
- Ubuntu 26.04 ships fonts-noto, fonts-noto-core, fonts-noto-cjk and fonts-noto-extra packages. Per a secondary blog source, these cover Arabic, Hebrew and Indic scripts. Which of these are installed by default on the desktop ISO was not verified. — [OneUptime blog (secondary)](https://oneuptime.com/blog/post/2026-03-02-how-to-configure-fonts-for-international-characters-on-ubuntu/view); [Ubuntu Discourse: Noto as default fonts proposal (older)](https://discourse.ubuntu.com/t/let-selection-of-default-fonts-be-based-on-noto/36923)
- Ubuntu 26.04 LTS: GNOME 50, kernel 7.0, released April 2026; 26.04.1 released later. — [Ubuntu Discourse 26.04.1](https://discourse.ubuntu.com/t/ubuntu-26-04-1-lts-released/86808), [Ubuntu 26.04 release notes](https://documentation.ubuntu.com/release-notes/26.04/)
- The official Ubuntu 26.04 release notes overview page contains no language/input-method/RTL information (fetched page showed none). — [Ubuntu release notes](https://documentation.ubuntu.com/release-notes/26.04/)

### Inferences
- Because Hijri has no native shell support, an Arabic-targeting derivative should preinstall and preconfigure a vetted Hijri extension (or ship it as a default-on option). This follows from the extension list above.
- With Arabic UI completeness possibly near a third on the shell module (if the figure is right), mixed Arabic/English UI is likely. Vendor-side translation work would have outsized value. Needs verification.

### Gaps
- No evidence found for Arabic in Firefox, LibreOffice or Collabora Office behaviour (bidi, shaping, Arabic-Indic digit options).
- No data found on the Ubuntu installer (Subiquity/Flutter installer) Arabic translation completeness or RTL layout.
- No Arabic keyboard layout/IBus (ibus-m17n, Arabic phonetic) evidence found.
- No GNOME 50 Arabic row retrieved from the l10n release stats.
- No specific 2025-2026 libadwaita/GTK4 RTL bug reports found.

## Indian languages: input methods, fonts, translation completeness, voice typing

### Takeaway
IBus with typing-booster/m17n is the working path on GNOME Wayland. GNOME 50 UI translation is strong only for Hindi (about 87%); Tamil, Telugu, Bengali, Marathi, Gujarati, Kannada and Malayalam are around 30-42% and Urdu is about 0%.

### Cited Findings
- GNOME 50 UI translation, via the Damned Lies release page (model-summarised, verify): Hindi 87% (25,878 translated, 2,122 fuzzy, 1,899 untranslated); Tamil 38%; Telugu 37%; Bengali 30%; Marathi 34%; Gujarati 35%; Kannada 34%; Malayalam 42%; Urdu 0%. Documentation translation 0-16% across these. — [l10n.gnome.org GNOME 50](https://l10n.gnome.org/releases/gnome-50/)
- Conflicting figure for the gnome-shell module alone (main branch): Hindi 82%, Bengali 58%, Tamil/Telugu/Kannada about 21%, Marathi/Gujarati about 22%, Malayalam 33%, Urdu not listed. The two pages measure different scopes (whole release set vs one module) so they are not strictly in conflict. — [l10n.gnome.org gnome-shell](https://l10n.gnome.org/module/gnome-shell/)
- All 10 languages of interest have active GNOME translation teams on the languages index. — [l10n.gnome.org languages](https://l10n.gnome.org/languages/)
- ibus-typing-booster is a predictive/completion input method; since version 2.27.23 it supports all m17n input methods, and it uses the same libm17n as ibus-m17n. It also provides emoji prediction. Upstream docs include GNOME integration instructions. — [ibus-typing-booster user docs](https://mike-fabian.github.io/ibus-typing-booster/docs/user/), [GitHub](https://github.com/mike-fabian/ibus-typing-booster)
- Precedent: Fedora 30 switched the default input method for Assamese, Bengali, Gujarati, Hindi, Kannada, Maithili, Malayalam, Marathi, Odia, Punjabi, Sindhi, Tamil, Telugu and Urdu from ibus-m17n to ibus-typing-booster (new installs only). — [Fedora Wiki](https://fedoraproject.org/wiki/Changes/Ibus_typing_booster_default_for_indian_languages) (2019)
- Fcitx5 on GNOME Wayland (Ubuntu 26.04, GNOME Shell 50.1, fcitx5 5.1.19): the candidate window appears at a fixed screen position (about 390,726) instead of at the caret for native Wayland clients without GTK/Qt IM modules. Open. GTK/Qt apps work normally. The reporter says IBus itself transmits cursor coordinates correctly; the bug is in fcitx5's IBus-compat/XCB window. — [fcitx5 #1672](https://github.com/fcitx/fcitx5/issues/1672)
- Further 2026 candidate-window reports for GNOME Wayland: fcitx5 5.1.22 on GNOME Shell 50.5 classic UI not following the cursor; a kimpanel candidate popup stealing focus on GNOME Wayland, breaking composition in contenteditable editors. (Reported by search snippet; not individually verified.) — [kimpanel #111](https://github.com/wengxt/gnome-shell-extension-kimpanel/issues/111), [search result for fcitx5 issues](https://github.com/fcitx/fcitx5/issues/1672)
- Older IBus/Wayland issues: lookup table appearing bottom-left of the application (Ubuntu im-config bug, 2022); GTK4 preferring ibus-gtk4 over the Wayland protocol causing misplaced candidate window (2022-2024 IBus issues); input method switching problems in GTK4 popovers. — [Launchpad #1969637](https://bugs.launchpad.net/ubuntu/+source/im-config/+bug/1969637), [ibus #2638](https://github.com/ibus/ibus/issues/2638), [ibus #2406](https://github.com/ibus/ibus/issues/2406)
- Voice typing offline options on Linux (secondary blogs, 2026): Vocalinux (whisper.cpp/Whisper/VOSK, X11 and Wayland), Voxtype (GNOME Wayland and X11), Speech Note (offline STT in its own window; copy text out), Blurt GNOME extension, Speed of Sound (GTK4). Hindi/Indic language support of these was not confirmed in the sources. — [Spokenly blog (secondary)](https://spokenly.app/blog/speech-to-text-linux), [Vocalinux GitHub](https://github.com/TeamADAPT/vocalinux)
- Old Pango Indic shaping patches (Telugu/Kannada akhand) from 2010 show a long history of Indic shaping issues; no current-year shaping bug was found. — [gtk-i18n list 2010](https://mail.gnome.org/archives/gtk-i18n-list/2010-August/msg00008.html)

### Inferences
- Default IBus plus ibus-typing-booster (with m17n tables) for the Indic locales is a low-risk choice mirroring Fedora since 2019; Fcitx5 on GNOME Wayland has open candidate-position bugs and should not be the default.
- Translation completeness is the largest measurable gap: only Hindi is near parity. A vendor shipping Tamil/Telugu/Marathi etc. should expect a largely English UI.

### Gaps
- No percentages for Arabic in GNOME 50, and no Ubuntu installer translation completeness (Launchpad Rosetta) found.
- No source found on whether Ubuntu 26.04 Desktop installs ibus-typing-booster, ibus-m17n or Noto Indic fonts by default.
- No GNOME 50 on-screen keyboard or emoji-picker Indic/Arabic-specific bugs found.
- No specific Indic rendering/shaping bug reports from 2025-2026 found; Urdu (Nastaliq) rendering was not covered (Noto Nastaliq availability not verified).
- Hindi/Marathi IBus layouts (InScript2 etc.) status not verified in a primary source.

## What Windows 11 and macOS 26 provide that GNOME lacks

### Takeaway
Both competitors ship integrated phonetic/transliteration keyboards for ten Indian languages and first-party voice dictation for several; GNOME has no first-party equivalent of voice typing.

### Cited Findings
- Windows 11 voice typing (online) covers Tamil, Hindi, Gujarati, Marathi and Telugu among Indian languages; Kannada not supported (Microsoft Q&A, user-facing; date about 2023-2024, may have changed). Voice typing needs internet. — [Microsoft Q&A](https://learn.microsoft.com/en-us/answers/questions/4025816/these-languages-support-voice-typing-in-windows-11), [Microsoft Support](https://support.microsoft.com/en-us/windows/use-voice-typing-to-talk-instead-of-type-on-your-pc-fec94565-c4bd-329d-e59a-af033fa5689f)
- Windows 10/11 include built-in Indic phonetic keyboards for Hindi, Bangla, Tamil, Marathi, Punjabi, Gujarati, Odia, Telugu, Kannada, Malayalam (typing "namaste" yields नमस्ते). These replaced the old Microsoft Indic Language Input Tool. — [YourWindowsGuide (secondary)](https://yourwindowsguide.com/2025/08/download-microsoft-indic-tool.html), [WindowsForum (secondary)](https://windowsforum.com/threads/how-to-set-up-indic-phonetic-keyboards-on-windows-a-step-by-step-guide.354605/)
- macOS 26 Tahoe: transliteration keyboards for Hindi, Marathi, Bangla, Gujarati, Punjabi, Urdu, Kannada, Malayalam, Tamil, Telugu, plus Arabic transliteration; dictation listed for Hindi (India), Tamil, Arabic (Saudi Arabia, UAE). — [Apple Community doc](https://discussions.apple.com/docs/DOC-250006842), [Apple feature availability](https://www.apple.com/lae/macos/feature-availability/)

### Inferences
- GNOME's functional counterpart to transliteration is m17n/typing-booster (itrans/phonetic tables), which is comparable in capability but requires manual setup and lacks discoverability.
- The real gap is voice typing: only third-party offline tools exist and none were confirmed to support Indic languages or to be integrated in the GNOME shell.

### Gaps
- No primary-source check of Apple's current dictation list for Telugu, Bengali, Marathi, Gujarati, Kannada, Malayalam, Urdu.
- Windows list is from Q&A pages, not an official current language-support table.

## Cheap fixes for a derivative (inferences from the above, not sourced recommendations)

### Takeaway
Preconfigure input and fonts per locale, and prioritise translation work; do not rely on Fcitx5 on GNOME Wayland.

### Cited Findings
- (See above) Fedora's 2019 precedent for typing-booster default; typing-booster supports all m17n tables and emoji prediction. — [Fedora Wiki](https://fedoraproject.org/wiki/Changes/Ibus_typing_booster_default_for_indian_languages)
- Hijri date via GNOME Shell extensions exists. — [extensions.gnome.org](https://extensions.gnome.org/extension/5995/hijri-date-extension/)

### Inferences
- Ship fonts-noto-core plus Noto Naskh/Kufi Arabic and Noto Nastaliq Urdu on the live/installed image, and verify fontconfig fallback order for Arabic and each Indic script (not verified in sources).
- Preinstall ibus-typing-booster and ibus-m17n; set GSettings input-sources defaults per locale (e.g. Hindi: typing-booster/m17n hi-itrans plus inscript2). Mirror Fedora's approach.
- Preinstall and enable a Hijri extension for the Arabic locale; consider Arabic-Indic digit locale options.
- Fund or contribute translations to GNOME (Tamil, Telugu, Bengali, Marathi etc.) and Ubuntu installer strings; test the installer in Arabic for RTL layout manually since no evidence was found.
- Offer an optional offline voice-typing app (Speech Note or Vocalinux) after verifying Indic/Arabic model quality; Whisper-class models cover Hindi/Arabic but accuracy for other Indic languages was not verified here.

### Gaps
- All of the above require hands-on testing on a 26.04 image; no source verified default package sets or end-to-end behaviour.
