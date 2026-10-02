# Sovereign desktop demand is real, but Nubo cannot buy its way in

**Read this first: the research largely failed.** The session's web-search budget (200 calls) was exhausted before the seven regional researchers started. Only Wikipedia fetches worked, plus a handful of vendor pages (Canonical pricing, Zorin Pro, pardus.org.tr, GitHub). Every finding below is secondary-quality unless marked otherwise. "None found" in any table means "not searched or not retrievable", and is NOT evidence that no programme exists. No primary procurement documents, tenders, press releases or government sources were read. Several regions (Africa, Gulf, Oceania, most of Asia and the Americas) produced almost nothing.

The best-supported finding is narrower than the headline stories. Real, sourced demand for desktop Linux in government exists, but it is mostly built in-house or by state-funded vehicles (France's Gendarmerie, India's Maya OS and BOSS, Kerala's school distro, Turkey's Pardus, China's Kylin, Russia's Astra). The 2025-26 European sovereignty wave is mostly about collaboration suites, not purchased desktop OSes. For an Indian consumer-first distribution monetised through paid cloud accounts, central-government desktop deals look unlikely near term. Education, SMEs, integrator partnerships and the Windows 10 end-of-support window are likelier routes. These are hypotheses, not findings.

## The France "2.5 million PCs" claim is not verified as stated

Earlier statements in this session said France plans to move 2.5 million government PCs to Linux. The Europe notes do not support that wording. What is sourced, from Wikipedia citing a DINUM press release of 8 April 2026, TechCrunch (10 April), The Register (13 April) and others (none of which could be retrieved):

- DINUM, the state digital directorate, announced it is moving **its own workstations** from Windows to Linux. About **250 were deployed by 18 April 2026** ([en.wikipedia DINUM](https://en.wikipedia.org/wiki/Direction_interminist%C3%A9rielle_du_num%C3%A9rique)).
- It ordered **all ministries to produce plans by autumn 2026** for non-American alternatives across PC operating systems, collaboration tools, antivirus, AI, databases, virtualisation and network equipment (same page). Autumn 2026 is the deadline for strategies, not for completed migrations. Wikipedia's "Linux adoption" page words this loosely, as if computers would switch by autumn ([Linux adoption](https://en.wikipedia.org/wiki/Linux_adoption)).
- DINUM built its own OS base, **Sécurix** (NixOS-based, MIT licence, ANSSI recommendations), with **Bureautix** as the office desktop. It is not a procured product and not Ubuntu-based (same page).
- The **"2.5 million" figure appears only in a Wikipedia summary** ("driving migration of 2.5 million civil servant workstations") with no primary source in the extract ([Digital sovereignty](https://en.wikipedia.org/wiki/Digital_sovereignty)). The best reading is an unverified estimate of the estate in scope of the ministry plans. No budget, tender, integrator or distribution selection for that estate was found.

**What this affects.** The only earlier report found in the reports folder, *Modern OS requirements 2026*, lists the figure at line 118 and already marks it "secondary sources only; not verified". It should be reworded to the DINUM facts above. The Country opportunity report was not present when this was written; any statement in it or in the conversation that France "plans to move 2.5 million PCs" should be corrected the same way. The Americas and Oceania notes also repeated the figure (with a caution in the Oceania note), so any number carried from them is affected.

## What was actually sourced: 24 programmes, few of them purchased desktops

| Organisation | Country | Size / seats | OS / distribution | Status | Date | Source quality | Relevance to Nubo |
|---|---|---|---|---|---|---|---|
| DINUM | France | about 250 (own staff); "2.5M" unverified | Sécurix/Bureautix (NixOS) | Pilot; ministry plans due autumn 2026 | Apr 2026 | Secondary | Built in-house; signals demand, not a buyer of distros |
| Gendarmerie nationale (GendBuntu) | France | **103,164** workstations, 97% adopted | Ubuntu-based, in-house | Completed; 24.04 upgrade Dec 2024 | 2014-2024 | Secondary | Proves Ubuntu derivatives scale to 100k+ seats, but run in-house ([GendBuntu](https://en.wikipedia.org/wiki/GendBuntu)) |
| Munich LiMux | Germany | about 12,600 of 15,500 desktops | LiMux | **Reversed** (2017 vote, back to Windows by 2020) | 2004-2020 | Secondary | Reversal risk: app compatibility, support, political ownership ([LiMux](https://en.wikipedia.org/wiki/LiMux)) |
| openDesk / ZenDiS | Germany | EUR 45M funding; RKI 7,000 users; BWI 7-year deal | Collaboration suite, **not an OS** | Deployed and trialling | 2024-2026 | Secondary | Overlaps Nubo's cloud suite; state-backed ([OpenDesk](https://en.wikipedia.org/wiki/OpenDesk)) |
| Schleswig-Holstein | Germany | Not verified | Nextcloud (SharePoint exit); Linux seats unverified | Announced | 2025 | Secondary | Seat counts unknown ([Nextcloud](https://en.wikipedia.org/wiki/Nextcloud)) |
| Ministry of Digitalisation | Denmark | Not stated | LibreOffice and Linux | Announced | Jun 2025 | Secondary | Scope and status unknown |
| Astra Linux | Russia | Over 1M licences by 2020 | Astra (MoD/FSTEC/FSB certified) | Deployed, mandated | 2018-2022 | Secondary | Closed to an Indian vendor ([Astra Linux](https://en.wikipedia.org/wiki/Astra_Linux)) |
| Kylin / NeoKylin; UOS (Deepin) | China | About 90% of government sector (2019) | Domestic Linux | Deployed | 2019 | Secondary | Closed in practice ([Kylin](https://en.wikipedia.org/wiki/Kylin_(operating_system))) |
| Ministry of State Security order | China | None stated | Domestic Linux replaces "Windows 10 China Government edition" | **Unverified**, August 2026 | Aug 2026 | Secondary, citations not viewable | Re-check first; informs closed-market list |
| Red Star OS | North Korea | n/a | State OS | Closed, sanctioned | 2012-2020 | Secondary | None |
| Government of South Korea | South Korea | None stated | Linux migration "looked at" | Announced | May 2019 | Secondary | Outcome unknown |
| DRDO / MoD (Maya OS) | India | Not published | Ubuntu-based Maya | Rollout planned after Aug 2023; later status unverified | 2021-2023 | Secondary | Competitor and benchmark ([Maya OS](https://en.wikipedia.org/wiki/Maya_OS)) |
| C-DAC (BOSS) | India | Not published | Debian family; 19 languages | Maintained; v10 Mar 2024 | 2007-2024 | Secondary | Competitor; targeted by APT36 in Oct 2025 ([BOSS](https://en.wikipedia.org/wiki/BOSS_GNU/Linux)) |
| Kerala IT@School / KITE | India | **Over 200,000** computers | Ubuntu-based in-house (18.04, 20.04) | Deployed, ongoing | 2001-2020 | Secondary | State builds its own; role would be support or cloud ([IT@School](https://en.wikipedia.org/wiki/IT@School_Project)) |
| Tamil Nadu ELCOT | India | Over 2,000 tested | SUSE and Ubuntu | Decision 2008; outcome unverified | 2008 | Secondary | Historic |
| NIC email to Zoho | India | About 1.2M accounts (Oct 2025), about 1.67M (Apr 2026) | Zoho Mail/Workplace, not an OS | Largely complete after Sep 2023 tender | 2023-2026 | Secondary | Closest analogue to Nubo's model: domestic vendor, India-resident data ([Zoho](https://en.wikipedia.org/wiki/Zoho_Corporation)) |
| Government e-Marketplace (GeM) | India | Reported INR 20 lakh crore cumulative; 25.45 lakh sellers | Procurement portal | Active | Aug 2026 | Secondary | Sellers must show country of origin ([GeM](https://en.wikipedia.org/wiki/Government_e_Marketplace)) |
| TUBITAK Pardus (ETAP) | Turkey | Not stated; "3.0+ million downloads" | Pardus 25.2, state-backed | Deployed in Health Ministry, Diyanet, AFAD and others | 2003-2026 | Secondary plus vendor site | Domestic distro is policy; competitor reference ([Pardus](https://www.pardus.org.tr/en/)) |
| Canaima | Venezuela | About 6M school laptops by 2017 | Debian-based | Default public-administration OS since Mar 2011; v8.0 Oct 2024 | 2007-2024 | Secondary | Closed, state-run ([Canaima](https://en.wikipedia.org/wiki/Canaima_(operating_system))) |
| Nova | Cuba | 8,000+ PCs announced 2011 | Nova Linux | Stalled; Windows dominant | 2009-2026 | Secondary | Cautionary tale ([Nova](https://en.wikipedia.org/wiki/Nova_(operating_system))) |
| Plan Ceibal | Uruguay | 1M devices by 2013 | Sugar/Linux, then Android and Windows 10 | **Moved off Linux** | 2007-2013+ | Secondary | Education deals follow hardware and compatibility ([Plan Ceibal](https://en.wikipedia.org/wiki/Plan_Ceibal)) |
| Misiones province (GobMis) | Argentina | Not stated | Devuan-based | Announced Jan 2021; status unverified | 2021 | Secondary | Small, regional |
| OLPC | Global (Africa, Uruguay) | About 3M laptops by 2015, about 35% Uruguay | Sugar/Linux | Historic | 2007-2015 | Secondary | Africa a small share ([OLPC](https://en.wikipedia.org/wiki/One_Laptop_per_Child)) |
| Quebec | Canada | 800 workstations, CAD 720k | Windows Vista | 2010 court ruling | 2010 | Secondary | Procurement law can force evaluation of alternatives |

Three patterns stand out. First, **the buyers who commit at scale build or fund the distribution themselves** (Gendarmerie, DINUM, Kerala, DRDO, TUBITAK). Second, **education programmes drift back to Windows or Android** when hardware and application compatibility matter (Ceibal, Cuba, Munich). Third, **the sovereignty money in 2025-26 goes to collaboration suites** (openDesk, La Suite numérique, Nextcloud, Zoho), which are exactly the layer Nubo sells.

## Windows 10 end of support and Ubuntu Pro pricing set the commercial benchmarks

Windows 10 standard support ended on **14 October 2025**. Paid extended support runs to **12 October 2027 for consumers** and **10 October 2028 for businesses and schools**. Windows 10 still held about **28% global share in September 2026** ([Windows 10](https://en.wikipedia.org/wiki/Windows_10)). That window is the one concrete, dated demand trigger in the notes, particularly for hardware that cannot run Windows 11.

Canonical's published list prices: Ubuntu Pro at **$25 per machine per year** for desktops, a free Personal tier for up to 5 machines, and a free Community tier up to 50 machines. 24/7 workstation support costs **$300 per machine per year**, with weekday support at half that ([Canonical pricing](https://ubuntu.com/pricing/pro)). The currency was shown as "$" and not confirmed as USD. Zorin sells a one-time Pro licence (the amount did not render, so it is unverified) and reported **1 million downloads in five weeks** after Windows 10 end of support and **2 million for Zorin 18 in under three months** ([Zorin OS](https://en.wikipedia.org/wiki/Zorin_OS)). Downloads are not seats or revenue.

What this implies for monetisation: others charge for support and security patching (Canonical), or sell a cheap one-time upgrade off a large free-download funnel (Zorin), or are funded by the state (everyone in the table). Nobody in the notes monetises through a paid cloud account bundled with a free desktop, except Zoho and the state suites, which sell the cloud layer rather than the OS. Nubo should not resell support it cannot back; Ubuntu Pro underneath is the likelier patch-SLA route. Pricing for SUSE, Red Hat, Kali and elementary was not retrieved.

## How Nubo could enter (hypotheses, not findings)

None of the following was tested against primary sources.

1. **Integrators and partners over direct bids.** Central governments build in-house or fund state vehicles (DINUM, ZenDiS, C-DAC, TUBITAK). Integrators fill the gaps: B1 Systems was engaged for an openDesk enterprise edition in August 2024, and Positivo has sold to Brazilian public bodies since 1990 ([Positivo](https://en.wikipedia.org/wiki/Positivo_Tecnologia)). Partner routes look likelier than prime-contractor bids.
2. **Cloud overlap is a competitive problem.** Nubo's mail, calendar and files overlap with state-backed suites (openDesk, La Suite numérique, Nextcloud, Zoho). In Europe this is competition, not partnership, and the "non-American" framing is likely to extend to "European-controlled", which an Indian parent may not satisfy.
3. **India is the best fit for the story, but the OS lane is occupied.** Zoho won the NIC email tender on India-resident data in September 2023. Maya and BOSS hold the government OS lane. Nubo's plausible Indian wedge is cloud accounts, localisation and support for education and SMEs, possibly through C-DAC, NIELIT or a state education body. Eligibility items (GeM onboarding, local-content class, STQC or CERT-In audit, MeitY empanelment) are unverified.
4. **Gulf demand looks like sovereign hosting, not desktop replacement.** The Gulf notes are background knowledge only (NCA controls, Etimad, local-content scoring, in-Kingdom hosting). If true, it binds Nubo's cloud, not its OS, and needs a local entity and regional data-centre partner.
5. **Data residency and certification gate everything institutional.** Likely gates, all unverified: EU-resident hosting, SecNumCloud-type certification, FedRAMP and FIPS for the US, IRAP and Essential Eight mapping for Australia, FSTEC-style certification (Russia). A published hardening guide, SBOM and patch cadence are cheap first steps.
6. **Closed markets: Russia, China, Turkey, Venezuela, North Korea.** Domestic distributions are policy there. They are references, not targets.
7. **Consumer-first remains the evidenced route.** The only dated, sourced demand spike reaching individuals is Windows 10 end of support. Education and refurbished-PC channels (Africa, Pacific, Latin America) are plausible but unsourced here, and the Ceibal and Cuba cases warn that dual-boot and Windows expectations are the obstacle.

## Rerun plan once CLAUDE_CODE_MAX_WEB_SEARCHES_PER_SESSION is raised

Prioritised, taken from the Gaps sections of the notes.

1. **France primary sources.** The numerique.gouv.fr press release of 8 April 2026, TechCrunch (10 April), The Register (13 April), Frandroid, The Stack, Le Monde and Reuters. Determine whether "2.5 million" is official and what the ministry plans cover. Also the Sécurix and cloud-gouv GitHub repositories, and TED/BOAMP/UGAP notices.
2. **Schleswig-Holstein.** Seat counts and phases (heise, Golem), plus Bundeswehr/BWI and the Deutsche Rentenversicherung and Bundesagentur trials.
3. **Denmark.** The Ministry of Digitalisation announcement, scope, dates, and Copenhagen and Aarhus.
4. **India.** MeitY, GeM rules for software, Make in India (PPP-MII) local-content thresholds, cloud empanelment, STQC and CERT-In audit rules, the 2015 open-source policy, Maya OS status after 2023, BOSS deployment numbers, state laptop schemes, and Windows 10 end-of-support response.
5. **China's August 2026 order.** Xinhua, Global Times, Caixin and 36Kr on the Ministry of State Security instruction and Xinchuang lists. Also Korea (Gooroom, HamoniKR, Windows 10 end of support).
6. **Gulf procurement portals.** Etimad (Saudi), NCA/CST cloud rules, the UAE, Qatar, Oman, Bahrain and Kuwait; whether registration applies to a mail and file service.
7. **Brazil.** SERPRO, Dataprev, ProInfo, COMPRAS.gov.br, Positivo and other OEM Linux preloads.
8. **US federal.** SAM.gov, FedRAMP, DISA STIG, FIPS, and K-12 and ChromeOS alternatives.
9. **Kenya and Rwanda education programmes.** ICT Authority DLP and its OS, Rwanda Smart Classroom with Positivo and Mara, South Africa SITA, Nigeria NITDA, Computer Aid, and World Bank and AfDB project rules.
10. **OEM Linux preload programmes.** Dell, Lenovo, HP, System76, Tuxedo, Slimbook and Canonical certified hardware; plus pricing for SUSE, Red Hat, Kali and Zorin Pro.
11. **Everywhere marked "none found".** Austria, Spain, Switzerland, Nordics, Netherlands, Italy, Poland, Baltic states, Ukraine, Pakistan, Bangladesh, Sri Lanka, Central Asia, Japan, Taiwan, Vietnam, Indonesia, Malaysia, Canada federal, Mexico, Australia and New Zealand. These were not searched, so treat them as open.

## Conclusion

The headline "France moves millions of PCs to Linux" turns out to describe a pilot of about 250 seats, a deadline for ministry plans, and a government-built NixOS stack. That is demand for sovereignty, not yet demand for anyone's distribution. The research could not confirm any case where a state buys a foreign-run Ubuntu derivative; every large sourced deployment was built or controlled domestically.

The strategic implication, which remains a hypothesis, is that Nubo should compete on the layer states are actually funding (cloud accounts and collaboration, India-resident or regionally hosted) and use partners for institutional access, rather than chase desktop mandates. The rerun in the order above, starting with the French primary documents and the Indian procurement rules, would settle whether that hypothesis holds.
