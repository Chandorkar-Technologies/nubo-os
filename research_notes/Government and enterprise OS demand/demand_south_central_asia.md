# Government and enterprise desktop OS demand: South Asia and Central Asia (as of October 2026)

RESEARCH LIMITATION: the WebSearch budget for this session was exhausted (200/200) before any search ran. Only WebFetch on Wikipedia and one failed meity.gov.in fetch (403) were possible. Almost all sources below are Wikipedia (secondary, source quality low-to-medium). No primary tender, GeM, PIB or MeitY documents were retrieved. Nothing below is invented; anything not sourced is listed under Gaps as "not verified, lead only". The report writer should treat this note as a thin, partial inventory and recommend a follow-up pass with working search.

## 1. How large and real is government and enterprise demand for a locally supported Linux desktop in India and the region, and what are the entry paths for Nubo?

### Takeaway
Verified evidence shows India has real but narrow Linux demand: defence (Maya OS), C-DAC's BOSS, and a long-running Kerala school deployment of about 200,000 computers. The largest recent Indian government software switch found (NIC email to Zoho, about 1.2 to 1.67 million accounts) went to a domestic cloud suite with India-resident data, a pattern close to Nubo's cloud-account model. No seat counts, tenders or programmes were verified for any other country in the region ("none found" in this session, not "none exist").

### Cited Findings

#### Inventory table (one row per country; "none found" = not found in this session's limited research)

| Country | Organisation / programme | Seats (status of number) | Timeline | OS | Status | Budget | Procurement route | Source / quality |
|---|---|---|---|---|---|---|---|---|
| India | DRDO / Ministry of Defence, Maya OS (with C-DAC, NIC) | No figure published; not verified | Development from 2021; rollout "commencing after 15 Aug 2023"; installed in MoD systems as of Aug 2023; Army, Navy, Air Force adoption planned by end of 2023 (whether it happened: not verified) | Maya OS, Ubuntu-based, Windows-like UI, "Chakravyuh" EDR | Announced / in progress (current status not verified) | Not public | Internal govt development, not an open tender | [Wikipedia: Maya OS](https://en.wikipedia.org/wiki/Maya_OS), secondary |
| India | C-DAC / NRCFOSS, BOSS GNU/Linux | No figure; not verified | First release 10 Jan 2007; v10.0 "Pragya" 15 Mar 2024; moved GNOME to Cinnamon in v8.0 (Oct 2019) | BOSS (Debian family; derivation not stated in fetched text) | Maintained, "endorsed by Government of India for adoption"; actual deployment size not verified | Not public | Not verified | [Wikipedia: BOSS GNU/Linux](https://en.wikipedia.org/wiki/BOSS_GNU/Linux), secondary |
| India | Kerala, IT@School / KITE (education) | Over 200,000 computers on IT@School GNU/Linux 18.04 across SCERT-run schools; 1.6 million students examined on KITE software | Project 2001; IT compulsory 2003; free-software transition "completed" 2006; became KITE in 2017 | IT@School GNU/Linux 18.04, KITE GNU/Linux lite 2020, KITE GNU/Linux 20.04 (all Ubuntu-based) | Deployed, ongoing; no reversal documented in the source | Not stated | State education department, in-house distro | [Wikipedia: IT@School Project](https://en.wikipedia.org/wiki/IT@School_Project), secondary |
| India | Tamil Nadu, ELCOT (state purchaser of student computers) | "over 2,000" SUSE/Ubuntu desktops and laptops tested over two years | Decision June 2008 to switch entirely to Linux | SUSE Linux and Ubuntu | Announced 2008; later outcome not verified (note: later TN free-laptop schemes reportedly shipped dual-boot or Windows, not verified) | Not stated | State PSU procurement | [Wikipedia: Linux adoption](https://en.wikipedia.org/wiki/Linux_adoption), secondary |
| India | NIC / Government of India central email and productivity (adjacent: cloud suite, not desktop OS) | About 1.2 million central-govt accounts on Zoho by Oct 2025; about 1.67 million migrated by Apr 2026 | Zoho won a competitive tender in Sep 2023 | Zoho Mail and Zoho Workplace (replaced NIC-based email) | Completed (largely) | Not stated | Competitive tender (portal not stated) | [Wikipedia: Zoho Corporation](https://en.wikipedia.org/wiki/Zoho_Corporation), secondary |
| India | Linux desktop share, market-level | 16.21% desktop share in India, July 2024 (likely StatCounter; includes ChromeOS/other classifications possibly; treat with caution) | Jul 2024 | Linux (all) | Statistic | n/a | n/a | [Wikipedia: Linux adoption](https://en.wikipedia.org/wiki/Linux_adoption), secondary; methodology not verified |
| Pakistan | none found | not verified | | | | | | no source retrieved |
| Bangladesh | none found | | | | | | | |
| Sri Lanka | none found | | | | | | | |
| Nepal | none found | | | | | | | |
| Bhutan | none found | | | | | | | |
| Maldives | none found | | | | | | | |
| Afghanistan | none found | | | | | | | |
| Kazakhstan | none found; Astra Linux Wikipedia page has no Central Asia mention | | | | | | | [Wikipedia: Astra Linux](https://en.wikipedia.org/wiki/Astra_Linux), secondary |
| Uzbekistan | none found | | | | | | | |
| Kyrgyzstan | none found | | | | | | | |
| Tajikistan | none found | | | | | | | |
| Turkmenistan | none found | | | | | | | |

#### Other verified facts
- Windows 10 standard support ended 14 Oct 2025; paid ESU runs to 12 Oct 2027 for consumers and 10 Oct 2028 for businesses and schools; Windows 10 still held about 28% global share in Sep 2026 (about 1 billion PCs estimated Dec 2025) — [Wikipedia: Windows 10](https://en.wikipedia.org/wiki/Windows_10), secondary. This sets the window in which hardware not eligible for Windows 11 (no TPM 2.0) is a Linux opportunity; no India-specific data found.
- GeM launched 9 Aug 2016; by Aug 2026 reported over INR 20 lakh crore cumulative procurement, 25.45 lakh registered sellers, 1.64 lakh buyer organisations; sellers must display country of origin; MSMEs about 45.6% of cumulative GMV — [Wikipedia: Government e Marketplace](https://en.wikipedia.org/wiki/Government_e_Marketplace), secondary (figures are from the page as fetched; not cross-checked on gem.gov.in).
- Make in India procurement preference exists since a 15 Jun 2017 revision of the Public Procurement Order and GFR; class-wise local-content thresholds could not be verified here — [Wikipedia: Make in India](https://en.wikipedia.org/wiki/Make_in_India), secondary.
- NIC runs MeghRaj cloud (IaaS/PaaS/SaaS, Kubernetes) with data centres in New Delhi, Hyderabad, Pune, Bhubaneswar; annual budget about INR 11.5 billion — [Wikipedia: NIC](https://en.wikipedia.org/wiki/National_Informatics_Centre), secondary (page flagged as promotional). No NIC desktop-OS programme was documented there.
- BOSS reportedly supports 19 languages including Indian regional languages; Oct 2025 APT36 targeted BOSS systems and vulnerabilities were patched — [Wikipedia: BOSS GNU/Linux](https://en.wikipedia.org/wiki/BOSS_GNU/Linux), secondary. Implication: BOSS is used enough in government to be a hostile-actor target.

### Inferences
- Indian government uses sovereignty and "data stays in India" as the stated rationale (Zoho, Maya). A Nubo pitch built on an Indian company, India-resident cloud and Ubuntu base fits this framing; the Zoho case shows a domestic private vendor can win a large tender (Sep 2023, central govt).
- Government desktop OS demand is served by state-backed distros (Maya, BOSS, Kerala's in-house distro), so a private entrant likely competes against or partners with them rather than being the default; the entry point is more plausibly cloud/mail/collab and refurb/education than a direct OS mandate.
- Kerala shows state education departments build their own Ubuntu spin; the realistic Nubo role there is support, localisation or cloud, not replacement.
- Windows 10 ESU end dates (Oct 2027 consumer, Oct 2028 business/schools) give a concrete sales window for older-hardware refurbishment and SMB offers.

### Gaps
- Not verified (no source retrieved; do not use as fact without checking): Policy on Adoption of Open Source Software for Government of India (2015) and its clauses; Meity's fetch returned 403.
- Not verified: GeM rules for OS/software listing, MeitY empanelment of cloud providers, STQC / CERT-In empanelled-auditor audit requirements, class-I/II local supplier thresholds under PPP-MII (50% / 20%), MeitY software-specific local-content notification.
- Not verified: whether Maya OS reached Army/Navy/Air Force, seat counts, any 2025-2026 update; BOSS deployment numbers; NIELIT usage.
- Not verified: Karnataka, Maharashtra, Andhra Pradesh, Tamil Nadu current laptop schemes and their OS; Indian Railways, banks, PSU Linux use; Windows 10 EoS response by Indian government; refurbished-PC programmes; telco/OEM Linux preload (e.g. Dell/HP/Lenovo Ubuntu or Linux-ready SKUs in India); large private/startup deployments.
- Not verified: all non-India countries (Pakistan, Bangladesh, Sri Lanka, Nepal, Bhutan, Maldives, Afghanistan, Kazakhstan, Uzbekistan, Kyrgyzstan, Tajikistan, Turkmenistan). Searches could not run. Leads to check next: Kazakhstan's Ministry of Digital Development "domestic software" and trusted-software lists; Uzbekistan's domestic software registry and IT Park preferences; Russian Astra/ALT/RED OS presence in Central Asia; Pakistan Punjab/Sindh IT department and NITB open-source stance; Sri Lanka ICTA and Nepal/Bhutan school-computer schemes (OLPC-type); Bangladesh BCC. These are leads only.

## 2. Which requirements would Nubo need to meet to be bid-eligible?

### Takeaway
From verified material alone: GeM registration with country-of-origin declaration is the baseline; everything else (local-content class, STQC/CERT-In audit, MeitY empanelment, language support, data residency) is unverified in this session and must be confirmed from primary documents.

### Cited Findings
- GeM requires sellers to display country of origin on listed products; seller registration is open to individuals, MSEs and organisations — [Wikipedia: Government e Marketplace](https://en.wikipedia.org/wiki/Government_e_Marketplace), secondary.
- Make in India preference in public procurement dates to a 15 Jun 2017 order/GFR revision — [Wikipedia: Make in India](https://en.wikipedia.org/wiki/Make_in_India), secondary.
- The Zoho NIC email win was described by officials as meeting data-sovereignty needs: main and backup data centres in India, government data not replicated outside the country — [Wikipedia: Zoho Corporation](https://en.wikipedia.org/wiki/Zoho_Corporation), secondary. This indicates data-residency in India is a de facto requirement for government cloud/mail.
- BOSS supports 19 languages including Indian regional languages — [Wikipedia: BOSS GNU/Linux](https://en.wikipedia.org/wiki/BOSS_GNU/Linux), secondary; useful as a benchmark for language-support expectations (the formal rule is not verified).

### Inferences
- Likely checklist for Nubo (to be confirmed from primary sources): Indian-registered entity and GeM seller/OEM onboarding; local-content declaration for Make in India class; India-resident hosting for the paid cloud accounts; third-party security audit (STQC or CERT-In empanelled auditor) for the cloud/mail service; Indian-language support (Hindi plus others) in the OS and mail UI; open-source licence compliance records for the Ubuntu/GNOME base and a clean SBOM.
- Competing against BOSS and Maya, plus Zoho for mail, suggests partnering with a system integrator or C-DAC/NIELIT channel is the lower-risk entry.

### Gaps
- No primary document (GeM T&Cs, DPIIT PPP-MII order, MeitY open-source policy, MeitY cloud empanelment guidelines, CERT-In audit guidelines, STQC certification scheme) was retrieved. All eligibility details above beyond GeM country-of-origin and the Zoho data-residency note are unverified.
- Lessons from failures (e.g. Munich-style reversals, India-specific cancelled migrations) were not researched; the only reversal-related datum is that the Kerala source shows none.
