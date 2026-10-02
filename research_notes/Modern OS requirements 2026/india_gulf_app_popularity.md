# India and Gulf (UAE, KSA, Qatar, Kuwait, Oman, Bahrain) app popularity on desktop, and Linux viability (as of Oct 2026)

Method note: about 17 searches/fetches. Search tool is US-only and returned many SEO/aggregator pages. Most Similarweb/StatCounter/DataReportal pages were seen only as search snippets, not full fetches. Per-app desktop MAU for the regions was NOT found; most figures are all-device. Weak sources are marked (WEAK).

## 1. Most-used apps per category in each region (usage evidence)

### Takeaway
Messaging, video and AI are dominated by WhatsApp, YouTube and ChatGPT in both regions, but I found no desktop-only usage rankings per app. Rankings below are website-traffic ranks (Similarweb) and all-device penetration (DataReportal-derived), so treat them as proxies for desktop. Most of the other apps in the requested categories (Teams, Zoho, WPS, Shahid, OSN+, Anghami, JioHotstar, etc.) have no usage figures in my sources.

### Cited Findings
- India overall top sites, Aug 2026 (Similarweb): 1 google.com, 2 youtube.com, 3 instagram.com, 4 whatsapp.com, 5 chatgpt.com. ChatGPT is in India's top 5 websites. — [Similarweb India](https://www.similarweb.com/top-websites/india/) (via search snippet, not fetched)
- India social networks category, Jun 2026: instagram.com, whatsapp.com, facebook.com, reddit.com, linkedin.com. — [Similarweb](https://www.similarweb.com/top-websites/india/computers-electronics-and-technology/social-networks-and-online-communities/) (snippet)
- India: DataReportal Digital 2026 India reports 1.03 billion internet users (about 70%). Figures cited by an aggregator: WhatsApp about 535M users, YouTube 500M, Instagram 481M, Facebook 403M. The numbers are relayed by an aggregator, not read on DataReportal directly. — [WSCubeTech summary (WEAK)](https://www.wscubetech.com/blog/social-media-platforms/); see also [DataReportal Digital 2026 global](https://datareportal.com/reports/digital-2026-global-overview-report)
- Saudi Arabia: WhatsApp used by 92.2% of internet users, YouTube 79.9%, Snapchat 79%; 33.9M internet users, 99% penetration (article dated 14 Sep 2026, cites DataReportal/Statista/Talkwalker; secondary). — [The Saudi Times (WEAK, aggregator)](https://thesauditimes.net/en/saudi-internet-and-social-media-statistics-2026-40-plus-key-numbers/)
- Saudi Arabia Similarweb: youtube.com is #1 in Arts and Entertainment (Jun 2026); Google #1 search engine, then bing.com (May 2026); amazon.sa #1 shopping Aug 2026, then temu.com, noon.com. — [Similarweb KSA arts](https://www.similarweb.com/top-websites/saudi-arabia/arts-and-entertainment/), [KSA search](https://www.similarweb.com/top-websites/saudi-arabia/computers-electronics-and-technology/search-engines/), [KSA ecommerce](https://www.similarweb.com/top-websites/saudi-arabia/e-commerce-and-shopping/) (snippets)
- UAE Similarweb search-engine category May 2026: google.com, bing.com, yandex.ru, music.youtube.com, claude.com (shows Claude and YouTube Music rank in the UAE top of that category). — [Similarweb UAE](https://www.similarweb.com/top-websites/united-arab-emirates/computers-electronics-and-technology/search-engines/) (snippet)
- Desktop browser share (StatCounter, via search snippet): India Chrome 91.29%, Edge 3.75%, Firefox 1.93%, Opera 1.49%, Safari 0.78%, Brave 0.64% (Nov 2025). Saudi Chrome 84.65%, Edge 5.74%, Safari 4.83%, Firefox 1.35% (May 2026). UAE Chrome 78.56%, Safari 11.52%, UC 2.75%, Edge 1.98% (Jul 2026; note the UAE URL was the desktop+mobile combined page, so not desktop-only). — [StatCounter India desktop](https://gs.statcounter.com/browser-market-share/desktop/india), [KSA desktop](https://gs.statcounter.com/browser-market-share/desktop/saudi-arabia), [UAE](https://gs.statcounter.com/browser-market-share/desktop-mobile/united-arab-emirates)
- Linux desktop share: StatCounter via a secondary site reports India 16.21% (July 2024), "highest of any major economy". The StatCounter OS-by-country figure for India is widely suspected to include ChromeOS/other artefacts, so use with caution. No Gulf Linux figures found. — [CommandLinux (WEAK)](https://commandlinux.com/statistics/desktop-os-market-share-by-country/)
- Qatar/Kuwait/Oman/Bahrain: no usage rankings found.

### Inferences
- Shortlist ordering that the evidence supports: messaging = WhatsApp first in both regions (Telegram, IMO, Botim ranks not evidenced); video = YouTube first; AI = ChatGPT first in India (top-5 site); browsers = Chrome first by far (78-91%), Edge second in India/KSA, Safari relatively high in UAE/KSA (Mac/iPad use), Firefox only 1-2%.
- The browser data means a Linux-for-consumers product should ship Chrome/Chromium (or equivalent) as an easy install, since sites are tested against it.
- Category entries without usage data (Shahid, OSN+, Anghami, JioHotstar, Zoho, WPS, Canva, Notion, Perplexity, Copilot, Gemini, iCloud, Dropbox) should be listed as "unranked" in the report.

### Gaps
- No per-app desktop MAU/share from Sensor Tower, Statista, GWI, Counterpoint, Comscore found (mostly paywalled; not reachable via this search tool).
- No full fetch of DataReportal country pages (India/UAE/KSA/Qatar/Kuwait/Oman/Bahrain) was done; numbers are second-hand.
- No Similarweb ranks for Qatar, Kuwait, Oman, Bahrain, nor UAE general top-10.
- No Linux share for Gulf countries.

## 2. Linux status per app (native / web-PWA / Wine-Android layer / unavailable)

### Takeaway
Only partial verification from sources; Flathub verification checked for Telegram, Discord, and Spotify only. Rest of the tags below come from general knowledge and are flagged UNVERIFIED so the report writer can check Flathub pages.

### Cited Findings
- Telegram Desktop Flatpak is verified/official on Flathub. — [Flathub Telegram](https://flathub.org/en/apps/org.telegram.desktop) (via search summary)
- Discord is Flathub-verified (Oct 2023). — [OMG Ubuntu](https://www.omgubuntu.co.uk/2023/10/discord-flatpak-now-verified-flathub)
- Spotify on Flathub is a community package, NOT verified by Spotify, about 114,615 downloads/month, x86_64 only (fetched ~Oct 2026). — [Flathub Spotify](https://flathub.org/en/apps/com.spotify.Client)
- Netflix/Prime Video on Linux play through Widevine in Firefox/Chrome, but Netflix defaults to 720p in Firefox on Linux (1080p needs a workaround), and software decoding is typical. Source is older and partly a how-to page. — [It's FOSS](https://itsfoss.com/netflix-firefox-linux/) (snippet; WEAK on currency)
- Hotstar claims: a TechVorm guide states Linux "cannot play back" Hotstar DRM content; this is an old blog and may be outdated for JioHotstar. — [TechVorm (WEAK, dated)](https://techvorm.com/guide-to-stream-hotstar-videos-drm-content-in-linux)

### Inferences (UNVERIFIED, from general knowledge, not from fetched sources)
- Likely native Linux apps: Telegram (Flathub verified), Signal (official Linux desktop app), Zoom (official Linux client), Spotify (official snap/deb; Flathub unofficial), Slack, Discord, LibreOffice, Firefox/Chrome/Edge/Brave, Dropbox (official Linux client), WPS Office (official Linux build), Zoho (web), Notion (web/unofficial wrapper).
- Likely web/PWA only: WhatsApp (no official Linux desktop app; WhatsApp Web), Google Meet, Teams (Microsoft deprecated its Linux desktop client; PWA), Microsoft 365 web, Google Workspace, Canva, ChatGPT, Gemini, Claude, Perplexity, Copilot, YouTube, YouTube Music, Netflix, Prime Video, Shahid, OSN+, Anghami, JioHotstar, iCloud web, OneDrive web.
- Likely Android layer / unavailable: Botim, IMO, Tawakkalna and UAE Pass are mobile-first (Waydroid or phone is the realistic route); iCloud desktop sync and Windows-only utilities are unavailable.
- Please have the report writer verify the above on Flathub/Snap Store before promising anything.

### Gaps
- Flathub/Snap official status for Signal, Zoom, Slack, WPS, Dropbox, Brave, Chrome, Edge, Teams not verified in this pass.
- Streaming quality caps on Linux (Prime Video/Netflix resolution; Shahid, OSN+, Anghami, JioHotstar) not checked on current official help pages.

## 3. Government and banking requiring Windows-only software, extensions, card readers, or blocking Linux

### Takeaway
India's income-tax portal officially supports Linux for DSC signing; UAE Pass/Nafath/Absher/Tawakkalna are built around a smartphone app as the second factor, which works with a desktop browser plus phone. I did not find confirmed Linux user-agent blocking, but coverage is thin.

### Cited Findings
- Income Tax e-filing DSC Management Utility (emBridge) is offered for Windows, Mac, Ubuntu and RedHat; portal recommends latest Chrome, Firefox, Safari. — [Income Tax portal downloads](https://www.incometax.gov.in/iec/foportal/downloads/dsc-management-utility) (fetched)
- Absher login problems on Safari are often fixed by switching to Chrome or Firefox; outdated browsers cause certificate issues. Source is a blog. — [KSABuddy (WEAK)](https://ksabuddy.com/how-to-fix-common-absher-login-problems-for-expats-in-saudi-arabia/) (snippet)
- UAE Pass is a smartphone-based national digital identity app (iOS/Android) that also does document signing. — [u.ae](https://u.ae/en/about-the-uae/digital-uae/digital-transformation/platforms-and-apps/the-uae-pass-app) (snippet); QR on a desktop site is scanned with the phone app (inferred from [UAE Pass docs](https://docs.uaepass.ae/feature-guides/authentication/mobile-application/pre-requisites), not fully read)
- DigiLocker is described as available on mobile and desktop/web; no Linux-specific limits found. — [DigiLocker Wikipedia (WEAK)](https://en.wikipedia.org/wiki/DigiLocker)
- Historical: some Indian banks needed a Java plugin on Linux for netbanking key files. Old source, likely stale. — [LWN](https://lwn.net/Articles/460701/)

### Inferences
- Items likely to need desktop-side attention: DSC/e-sign USB tokens in India (needs PKCS#11/emBridge, proprietary drivers; Linux utility exists for income-tax but GST, MCA, e-procurement tools vary, unverified), Saudi/UAE card readers (Emirates ID reader software, Saudi smart-card), and any bank that fingerprints user agents.
- Aadhaar, UPI: UPI is mobile-app based, not a desktop use case; Aadhaar services (UIDAI) are web.

### Gaps
- No evidence checked for: SBI/HDFC/ICICI web banking Linux support, GST portal DSC on Linux, MCA, Emirates ID reader/UAE Pass desktop, Nafath desktop flow, Tawakkalna web, Qatar Metrash/Kuwait Sahel/Oman/Bahrain eGov, e-signature products (Adobe Sign, DocuSign work in browser, unverified).
- No confirmation of any site blocking Linux user agents.

## 4. Gulf service restrictions an OS should not promise

### Takeaway
Consumer VoIP calling (WhatsApp, FaceTime, Skype-type) is blocked or restricted on local carrier networks in UAE, Qatar, Oman and (officially) Saudi Arabia; Bahrain is the exception per secondary sources. Licensed or business tools (Botim, ToTok-style, C'ME, Teams, Zoom, Meet) generally work. An OS should not promise WhatsApp calling or VPN-based workarounds in the Gulf.

### Cited Findings
- UAE: WhatsApp messaging works; voice/video calls blocked in 2026. Teams, Zoom and Google Meet permitted for business use; Botim, C'ME licensed by TDRA. — [Simology UAE VoIP (WEAK, eSIM seller)](https://simology.io/blog/uae-voip-app-calling-what-works-what-doesnt-2025-traveller-guide); [AWS Legal Group](https://aws-legalgroup.com/new-whatsapp-regulations/) (snippet); no TDRA primary notice fetched
- Saudi: Gulf News (2 Feb 2025) reported WhatsApp calls activated on some networks per a tech expert, with no CST confirmation; CST had denied a similar March 2024 report and kept the ban. — [Gulf News](https://gulfnews.com/world/gulf/saudi/whatsapp-calls-reportedly-activated-in-saudi-arabia-permanent-change-or-temporary-test-1.500027288) (fetched). Later 2025 blog says calls still restricted — [SaudiMoments (WEAK)](https://www.saudimoments.com/do-whatsapp-calls-work-in-saudi-arabia-2025-updates-714768.html)
- Qatar: CRA restricts consumer VoIP; WhatsApp calls blocked on Qatari SIMs (2026 page). — [Simology Qatar (WEAK)](https://simology.io/blog/qatar-voip-roaming-rules-2026-messaging-calling-workarounds)
- Oman: calling blocked; Bahrain: no limits per a secondary source; Kuwait lumped with restricted countries. — [Cloudwards (WEAK)](https://www.cloudwards.net/countries-where-whatsapp-is-banned/), [Istizada (WEAK)](https://istizada.com/blog/telecommunication-voip-challenges-in-the-middle-east/)
- Botim, IMO and Google Meet described as accessible in Saudi by a corporate blog. — [FreJun (WEAK)](https://frejun.com/secure-methods-make-calls-ksa-without-restrictions/)

### Inferences
- Do not market VPN or "unblock calls" features for the Gulf; restrictions are on carrier-network traffic and vary by network, time and licence status, which is a legal/compliance risk.
- Wi-Fi/home broadband versus mobile data behaviour was not established.

### Gaps
- No primary regulator text (TDRA, CST, CRA Qatar, TRA Oman/Bahrain/Kuwait CITRA) found; all status claims come from secondary sources. Kuwait has no specific source.

## 5. Which top apps Flathub or Snap provide officially

### Takeaway
Confirmed only: Telegram and Discord verified on Flathub; Spotify is not (community package). Others not verified in this pass.

### Cited Findings
- Telegram verified on Flathub; Discord verified since Oct 2023; Spotify community-only on Flathub. — sources in section 2.

### Gaps
- Check flathub.org verified badge pages and snapcraft.io publisher status for: Signal (org.signal.Signal), Zoom (us.zoom.Zoom), Slack, Brave, Chrome, Edge, Firefox, Opera, WPS Office, Dropbox, LibreOffice (TDF), Notion/others, Teams (community PWA wrappers), Anghami (unlikely), and WhatsApp (only third-party wrappers, e.g. ZapZap, unofficial). I did not check any of these.

## Overall remaining gaps for the report writer
- All per-app Linux tags except those in section 2 cited findings are unverified general knowledge.
- No data for e-learning and creative tools (Coursera, Byju's/PhysicsWallah, Udemy, Canva, Adobe, Figma) and no OneDrive/iCloud/Dropbox usage ranks.
- No Sensor Tower, Counterpoint, GWI, Comscore, TDRA/CST primary documents were reached.
