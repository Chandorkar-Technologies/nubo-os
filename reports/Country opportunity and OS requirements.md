# Where Nubo OS can win: country opportunities and OS requirements

**Nubo OS should launch first in India and in a small set of privacy- and sovereignty-minded, Linux-friendly, high-income markets (Germany, Netherlands, France, Switzerland, Norway, Denmark, Spain), with English-language add-ons in Singapore, Australia and New Zealand, and then widen to Brazil, Mexico, Turkey, the Gulf, Taiwan, Thailand, Indonesia, South Africa, Nigeria and Kenya.** The ranking is a synthesis of seven regional research notes, not a measured market model: nothing in the notes gives paid-email willingness-to-pay by country, so "opportunity" combines connectivity, StatCounter desktop-Linux share (a noisy web-traffic proxy), income and payment rails, language fit, and legal friction. Desktop is Windows-dominated everywhere (typically 65-90%), so the realistic entry is older PCs and Windows 10 leftovers, students, developers and sovereignty-minded users, not retail replacement. The strongest legal themes are new OS-level age-signal laws (California AB 1043 from 1 Jan 2027; Brazil's Digital ECA in force since 17 Mar 2026), cross-border transfer rules that make India-hosted accounts need safeguards in most regimes (India has no EU adequacy decision, background knowledge), sanctions on Russia, Belarus, Iran, Cuba and North Korea, and payment or foreign-exchange limits across much of Africa, South Asia and Latin America. The notes ran out of web-search budget (200 calls) part-way; a large share of legal and payment cells are background knowledge and are flagged as such. Counsel is needed on EU Cyber Resilience Act (CRA) manufacturer status, whether a free open-source distribution is an "operating system provider" under AB 1043 and Brazil's ECA, sanctions reach over an Indian company, and Russia/Belarus.

## Contents

1. [Executive summary](#executive-summary)
2. [Europe](#europe)
3. [Asia](#asia): [South and Central Asia](#south-and-central-asia) | [East and Southeast Asia](#east-and-southeast-asia) | [West Asia, Middle East and Caucasus](#west-asia-middle-east-and-caucasus)
4. [Africa](#africa)
5. [North and Central America and the Caribbean](#north-and-central-america-and-the-caribbean)
6. [South America](#south-america)
7. [Oceania](#oceania)
8. [OS requirements checklist by market](#os-requirements-checklist-by-market)
9. [Data quality, caveats and follow-up searches](#data-quality-caveats-and-follow-up-searches)

Legend used in all tables. **Linux %** is StatCounter desktop share, September 2026 unless stated; "nf" means not fetched, "n/v" not verified. **noisy** marks figures the notes flag as small-sample, bot-affected or implausible. **[bg]/BK** marks background knowledge with no source retrieved this session; treat it as a lead, not a fact. Population/internet figures are DataReportal Digital 2026 (data as of Oct 2025) unless stated; Europe and Africa use rounded ITU-based figures from a secondary compilation. Ratings are the researchers' judgement. This report builds on, and does not repeat, the earlier "Modern OS requirements 2026" report (CRA, security) and "Government and enterprise OS demand" report.

---

## Executive summary

### Ranked global shortlist

The shortlist is my synthesis of the regional notes. Wave 1 is where launch effort should go first; wave 2 follows once localisation, hosting regions and billing exist; wave 3 is long-tail or conditional.

| Wave | Market | Why (from the notes) | Main watch-item |
|---|---|---|---|
| 1 | **India** (home) | 1.03 bn internet users (70.0%); PC market +12.1% YoY in Q2 2026 (IDC); rising new-PC prices push buyers to refurbished machines; Indic-language fit; INR billing natural for an Indian company ([DataReportal](https://datareportal.com/reports/digital-2026-six-billion-internet-users), [NCN/IDC](https://www.ncnonline.net/indias-pc-market-grows-12-1-yoy-in-q2-2026-as-channel-stocking-and-enterprise-demand-sustain-momentum-idc/)) | StatCounter Linux 10.45% is noisy; DPDP Rules phased to ~May 2027; UPI/RBI recurring-payment rules not researched |
| 1 | **Germany** | Largest paying European market; Linux 6.49%; Schleswig-Holstein ~80% migrated to LibreOffice/Linux by Dec 2025; SEPA direct debit | Full German localisation; EU hosting; GDPR transfer rules |
| 1 | **Netherlands** | Highest Linux share among fetched European countries (7.64%); iDEAL | Same EU baseline |
| 1 | **France** | Large market (68M); strongest sovereignty signal (DINUM, see note below); Linux 4.46% | French UI/docs (Toubon law, bg); sovereignty buyers may question an Indian vendor |
| 1 | **Switzerland, Norway, Denmark** | High ARPU, privacy brand; Linux 3.72% / 5.35% / n/f; Danish ministry moved to Linux/LibreOffice (2025) | Swiss FADP; EEA incorporation of CRA unverified |
| 1 | **Spain** | 49M people, Linux 5.72%, Bizum | Catalan/Basque/Galician coverage |
| 1 (English add-on) | **Singapore, Australia, New Zealand** | Cards work, English, high connectivity (98%/97%/96%), Linux 5.71%/2.8%/3.29% | Australia Children's Online Privacy Code due 10 Dec 2026; GST on digital services (bg) |
| 2 | **Brazil** | 185M online, Linux 4.15%, Pix | Digital ECA age rules, LGPD SCCs, tax friction |
| 2 | **Mexico** | 110M online, Linux 3.21%, Spanish only | New LFPDPPP (Mar 2025), regulations pending |
| 2 | **UK, Austria, Sweden, Finland, Italy, Belgium, Poland** | Large or rich; EU/UK baseline reuse | UK PSTI/Online Safety (bg); Poland 88.98% Windows, price-sensitive |
| 2 | **Turkey, UAE, Saudi Arabia, Israel** | Turkey 77.5M users, Linux 5.9%; UAE Linux 5.55%; Saudi 34.4M users; Israel Linux 13.4% (dev-heavy) | Arabic RTL/Hijri; VoIP/VPN limits; KVKK transfer regime |
| 2 | **Taiwan, Thailand, Indonesia, Malaysia, Japan, Hong Kong** | Thailand Linux 10.67%; Indonesia 230M online; Taiwan 22M online, Linux 4.16% | CJK/Thai input quality; Indonesia GR 33/2026 transfers from Jan 2027 |
| 2 | **South Africa, Nigeria, Kenya, Egypt, Morocco, Ghana** | SA POPIA clear + cards; Nigeria 109M users, Linux 8.9%; Kenya M-Pesa | FX/payments; Kenya Sept 2026 transfer guidance; Egypt licensing |
| 2 | **Canada, United States** | Highest willingness to pay (background), but Linux 2.41% / 3.69% and the heaviest compliance (AB 1043, state laws) | Age-signal APIs; Quebec Law 25 + French |
| 3 | Argentina, Chile, Colombia, Peru, Uruguay; Kazakhstan, Uzbekistan, Bangladesh, Pakistan, Nepal; Georgia, Jordan, Cyprus; Rwanda, Mauritius, Senegal; South Korea, Philippines, Vietnam; Central/Eastern Europe | Mid-sized or conditional; evidence thin on payments and legal | Local hosting (Kazakhstan), India-origin sensitivity (Pakistan), localisation (Vietnam), FX (Bangladesh, Nepal) |
| 3 (free download only) | Pacific islands, small Caribbean states, micro-states, most of Sub-Saharan Africa | Tiny or unbanked | Not revenue markets |

**Correction on France.** The claim that France is moving 2.5 million government PCs to Linux is **not verified**. The verified position (from the commissioning brief, not from a source URL in the notes) is that DINUM announced on 8 April 2026 it is moving its own workstations (about 250 deployed by 18 April 2026) and ordered ministries to submit plans by autumn 2026. The 2.5 million figure appears only in a Wikipedia summary and an aggregator ([Tuta](https://tuta.com/blog/countries-ditching-microsoft-choosing-linux-digital-sovereignty)) without a primary source. Where country tables below mention it, it is marked unverified. Other sovereignty signals are better sourced: Schleswig-Holstein (~30,000 workstations, ~80% migrated by Dec 2025, EUR 15M/yr licence savings vs EUR 9M one-off in 2026) ([LinuxSecurity](https://linuxsecurity.com/news/government/schleswig-holsteins-bold-move-to-open-source)) and the Danish Ministry of Digital Affairs ([The Record](https://therecord.media/denmark-digital-agency-microsoft-digital-independence)). These are public-sector desktops, not consumer sales; the consumer benefit is brand legitimacy.

### Blocked or high-risk countries

| Country / area | Reason (source quality) |
|---|---|
| Russia | EU 19th (Oct 2025) and 20th (23 Apr 2026) sanctions packages widen software, AI/HPC and cybersecurity service bans; Visa/Mastercard unavailable (bg); 242-FZ localisation (bg). Paid accounts blocked; a free ISO needs legal review ([Consilium 19th](https://www.consilium.europa.eu/en/press/press-releases/2025/10/23/19th-package-of-sanctions-against-russia-eu-targets-russian-energy-third-country-banks-and-crypto-providers/), [Consilium 20th](https://www.consilium.europa.eu/en/press/press-releases/2026/04/23/russia-s-war-of-aggression-against-ukraine-20th-round-of-stern-eu-sanctions-hits-energy-military-industrial-complex-trade-and-financial-services-including-crypto/)) |
| Belarus | Parallel sanctions; payment rails cut (bg); US June 2024 rule excludes free web apps and retail software but not paid services ([Arnold & Porter](https://www.arnoldporter.com/en/perspectives/advisories/2024/06/russias-access-to-it-services-and-software-restricted)) |
| Crimea, Donetsk, Luhansk and occupied Ukrainian regions | Comprehensive regimes (OFAC Ukraine/Russia-related program; bg for EU/UK). Geo-block |
| Iran | US sanctions; GL D-2 folded into 31 CFR 560.540 (May 2024) permits internet communication software but paid accounts, government users and payment rails remain barred ([Baker McKenzie](https://sanctionsnews.bakermckenzie.com/ofac-issues-updated-iran-general-license-related-to-certain-services-software-and-hardware-for-communications-over-the-internet-and-new-related-faqs/)); no international cards (bg) |
| Cuba | US embargo; internet/mail carve-outs exist but payments impossible ([sanctionslawyers.net](https://sanctionslawyers.net/economic-sanctions-programs/cuba/)) |
| North Korea | UN/US/EU sanctions (bg for detail); OFAC program active ([OFAC](https://ofac.treasury.gov/sanctions-programs-and-country-information)) |
| China | Not blocked for a download, but a cloud account needs MIIT licence, ICP filing, localisation (bg) and the state is mandating domestic Linux (Kylin/UOS) for state entities (news reports) ([Soyacincau](https://soyacincau.com/2026/08/24/china-orders-state-agencies-to-ditch-windows/)). Effectively blocked for paid |
| Afghanistan, Turkmenistan | Afghanistan: nationwide shutdown Sept/Oct 2025 froze banking ([The Diplomat](https://thediplomat.com/2025/10/afghanistans-digital-blackout-a-self-inflicted-economic-crisis/)); Turkmenistan: censored "Turkmenet", 122,000+ domains blocked ([Wikipedia](https://en.wikipedia.org/wiki/Internet_censorship_in_Turkmenistan)) |
| Sudan, South Sudan, Libya, Somalia, Eritrea | OFAC programs (not Eritrea), conflict, banking collapse, no workable billing ([sanctionslawyers.net](https://sanctionslawyers.net/blog-en/ofac-sanctioned-countries-list-2026/)); Eritrea is background knowledge |
| Yemen, Syria | Yemen: Houthi-area designations (bg), 17.7% penetration, no billing. Syria: OFAC GL 25 (23 May 2025) and removal of the Syria regulations (25 Aug 2025) but broad export controls remain; no payment rails ([Holland & Knight](https://www.hlc.com/en/publications/ofac-lifts-certain-sanctions-on-syria-broad-export-controls-remain-in-place)) |
| Myanmar | Cybersecurity Law 1/2025: platforms with 100k+ users must register locally; unauthorised VPN criminalised ([Lexology](https://www.lexology.com/library/detail.aspx?g=f9cee2e1-6fff-4f55-a958-a73f4a6a6014)); sanctions on military-linked entities (bg) |
| Venezuela | OFAC GL 61/62 (21 Aug 2026) ease telecom/cloud, but not shown to cover paid consumer subscriptions; weak rails ([Cleary](https://www.clearygottlieb.com/news-and-insights/publication-listing/ofac-issues-general-licenses-authorizing-activity-in-venezuelan-telecommunications-sector)) |
| Higher risk, not blocked | Pakistan (legal flux, India-origin sensitivity, transfers to India singled out ([DLA Piper](https://www.dlapiperdataprotection.com/index.html?t=law&c=PK))); Vietnam (tightening localisation); Tanzania, Ethiopia, Uganda, Cameroon, Togo, Chad, Guinea (shutdowns, 30 shutdowns in 15 African countries in 2025 ([Access Now](https://www.accessnow.org/press-release/resilience-and-resistance-internet-shutdowns-in-africa-in-2025/))) |

### Cross-cutting requirements that recur

1. **OS-level age signals.** California AB 1043 (operative 1 Jan 2027) requires "operating system providers" to ask for birth date/age at account setup and expose a real-time API with four brackets (under 13, 13-16, 16-18, 18+), with penalties up to $2,500 (negligent) / $7,500 (intentional) per affected child ([leginfo](https://leginfo.legislature.ca.gov/faces/billTextClient.xhtml?bill_id=202520260AB1043)). Brazil's Digital ECA (Lei 15.211, in force 17 Mar 2026) reaches any service accessible to children in Brazil, requires more than self-declaration, parental linking under 16 and OS/app-store age signals, with fines up to 10% of Brazil revenue or R$50M ([Legal500](https://www.legal500.com/intelligence/brazil/privacy/the-digital-eca-transforms-the-internet-and-the-software-industry-in-brazil)). Australia's Children's Online Privacy Code is due by 10 Dec 2026 ([OAIC](https://www.oaic.gov.au/news/media-centre/pasing-of-bill-a-significant-step-for-australias-privacy-law)). Whether a free open-source OS is covered by AB 1043 or the ECA is **unchecked**. Inference from the notes: one age-bracket field at account creation serves AB 1043 and is a base for Brazil, but Brazil likely needs stronger verification.
2. **Data residency and cross-border transfer.** No verified market imposes localisation on consumer mail/files in the Americas, Oceania or most of Europe, but transfers to India need safeguards (SCCs, consent, or adequacy) in the EU, Brazil, Turkey, Saudi Arabia, Bahrain, Jordan, Kenya, Nigeria, South Africa, Thailand and others. Hard localisation or licensing pressure appears in China, Vietnam (revised Cybersecurity Law from 1 Jul 2026), Kazakhstan (citizens' data on in-country servers), Russia (bg), Turkey (large social networks), and sector rules (UAE health and financial data, Saudi government content, Kenya "strategic" data). Recommended in the notes: offer a data-location choice (EU, India, GCC, regional Africa) and EU hosting by default for Europe.
3. **Sanctions and export controls.** Geo-block paid sign-up and billing for Russia, Belarus, Crimea/DNR/LNR, Iran, Cuba, North Korea, Sudan, South Sudan, Libya, Somalia, Eritrea, Yemen and (pending counsel) Syria; screen paying customers in DRC, CAR, Mali, Zimbabwe (list-based programs). Encryption: publicly available source is outside the EAR under 15 CFR 742.15, with notification only for "non-standard cryptography"; Indian export rules and EAR reach over US-origin Ubuntu packages are unverified. Canonical trademarks must be removed from a modified derivative ([Canonical IP policy](https://canonical.com/legal/intellectual-property-policy)).
4. **Scripts, input methods, calendars and fonts.** Arabic/Persian/Urdu/Hebrew/Thaana RTL; Hijri (Umm al-Qura in Saudi, bg) and Jalali; Indic scripts incl. Bengali, Sinhala, Tibetan (Dzongkha), Ge'ez; CJK with IBus/Fcitx5; Thai, Khmer, Lao, Burmese (Zawgyi/Unicode issue, bg); Cyrillic variants incl. Kazakh letters; Greek, Armenian, Georgian. Most of this is background knowledge applied to a real engineering list.
5. **Gulf and regional VoIP/VPN limits.** In the UAE only licensees may provide VoIP (TDRA-approved apps list) and a VPN sold to bypass ISP filtering is not permitted ([Hadef & Partners](https://hadefpartners.com/news-insights/insights/vpn-and-voip/)); Saudi, Qatar, Oman, Kuwait, Bahrain, Turkey rules are unverified or background. Market mail/calendar/contacts/files only; do not promote calling, a one-click VPN or circumvention.
6. **Payment and currency limits.** Stripe merchant support is limited (India "Preview" at fetch time; Australia and NZ supported; no Pacific islands) ([Stripe](https://stripe.com/global)); Razorpay supports international payments from India including subscriptions ([Razorpay](https://razorpay.com/docs/payments/international-payments/)). Local rails matter: Pix (Brazil), iDEAL, SEPA direct debit, BLIK, Bizum, M-Pesa, MTN MoMo, Wave, Fawry, TWINT, Vipps, Swish, UPI (all background unless stated). FX controls hit Egypt, Nigeria, Ethiopia, Algeria, Malawi, Zimbabwe, Angola, Argentina, Venezuela, Bangladesh, Nepal, Pakistan (mostly background).
7. **Internet shutdown and censorship risk.** Africa (30 shutdowns in 15 countries in 2025), Afghanistan, Myanmar, Iraq exam shutdowns (bg), Iran, Turkmenistan, Uganda's Facebook block. Design offline-tolerant mail/calendar clients (IMAP caching, local calendar, delta sync).
8. **EU/UK product and local-representation law.** CRA reporting obligations for manufacturers apply from 11 Sept 2026; remaining obligations from 11 Dec 2027 ([Hunton](https://www.hunton.com/privacy-and-cybersecurity-law-blog/eu-cyber-resilience-act-reporting-obligations-take-effect-for-manufacturers), [Commission](https://digital-strategy.ec.europa.eu/en/policies/cra-reporting)). Representation or local entities are flagged for GDPR Art. 27 (bg), Korea (above thresholds), Turkey (large social networks), Myanmar, China, Vietnam (not verified). Whether a monetised open-source distribution is a "manufacturer" is open ([Kennedys](https://www.kennedyslaw.com/en/thought-leadership/article/2026/eu-cyber-resilience-act-what-the-european-commission-s-2026-guidance-means-for-manufacturers/)).

---

## Europe

The EU/EEA is one regime for GDPR, CRA, the European Accessibility Act (EAA; bg: applied from 28 June 2025 to consumer electronic communications, e-commerce, banking, and consumer computer hardware and their operating systems), and consumer law. European desktop share in September 2026 was Windows 77.28%, OS X 10.93%, macOS 5.57%, Linux 4.61%, ChromeOS 1.6% ([StatCounter Europe](https://gs.statcounter.com/os-market-share/desktop/europe)). Population figures are rounded background estimates; internet % is ITU via Wikipedia. EUR members use SEPA; Bulgaria adopted the euro 1 Jan 2026 (bg, confirm). The EU baseline for all rows marked "EU": GDPR (no localisation; transfers to India need SCCs because India has no adequacy decision, bg), CRA, EAA, ePrivacy, Digital Content Directive for paid accounts (bg), and likely a GDPR Art. 27 EU representative (bg).

### EU member states

| Country | Pop / net % | Linux % (Sept 2026) | Languages / input | Legal beyond EU baseline | Rating |
|---|---|---|---|---|---|
| Austria | 9.2M / 91.9% | nf | German (de-AT) | none | Medium-High: rich, reuses German localisation |
| Belgium | 11.8M / 95.8% | nf | Dutch, French, German; AZERTY BE | none | Medium |
| Bulgaria | 6.4M / 79.7% | nf | Bulgarian Cyrillic (BDS/phonetic) | none | Low-Medium |
| Croatia | 3.8M / 83.6% | nf | Croatian | none | Low-Medium |
| Cyprus | 0.9M / 89.6% | 2.2 (West Asia note) | Greek, Turkish (north) | none | Low (small); see also West Asia |
| Czechia | 10.9M / 87.7% | nf | Czech | none; CZK | Medium |
| Denmark | 5.9M / 99.8% | nf | Danish | none; ministry moved to Linux/LibreOffice 2025 ([The Record](https://therecord.media/denmark-digital-agency-microsoft-digital-independence)); MobilePay | High: sovereignty drive, high ARPU |
| Estonia | 1.4M / 92.2% | nf | Estonian, Russian (Cyrillic) | none | Low-Medium |
| Finland | 5.6M / 94.1% | nf | Finnish, Swedish, Sami | none | Medium-High |
| France | 68M / 88.7% | 4.46 | French (AZERTY); Toubon-law French UI/docs (bg) | none; DINUM own-workstation migration (see correction); 2.5M-PC claim **unverified**; Lyon, Marseille replacing Microsoft (secondary) | High: large, strongest sovereignty signal |
| Germany | 84M / 93.5% | 6.49 | German (QWERTZ); Turkish/Russian minorities | BDSG; Schleswig-Holstein ~80% migrated ([LinuxSecurity](https://linuxsecurity.com/news/government/schleswig-holsteins-bold-move-to-open-source)); SEPA direct debit | High: largest paying market |
| Greece | 10.4M / 86.3% | nf | Greek script | none | Low-Medium |
| Hungary | 9.6M / 93.8% | nf | Hungarian; HUF | none | Low-Medium |
| Ireland | 5.3M / 97.2% | nf | English, Irish | DPC lead authority (bg) | Medium |
| Italy | 59M / 89.2% | 4.24 | Italian | none; no public-sector signal verified | Medium-High |
| Latvia | 1.9M / 92.7% | nf | Latvian, Russian | Russia-sanctions sensitivity | Low |
| Lithuania | 2.9M / 89.2% | nf | Lithuanian, Russian | none | Low |
| Luxembourg | 0.67M / 99.1% | nf | Luxembourgish, French, German | none | Low (small, wealthy) |
| Malta | 0.57M / 93.9% | nf | Maltese, English | none | Low |
| Netherlands | 18M / 97.0% | 7.64 | Dutch, Frisian | "public money, public code" debate (bg); iDEAL | High: highest Linux share fetched |
| Poland | 37M / 89.7% | 3.96 (Windows 88.98) | Polish; BLIK | none | Medium: large but price-sensitive |
| Portugal | 10.6M / 88.5% | nf | pt-PT; MB Way | none | Medium |
| Romania | 19M / 93.2% | nf | Romanian; RON | none | Low-Medium |
| Slovakia | 5.4M / 89.8% | nf | Slovak | none | Low-Medium |
| Slovenia | 2.1M / 90.8% | nf | Slovenian | none | Low |
| Spain | 49M / 95.8% | 5.72 | Spanish, Catalan, Basque, Galician | none; Bizum | High: large, strong Linux share |
| Sweden | 10.5M / 95.8% | nf | Swedish, Sami; Swish, Klarna | none | High-Medium |

### EEA, UK, Switzerland

| Country | Pop / net % | Linux % | Languages | Legal | Rating |
|---|---|---|---|---|---|
| Norway | 5.5M / 99.0% | 5.35 | Bokmal, Nynorsk, Sami | GDPR via EEA; CRA/EAA incorporation unverified; Vipps | High |
| Iceland | 0.39M / 98.2% | nf | Icelandic | EEA as Norway | Low (tiny) |
| Liechtenstein | 0.04M / 98.3% | nf | German; CHF | EEA | Low (tiny) |
| United Kingdom | 69M / 95.5% | 3.55 | English, Welsh, Gaelic | UK GDPR + DPA 2018; EU adequacy status unverified; PSTI covers connectable hardware (software-only OS unlikely, bg); Online Safety Act (bg); no UK CRA | Medium-High |
| Switzerland | 9M / 97.3% | 3.72 | German, French, Italian, Romansh | revised FADP; CRA not directly applicable (bg); TWINT | High: privacy brand, high ARPU |

### Western Balkans, Moldova, Ukraine, Belarus, Russia, microstates

| Country | Pop / net % | Linux % | Languages | Legal | Rating |
|---|---|---|---|---|---|
| Albania | 2.4M / 85.9% | nf | Albanian | GDPR-aligned (bg) | Low |
| Bosnia and Herzegovina | 3.2M / 86.1% | nf | Latin + Cyrillic | GDPR-aligned 2025 (bg, unverified) | Low |
| Kosovo | 1.6M / 89.4% (2018, old) | nf | Albanian, Serbian | GDPR-style law (bg); EUR | Low |
| Montenegro | 0.62M / 88.9% | nf | Latin/Cyrillic | GDPR-aligned (bg) | Low |
| North Macedonia | 1.8M / 93.1% | nf | Macedonian Cyrillic | GDPR-aligned (bg) | Low |
| Serbia | 6.6M / 87.7% | 3.7 (Windows 88.36) | Cyrillic + Latin | 2018 law (bg); sanctions-evasion scrutiny (bg, weak) | Low-Medium |
| Moldova | 2.4M / 77.4% | nf | Romanian, Russian | 2024 law (bg) | Low |
| Ukraine | ~33M (uncertain) / 82.5% | 2.95 | Ukrainian Cyrillic, Russian | law modernising (bg); martial law; occupied areas sanctioned (bg) | Medium-Low |
| Belarus | 9.1M / 95.5% | 3.08 | Belarusian, Russian | Law 99-Z (bg); sanctions | Blocked paid; low for free download |
| Russia | 146M / 95.6% | 4.05 (Windows 90.91) | Russian Cyrillic | 152-FZ/242-FZ (bg); EU/UK/US sanctions; domestic Astra Linux push (bg) | Blocked for paid |
| Andorra, Monaco, San Marino | 0.08M, 0.04M, 0.034M | nf | Catalan/Spanish/French, French, Italian | GDPR-aligned (bg) | Low (tiny) |
| Vatican City | ~800 | nf | Italian, Latin | own rules (bg) | Not a market (serve under Italy) |

### Most promising and most restricted

Germany, the Netherlands and France anchor the region: Germany is the biggest paying base at 6.49% desktop Linux, the Netherlands has the highest share fetched (7.64%) and iDEAL, and France has the largest sovereignty narrative. Switzerland, Norway and Denmark follow on income and privacy branding; Spain on 5.72% Linux at scale. The sovereignty pitch has a positioning risk: an Indian vendor selling to buyers who want "European" hosting, so the notes infer an EU legal entity and EU-region hosting may be needed. Public-sector moves (Schleswig-Holstein, Denmark, DINUM) are desktops and brand tailwind, not consumer revenue. The truly restricted cases are Russia, Belarus and occupied regions; others (UK, Switzerland, Serbia) are friction rather than bans. A free image is not clearly a "service" under EU Russia sanctions, but a paid mail/file account sold to Russian persons is a services transaction with high risk (inference). Not verified: UK PSTI/EAA scope for an OS, Russia/Balkan data laws, GDPR Art. 27 requirement, Digital Content Directive treatment.

---

## Asia

### South and Central Asia

India is the home market and the only High; the rest are Medium at best. Population and users are DataReportal (Oct 2025).

| Country | Pop / users | Linux % (Sept 2026) | Scripts / key OS need | Legal / data / sanctions | Rating |
|---|---|---|---|---|---|
| India | ~1.47bn (derived) / 1.03bn (70.0%) | 10.45 **noisy** (Windows 82.31) | Devanagari, Bengali, Tamil, Telugu, Kannada, Malayalam, Gujarati, Gurmukhi, Odia, Urdu Nastaliq; phonetic/Inscript input | DPDP Rules notified 14 Nov 2025, phased over 18 months; Significant Data Fiduciaries may face India-only data ([PIB](https://www.pib.gov.in/PressReleasePage.aspx?PRID=2190014&reg=3&lang=2)); CERT-In 2022 directions (bg); BOSS (C-DAC) and Maya OS institutional Linux ([Wikipedia](https://en.wikipedia.org/wiki/Bharat_Operating_System_Solutions)) | **High** |
| Pakistan | 256M / 117M (45.6%) | 2.39 | Urdu Nastaliq (RTL), Pashto, Sindhi | No data law (PDPB 2023 unenacted); transfers to India need justification ([DLA Piper](https://www.dlapiperdataprotection.com/index.html?t=law&c=PK)); PECA 2025 | Medium (high risk) |
| Bangladesh | 176M / 82.8M (47.0%) | 4.72 | Bengali (Avro/Bijoy bg) | PDPO 2025 (6 Nov 2025), ~May 2027 compliance; restricted data local; Jan 2026 reported rollback of broad localisation (conflicting, verify) | Medium |
| Sri Lanka | 23.3M / 13.9M (59.7%) | 0.65 **noisy** (Windows 97.9) | Sinhala, Tamil | PDPA 2022, duties awaiting commencement; transfers need instruments | Low |
| Nepal | 29.6M / 16.6M (56.0%) | 2.84 | Nepali Devanagari | Privacy Act 2075; FX bill 2026 pending | Medium/Low |
| Bhutan | 798k / 706k (88.4%) | 6.8 **noisy** | Dzongkha (Tibetan script) | not researched | Low |
| Maldives | 530k / 449k (84.7%) | 5.0 **noisy** | Dhivehi Thaana (RTL) | not researched | Low |
| Afghanistan | 44.1M / 11.3M (25.5%) | 10.54 **noisy** | Dari, Pashto RTL | Sept 2025 shutdown froze banking | **Blocked** |
| Kazakhstan | 20.9M / 19.5M (93.4%) | 5.13 | Kazakh Cyrillic letters (Ә Ғ Қ Ң Ө Ұ Ү Һ І), Russian | citizens' data on in-country servers (2016 amendment); foreign reach unclear ([Lexology](https://www.lexology.com/library/detail.aspx?g=df9f87c9-a87d-4246-a3f5-086421bf6117)) | Medium |
| Uzbekistan | 37.2M / 33.1M (89.0%) | 3.21 | Uzbek Latin (O', G'), Cyrillic, Russian | Senate approved easing 6 Feb 2026: only biometric, genetic, telecom data stay local; in-force status unverified ([Times of Central Asia](https://timesca.com/uzbekistan-eases-data-localization-rules-to-support-global-payment-platforms/)) | Medium |
| Kyrgyzstan | 7.32M / 6.48M (88.5%) | 3.17 | Kyrgyz Cyrillic, Russian | not researched | Low |
| Tajikistan | 10.8M / 6.15M (56.8%) | 4.48 | Tajik Cyrillic | not researched | Low |
| Turkmenistan | 7.65M / 3.53M (46.1%) | 4.87 **noisy** | Turkmen Latin, Russian | state censorship | **Blocked** (practically) |

India deserves the detail. The PC market grew 12.1% YoY to 3.9M units in Q2 2026 (consumer 1.7M, commercial 2.2M), global shipments fell 4.9% as a memory shortage lifts prices, and refurbished laptops are projected to grow at double digits (a soft forecast) ([NCN/IDC](https://www.ncnonline.net/indias-pc-market-grows-12-1-yoy-in-q2-2026-as-channel-stocking-and-enterprise-demand-sustain-momentum-idc/), [BusinessToday](https://www.businesstoday.in/india/story/refurbished-gadgets-go-mainstream-as-rising-prices-push-buyers-away-from-new-devices-542394-2026-07-11)). Windows 10 support ended 14 Oct 2025. The 223M jump in India's user count is largely methodological. Note the thesis that older PCs unable to run Windows 11 are Nubo candidates is inference; the installed base was not found. Not researched: UPI AutoPay/RBI recurring-payment limits, GST on digital services, education programmes (NEP), state Linux migrations.

Narrative. Kazakhstan and Uzbekistan have the highest connectivity but need Russian/local-language work and, in Kazakhstan, an in-country hosting partner before paid cloud accounts. Bangladesh and Nepal are large and young but FX-limited. Pakistan is the biggest risk: legal flux and political sensitivity of an India-based host. A notes-supported recommendation is to launch OS-download only (no cloud account) in Bangladesh, Sri Lanka and Kazakhstan until counsel clears hosting. Hardware type approval (BIS/WPC, PTA/BTRC) is relevant only for future bundles.

### East and Southeast Asia

| Country | Pop / users | Linux % (Sept 2026) | Languages / input | Legal / data | Rating |
|---|---|---|---|---|---|
| China | 1.42bn / 1.30bn (91.6%) | 1.55 **noisy** | Simplified Chinese; Fcitx5 common (bg) | PIPL export via CAC assessment, standard contract or certification (certification measures from 1 Jan 2026) ([Legal500](https://www.legal500.com/intelligence/china/privacy/cross-border-transfer-of-personal-information-china's-new-measure-on-certification)); MIIT/ICP/MLPS (bg); state entities told to move to Kylin/UOS | **Blocked** for paid |
| Hong Kong | 7.40M / 7.16M (96.8%) | 5.41 | Traditional Chinese, Cantonese (Cangjie) | PDPO (bg); no localisation | Medium-High |
| Macau | n/v | 4.59 **noisy** | Traditional Chinese, Portuguese | PDPA 8/2005 (bg) | Low-Medium |
| Taiwan | 23.1M / 22.3M (96.7%) | 4.16 | Traditional Chinese | PDPA (bg); China-risk sensitivity | **High** |
| Japan | 123M / 107M (87.0%) | 7.78 (Aug 2026) **noisy** | Japanese (ibus-mozc) | APPI (bg) | Medium-High |
| South Korea | 51.7M / 50.6M (97.9%) | 2.09 | Hangul | PIPA: domestic agent above KRW 1tn sales or 1M+ Korean data subjects ([Nomardy](https://kj.nomardy.com/korea-pipa-compliance-for-foreign-companies/)); CSAP for public cloud (bg) | Medium |
| North Korea | n/v | n/v | Korean | UN/US/EU sanctions (bg) | **Blocked** |
| Mongolia | 3.53M / 2.93M (83.0%) | 2.17 **noisy** | Mongolian Cyrillic | 2021 law (bg, n/v) | Low |
| Indonesia | 286M / 230M (80.5%) | 4.43 | Bahasa Indonesia | PDP Law 27/2022; GR 33/2026 in force ~16 Jan 2027; transfer mechanisms not operable (no regulator) ([Nusantara DFDL](https://www.nusantaradfdl.com/insights/indonesia-personal-data-protection-law-gr-33-2026/)); GR 71/2019 public-sector localisation | High (scale) / Medium (revenue) |
| Malaysia | 36.1M / 35.4M (98.0%) | 6.1 (ChromeOS 5.08) | Bahasa Melayu, Jawi | PDPA amended 2024 (bg) | Medium-High |
| Singapore | 5.88M / 5.78M (98.4%) | 5.71 | English, Chinese | PDPA (bg), no localisation | **High** |
| Thailand | 71.6M / 67.8M (94.7%) | 10.67 | Thai | PDPA: adequacy/safeguards, no localisation, no registration ([DLA Piper](https://www.dlapiperdataprotection.com/index.html?t=law&c=TH)) | **High** |
| Vietnam | 102M / 85.6M (84.2%) | 2.29 | Vietnamese (unikey/bamboo) | PDPL from 1 Jan 2026; revised Cybersecurity Law from 1 Jul 2026 requires local storage for internet service providers; draft Data Security Law may ban core-data export ([TechTimes](https://www.techtimes.com/articles/320523/20260715/vietnam-bans-core-data-exports-fourth-data-law-security-ministry-controls-transfers.htm)) | Medium |
| Philippines | 117M / 98.0M (83.8%) | 2.38 (ChromeOS 6.79) | English, Filipino | DPA 2012 (bg); GCash/Maya | Medium |
| Myanmar | 54.9M / 39.8M (72.5%) | 7.17 **noisy** | Burmese (Zawgyi vs Unicode, bg) | Cybersecurity Law 2025 platform registration, VPN offence | Low / high risk |
| Cambodia | 17.9M / 12.0M (67.3%) | 3.78 **noisy** | Khmer | no comprehensive law (bg) | Low |
| Laos | 7.90M / 5.03M (63.6%) | nf | Lao | 2017 law (bg) | Low |
| Brunei | 467k / 463k (99.0%) | nf | Malay | PDPO 2025 (bg, n/v) | Low |
| Timor-Leste | 1.42M / 575k (40.4%) | nf | Tetum, Portuguese | none known | Low |

Singapore is the credibility hub (98.4% online, 23% Apple, strong cards). Thailand has the region's highest Linux share (10.67%) and 68M users but Thai input and fonts must be excellent. Taiwan's bar is Traditional Chinese quality. Indonesia is the volume prize but price-sensitive, wallet-driven, and its transfer regime is incomplete until Jan 2027. Japan and Korea are wealthy but entrenched in local ecosystems; Japan's 7.8% is probably noisy. The Philippines and Malaysia show ChromeOS 6.8%/5.1%, hinting at education hardware. Product work: preinstall IBus/Fcitx5 engines per locale (libpinyin/Rime, mozc, hangul, chewing/cangjie, unikey/bamboo, m17n for Thai/Khmer/Lao/Burmese) and Noto CJK/Thai/Khmer/Lao/Myanmar fonts, and test GNOME 50/Wayland candidate windows (inference). Not verified: most PDPA regimes (Japan, Singapore, Malaysia, Philippines, HK, Taiwan), all payment facts, Myanmar and North Korea sanctions detail.

### West Asia, Middle East and Caucasus

Several DLA Piper fetches returned wrong countries (Oman, Iraq), so those legal cells are largely background.

| Country | Pop / users | Linux % (Sept 2026) | Language / OS need | Legal / data / VoIP | Rating |
|---|---|---|---|---|---|
| UAE | 11.4M / 11.3M (99%) | 5.55 | Arabic RTL, English; large expat Indic base (bg) | PDPL 45/2021, executive regulations unconfirmed after Jan 2025; health and financial data stay in UAE; VoIP licensee-only; VPN limits ([DLA Piper](https://www.dlapiperdataprotection.com/index.html?t=law&c=AE), [Hadef](https://hadefpartners.com/news-insights/insights/vpn-and-voip/)) | **High** |
| Saudi Arabia | 34.7M / 34.4M (99%) | 4.0 | Arabic RTL, Hijri/Umm al-Qura (bg) | PDPL in force Sept 2023, SDAIA SCCs; government content stays in Kingdom; CST registration for cloud (search summary) ([DLA Piper](https://www.dlapiperdataprotection.com/index.html?t=law&c=SA)) | **High** |
| Qatar | 3.13M / 3.10M (99%) | 4.49 | Arabic, English | PDPPL; no general localisation | Medium |
| Kuwait | 5.05M / 5.00M (99%) | 2.78 | Arabic, English | CITRA regulation (2024): name foreign transfer countries | Medium |
| Oman | 5.54M / 5.28M (95.3%) | 3.77 | Arabic, English | PDPL RD 6/2022 (bg, n/v) | Medium |
| Bahrain | 1.65M / 1.64M (99%) | 3.03 | Arabic, English | PDPL: transfers only to approved countries (list of 83 incl. US, EU) or authorisation/consent | Medium |
| Turkey | 87.7M / 77.5M (88.3%) | 5.9 | Turkish (dotted/dotless i) | KVKK, 2024 transfer regime (SCCs with 5-day notice); large social networks must localise; VERBIS ([DLA Piper](https://www.dlapiperdataprotection.com/index.html?t=law&c=TR)); Pardus national Linux (bg) | **High** |
| Israel | 9.55M / 8.72M (91.3%) | 13.4 (dev-heavy, possibly overstated) | Hebrew RTL | Amendment 13 effective 14 Aug 2025 | **High**; GCC-facing branding risk (bg) |
| Iraq | 47.3M / 39.6M (83.8%) | 33.6 **noisy: do not use** | Arabic, Kurdish (Sorani RTL) | no comprehensive law (bg) | Medium-Low |
| Iran | 92.6M / 73.8M (79.6%) | 6.6 **noisy** (VPN-distorted) | Persian RTL, Jalali, ZWNJ | no data law; OFAC GL D-2 folded into 31 CFR 560.540 | **Blocked** for paid |
| Palestine | 5.61M / 4.86M (86.6%) | no data | Arabic | n/v | Low |
| Jordan | 11.5M / 10.6M (92.5%) | 3.2 | Arabic, English | PDPL 24/2023: transfers only to equivalent countries | Medium |
| Lebanon | 5.86M / 5.38M (91.8%) | 3.5 | Arabic, French | n/v; banking crisis | Low-Medium |
| Syria | 25.8M / 9.25M (35.8%) | no data | Arabic | sanctions easing, export controls remain | **Blocked-to-Low** |
| Yemen | 42.1M / 7.44M (17.7%) | 23.2 **noisy** | Arabic | Houthi designations (bg) | **Blocked** |
| Cyprus | 1.37M / 1.30M (94.7%) | 2.2 | Greek, Turkish | EU baseline | Medium (EU reuse); also in Europe |
| Armenia | 2.95M / 2.36M (80%) | 2.4 | Armenian script, Russian | 2015 law (bg) | Low-Medium |
| Georgia | 3.81M / 3.12M (81.9%) | 6.8 | Georgian Mkhedruli | 2023 GDPR-aligned (bg); foreign-agent tensions (bg) | Medium |
| Azerbaijan | 10.4M / 9.27M (89%) | 4.6 | Azerbaijani Latin, Russian | 2010 law with localisation (bg, n/v) | Low-Medium |

The notes rank Turkey first, then UAE, Saudi, Israel, a GCC bundle, Georgia, Cyprus, Jordan and Iraq. Gulf users judge the OS by Arabic: RTL across installer, GDM, GNOME Shell and GTK4 apps; Noto Naskh/Kufi and Amiri fonts; Arabic-Indic digits; Hijri/Umm al-Qura and Friday-weekend options; Hunspell Arabic; ar and ar-azerty keyboards (inference from the market). Do not market calling or circumvention: the UAE allows VoIP only via licensees (TDRA-approved list includes Teams, Zoom, Webex, Botim) ([PIN Legal](https://www.pinlegalglobal.com/articles/legal-framework-for-voip-internet-communication-in-the-uae)); ship mail/calendar/contacts/files and geo-label any Jitsi/Nextcloud Talk-type feature. A consumer mail product is largely outside hard localisation rules (UAE health and finance, Saudi government), but offer a GCC data-location option. Iran, Yemen and Syria: allow free download, geo-block paid sign-up, add OFAC/EAR screening, take US and Indian counsel's advice. Nubo's Indian status still leaves USD-rail exposure (inference).

---

## Africa

Figures are rounded ITU 2024-based numbers from one secondary compilation ([Wikipedia](https://en.wikipedia.org/wiki/List_of_countries_by_number_of_Internet_users)) that the notes say is partly calculated; Nigeria uses DataReportal (109M, 45.5%) instead ([DataReportal](https://datareportal.com/digital-in-nigeria)). Africa desktop share: Windows 84.44%, macOS 6.17%, Linux 5.07%, OS X 3.94% ([StatCounter](https://gs.statcounter.com/os-market-share/desktop/africa)). StatCounter was fetched only for seven countries (shown); other rows are nf. Data-law cells without a link are background knowledge (BK). Malabo Convention (in force 8 June 2023) status is noted where known. About 25% of Sub-Saharan Africans use mobile internet on their own device and 20GB costs about 14% of average monthly income ([GSMA](https://www.gsma.com/solutions-and-impact/connectivity-for-good/mobile-for-development/blog/despite-improvements-sub-saharan-africa-has-the-widest-usage-and-coverage-gaps-worldwide/)).

### North Africa

| Country | Pop / users | Linux % | Languages | Legal / payments | Rating |
|---|---|---|---|---|---|
| Egypt | 110M / 82M (74.6%) | 4.35 (Windows 89.6) | Arabic RTL | PDPL 151/2020; transfer permits (BK); Fawry, wallets; EGP controls | High |
| Morocco | 38M / 35M (91.2%) | 4.69 | Arabic, Tamazight (Tifinagh), French | Law 09-08, prior authorisation (BK); CMI | High |
| Algeria | 45M / 35M (77.4%) | nf | Arabic, Tamazight, French | Law 18-07; strict FX; cards often unusable (BK) | Low-Medium |
| Tunisia | 12M / 9M (76.5%) | nf | Arabic, French | Law 2004-63; replacement bill early 2026 | Medium |
| Libya | 7M / 5.7M (82%) | nf | Arabic | no law; OFAC program | **Blocked** |
| Sudan | 46M / 8.6M (18.6%, 2017) | nf | Arabic, English | no law; OFAC with SDN; war | **Blocked** |
| Mauritania | 5M / 2M (45.8%) | nf | Arabic, French, Hassaniya | 2017 law (BK); Malabo | Low |
| Western Sahara (territory) | ~0.6M (n/v) | nf | Arabic, Spanish | serve via Morocco only (BK) | Low |

### West Africa

| Country | Pop / users | Linux % | Languages | Legal / payments | Rating |
|---|---|---|---|---|---|
| Nigeria | 228M / 109M | 8.9 (Windows 80.3) | English, Pidgin, Hausa, Yoruba, Igbo (tone marks) | NDPA 2023 ss.41-43; NDPC probing cross-border; CBN local card switching ([CIPIT](https://cipit.strathmore.edu/navigating-the-crossroads-the-challenges-of-cross-border-data-flows-under-domestic-laws-in-africa/)); at least one 2025 shutdown; naira volatility | High |
| Ghana | 34M / 25M (72.2%) | 5.19 (ChromeOS 2.36) | English, Twi, Ewe, Ga | DPA 2012; new fee schedule Feb 2026; MoMo | High |
| Senegal | 18M / 11M | nf | French, Wolof | Law 2008-12; Wave, Orange Money; Malabo | Medium |
| Cote d'Ivoire | 28M / 12M | nf | French | Law 2013-450 (BK); XOF | Medium |
| Benin | 13M / 4.4M | nf | French, Fon | Digital Code 2017; Malabo | Low-Medium |
| Togo | 9M / 3.6M | nf | French, Ewe | shutdowns 2025 | Low |
| Burkina Faso | 23M / 6.5M | nf | French, Moore | junta (BK) | Low |
| Mali | 23M / 8.5M | nf | French, Bambara | OFAC list-based; junta, conflict | Low |
| Niger | 28M / 11M | nf | French, Hausa | Law 2022-059; Malabo; junta | Low |
| Guinea | 13M / 4.3M | nf | French, Fula | shutdown 2025 | Low |
| Guinea-Bissau | 2M / 0.6M | nf | Portuguese, Kriol | shutdown 2025; Malabo | Low |
| Sierra Leone | 8.6M / 2.2M | nf | English, Krio | no law | Low |
| Liberia | 5M / 1.7M | nf | English | no law | Low |
| Gambia | 2.4M / 1.2M | nf | English | Malabo | Low |
| Cabo Verde | 0.6M / 0.4M | nf | Portuguese | Law 2001 (BK) | Low |

### Central Africa

| Country | Pop / users | Linux % | Languages | Legal | Rating |
|---|---|---|---|---|---|
| DR Congo | 95M / 19M | nf | French, Lingala, Swahili | OFAC list-based; Goma shutdown 2025 | Low |
| Cameroon | 28M / 13M | nf | French, English | shutdowns 2025 | Low-Medium |
| Chad | 18M / 2.3M | nf | French, Arabic | shutdowns 2025; Malabo | Low |
| Central African Rep. | 5.6M / 0.8M | nf | French, Sango | OFAC list-based; shutdowns | Low (screening) |
| Republic of Congo | 6M / 2.9M | nf | French | DPA inaugurated Jan 2026; Malabo | Low |
| Gabon | 2.4M / 1.6M | nf | French | Law 2011; Malabo status conflicting in notes | Low |
| Equatorial Guinea | 1.7M / 1.1M | nf | Spanish, French | 2025 restrictions (Annobon) | Low |
| Sao Tome and Principe | ~0.2M (n/v) | nf | Portuguese | Malabo | Low |
| Burundi | 14M / 1.2M | nf | Kirundi, French | law adopted 15 Jan 2026 | Low |

### East Africa

| Country | Pop / users | Linux % | Languages | Legal / payments | Rating |
|---|---|---|---|---|---|
| Kenya | 54M / 19M (35%; other sources higher) | 3.82 (macOS 8.83) | English, Swahili | DPA 2019; Sept 2026 guidance: cloud access from abroad counts as transfer; strategic data (civil registration, elections, public finance, education, health) needs a Kenyan serving copy ([Cova Africa](https://www.covafrica.com/2026/09/kenya-issues-new-cross-border-data-transfer-guidance-familiar-concepts-but-important-local-differences/)); M-Pesa; 2025 shutdown | High |
| Tanzania | 62M / 19M | nf | Swahili, English | PDPA 2022 registration by 8 Apr 2026; 8 shutdowns in 2025 | Medium-Low |
| Uganda | 48M / 4.3M (looks low) | nf | English, Luganda | DPPA 2019; Facebook blocked fifth year | Low-Medium |
| Ethiopia | 125M / 27M | nf | Amharic, Oromo, Tigrinya (Ge'ez/Fidel) | Proclamation 1321/2024 (BK); shutdowns; FX | Low-Medium |
| Rwanda | 14M / 4.4M | nf | Kinyarwanda, English, French | Law 058/2021; bank data localised | Medium-High |
| Somalia | 18M / 5M | nf | Somali, Arabic | OFAC program | Low (blocked-ish) |
| South Sudan | 11M / 0.7M | nf | English, Arabic | no law; OFAC; shutdown | **Blocked** |
| Eritrea | 6M / 0.9M | nf | Tigrinya, Arabic | state telecom (BK) | **Blocked** (BK) |
| Djibouti | 1.1M / 0.7M | nf | French, Arabic | Law 2022 (BK) | Low |
| Madagascar | 30M / 5.6M | nf | Malagasy, French | Law 2014-038 (BK) | Low |
| Comoros | 0.9M / 0.3M | nf | Comorian, Arabic | n/v | Low |
| Mauritius | 1.3M / 1.0M | nf | English, French, Creole | DPA 2017, amendment under way | Medium |
| Seychelles | ~0.1M (n/v) | nf | English, French | DPA 2023 (BK) | Low |
| Malawi | 20M / 3.8M | nf | English, Chichewa | DPA 2024 (BK); FX shortages | Low |

### Southern Africa

| Country | Pop / users | Linux % | Languages | Legal / payments | Rating |
|---|---|---|---|---|---|
| South Africa | 60M / 47M (78.4%) | 5.68 (Windows 81.47) | English, Afrikaans, isiZulu, isiXhosa, Sesotho, Setswana (click consonants) | POPIA s.72 transfers; Malabo not ratified ([DataGuidance](https://www.dataguidance.com/jurisdictions/african-bodies)); no 2025 shutdowns; cards, PayFast | **High** |
| Zambia | 20M / 3.4M | nf | English, Bemba | DPA 2021; Malabo | Low |
| Zimbabwe | 16M / 6.7M | nf | English, Shona | Cyber and Data Protection Act 2021; OFAC SDN-only; FX | Low-Medium |
| Mozambique | 35M / 7.2M | nf | Portuguese | no general law; Cloud Computing Regulations (registration/licensing) | Low-Medium |
| Angola | 33M / 13M | nf | Portuguese | Law 22/11 (BK); first shutdown Jul 2025 | Low-Medium |
| Namibia | 2.7M / 1.8M | nf | English, Afrikaans | no law; ZAR-pegged | Medium |
| Botswana | 2.6M / 1.5M | nf | English, Setswana | DPA 2024 (BK) | Low-Medium |
| Lesotho | 2.3M / 1.2M | nf | Sesotho | DPA 2011; Malabo | Low |
| Eswatini | 1.2M / 0.8M | nf | siSwati | DPA 2022; mapping deadline 31 Mar 2026 | Low |

South Africa is the best launch market (POPIA clear, cards, English plus Afrikaans/Zulu); Nigeria is the largest (109M users, 8.9% Linux) with FX and a CBN local card-switching rule; Kenya has the best mobile-money billing but a strict, new transfer regime; Egypt and Morocco give Arabic (and French/Tifinagh) at scale, with FX and authorisation friction. Francophone West (Senegal, Cote d'Ivoire) is second wave once French UI and Wave/Orange Money billing exist. Product implications (partly inference): offline-first sync with delta updates, a low-RAM mode for 4GB machines, local mirrors (Cape Town, Lagos, Nairobi, Cairo, BK), prepaid vouchers and local-currency prices because many lack international cards, and a regional aggregator (Paystack, Flutterwave, BK). Mobile-money accounts exceed 1.2B across Sub-Saharan and North Africa but about 75% are inactive monthly ([Connecting Africa](https://www.connectingafrica.com/mobile-money/-1-4t-flowed-through-mobile-money-in-sub-saharan-africa-in-2025-gsma), [WeeTracker](https://weetracker.com/2026/03/30/mobile-money-africa-inactivity-gsma-report-2026/)). Most restricted: Sudan, South Sudan, Libya, Somalia, Eritrea (blocked for paid); the shutdown-prone group (Tanzania, Ethiopia, Uganda, Cameroon, Togo, Chad, Guinea); the junta states; and FX-limited markets. Countries with no data law in early 2026: Liberia, Libya, Mozambique, Namibia, Sierra Leone, South Sudan, Sudan ([TechHive](https://www.techhiveadvisory.africa/insights/bimonthly-update-on-privacy-in-africa-january-february-2026)). **Row audit:** the tables above list 54 sovereign states plus Western Sahara with Mauritania once; the source note was unaudited and its original had Mauritania twice. Re-audit before relying on the count.

---

## North and Central America and the Caribbean

Population/users are DataReportal; Linux share is StatCounter, Sept 2026, and no figures were obtained for Central America or the Caribbean (page unreadable). Languages are background knowledge.

| Country | Pop / users | Linux % | Languages | Legal / data / sanctions | Rating |
|---|---|---|---|---|---|
| United States | 348M / 324M (93.1%) | 3.69 (Windows 64.45, Apple 26.51, ChromeOS 5.34); another source says ~5.03%, conflicting | English, Spanish | AB 1043 from 1 Jan 2027 ([leginfo](https://leginfo.legislature.ca.gov/faces/billTextClient.xhtml?bill_id=202520260AB1043)); state privacy laws (count n/v); COPPA, FTC (bg); DOJ bulk-data rule if moved to India (bg); EAR 742.15 | Medium |
| Canada | 40.2M / 38.2M (95.1%) | 2.41 | English, French (Quebec French rules, n/v) | PIPEDA; Bill C-27 died Jan 2025; Bill C-8 Royal Assent 15 Jun 2026 (does not replace PIPEDA); Quebec Law 25 PIA before out-of-province transfers ([Fusion Computing](https://fusioncomputing.ca/pipeda-compliance-small-business-canada/)) | Medium |
| Mexico | 132M / 110M (83.5%) | 3.21 | Spanish (es-MX) | New LFPDPPP 21 Mar 2025; INAI dissolved; regulations pending ([Hunton](https://www.hunton.com/privacy-and-information-security-law/mexico-overhauls-federal-data-protection-law)); no localisation seen | **High** |
| Costa Rica | 5.16M / 4.78M (92.6%) | nf | Spanish | Law 8968 (bg) | Low-Medium |
| Panama | 4.58M / 3.60M (78.4%) | nf | Spanish, English | Law 81/2019 (bg) | Low-Medium |
| Guatemala | 18.8M / 11.6M (62.0%) | nf | Spanish, Mayan | n/v | Low |
| Honduras | 11.1M / 8.0M (72.4%) | nf | Spanish | n/v | Low |
| El Salvador | 6.37M / 4.90M (76.8%) | nf | Spanish | n/v | Low |
| Nicaragua | 7.03M / 4.89M (69.6%) | nf | Spanish | n/v; political risk (bg) | Low |
| Belize | 424k / 307k (72.4%) | nf | English, Spanish | n/v | Low |
| Dominican Republic | 11.5M / 10.5M (91.0%) | nf | Spanish | n/v | Low-Medium |
| Cuba | 10.9M / 7.79M (71.3%) | nf | Spanish | US embargo with internet carve-outs ([sanctionslawyers.net](https://sanctionslawyers.net/economic-sanctions-programs/cuba/)) | **Blocked** |
| Haiti | 11.9M / 4.69M (39.3%) | nf | Creole, French | n/v | Low |
| Jamaica | 2.84M / 2.54M (89.5%) | nf | English, Patois | 2020 law (bg) | Low |
| Trinidad and Tobago | 1.51M / 1.28M (84.7%) | nf | English | partial (bg) | Low |
| Bahamas | 403k / 383k (94.8%) | nf | English | n/v | Low |
| Barbados | 283k / 226k (80.0%) | nf | English | n/v | Low |
| Antigua and Barbuda, Dominica, Grenada, St Kitts and Nevis, St Lucia, St Vincent and the Grenadines (grouped) | ~50k-180k each (bg); DataReportal n/v | nf | English; French-lexicon Creoles | n/v | Low |
| Puerto Rico | n/v | n/v | Spanish, English | US federal law (bg) | Low-Medium (not verified) |

The US and Canada are the only places in the region with strong card payments and willingness to pay (the latter is background), but have the lowest Linux share and the heaviest compliance load. Mexico is the regional volume play (110M online, Spanish only, no localisation seen). Cuba is blocked for paid accounts; Nicaragua is background-only risk. The remaining Central American and Caribbean markets are free-download audiences. Not verified: US state law count, Cyber Trust Mark (hardware only), Canada accessibility law, Mexican payments (OXXO), all payments in the Caribbean.

---

## South America

| Country | Pop / users | Linux % | Languages | Legal / data / payments | Rating |
|---|---|---|---|---|---|
| Brazil | 213M / 185M (86.9%) | 4.15 (Windows 86.7) | pt-BR | LGPD (ANPD), Resolution 19/2024 SCCs; Brazil-EU mutual adequacy from 27 Jan 2026; India not adequate (inference) ([DLA Piper](https://www.dlapiperdataprotection.com/index.html?t=law&c=BR)); Digital ECA ([Legal500](https://www.legal500.com/intelligence/brazil/privacy/the-digital-eca-transforms-the-internet-and-the-software-industry-in-brazil)); Pix ~200M monthly users ([Wikipedia](https://en.wikipedia.org/wiki/Pix_(payment_system))); tax (IOF, ISS, CBS/IBS) n/v | **High** (high compliance cost) |
| Argentina | 45.9M / 41.6M (90.6%) | 3.02 | Spanish (rioplatense) | Law 25.326, EU-adequate, database registration ([DLA Piper](https://www.dlapiperdataprotection.com/index.html?t=law&c=AR)); currency controls n/v | Medium |
| Chile | 19.9M / 18.8M (94.5%) | 3.31 | Spanish | Law 21.719 in force 1 Dec 2026, new agency | Medium |
| Colombia | 53.6M / 41.7M (77.8%) | 2.85 | Spanish | Laws 1266/2008, 1581/2012; RNBD registration ([DLA Piper](https://www.dlapiperdataprotection.com/index.html?t=law&c=CO)) | Medium |
| Peru | 34.7M / 28.4M (82.0%) | 3.38 | Spanish, Quechua | Law 29733, DS 016-2024-JUS from 30 Mar 2025 | Medium |
| Uruguay | 3.38M / 3.15M (93.0%) | nf | Spanish | Law 18.331, EU-adequate | Medium (small) |
| Ecuador | 18.3M / 15.4M (83.9%) | nf | Spanish, Quechua | 2021 law (bg) | Low-Medium |
| Paraguay | 7.03M / 5.84M (83.1%) | nf | Spanish, Guarani | 2025 law (bg) | Low-Medium |
| Bolivia | 12.6M / 9.0M (71.3%) | nf | Spanish, Quechua, Aymara | n/v | Low-Medium |
| Venezuela | 28.5M / 17.6M (61.6%) | nf | Spanish | OFAC GL 61/62 (Aug 2026) for telecom/cloud, not shown to cover paid consumer ([Cleary](https://www.clearygottlieb.com/news-and-insights/publication-listing/ofac-issues-general-licenses-authorizing-activity-in-venezuelan-telecommunications-sector)); weak rails | **Blocked/High risk** |
| Guyana | 837k / 684k (81.7%) | nf | English | n/v | Low |
| Suriname | 641k / 503k (78.4%) | nf | Dutch | n/v | Low |

South America overall: Windows 87.01, Apple 8.56, Linux 3.67, ChromeOS 0.76 ([StatCounter](https://gs.statcounter.com/os-market-share/desktop/south-america)). Brazil combines scale, the highest Linux share checked (4.15%) and Pix, but also the ECA, LGPD SCCs and tax friction; selling from India likely means foreign-currency billing and high card declines in Brazil, Argentina and Venezuela (inference). Mercado Pago, OXXO, VAT/IVA on foreign digital services and currency controls were not verified. Public-sector Linux history (Brazil, Venezuela Canaima, Cuba Nova, Ecuador, Uruguay/Argentina Huayra) is recollection only. Brazil, Chile and Mexico are changing law fastest, so compliance cost rises there first.

---

## Oceania

| Country | Pop / users | Linux % | Languages (bg) | Legal / data / payments | Rating |
|---|---|---|---|---|---|
| Australia | 27.0M / 26.2M (97.1%) | 2.8 (Windows 64.83, Apple ~30.4) | English plus migrant languages | Privacy Act reform 2024; Children's Online Privacy Code due 10 Dec 2026 ([MinterEllison](https://www.minterellison.com/articles/oaics-childrens-online-privacy-code-what-to-expect)); smart-device rules from 4 Mar 2026 exclude PCs/laptops ([Nemko](https://www.nemko.com/blog/mandatory-cybersecurity-australias-new-regulations-from-4-march-2026)); Assistance and Access Act (bg); GST (bg); Stripe supported ([Stripe](https://stripe.com/global)) | **High** |
| New Zealand | 5.26M / 5.06M (96.2%) | 3.29 (ChromeOS 4.69) | English, te reo Maori | Privacy Act 2020, IPP3A from 1 May 2026 ([Justice NZ](https://www.justice.govt.nz/about/news-and-media/news/new-privacy-information-principle-in/)) | High (small) |
| Papua New Guinea | 10.8M / 2.60M (24.1%) | 5.34 **noisy** | Tok Pisin, English | no law found | Low |
| Fiji | 934k / 741k (79.3%) | 6.85 **noisy** | English, iTaukei, Fiji Hindi | no comprehensive law | Medium-Low |
| Solomon Islands | 844k / 358k (42.5%) | nf | English, Pijin | n/v | Low |
| Vanuatu | 337k / 154k (45.7%) | nf | Bislama, English, French | DPPA in effect 2 Jan 2025, extraterritorial ([DataGuidance](https://www.dataguidance.com/jurisdictions/vanuatu)) | Low |
| Samoa | 220k / 128k (58.1%) | nf | Samoan, English | Digital ID Act 2024; no data law found | Low |
| Tonga | 104k / 60.7k (58.5%) | nf | Tongan, English | none found | Low |
| Kiribati | 137k / 121k (88.0%, looks high) | nf | I-Kiribati, English | n/v | Low |
| Tuvalu | 9,456 / 7,027 (74.3%) | nf | Tuvaluan | n/v | Low |
| Nauru | 12k / 9.96k (82.7%) | nf | Nauruan | n/v | Low |
| Palau | 17.7k / 11.4k (64.6%) | nf | Palauan | n/v | Low |
| Marshall Islands | 36k / 23.6k (65.7%) | nf | Marshallese | n/v | Low |
| FSM | 114k / 46.1k (40.5%) | nf | English plus local | n/v | Low |
| Guam (US territory) | 169k / 136k (80.5%) | nf | English, Chamorro | US federal law (bg) | Low-Medium |
| French Polynesia | 283k / 205k (72.7%) | nf | French, Tahitian | French law application n/v | Low-Medium |
| New Caledonia | 296k / 243k (82.0%) | nf | French, Kanak | as above | Low-Medium |
| Niue | 1,820 / 1,448 (79.6%) | nf | Niuean, English | n/v | Low |
| Cook Islands | n/v | nf | English, Cook Islands Maori | n/v | Low |

AU plus NZ (about 31.3M users) are the only paying markets; Pacific states are a free-download audience served by one English listing. No Oceania state is sanctioned. Australia's PC/laptop exclusion from smart-device rules means a laptop bundle is outside it, whereas a Nubo-branded router, NAS or camera would be in scope. Not verified: language locales (mi_NZ, sm_WS, to_TO), small-business exemption (A$3M) applicability, eSafety codes for OS providers, GST thresholds, PayPal coverage in the Pacific.

---

## OS requirements checklist by market

Derived only from the notes; background items are marked.

| Market group | Languages / input / fonts | Calendar, RTL | Data hosting option | Age / parental signal | Payments | Entity / agent | Government certification |
|---|---|---|---|---|---|---|---|
| EU/EEA, UK, Switzerland | Local languages incl. Catalan/Basque/Galician, Sami, Welsh; Nordic and diacritic layouts; French UI required (Toubon, bg) | none | EU region by default; SCCs if India-hosted | EAA/accessibility (bg); UK Online Safety (bg) | SEPA DD, iDEAL, Bancontact, BLIK, Bizum, TWINT, Vipps, Swish, MB Way | GDPR Art. 27 representative (bg); EU entity may help positioning | none verified |
| Russia, Belarus, Ukraine, Balkans | Cyrillic variants (Serbian dual script, Ukrainian) | none | n/a (blocked) | n/v | Visa/MC unavailable in RU/BY (bg) | n/v | Astra Linux (bg) |
| India | 11+ Indic scripts and Urdu; Inscript/phonetic input; BOSS supports 19 languages as benchmark | none | India region default (DPDP) | n/v | INR, UPI (bg) | Indian entity | BOSS/Maya institutional |
| Pakistan, Bangladesh, Nepal, Sri Lanka, Bhutan, Maldives | Nastaliq, Bengali, Devanagari, Sinhala/Tamil, Dzongkha, Thaana | RTL for Urdu/Thaana | Avoid India-hosting for Pakistan (inference); Bangladesh restricted data local | n/v | FX limits (mostly BK) | legal review before onboarding | none found |
| Central Asia | Cyrillic incl. Kazakh letters; Uzbek Latin O'/G' | none | In-country for Kazakhstan | n/v | local rails BK | local partner (inference) | none found |
| East Asia | Simplified/Traditional Chinese, Cantonese, Japanese, Korean; IBus + Fcitx5 | none | CAC route/in-country for China; none for HK, TW, JP | n/v | cards; Naver/Kakao Pay (bg) | Korea domestic agent above thresholds; China licence/partner | CSAP (bg); China Kylin/UOS mandate |
| Southeast Asia | Thai, Khmer, Lao, Burmese (Zawgyi, bg), Vietnamese, Bahasa, Jawi | none | Vietnam local storage; Indonesia GR 33 from Jan 2027 | n/v | PromptPay, GoPay/OVO, MoMo, GCash (bg) | Myanmar registration above 100k users | none |
| Gulf and Middle East | Arabic RTL, Hebrew, Persian, Kurdish, Turkish dotted-i; Arabic fonts (Noto Naskh/Kufi, Amiri) | Hijri/Umm al-Qura, Jalali (Iran), Friday weekend (inference) | GCC/KSA/UAE region option; UAE health/finance data local | n/v | cards; mada, KNET (bg) | CST registration (Saudi, search summary), VERBIS and local rep (Turkey) | NCA CCC (Saudi public sector) |
| Caucasus | Armenian, Georgian, Azerbaijani Latin | none | Azerbaijan localisation (bg) | n/v | cards | n/v | none |
| Africa | Arabic RTL, French, Swahili, Hausa/Yoruba/Igbo tone marks, Ge'ez/Fidel, Tifinagh, Zulu/Xhosa clicks, Portuguese | RTL (North Africa) | Regional node (South Africa/Kenya) for East/Southern; EU or India with SCCs elsewhere; Kenya strategic data copy | n/v | M-Pesa, MoMo, Orange Money, Wave, Fawry; prepaid vouchers, local currency | Tanzania PDPC registration; Kenya ODPC processor registration (BK); Mozambique cloud registration | none found |
| US, Canada | English, Spanish, French (Quebec) | none | no localisation | AB 1043 four-bracket API; state app-store laws (n/v) | cards | n/v | none |
| Latin America | Spanish variants, pt-BR, Quechua/Aymara/Guarani minor | none | no localisation verified; SCCs for Brazil | Brazil ECA stronger verification | cards, Pix | n/v | none found |
| Oceania | English, te reo Maori, Pacific languages; macrons, okina | none | no localisation found | Australia Children's Code | Stripe AU/NZ | GST registration (bg) | n/v |

Hardware type approval (RCM/ACMA, KC, MIC, SRRC, SDPPI/TKDN, TDRA, CST) matters only if Nubo ships bundles and was not researched.

---

## Data quality, caveats and follow-up searches

**Search budget.** The 200-call web-search budget ran out part-way; most notes report only 5-7 searches before the quota hit, then switched to page fetches. Legal cells therefore rely heavily on background knowledge (marked BK/[bg]) in Europe (UK PSTI, EAA, adequacy, Russian and Balkan laws), East Asia (most data laws), West Asia (Oman, Iraq, Lebanon, Caucasus), Africa (most data laws, all payments, all public-sector columns), and the Americas (all payments and tax). Language/script entries are background knowledge throughout. Public-sector Linux evidence is thin: only Schleswig-Holstein, Denmark, DINUM, China, India (BOSS/Maya) and a 2019 Korea announcement are sourced.

**Noisy or missing StatCounter data.** Iraq 33.6% and Yemen 23.2% Linux look like bot or sample noise and must not be used; Afghanistan 10.54%, Myanmar 7.17%, Bhutan 6.8%, Fiji 6.85%, PNG 5.34%, Sri Lanka's near-zero non-Windows and Israel's 13.4% (developer-heavy) are flagged. India's 10.45% is far above typical global desktop figures and varies between sources; use it only as a directional signal. Japan uses August 2026, not September. StatCounter returned no data for Syria, Palestine and Central America/Caribbean; Laos, Brunei, Timor-Leste, most of Europe's 30 smaller countries, 48 African countries and 14 Pacific markets were not fetched. StatCounter measures web traffic, excludes nothing about bots, and undercounts users who block tracking (inference). A US Linux figure of ~5.03% from another source conflicts with StatCounter's 3.69%.

**Population/user data.** India's population is derived (~1.47bn), not fetched. Africa uses one secondary compilation with partly calculated numbers; Kenya (19M) and Uganda (4.3M) look low against other sources not checked. Kosovo's 89.4% is from 2018. Kiribati's 88.0% looks high. Macau, North Korea, Seychelles, Sao Tome, Western Sahara, Cook Islands and Puerto Rico lack verified figures. Cyprus appears in both Europe and West Asia.

**Structural issues.** The Africa row count is unaudited and the source note had Mauritania twice (I list it once, under North Africa). The Gabon Malabo-ratification status conflicts between sources. Some notes repeated the unverified France 2.5M claim; it is corrected above. Secondary sources (Tuta, TechTimes, commentary sites, sanctionslawyers.net, law-firm marketing pages) are medium reliability. OFAC's programs page lists no Syria comprehensive program (Syria now only under PAARSS), so earlier lists naming Syria are outdated; confirm before enabling Syria sign-ups.

**Legal points that need counsel.** (1) Whether Nubo is a CRA "manufacturer" given a free OS monetised through paid cloud accounts, and open-source steward treatment. (2) Whether a free open-source OS distribution is an "operating system provider" under California AB 1043 and Brazil's Digital ECA (the sources do not address it). (3) Reach of OFAC, EAR and EU/UK sanctions over an Indian company (nexus via USD, US processors, EU hosts, US-origin Ubuntu packages) and Indian export rules. (4) Russia and Belarus, including the free-download question. (5) Whether GDPR Art. 27 representative duties, Digital Content Directive withdrawal rights and Korean agent thresholds apply. (6) Whether OAIC treats a free-OS-plus-paid-cloud publisher as subject to the Privacy Act (A$3M small-business exemption). This report is research synthesis, not legal advice.

**Highest-value follow-up searches.**
1. Primary-source confirmation of the DINUM announcement (8 Apr 2026; ~250 workstations by 18 Apr; autumn 2026 ministry plans) and any other European government Linux programmes.
2. AB 1043 and Brazil ECA text and regulator guidance on open-source/free OS coverage; other US state app-store/OS age laws (Texas, Utah, Louisiana).
3. CRA guidance on monetised open-source stewards, and EAA scope for operating systems.
4. Payment feasibility: UPI/RBI limits and foreign-merchant flows from India, Stripe/Razorpay/Paddle country coverage, Pix for foreign merchants, M-Pesa/MoMo aggregators, Gulf and Turkish gateways, Mercado Pago, tax on digital services (VAT/IVA/GST) by country.
5. GCC TRA/CITRA/CRA VoIP and VPN rules for 2026 and Saudi CST registration for a foreign consumer cloud provider; UAE PDPL executive regulations.
6. Data-law verification for the BK-heavy set: Russia 242-FZ, UK/Swiss adequacy, Oman, Iraq, Caucasus, Japan/Singapore/Malaysia/Philippines/HK/Taiwan, most of Africa (via DLA Piper, DataGuidance, AU data hub), Ecuador/Paraguay/Central America.
7. Desktop OS share cross-checks (Steam survey, vendor telemetry, Counterpoint) for India, Thailand, Israel, Nigeria; StatCounter for missing small markets.
8. Willingness-to-pay: Proton/Tuta/Mailbox.org paid-email penetration by country, refurbished-PC volumes, Windows-10-stuck installed base by market, education/refurb programmes.
9. Sanctions detail for Myanmar, North Korea, Afghanistan and Libya, and the Syria State Department advisory (403 in the notes).
10. Pakistan, Bangladesh, Vietnam and Kazakhstan hosting and licensing specifics; whether Uzbekistan's Feb 2026 amendment is in force.
