# Europe: market opportunity and OS-distribution requirements (as of October 2026)

Evidence convention: items with a [Source](URL) were retrieved in this session. Items tagged **[bg]** are from the researcher's background knowledge (not re-verified this session, treat as "not verified"). Search budget ran out mid-task (the web search tool hit its session cap), so several legal items (Russia localisation, UK PSTI, EAA scope, adequacy decisions, Swiss/Balkan DP laws) are [bg] and should be confirmed by counsel before launch. Population figures are rounded approximations **[bg]** (Eurostat/UN WPP ~2024-25); internet-use % is ITU data via Wikipedia, year shown.

## Which countries are the best first targets, and why?

### Takeaway
Best first targets are the Linux-friendly, high-income, privacy- and sovereignty-minded markets with strong Linux share and local-payment ecosystems: Germany, Netherlands, France, Switzerland, Nordics (Norway, Denmark, Sweden, Finland), Spain, Austria. Sovereignty-driven public-sector Linux moves in France, Germany (Schleswig-Holstein) and Denmark in 2025-26 create a tailwind, and an India-based host must address GDPR transfer rules (India has no EU adequacy decision [bg]) by hosting mail/files in an EU region.

### Cited Findings
- Europe desktop share, StatCounter Sept 2026: Windows 77.28%, OS X 10.93%, macOS 5.57%, Linux 4.61%, ChromeOS 1.6% — [StatCounter Europe](https://gs.statcounter.com/os-market-share/desktop/europe)
- Germany Linux 6.49%, Windows 76.6%, OS X 12.74%, macOS 3.41%, ChromeOS 0.74% (Sept 2026) — [StatCounter DE](https://gs.statcounter.com/os-market-share/desktop/germany)
- Netherlands Linux 7.64%, Windows 70.42%, OS X 12.61%, macOS 6.73%, ChromeOS 2.6% — [StatCounter NL](https://gs.statcounter.com/os-market-share/desktop/netherlands)
- Spain Linux 5.72%, Windows 78.47% — [StatCounter ES](https://gs.statcounter.com/os-market-share/desktop/spain)
- Norway Linux 5.35%, Windows 71.09%, ChromeOS 2.16% — [StatCounter NO](https://gs.statcounter.com/os-market-share/desktop/norway)
- France Linux 4.46%, Windows 77.26% — [StatCounter FR](https://gs.statcounter.com/os-market-share/desktop/france)
- Italy Linux 4.24%, Windows 79.45% — [StatCounter IT](https://gs.statcounter.com/os-market-share/desktop/italy)
- Poland Linux 3.96%, Windows 88.98% — [StatCounter PL](https://gs.statcounter.com/os-market-share/desktop/poland)
- UK Linux 3.55%, Windows 68.87%, OS X 17.42%, macOS 7.28%, ChromeOS 2.87% — [StatCounter UK](https://gs.statcounter.com/os-market-share/desktop/united-kingdom)
- Switzerland Linux 3.72%, Windows 68.78%, Apple combined ~27.3% — [StatCounter CH](https://gs.statcounter.com/os-market-share/desktop/switzerland)
- Serbia Linux 3.7%, Windows 88.36% — [StatCounter RS](https://gs.statcounter.com/os-market-share/desktop/serbia)
- Ukraine Linux 2.95%, Windows 82.28%, macOS 11.78% — [StatCounter UA](https://gs.statcounter.com/os-market-share/desktop/ukraine)
- Belarus Linux 3.08%, Windows 90.25% — [StatCounter BY](https://gs.statcounter.com/os-market-share/desktop/belarus)
- Russia Linux 4.05%, Windows 90.91% — [StatCounter RU](https://gs.statcounter.com/os-market-share/desktop/russian-federation)
- Public-sector signals: France announced (April 2026) plan to move all government computers (2.5M civil servants) from Microsoft to Linux; Lyon and Marseille started replacing Microsoft; Schleswig-Holstein ~30,000 workstations to LibreOffice/Linux, ~80% migrated by Dec 2025, EUR 15M/yr licence savings vs EUR 9M one-off in 2026; Danish Ministry of Digital Affairs moved staff to Linux/LibreOffice (summer 2025) — [Tuta summary](https://tuta.com/blog/countries-ditching-microsoft-choosing-linux-digital-sovereignty), [LinuxSecurity](https://linuxsecurity.com/news/government/schleswig-holsteins-bold-move-to-open-source), [The Record](https://therecord.media/denmark-digital-agency-microsoft-digital-independence). Secondary/aggregator sources; the French plan figures should be confirmed against a primary government source.
- Internet penetration (ITU via Wikipedia, years per row below) is 77-100% across the region — [Wikipedia ITU list](https://en.wikipedia.org/wiki/List_of_countries_by_number_of_Internet_users)

### Inferences
- Linux share is highest (5-8%) in DE, NL, ES, NO; those are plausible beachheads. Absolute numbers favour DE (~84M people, ~6.5% desktop Linux), FR, ES, IT, PL; per-capita willingness-to-pay favours DE/NL/CH/Nordics/AT.
- Public-sector migrations are mostly office/government desktops, not consumers; the consumer benefit is brand legitimacy, "EU-hosted, non-US" messaging and ecosystem (LibreOffice, Nextcloud) familiarity. Nubo being Indian is a positioning risk for "European sovereignty" buyers; EU hosting plus an EU legal entity may be needed (inference).
- StatCounter Linux share excludes ChromeOS and may undercount privacy-minded users who block tracking; treat as a floor (inference).

### Gaps
- StatCounter pages for ~30 smaller countries were not fetched; marked "nf" below.
- No verified willingness-to-pay or paid-email market-size data per country (Proton/Tuta/Mailbox.org penetration not researched).

## What local requirements differ from the EU baseline (language, residency, sanctions)?

### Takeaway
The EU/EEA is a single regime for GDPR, CRA, EAA, consumer law. Deviations are: UK (UK GDPR + PSTI), Switzerland (FADP), Balkans/Moldova/Ukraine (GDPR-style laws of varying maturity), and Russia/Belarus (localisation and sanctions). Language/keyboard coverage is the biggest practical variable (Cyrillic, Greek, Baltic/Nordic, Celtic, and minority languages).

### Cited Findings
- EU Cyber Resilience Act: reporting obligations (Art. 14: 24h early warning, 72h notification, final report 14 days after mitigation for exploited vulns, one month for severe incidents) have applied since 11 Sept 2026 to manufacturers of products with digital elements; remaining obligations (essential requirements, conformity assessment, technical documentation) apply from 11 Dec 2027 — [Hunton](https://www.hunton.com/privacy-and-cybersecurity-law-blog/eu-cyber-resilience-act-reporting-obligations-take-effect-for-manufacturers), [Commission CRA reporting page](https://digital-strategy.ec.europa.eu/en/policies/cra-reporting), [Skadden](https://www.skadden.com/insights/publications/2026/09/get-ready-reporting-faqs-and-checklist), [Kirkland](https://www.kirkland.com/publications/kirkland-alert/2026/09/the-eu-cyber-resilience-act)
- CRA open-source treatment (free software outside commercial activity is not in scope; a monetised distribution with paid cloud account is likely a "manufacturer"/steward question) — not verified this session; see Kennedys on 2026 Commission guidance: [Kennedys](https://www.kennedyslaw.com/en/thought-leadership/article/2026/eu-cyber-resilience-act-what-the-european-commission-s-2026-guidance-means-for-manufacturers/)
- EU sanctions on Russia: 19th package (Oct 2025) widened the ban on providing certain software (banking, finance, space services, technical testing, AI, quantum) and AI/HPC services to Russian entities — [Consilium 19th](https://www.consilium.europa.eu/en/press/press-releases/2025/10/23/19th-package-of-sanctions-against-russia-eu-targets-russian-energy-third-country-banks-and-crypto-providers/), [Lexology](https://www.lexology.com/library/detail.aspx?g=0bdb0332-5cd0-46cc-8011-e088b43406cf). 20th package (23 Apr 2026) added a ban on providing cybersecurity services to Russia and further trade/financial/crypto measures — [Consilium 20th](https://www.consilium.europa.eu/en/press/press-releases/2026/04/23/russia-s-war-of-aggression-against-ukraine-20th-round-of-stern-eu-sanctions-hits-energy-military-industrial-complex-trade-and-financial-services-including-crypto/), [Morgan Lewis](https://www.morganlewis.com/pubs/2026/05/eu-adopts-20th-sanctions-package-against-russia-expands-anti-circumvention-efforts)
- US (BIS/OFAC, June 2024 rule): IT-services/software ban for Russia and Belarus excludes retail off-the-shelf software, internet access, free cloud/web apps such as email/spreadsheet/document apps, and VPN; OFAC GL 25D authorises communications-related services and software/hardware incident to internet communications; the consumer-communications export exception was narrowed — [Arnold & Porter](https://www.arnoldporter.com/en/perspectives/advisories/2024/06/russias-access-to-it-services-and-software-restricted), [Fenwick](https://www.fenwick.com/insights/publications/u-s-imposes-sweeping-new-sanctions-and-export-controls-on-russia-and-belarus), [Cleary](https://www.clearytradewatch.com/2024/10/u-s-uk-and-eu-sanctions-alignment-u-s-it-and-software-sector-service-bans-and-export-controls-take-effect-as-russia-sanctions-continue-to-expand/). Note: this is the US regime; a free-of-charge download is more defensible than a paid account; paid accounts raise payment-channel and payer-screening issues (inference).
- Per-country Linux/OS data: see tables. Not verified this session: GDPR adequacy status of UK, Switzerland, India; Russian law 152-FZ/242-FZ localisation; Belarus Law 99-Z; UK PSTI scope; EAA scope (my [bg]: EAA applied from 28 June 2025 to consumer e-commerce, e-books, banking, electronic communications, and consumer general-purpose computer hardware and their operating systems; micro-enterprises exempt for services).

### Inferences
- A free OS image is not itself a "service" under EU Russia sanctions in most readings, but selling a paid mail/file account to Russian persons is a services transaction with high compliance risk, and payments from Russia are practically blocked (Visa/Mastercard exit [bg]). Recommend geo-blocking account sign-up and billing for Russia/Belarus and sanctioned regions (Crimea, Donetsk, Luhansk, Kherson, Zaporizhzhia occupied areas) while leaving ISO downloads reviewed with counsel (inference, not legal advice).
- Because Nubo is Indian, EU/UK sanctions bind it only via EU/UK nexus (EU-based entity, EU persons, EUR payments, EU hosts) and OFAC via USD/US-cloud nexus; Canonical (UK) and Ubuntu archive mirrors are separate legal actors [bg].
- Residency: GDPR does not require EU localisation, but hosting in India would need SCCs/transfer impact assessment because India has no EU adequacy decision [bg]. Hosting in EU region (e.g. Germany/Finland) satisfies all EU/EEA, UK (with UK adequacy [bg]) and Swiss use cases most simply.

### Gaps
- Not verified: UK PSTI applicability to a downloadable OS (it covers connectable consumer products; software-only OS likely out of scope, preinstalled hardware bundles in scope [bg]); EAA obligations for OS; EU Digital Services/Data Act applicability; Russia/Belarus/Ukraine/Balkan data laws and any localisation duty; Kosovo-specific payment rules; Swiss FADP details.

## Country table (all 46 European countries)

Legend. **EU** = GDPR + CRA + EAA + EU consumer acquis + ePrivacy (no localisation; transfers to India need SCCs) **[bg]**. **EEA** = same via EEA Agreement (CRA/EAA incorporation timing not verified). EUR members: AT BE HR CY EE FI FR DE GR IE IT LV LT LU MT NL PT SK SI ES; Bulgaria adopted euro 1 Jan 2026 **[bg, confirm]**. Pop = approx millions [bg]. Net% = ITU internet users share of population, year.  "nf" = StatCounter not fetched. Desktop OS date: Sept 2026 StatCounter (W/OS X+macOS/Linux/ChromeOS). Languages are [bg] general knowledge. Public-sector Linux column cites only items found; otherwise "none verified".

### EU member states (27)

| Country | Pop / Net% (yr) | Desktop OS (Sept 2026) | Languages / scripts / input | Data/legal (deviations from EU baseline) | Public-sector Linux signal | Payments | Rating |
|---|---|---|---|---|---|---|---|
| Austria | 9.2M / 91.9% (2025) | nf | German (Latin; umlauts; Austrian de-AT keyboard) | EU baseline | none verified | EUR; SEPA DD, cards, EPS, Klarna | Medium-High: rich, German-speaking, shared German localisation |
| Belgium | 11.8M / 95.8% (2024) | nf | Dutch, French, German (AZERTY BE layout) | EU baseline | none verified | EUR; Bancontact, cards | Medium: three languages, privacy-aware |
| Bulgaria | 6.4M / 79.7% (2025) | nf | Bulgarian (Cyrillic, BDS/phonetic layouts) | EU baseline | none verified | EUR (from 2026 [bg]); cards, ePay | Low-Medium: lower income, Cyrillic needs |
| Croatia | 3.8M / 83.6% (2024) | nf | Croatian (Latin, diacritics) | EU baseline | none verified | EUR; cards | Low-Medium |
| Cyprus | 0.9M / 89.6% (2024) | nf | Greek (Greek script, EL/EN layouts), Turkish in north | EU baseline | none verified | EUR; cards | Low (small) |
| Czechia | 10.9M / 87.7% (2024) | nf | Czech (Latin, QWERTZ CZ) | EU baseline | none verified | CZK; cards, bank transfers, Apple/Google Pay | Medium |
| Denmark | 5.9M / 99.8% (2024) | nf | Danish (æøå) | EU baseline | Ministry of Digital Affairs moved to Linux/LibreOffice (2025) — [The Record](https://therecord.media/denmark-digital-agency-microsoft-digital-independence) | DKK; Dankort, MobilePay, cards | High: sovereignty drive, high ARPU |
| Estonia | 1.4M / 92.2% (2024) | nf | Estonian, Russian minority (Cyrillic) | EU baseline | none verified | EUR; bank links, cards | Low-Medium (small, digital-savvy) |
| Finland | 5.6M / 94.1% (2025) | nf | Finnish, Swedish, Sami | EU baseline | none verified | EUR; cards, MobilePay, bank links | Medium-High |
| France | 68M / 88.7% (2024) | Win 77.26 / Apple 17.37 / Linux 4.46 / ChromeOS 0.9 | French (AZERTY, accents, FR layout); regional languages minor | EU baseline; French language law (Toubon: UI/docs in French required) [bg] | April 2026 plan to move 2.5M civil-servant PCs to Linux; Lyon, Marseille — [Tuta](https://tuta.com/blog/countries-ditching-microsoft-choosing-linux-digital-sovereignty) (secondary) | EUR; Carte Bancaire, cards, SEPA, PayPal | High: big market, strongest sovereignty signal |
| Germany | 84M / 93.5% (2024) | Win 76.6 / Apple 16.15 / Linux 6.49 / ChromeOS 0.74 | German (QWERTZ, ß, umlauts); Turkish/Russian minorities | EU baseline; strict BDSG, strong privacy culture; Schleswig-Holstein ~80% migrated — [LinuxSecurity](https://linuxsecurity.com/news/government/schleswig-holsteins-bold-move-to-open-source) | Schleswig-Holstein; others [bg] | EUR; SEPA direct debit (dominant), PayPal, Klarna, giropay (sunset) [bg] | High: largest paying market, highest Linux share among big markets |
| Greece | 10.4M / 86.3% (2024) | nf | Greek (script, EL layout) | EU baseline | none verified | EUR; cards, bank transfers | Low-Medium |
| Hungary | 9.6M / 93.8% (2024) | nf | Hungarian (QWERTZ HU, ő ű) | EU baseline | none verified | HUF; cards | Low-Medium |
| Ireland | 5.3M / 97.2% (2024) | nf | English, Irish (Gaeilge) | EU baseline; DPC is lead authority for many US firms [bg] | none verified | EUR; cards, PayPal, Revolut | Medium: English, but Windows/Mac dominant |
| Italy | 59M / 89.2% (2024) | Win 79.45 / Apple 15.42 / Linux 4.24 / ChromeOS 0.89 | Italian (Latin) | EU baseline | none verified | EUR; cards, PayPal, Satispay, prepaid cards | Medium-High: large market |
| Latvia | 1.9M / 92.7% (2024) | nf | Latvian, Russian (Cyrillic) | EU baseline; Russia-related sanctions sensitivity | none verified | EUR; cards | Low (small) |
| Lithuania | 2.9M / 89.2% (2024) | nf | Lithuanian, Russian | EU baseline | none verified | EUR; cards | Low |
| Luxembourg | 0.67M / 99.1% (2025) | nf | Luxembourgish, French, German | EU baseline | none verified | EUR | Low (small, wealthy) |
| Malta | 0.57M / 93.9% (2024) | nf | Maltese, English | EU baseline | none verified | EUR | Low (small) |
| Netherlands | 18M / 97.0% (2024) | Win 70.42 / Apple 19.34 / Linux 7.64 / ChromeOS 2.6 | Dutch, Frisian (US-intl style layouts) | EU baseline; strong Dutch government "public money, public code"/sovereignty debate [bg] | none verified in session | EUR; iDEAL (dominant), cards, SEPA | High: highest Linux share, iDEAL |
| Poland | 37M / 89.7% (2025) | Win 88.98 / Apple 6.76 / Linux 3.96 / ChromeOS 0.3 | Polish (programmer's keyboard) | EU baseline | none verified | PLN; BLIK, cards, Przelewy24 | Medium: large, Windows-heavy, price-sensitive |
| Portugal | 10.6M / 88.5% (2024) | nf | Portuguese (pt-PT) | EU baseline | none verified | EUR; MB Way, Multibanco | Medium |
| Romania | 19M / 93.2% (2025) | nf | Romanian (diacritics) | EU baseline | none verified | RON; cards | Low-Medium |
| Slovakia | 5.4M / 89.8% (2024) | nf | Slovak (QWERTZ) | EU baseline | none verified | EUR; cards | Low-Medium |
| Slovenia | 2.1M / 90.8% (2024) | nf | Slovenian | EU baseline | none verified | EUR; cards | Low |
| Spain | 49M / 95.8% (2024) | Win 78.47 / Apple 13.88 / Linux 5.72 / ChromeOS 1.93 | Spanish, Catalan, Basque, Galician (ES layout, Ñ) | EU baseline; co-official languages need coverage | none verified in session | EUR; cards, Bizum | High: large, 5.7% Linux |
| Sweden | 10.5M / 95.8% (2025) | nf | Swedish (åäö), Sami | EU baseline | none verified | SEK; Swish, Klarna, cards | High-Medium |

### EEA non-EU, UK, Switzerland

| Country | Pop / Net% (yr) | Desktop OS | Languages/scripts | Data/legal | Public-sector | Payments | Rating |
|---|---|---|---|---|---|---|---|
| Norway | 5.5M / 99.0% (2024) | Win 71.09 / Apple 21.41 / Linux 5.35 / ChromeOS 2.16 | Norwegian (Bokmål, Nynorsk), Sami | EEA: GDPR via EEA; CRA/EAA EEA-incorporation status not verified | none verified | NOK; Vipps, cards | High: wealthy, Linux 5.35% |
| Iceland | 0.39M / 98.2% (2024) | nf | Icelandic (þ ð) | EEA as above | none verified | ISK; cards | Low (tiny) |
| Liechtenstein | 0.04M / 98.3% (2024) | nf | German | EEA as above; CHF used | none | CHF | Low (tiny) |
| United Kingdom | 69M / 95.5% (2024) | Win 68.87 / Apple 24.7 / Linux 3.55 / ChromeOS 2.87 | English, Welsh, Gaelic (UK keyboard) | UK GDPR + DPA 2018 (+ Data (Use and Access) Act 2025 [bg]); EU adequacy for UK [bg, renewal status unverified]; PSTI Act 2022 applies to connectable consumer products (hardware bundles in scope; software-only OS unlikely) [bg]; Online Safety Act [bg]; Canonical is UK-based | none verified | GBP; cards, PayPal, Open Banking, Apple/Google Pay | Medium-High: English, large, high Apple/ChromeOS share, post-Brexit separate CRA (UK has no CRA) |
| Switzerland | 9M / 97.3% (2025) | Win 68.78 / Apple 27.3 / Linux 3.72 / ChromeOS 0.2 | German, French, Italian, Romansh (CH layouts) | revised FADP (2023); EU adequacy [bg]; CRA not directly applicable (non-EU) [bg]; Swiss hosting highly valued | none verified | CHF; TWINT, PostFinance, cards | High: privacy brand, high ARPU |

### Western Balkans, Moldova, Ukraine, Belarus, Russia

| Country | Pop / Net% | Desktop OS | Languages | Data/legal | Public-sector | Payments | Rating |
|---|---|---|---|---|---|---|---|
| Albania | 2.4M / 85.9% (2024) | nf | Albanian (Latin) | GDPR-aligned law (candidate state) [bg] | none verified | ALL; cards limited | Low |
| Bosnia & Herzegovina | 3.2M / 86.1% (2024) | nf | Bosnian, Croatian, Serbian (Latin + Cyrillic) | GDPR-aligned law 2025 [bg, unverified] | none verified | BAM (pegged to EUR); cards | Low |
| Kosovo | 1.6M / 89.4% (2018, old) | nf | Albanian, Serbian | GDPR-style law 2019 [bg] | none verified | EUR (unilateral); cards | Low |
| Montenegro | 0.62M / 88.9% (2024) | nf | Montenegrin (Latin/Cyrillic) | GDPR-aligned [bg] | none verified | EUR; cards | Low |
| North Macedonia | 1.8M / 93.1% (2025) | nf | Macedonian (Cyrillic), Albanian | GDPR-aligned law 2020 [bg] | none verified | MKD; cards | Low |
| Serbia | 6.6M / 87.7% (2024) | Win 88.36 / Apple 7.77 / Linux 3.7 | Serbian (Cyrillic + Latin) | Law on Personal Data Protection 2018 (GDPR-modelled) [bg]; not EU | none verified | RSD; cards, IPS QR | Low-Medium: Cyrillic, price-sensitive; some Russia-sanctions-evasion scrutiny [bg] |
| Moldova | 2.4M / 77.4% (2024) | nf | Romanian (Latin), Russian | Law on Personal Data Protection 2024 aligned to GDPR [bg]; EU candidate | none verified | MDL; cards | Low |
| Ukraine | ~33M [bg, uncertain post-war] / 82.5% (2024) | Win 82.28 / Apple 14.66 / Linux 2.95 | Ukrainian (Cyrillic), Russian | Law on Personal Data Protection (modernisation pending EU accession) [bg]; war-time martial law, no sanctions on supplying software | none verified | UAH; Monobank/Privat24, cards | Medium-Low: tech-savvy, EU-aspirant; low ARPU, war risk |
| Belarus | 9.1M / 95.5% (2025) | Win 90.25 / Apple 6.53 / Linux 3.08 | Belarusian, Russian (Cyrillic) | Law No. 99-Z (2021) [bg]; localisation expectations [bg]; EU/UK/US sanctions on regime | none verified | BYN; EU/US payment rails largely cut [bg] | Blocked/High risk for paid; Low for free download |
| Russia | 146M / 95.6% (2025) | Win 90.91 / Apple 5.03 / Linux 4.05 | Russian (Cyrillic ЙЦУКЕН), minority languages | 152-FZ with 242-FZ localisation of Russian citizens' data [bg]; broad EU/UK/US sanctions incl. software/IT-service bans (19th pkg Oct 2025, 20th pkg Apr 2026) and payment-rail cut-off | Domestic "Astra Linux"/import-substitution policies [bg] | RUB; MIR; Visa/MC unavailable [bg] | Blocked for paid cloud; free ISO needs legal review |

### Microstates

| Country | Pop / Net% | Desktop OS | Languages | Data/legal | Payments | Rating |
|---|---|---|---|---|---|---|
| Andorra | 0.08M / 94.4% (2024) | nf | Catalan, Spanish, French | Own GDPR-aligned law, EU adequacy [bg] | EUR | Low (tiny) |
| Monaco | 0.04M / 99.0% (2024) | nf | French | Own law, GDPR-aligned [bg] | EUR | Low (tiny) |
| San Marino | 0.034M / not found | nf | Italian | GDPR-aligned [bg] | EUR | Low (tiny) |
| Vatican City | ~800 / not found | nf | Italian, Latin | Own canon-law data rules [bg] | EUR | Not a market (serve under Italy) |

## 10 most promising (narrative)
1. **Germany**: largest paying market; Linux 6.49%; Schleswig-Holstein example; SEPA direct debit; needs full German localisation.
2. **Netherlands**: Linux 7.64% (highest of those fetched); iDEAL; English-fluent.
3. **France**: April 2026 government Linux plan (secondary source); Toubon-law French UI; Carte Bancaire.
4. **Switzerland**: highest ARPU, privacy brand; non-EU (CRA not directly applicable, FADP); TWINT.
5. **Norway**: Linux 5.35%, wealthy, EEA, Vipps.
6. **Denmark**: ministry-level Linux move, sovereignty narrative; MobilePay.
7. **Spain**: Linux 5.72%, large; Bizum; co-official languages.
8. **United Kingdom**: big English-language market, 3.55% Linux; separate PSTI/UK GDPR; strong Apple/ChromeOS alternative narrative.
9. **Austria / Sweden / Finland**: grouped; high income, German/Nordic localisation reuse; Sweden Swish/Klarna.
10. **Italy**: large (59M), Linux 4.24%; no verified public-sector signal, so ranked last.
(Poland is the main volume alternative but 88.98% Windows and lower ARPU.)

## 5 most restricted
1. **Russia**: EU/UK/US sanctions, software and IT-service bans, payment rails cut, local-data law. Treat paid accounts as blocked.
2. **Belarus**: parallel EU/US sanctions on the regime and payment limits.
3. **Ukraine's occupied territories and Crimea** (sub-national): comprehensive sanctions regimes by EU/UK/US [bg]. Geo-block.
4. **Serbia / Moldova / Balkan sanctions-circumvention watch**: not sanctioned, but KYC/payment-screening scrutiny [bg, weak].
5. **United Kingdom / Switzerland (regulatory-heavy, not blocked)**: UK PSTI/Online Safety Act and Swiss FADP add compliance work without blocking; included as "high-compliance" rather than banned. Plain statement: only Russia, Belarus and occupied regions are truly blocked; others are friction, not bans.

## Cross-cutting notes
- Data point for pitch: Europe-wide desktop Linux 4.61% (Sept 2026) vs global typical 4% [bg].
- Key unknowns to commission with counsel: CRA status of a monetised open-source distro; EAA application to OS; whether sign-up must verify non-Russian residency; GDPR Art. 27 EU representative requirement for a non-EU controller (I [bg] believe it applies to an India-based provider targeting EU residents); DPO/DPIA; EU consumer rules on digital-content contracts, 14-day withdrawal and Digital Content Directive (2019/770) for paid accounts [bg].
