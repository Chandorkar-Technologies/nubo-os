# Website strategy: getting visitors to download Nubo OS

Status: October 2026. Design preview: https://claude.ai/artifact/KfuiAp6TfmjkMfdrqG4qTb
Sources: page teardowns done on 2 Oct 2026 (Zorin OS, elementary OS, Windows 11, Apple Mac, macOS, Ubuntu Desktop, End of 10). Anything not from those pages is marked as our own judgement.

## What the best pages do

| Page | What works | What we take |
|---|---|---|
| Zorin OS | Hero lists benefits; one button, "Download"; "test-drive from USB, no install" as the friction remover; sections on speed, security, privacy, reviving old PCs, Windows 10 end of support, apps, gaming, phone link, dual boot, accessibility, file compatibility; 12+ testimonials, press logos, a municipality case study | Same section list; the USB trial as a first-class idea; Windows 10 story |
| elementary OS | Version, file size and system specs next to the download button; ARM64 and x86-64 choices; press quotes; privacy stated repeatedly | Download facts on the page; honest architecture note |
| Windows 11 | Speed claim with a number and a footnote naming the baseline and benchmark; free-upgrade message removes the price objection early; FAQ before the user leaves | Footnoted, methodical claims; FAQ |
| Apple Mac | "Learn more" before "Buy"; battery and speed shown as tested outcomes with methodology; footnotes everywhere; a "help me choose" step | Two-level CTA; tested claims only |
| Ubuntu Desktop | A claim in the hero, app grid with logos, hardware partners and certification, enterprise and support story | Apps grid; engineering depth |
| End of 10 | Plain, conversational, "you don't have to do it alone"; urgency from the Windows 10 deadline | Tone; urgency; fear reduction |
| macOS (feature page) | Annotated real screenshots, a grid of small feature tiles, a compatibility list, footnotes | Annotated real screens; feature tiles |

## What visitors need answered, in order

1. Will it run on my PC? (Try from USB, no install.)
2. Will my apps and files work? (Real app grid; Office files open; what does not work.)
3. Is it fast? Does it save battery? (Needs real measurements. See below.)
4. Is it safe and private? (Encryption, signed updates, sandbox, open code.)
5. How long will it be supported? (Five years, to April 2031.)
6. Can I undo it? (USB trial, dual boot, reinstall.)
7. What does it cost? (Free.)
8. Who is behind it? (Company page, contact, security page: still to do.)

## Funnel

- First screen: benefit headline, one primary button "Download Nubo OS", one secondary "Try it without installing", four trust facts, a real desktop screenshot. The buttons must be visible without scrolling on a laptop-height window.
- A sticky "Download" bar after the hero; a download button in the nav; a download band mid-page; the full download box at the end of the OS page.
- Download box carries what elementary does: version, size, supported hardware, checksum, and step-by-step help per operating system.
- Two-level path: "Try it without installing" leads to the USB trial explanation; "Download" leads to the box.

## Claims policy (important)

- Do not publish a speed or battery claim without a measurement we can footnote. Microsoft and Apple both attach the baseline, the test and the date to every number.
- The only numbers we have today come from a 4-core, 4 GB virtual machine with software rendering (boot to desktop 18 s, about 2 GB memory in use at idle). They are not representative and would not help us. Do not publish them.
- Allowed now: features we can show or verify (Wayland with fractional scaling, HDR and VRR; hardware video decoding on by default; Power Mode in the quick settings; apps update separately; five-year support base).
- "Best OS on the planet" and similar superlatives: avoid; consumer-protection rules in the EU and India can challenge them.

## Benchmark plan (so the page can carry real numbers)

Machines: at least three real laptops (an older Intel laptop with 8 GB, a mid-range AMD laptop, a recent Intel laptop), each running Nubo OS, Windows 11 where supported, and Ubuntu 26.04.
Measure: time from power-on to usable desktop; idle memory; cold start of Firefox and the office suite; battery drain per hour for web browsing, 1080p video playback, and idle with screen on; fan and temperature during video playback.
Publish: every number with the machine, the date, the build and the method, in a footnote. Repeat each test at least five times and report the median.

## Open items before launch

- Real benchmark numbers (above).
- System requirements: "4 GB memory, 25 GB storage" is taken from the base system's usual figures and is not yet confirmed for 26.04.
- Testimonials and press: none yet. Do not invent them. Start an early-access programme to collect them.
- Company, contact, security and privacy pages; a security.txt.
- Legal: how to credit the base system without breaching its trademark rules; app-icon use on the page; the claim review.
- A real download file hosted at os.nubosuite.tech, with the checksum published from the build pipeline.
- ARM image, if Mac users are a target.
