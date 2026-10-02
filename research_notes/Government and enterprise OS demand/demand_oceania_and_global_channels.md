# Oceania and global private-sector/channel demand for desktop Linux (as of Oct 2026)

RESEARCH LIMITATION (read first): the WebSearch quota for this session was exhausted (200/200) before any search ran, so this note rests on about 10 WebFetch calls, several of which timed out or returned 404. Almost nothing about Oceania was verified. Anything not cited below is "not verified". Facts from my pre-2026 background knowledge are labelled as such and carry no citation; they should be re-checked before use. A re-run with search quota is recommended for Part 1 and Part 2(a)-(e).

## Where is real procurement-grade demand, who sells to those buyers, and at what price points?

### Takeaway
No verified Oceania government or education Linux desktop programme was found. The only verified, citable price points are Canonical's (Ubuntu Pro $25/machine/year; workstation full support $300/machine/year) and Zorin's one-time Pro licence. The strongest verified demand signal is European sovereignty-driven migration plus consumer Windows-10-rescue downloads (Zorin), not Oceania procurement.

### Cited Findings
- Ubuntu Pro list price: $25 per machine per year for desktop/workstation; $500 per machine per year for server with unlimited VMs; free Personal tier for up to 5 machines; free Community tier up to 50 machines for active community members — [Canonical pricing](https://ubuntu.com/pricing/pro) (primary; currency shown as $, presumably USD, not confirmed)
- Canonical 24/7 enterprise support add-on: $300 per workstation per year (full support); server $1,775 (infra) or $3,400 (full) per machine per year; weekday support is 50% of 24/7 price; infra-only covers about 4,700 Main packages, full covers over 36,000 Universe packages — [Canonical pricing](https://ubuntu.com/pricing/pro) (primary)
- Zorin OS Pro is a one-time purchase (not subscription) with current major-version updates; each computer needs its own licence, businesses can buy tax-free with a VAT/GST number; the dollar amount did not render on the fetched page, so price NOT verified — [Zorin Pro page](https://zorin.com/os/pro/) (primary)
- Zorin OS: 1 million downloads within five weeks after Windows 10 end of support (Oct 2025), mostly from Windows users; Zorin OS 18 reached 2 million downloads in under three months by January 2026; Zorin 18 released 14 Oct 2025, supported to 1 June 2029; Zorin Group is Dublin-based — [Wikipedia: Zorin OS](https://en.wikipedia.org/wiki/Zorin_OS) (secondary, aggregator of vendor claims; downloads are not seats or conversions)
- Denmark's Ministry of Digitalisation announced in June 2025 plans to phase out Microsoft Office 365 and Windows for LibreOffice and Linux; Schleswig-Holstein (Germany) is migrating to Linux and LibreOffice — [Wikipedia: Digital sovereignty](https://en.wikipedia.org/wiki/Digital_sovereignty) (secondary; no seat counts given)
- France: Wikipedia states government computers in public institutions would switch from Windows to Linux by autumn 2026, and (separately) that a mandate in April 2026 started migration of 2.5 million civil-servant workstations — [Wikipedia: Linux adoption](https://en.wikipedia.org/wiki/Linux_adoption), [Wikipedia: Digital sovereignty](https://en.wikipedia.org/wiki/Digital_sovereignty). Low-to-medium reliability: the 2.5M figure is a very large claim from a secondary summary and must be checked against French government sources before use.
- China: Ministry of State Security reportedly directed some government entities to move from Windows 10 China Government edition to domestic Linux — [Wikipedia: Linux adoption](https://en.wikipedia.org/wiki/Linux_adoption) (secondary)
- Historic precedents: French Gendarmerie 65,000 seats on GendBuntu (completed 2014); Munich LiMux ~12,000 of 15,000 PCs (2013) — [Wikipedia: Linux adoption](https://en.wikipedia.org/wiki/Linux_adoption) (secondary, old; Munich later reversed, from background knowledge, not verified here)

### Inferences
- Procurement-grade buyers want a named vendor with SLA support; Canonical's published ladder ($25 base, $300 with 24/7 workstation support) is the benchmark Nubo would be compared with. Nubo, built on Ubuntu, should price below or bundle value (cloud accounts) rather than resell support it cannot back.
- Zorin's model (cheap one-time Pro licence, large free-download funnel) shows consumer conversion is small relative to downloads; the headline download figures are not revenue.
- European sovereignty programmes buy from EU vendors; an Indian company is unlikely to win these, and this demand does not transfer to Oceania.

### Gaps
- Pricing for SUSE (SLED), Red Hat Enterprise Linux Workstation, Kali, elementary, Zorin Pro amount, Ubuntu Desktop non-US currency prices: not retrieved.
- Seat-count enterprise examples (2024-2026) beyond the secondary Wikipedia items: not verified; no reliable named private-sector Win10-triggered migration found.

## What would Nubo need to do (certification, partners, support SLAs) to be considered?

### Takeaway
Not verified from Australian or NZ sources (fetches failed). Based on general knowledge, Australian government buyers require Essential Eight alignment, ISM controls and IRAP-assessed cloud services, which applies mainly to Nubo's hosted mail/files service rather than the OS image itself.

### Cited Findings
- No cited findings: the Essential Eight and IRAP pages (cyber.gov.au, Wikipedia) timed out or returned 404.

### Inferences
- (From background knowledge, uncited, verify) The Essential Eight is the ASD baseline; for non-corporate Commonwealth entities it is mandated via the Protective Security Policy Framework. IRAP assessors assess cloud services against the ISM for PROTECTED-level use. Nubo's cloud accounts would need IRAP assessment (or hosting on an already-assessed provider region) before federal or most state use; the desktop OS needs patching cadence (Essential Eight: patch OS within set timeframes, application control, MFA) and a documented hardening guide.
- Practical path: partner with an Australian reseller or MSP that already holds panel positions, publish an Essential Eight mapping for Nubo OS, use Ubuntu Pro/ESM underneath for patch SLAs, offer local-currency invoicing and an AU/NZ data-residency option for the cloud accounts, and pursue OEM-certified hardware (Dell/Lenovo Ubuntu-certified models) so buyers get a supported hardware bundle.
- Consumer-first remains the realistic Oceania entry; public-sector sales are long cycles.

### Gaps
- DTA policies (e.g. Hosting Certification Framework), AusTender and GETS NZ search, state education departments, Defence: not researched.
- NZ government open-source/cloud-first policy and Ministry of Education: fetch returned empty; not verified.

## Part 1 table: Oceania by country (all "not verified")

| Country/group | Demand found | Detail | Status | Source quality |
|---|---|---|---|---|
| Australia (federal: DTA, ASD E8/ISM/IRAP, Defence) | None found | Searches blocked; no deployments verified | Not verified | n/a |
| Australia (state education departments) | None found | Not researched; background: state schools run Windows/Chromebook/iPad, not verified | Not verified | n/a |
| New Zealand (government, MoE) | None found | Not verified | Not verified | n/a |
| Pacific island states (grouped: Fiji, PNG, Samoa, Tonga, Vanuatu, Solomons, etc.) | None found | ADB/World Bank/refurbished PC programmes not verified | Not verified | n/a |

## Part 2 summary by sub-question (all thin)

- (a) Enterprise deployments: only the secondary items above (France, Denmark, Schleswig-Holstein, China); no named private-sector seat counts verified.
- (b) OEM preload/certification (Dell, Lenovo, HP, Framework, System76, Tuxedo, Slimbook, Star Labs, Canonical certification, Snapdragon X): not verified from sources this session. Background knowledge, uncited: Dell and Lenovo sell Ubuntu-certified models and Lenovo certifies ThinkPad/ThinkStation for Ubuntu and Fedora; Framework, System76, Tuxedo, Slimbook and Star Labs sell Linux-first hardware. Re-verify.
- (c) Refurbished/Win10 rescue: Zorin download figures above only; End of 10, Endless, refurbished Ubuntu stock: not verified.
- (d) Telco/ISP/bank bundling: not found.
- (e) Schools/universities: not verified (only historic Tamil Nadu ELCOT Linux-for-students 2008, per [Wikipedia: Linux adoption](https://en.wikipedia.org/wiki/Linux_adoption)).
- (f) Vendors: Canonical and Zorin only (see first section).

### Gaps
- Everything above marked not verified; recommended follow-up with search access: DTA/AusTender, cyber.gov.au E8 and IRAP, GETS NZ, Canonical certified-hardware and Dell/Lenovo press pages, Phoronix/The Register on Win10 migrations, SUSE/Red Hat/Kali/elementary pricing pages.
