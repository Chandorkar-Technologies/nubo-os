# Europe: government, public-sector, education and private-sector demand for sovereign/Linux desktop OS (as of October 2026)

RESEARCH LIMITATION (read first): the WebSearch quota for the session was exhausted (200/200) before this task started, so no web searches could be run. Only WebFetch worked, and only for Wikipedia pages (primary sites such as numerique.gouv.fr, TechCrunch, The Register and Le Monde returned 404 or no relevant content). Everything below is therefore secondary-source (Wikipedia, which itself cites primary/press sources) and is marked as such. Many countries and the tender/requirement details could not be researched; those are listed as Gaps. Nothing is invented; items from my own background memory are quarantined under "Unverified background" in the Gaps sections and must not be treated as facts.

## Q1. How real and how large is European sovereignty-driven desktop-OS demand in 2025-2026? (France verification, programme inventory, country table)

### Takeaway
The France "2.5 million PCs" claim is NOT supported as stated for Linux deployment: the best-sourced facts are that DINUM (the state digital directorate) announced on 2026-04-08 its own exit from Windows to Linux, with deployment limited to about 250 DINUM workstations as of 2026-04-18, and ordered all ministries to produce a plan by autumn 2026 for non-American tech (incl. PC operating systems). The 2.5 million figure appears in a Wikipedia summary as "driving migration of 2.5 million civil servant workstations" but its primary source was not verified. Real, verified European demand is mostly collaboration suites (openDesk, La Suite numerique, Nextcloud) plus a handful of desktop-OS programmes (Gendarmerie ~103k seats being the largest proven deployment); Russia is the only place with mandated, certified, large-scale Linux desktop procurement.

### Cited Findings

#### France: verification of the "2.5 million government PCs to Linux" claim
- April 2026: DINUM announced its departure from Microsoft Windows in favour of Linux on its own workstations ("En avril 2026, la DINUM annonce sa sortie de Microsoft Windows au profit de Linux sur ses postes de travail") — [fr.wikipedia DINUM](https://fr.wikipedia.org/wiki/Direction_interminist%C3%A9rielle_du_num%C3%A9rique) (secondary; Wikipedia cites the sources below)
- The DINUM plan requires all French ministries to produce a strategy by autumn 2026 to adopt non-American tech for PC operating systems, collaboration tools, antivirus, AI, databases, virtualisation and network equipment — [en.wikipedia DINUM](https://en.wikipedia.org/wiki/Direction_interminist%C3%A9rielle_du_num%C3%A9rique) (secondary)
- As of 2026-04-18 deployment was limited to 250 workstations inside DINUM itself — same en.wikipedia page (secondary)
- Wikipedia's citation list for that section: official DINUM press release on numerique.gouv.fr dated 2026-04-08; TechCrunch (Z. Whittaker, 2026-04-10); The Register (S. Sharwood, 2026-04-13); Frandroid (2026-05-04); The Stack (2026-04-27); GitHub cloud-gouv (May 2026) — same page. These are the primary/quality-press sources to read; I could not retrieve them (404s on guessed URLs; numerique.gouv.fr news page showed no Linux item).
- Technology: Sécurix, "a highly secure, reproducible operating system base built on NixOS", MIT licence on GitHub, incorporating ANSSI security recommendations (TPM2 management, YubiKey-based disk encryption); Bureautix is the office-desktop implementation, configuration managed via Git rather than a central directory — same page (secondary). Note: NixOS-based, not Ubuntu/Debian-based, and not a procured product.
- Generic Wikipedia "Linux adoption" says: "In April 2026, the French government announced that computers used by public institutions in the country would switch from using Windows to Linux by autumn 2026" — [Linux adoption](https://en.wikipedia.org/wiki/Linux_adoption) (secondary, loosely worded; conflicts with the DINUM-specific page which says autumn 2026 is the deadline for ministry STRATEGIES, not completed migration)
- The "2.5 million" figure: "French authorities mandated all government ministries create plans eliminating non-European digital dependencies, driving migration of 2.5 million civil servant workstations from Windows to Linux" — [Digital sovereignty](https://en.wikipedia.org/wiki/Digital_sovereignty) (secondary, no primary cited in the extract). Verdict: number unverified; best reading is an estimate of the total civil-service PC estate in scope of the ministry plans, not an announced migration order or budget. No tender, budget, integrator or distribution selected for the wider estate was found.
- La Suite numerique (DINUM + ANCT, with Dutch and German government collaboration): Docs, Visio (LiveKit), Tchap (over 600,000 government agents), Fichiers, Messagerie, Grist, all MIT-licensed — [GitHub suitenumerique](https://github.com/suitenumerique) (primary-ish, vendor GitHub)
- openDesk collaboration with DINUM began February 2024 — [OpenDesk](https://en.wikipedia.org/wiki/OpenDesk) (secondary)
- Gendarmerie nationale GendBuntu (Ubuntu-based): 65,000 PCs migrated by June 2014; 70,000 on 14.04 LTS in March 2017; June 2024 97% adoption across 103,164 workstations; upgrade to 24.04 completed December 2024; about 40% lower TCO than proprietary by Dec 2013, about EUR 2M/yr savings target — [GendBuntu](https://en.wikipedia.org/wiki/GendBuntu) (secondary; status: completed and maintained, the single largest proven Ubuntu-derivative government desktop deployment in Europe, and in-house maintained, not tendered)

#### Germany
- Munich LiMux: project approved 2004, migration from 2006, about 12,600 of 15,500 desktops by 2012; City Council voted in 2017 to return to Windows by 2020 citing user dissatisfaction/lack of software; 2020 coalition reversed rhetoric toward open standards; city reported about EUR 11.7M savings; a 2018 documentary suggested most staff were satisfied, implying political rather than technical drivers — [LiMux](https://en.wikipedia.org/wiki/LiMux) (secondary). Lesson: reversal risk is political, driven by application compatibility (Office/specialist apps), fragmented IT governance and user support; sovereignty projects need a continuous funding owner and an application-compatibility story.
- openDesk (ZenDiS, Centre for Digital Sovereignty): v1.0 released 2024-10-20; German government allocated combined EUR 45M to ZenDiS for openDesk development (as of 2024); Bundeswehr via BWI signed a seven-year agreement with ZenDiS (April 2025); Robert Koch Institute/health ministry Agora platform with 7,000 users (June 2025); Deutsche Rentenversicherung Bund and Bundesagentur fur Arbeit trial from January 2026; B1 Systems engaged for an enterprise edition (August 2024); International Criminal Court announced move from Microsoft Office to openDesk in October 2025 after US sanctions — [OpenDesk](https://en.wikipedia.org/wiki/OpenDesk) (secondary). Note: openDesk is a web/server collaboration suite, not a desktop OS.
- Schleswig-Holstein and the European Data Protection Supervisor switched from SharePoint to Nextcloud in 2025; Nextcloud interest tripled in first five months of 2025 — [Nextcloud](https://en.wikipedia.org/wiki/Nextcloud) (secondary). Germany also won Nextcloud's "Bundescloud" tender via ITZBund in April 2018 (same page). Schleswig-Holstein desktop/Linux seat counts and timeline: NOT verified (Wikipedia page had no content).
- March 2025: Deutsche Verwaltungscloud launched, multi-cloud on open standards — [Digital sovereignty](https://en.wikipedia.org/wiki/Digital_sovereignty) (secondary)

#### Denmark
- June 2025: Danish Ministry of Digitalisation announced a government-wide initiative to phase out Microsoft Office 365 and Windows in favour of LibreOffice and Linux — [Digital sovereignty](https://en.wikipedia.org/wiki/Digital_sovereignty) (secondary; seat counts, dates and status not stated; Copenhagen/Aarhus not verified)

#### EU level
- 2025-10: European Commission established the Digital Commons EDIC (DC-EDIC) with France, Germany, Netherlands, Italy, Luxembourg for sovereign open-source digital infrastructure — [Digital sovereignty](https://en.wikipedia.org/wiki/Digital_sovereignty) (secondary)
- EuroStack: launched September 2024; pitch published 2025-01-10 with 80+ organisations; academic version with Bertelsmann Stiftung and CEPS February 2025; endorsed by the European Parliament ITRE Committee June 2025; advocates propose EUR 300B over 10 years — [EuroStack](https://en.wikipedia.org/wiki/EuroStack) (secondary; advocacy initiative, not a funded programme)
- EU OS project, Cloud and AI Development Act, EUCS, Sovereign Tech Agency, Commission open-source strategy: pages returned 404 or no content; NOT verified.

#### Russia
- Astra Linux: certified by the Ministry of Defence, FSTEC and FSB, protection to "top secret" level (levels Oryol / Voronezh / Smolensk); January 2018 plan to deploy across all Russian Army computers replacing Windows; by 2020 more than one million licences sold and RUB 2B sales; used by Gazprom, Rosatom, RZD, healthcare and education; adoption accelerated after 2022 sanctions/Microsoft exit; IPO plans announced July 2022 — [Astra Linux](https://en.wikipedia.org/wiki/Astra_Linux) (secondary). ROSA, ALT Linux, import-substitution seat quotas: NOT verified.

#### Country table (status of research)
| Country | Programme found this session | Seats | Status | Source quality |
|---|---|---|---|---|
| France | DINUM exit from Windows (Sécurix/Bureautix, NixOS); ministry plans due autumn 2026; Gendarmerie GendBuntu | about 250 DINUM (Apr 2026); 103,164 Gendarmerie (Jun 2024); "2.5M" unverified | DINUM pilot/in progress; Gendarmerie completed | secondary |
| Germany | openDesk (ZenDiS, Bundeswehr/BWI, RKI 7,000 users, DRV/BA trials, ICC); Schleswig-Holstein Nextcloud; Munich LiMux reversed | Munich about 12,600 desktops; others partial | mixed | secondary |
| Denmark | Ministry of Digitalisation move to LibreOffice+Linux (June 2025) | not stated | announced | secondary |
| Russia | Astra Linux (MoD/FSB/FSTEC certified), army-wide plan 2018 | over 1M licences by 2020 | deployed/mandated | secondary |
| Netherlands, Germany (DC-EDIC), Italy, Luxembourg | DC-EDIC members (Oct 2025) | n/a | announced consortium | secondary |
| Sweden, Netherlands, France | Nextcloud for file transfer (2019) | n/a | deployed | secondary |
| Italy (Turin) | 2014 decision to switch to Linux | not stated | historic, outcome not verified | secondary |
| Austria, Spain, Switzerland, Poland, Czechia, Lithuania, Estonia, Finland, Norway, Sweden (OS), Netherlands (OS), Ukraine, UK, Belarus, Moldova, Western Balkans, Iceland, Liechtenstein, microstates, other EU member states | NONE FOUND / NOT RESEARCHED (search quota exhausted); this is not evidence of absence | - | - | - |

### Inferences
- The headline demand is for sovereign collaboration/cloud suites and political commitments to "non-American" stacks, not yet for a bought desktop OS. Actual Linux desktop seats under commitment in 2026: Gendarmerie about 103k (legacy, in-house) plus DINUM about 250 (pilot) plus Russia (not an addressable market for an Indian vendor).
- The France 2.5M number should be described in any report as "announced ambition/scope of ministry plans, not a verified migration".
- DINUM builds in-house (NixOS, MIT) rather than buying a distribution; a foreign Ubuntu-derivative is unlikely to be chosen centrally, but ministries' own plans (due autumn 2026) and agencies without in-house capacity are the opening.

### Gaps
- Primary DINUM press release (2026-04-08), TechCrunch, The Register, Frandroid, Le Monde, Reuters pieces not read; exact scope, timeline, budget and whether "2.5 million" is official remain unverified.
- No data found for Austria (Bundesheer LibreOffice, Ministry of Economy), Spain (Extremadura, Andalucia, LliureX, Catalonia), Switzerland (federal open-source law, Bern), Netherlands, Italy, Nordics, Poland, Czechia, Lithuania, Estonia, Ukraine, Belarus, UK, Western Balkans, Moldova, microstates; Copenhagen/Aarhus; Schleswig-Holstein seat counts (known to me only from memory, unverified: about 30,000 state workstations moving to Linux/LibreOffice announced 2024, with 2025-2026 phases); Lyon (2025 Microsoft exit, from memory, unverified); ROSA/ALT Linux seat quotas; education (LliureX, Pardus, Skolelinux), hospitals, private sector (e.g. large employers).
- Unverified background (from model memory, NOT sourced): Austrian armed forces announced LibreOffice move in 2025; Schleswig-Holstein 2024 announcement; Denmark's Copenhagen and Aarhus statements in 2025. Do not cite without checking.

## Q2. Entry paths for a new Ubuntu-derived distribution with a cloud account service (partners, integrators, funding calls, frameworks)

### Takeaway
Only thinly evidenced this session. The visible patterns: government buyers prefer open-source stacks built or integrated by public bodies (DINUM, ZenDiS/BWI) with specialist integrators (B1 Systems for openDesk), and public funding flows through national institutions (ZenDiS EUR 45M) and EU consortia (DC-EDIC). Ubuntu derivatives have precedent (GendBuntu).

### Cited Findings
- openDesk has an enterprise edition path via integrator B1 Systems (engaged August 2024) — [OpenDesk](https://en.wikipedia.org/wiki/OpenDesk) (secondary)
- ZenDiS received a combined EUR 45M for openDesk development (2024) — same page
- BWI (Bundeswehr public IT company) contracted ZenDiS for 7 years (April 2025), showing in-house public IT companies as procurement gateways — same page
- DC-EDIC (France, Germany, Netherlands, Italy, Luxembourg), established October 2025 — [Digital sovereignty](https://en.wikipedia.org/wiki/Digital_sovereignty)
- Nextcloud won German "Bundescloud" via ITZBund tender (2018), a precedent for open-source vendors via national IT service centres — [Nextcloud](https://en.wikipedia.org/wiki/Nextcloud)
- GendBuntu shows an Ubuntu-derived distribution can scale to 100k+ seats when run in-house — [GendBuntu](https://en.wikipedia.org/wiki/GendBuntu)

### Inferences
- Realistic entry for Nubo: (1) component partner to openDesk/La Suite numerique/Nextcloud-style stacks (Nubo's mail/calendar/files cloud overlaps with these, which are already state-backed; so competition more than partnership), (2) via European integrators/ISVs, (3) consumer/SME first and education pilots. Direct central government wins by an Indian vendor look unlikely in 2026 given "non-American"/European-sovereignty framing, likely extending to "European-hosted, European-controlled".

### Gaps
- No TED notices, framework agreements, UGAP/BOAMP, Bund.de or NGI/Horizon call details retrieved. NGI/NLnet, Sovereign Tech Agency, EU Open Source strategy funding not verified.

## Q3. Requirements a vendor would need to meet (certifications, SLAs, LTS, local hosting)

### Takeaway
Only fragments verified: ANSSI recommendations are baked into DINUM's Sécurix; Russia requires FSTEC/FSB/MoD certification. Broader European requirements (SecNumCloud, CSPN, BSI, EUCS, language, accessibility) were not verified in this session.

### Cited Findings
- Sécurix incorporates ANSSI security recommendations (TPM2, YubiKey disk encryption), MIT licence, reproducible builds — [en.wikipedia DINUM](https://en.wikipedia.org/wiki/Direction_interminist%C3%A9rielle_du_num%C3%A9rique)
- Russian certification regime: Ministry of Defence, FSTEC and FSB approval for Astra Linux — [Astra Linux](https://en.wikipedia.org/wiki/Astra_Linux)
- DINUM scope includes antivirus, virtualisation, databases, AI and network equipment, so vendor stacks are assessed as non-American across layers — [en.wikipedia DINUM](https://en.wikipedia.org/wiki/Direction_interminist%C3%A9rielle_du_num%C3%A9rique)
- Cloud-law driver: concerns about the US CLOUD Act cited as motivation — same page

### Inferences
- Likely baseline for any serious offer (not verified here): open-source licensing of the full stack, reproducible/auditable builds, EU-resident hosting under EU-owned entity, long-term support at least 5 to 10 years, and security certification in the target country; an Indian parent may be a ground for "non-European control" questions. Treat as hypotheses.

### Gaps
- SecNumCloud, CSPN, Common Criteria, BSI C5, EUCS status, EU public procurement preferences for European/open-source, accessibility (EN 301 549), language requirements, SLA norms: not researched (no search quota). Recommend re-running with search enabled, prioritising: numerique.gouv.fr 2026-04-08 press release, TechCrunch 2026-04-10, The Register 2026-04-13, heise/Golem on Schleswig-Holstein and Bundeswehr, TED CPV 48620000/72200000 notices, Commission "Cloud and AI Development Act" proposal, EU OS (euro-linux project), Austria Bundesheer, Danish Digitaliseringsministeriet.
