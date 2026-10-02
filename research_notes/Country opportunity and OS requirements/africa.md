# Africa: market opportunity and OS-distribution requirements for Nubo OS (as of October 2026)

Method note. The web search budget for the session ran out after 5 searches, so research used 5 searches plus about 14 fetches. Items with a link were seen in this session. Items marked **(BK)** are background knowledge not verified this session; the report writer should treat them as leads to confirm, not facts. "n/v" means not verified. Population and internet-user figures come from one secondary compilation (Wikipedia, mostly ITU 2024 penetration; the population and user counts there are described as "calculated from penetration rates and external data"), so they are rounded and approximate. For Nigeria the compilation (about 94M users) conflicts with DataReportal (109M in Oct 2025); the DataReportal figure is used for Nigeria. Product context: Nubo OS is a free Ubuntu 26.04 and GNOME 50 distribution with paid cloud accounts (mail, calendar, contacts, files).

## Q1. Which African countries are credible early targets for a free desktop OS plus low-cost paid cloud account, and why?

### Takeaway
The credible first wave is South Africa, Nigeria, Egypt, Kenya, Morocco, Ghana, followed by Rwanda, Tunisia, Algeria, Senegal and Mauritius. They combine large or well-connected online populations, a functioning data-protection regime, an English, French or Arabic user base, and workable mobile-money or card payment. Desktop is a small, Windows-dominated niche everywhere (about 80 to 90 percent Windows), so volume will come from refurbished-PC owners, students, developers and Windows 10 end-of-life leftovers, not from mass retail.

### Cited Findings

**Desktop OS share (StatCounter, September 2026, desktop only)**
- Africa overall: Windows 84.44%, macOS 6.17%, Linux 5.07%, OS X 3.94%, ChromeOS 0.38% — [StatCounter Africa](https://gs.statcounter.com/os-market-share/desktop/africa). A search-result snippet quoted an August 2026 Africa page with very different numbers (Windows 51.81%, macOS 37.75%, Linux 3.8%); the direct fetch of the live page shows the September figures above. Treat the snippet as unreliable.
- South Africa: Windows 81.47%, macOS 6.78%, OS X 5.71%, Linux 5.68% — [StatCounter](https://gs.statcounter.com/os-market-share/desktop/south-africa)
- Egypt: Windows 89.55%, Linux 4.35%, macOS 3.66%, OS X 2.31% — [StatCounter](https://gs.statcounter.com/os-market-share/desktop/egypt)
- Nigeria: Windows 80.29%, Linux 8.9%, macOS 6.09%, OS X 4.15% — [StatCounter](https://gs.statcounter.com/os-market-share/desktop/nigeria)
- Kenya: Windows 83.11%, macOS 8.83%, Linux 3.82%, OS X 3.74% — [StatCounter](https://gs.statcounter.com/os-market-share/desktop/kenya)
- Morocco: Windows 84.46%, macOS 7.73%, Linux 4.69%, OS X 2.92% — [StatCounter](https://gs.statcounter.com/os-market-share/desktop/morocco)
- Ghana: Windows 79.21%, OS X 7.63%, macOS 5.60%, Linux 5.19%, ChromeOS 2.36% — [StatCounter](https://gs.statcounter.com/os-market-share/desktop/ghana)
- Caveat: StatCounter's "Linux" bucket may include some bot or Android-desktop-mode traffic and is a web-traffic measure, not an installed base (BK). Nigeria's 8.9% Linux is the highest of the six pages checked.

**Connectivity and device context**
- Nigeria: 109M internet users (45.5%) in October 2025; 165M cellular connections; 130M offline — [DataReportal Digital 2026 Nigeria](https://datareportal.com/digital-in-nigeria)
- Sub-Saharan Africa has the world's widest usage gap (about 60%); roughly 66% (820M people) live under mobile broadband coverage but do not use mobile internet; only about 25% use mobile internet on their own device; an entry-level smartphone costs about 76% of monthly income for the poorest quintile; 20GB of data costs about 14% of average monthly income — [GSMA](https://www.gsma.com/solutions-and-impact/connectivity-for-good/mobile-for-development/blog/despite-improvements-sub-saharan-africa-has-the-widest-usage-and-coverage-gaps-worldwide/)
- Population and internet-user estimates for 50 African countries (mostly ITU 2024 penetration) — [Wikipedia compilation, Dec 2025](https://en.wikipedia.org/wiki/List_of_countries_by_number_of_Internet_users). Used in the table below.

### Master country table

Column key. Pop/Users = rounded population and internet users (ITU 2024 unless a different year is shown; source: Wikipedia compilation above). OS = StatCounter desktop, Sept 2026 (Win/Linux), "n/v" if not fetched. Languages = main languages and scripts (BK throughout unless cited). DP/Local = data-protection law and localisation (BK unless cited). Other legal = telecom, VPN, shutdown, sanctions, entity rules. Public/Edu = public-sector, open-source, education signals (BK; I found no cited evidence on these in this session, see Gaps). Pay = payment feasibility (BK). Rating = High/Medium/Low/Blocked with reason.

#### North Africa (6 plus Western Sahara)

| Country | Pop / Users | OS | Languages and scripts | DP law / localisation | Other legal | Public / Edu | Payments | Rating |
|---|---|---|---|---|---|---|---|---|
| Egypt | 110M / 82M (74.6%) | Win 89.6, Linux 4.35 | Arabic (RTL, Arabic-Indic digits optional), English | PDPL Law 151/2020 with executive regulations; DPA guidance and breach templates published Jan-Feb 2026 ([TechHive](https://www.techhiveadvisory.africa/insights/bimonthly-update-on-privacy-in-africa-january-february-2026)); Malabo ratified ([Wikipedia](https://en.wikipedia.org/wiki/Malabo_Convention)); transfers need licence/permit from the Data Protection Center (BK); Egypt is cited as having localisation duties ([search summary, CIPESA/FPF context](https://fpf.org/wp-content/uploads/2025/06/June-Issue-Brief-Cross-Border-Data-Flows-in-Africa.pdf), unreadable PDF, n/v) | Content-regulation and licensing of platforms (BK); VPN use tolerated but sites blocked (BK) | Large state education digitisation (BK, n/v) | Cards plus Fawry, wallets (Vodafone Cash); EGP controls and devaluation history (BK) | High: largest Arabic market, 82M users, highest Windows share means large Windows-10-EOL pool; payment and FX friction |
| Morocco | 38M / 35M (91.2%) | Win 84.5, Linux 4.7 | Arabic, Tamazight (Tifinagh script), French, Darija | Law 09-08 (CNDP); prior authorisation for transfers (BK) | VoIP historically restricted (BK) | n/v | Cards, CMI, mobile wallets; MAD is a managed currency (BK) | High: highest penetration in Africa, French and Arabic, near EU |
| Algeria | 45M / 35M (77.4%) | n/v | Arabic, Tamazight (Tifinagh), French | Law 18-07 (ANPDP); National Data Governance Framework gazetted early 2026 ([TechHive](https://www.techhiveadvisory.africa/insights/bimonthly-update-on-privacy-in-africa-january-february-2026)); transfers need authorisation (BK) | Exam-time internet cuts in past years (BK, n/v for 2025-26); strict FX controls (BK) | n/v | International cards often unusable; dinar not convertible (BK) | Low-Medium: large online base but FX and card barriers |
| Tunisia | 12M / 9M (76.5%) | n/v | Arabic, French | Law 2004-63; 123-article replacement bill introduced early 2026 ([TechHive](https://www.techhiveadvisory.africa/insights/bimonthly-update-on-privacy-in-africa-january-february-2026)) | Decree 54 cybercrime law criticised for speech limits (BK) | Strong FOSS community (BK, n/v) | Cards limited by FX allowance (BK) | Medium: small, educated, FX friction |
| Libya | 7M / 5.7M (82%) | n/v | Arabic | No data-protection law; law expected to progress in 2026 ([TechHive](https://www.techhiveadvisory.africa/insights/bimonthly-update-on-privacy-in-africa-january-february-2026)) | OFAC Libya program (targeted, E.O. 13726) ([sanctions summary](https://sanctionslawyers.net/blog-en/ofac-sanctioned-countries-list-2026/)); split governance | n/v | Banking disrupted; cash economy (BK) | Blocked: sanctions exposure and no workable billing |
| Sudan | 46M / 8.6M (18.6%, 2017) | n/v | Arabic, English | No law; expected 2026 ([TechHive](https://www.techhiveadvisory.africa/insights/bimonthly-update-on-privacy-in-africa-january-february-2026)) | OFAC Sudan program with SDN designations ([sanctions summary](https://sanctionslawyers.net/blog-en/ofac-sanctioned-countries-list-2026/)); active war and repeated blackouts (BK) | n/v | Banking collapse; no workable billing (BK) | Blocked: sanctions, conflict, no billing |
| Mauritania | 5M / 2M (45.8%) | n/v | Arabic, French, Hassaniya | Data protection law 2017 (BK); Malabo ratified (tipped trigger country, May 2023, [Wikipedia](https://en.wikipedia.org/wiki/Malabo_Convention)) | Shutdowns during exams/elections in past (BK, n/v) | n/v | Bankily wallet (BK) | Low: small |
| Western Sahara (territory) | about 0.6M (n/v) | n/v | Arabic, Spanish, Hassaniya | Disputed; no separate regime; treat under Morocco (BK) | Territory status contested; do not list separately for sales | n/v | Moroccan rails (BK) | Low: serve via Morocco only |

#### West Africa (16)

| Country | Pop / Users | OS | Languages and scripts | DP law / localisation | Other legal | Public / Edu | Payments | Rating |
|---|---|---|---|---|---|---|---|---|
| Nigeria | 228M / 109M (45.5%, Oct 2025, [DataReportal](https://datareportal.com/digital-in-nigeria)) | Win 80.3, Linux 8.9 | English, Pidgin, Hausa, Yoruba, Igbo (Latin with tone marks; Ajami optional) | NDPA 2023, ss. 41-43 limit transfers to adequate countries, safeguards or consent ([search summary of CIPESA/CIPIT](https://cipit.strathmore.edu/navigating-the-crossroads-the-challenges-of-cross-border-data-flows-under-domestic-laws-in-africa/)); NDPC enforcement drive in education sector and probes of e-commerce cross-border transfers early 2026 ([TechHive](https://www.techhiveadvisory.africa/insights/bimonthly-update-on-privacy-in-africa-january-february-2026)); CBN requires domestic card transactions to be switched locally | Nigeria had at least one shutdown in 2025 ([Access Now](https://www.accessnow.org/press-release/resilience-and-resistance-internet-shutdowns-in-africa-in-2025/)); NDPC registration for "data controllers of major importance" (BK) | n/v | Cards, Paystack/Flutterwave, bank transfer, USSD; naira volatility and past FX restrictions (BK) | High: largest market, highest Linux share, English; price in naira, FX risk |
| Ghana | 34M / 25M (72.2%) | Win 79.2, Linux 5.2, ChromeOS 2.4 | English, Akan/Twi, Ewe, Ga, Hausa | DPA 2012 (Act 843), Data Protection Commission; new fee schedule from Feb 2026 and a new bill in progress ([TechHive](https://www.techhiveadvisory.africa/insights/bimonthly-update-on-privacy-in-africa-january-february-2026)); registration of controllers (BK) | Not on the 2025 shutdown list ([Access Now](https://www.accessnow.org/press-release/resilience-and-resistance-internet-shutdowns-in-africa-in-2025/)) | n/v | MTN MoMo, Telecel Cash, cards, Paystack (BK) | High: English, stable, high penetration, mobile money |
| Senegal | 18M / 11M (60.1%) | n/v | French, Wolof, Pulaar (Latin; Wolofal/Ajami optional) | Law 2008-12, CDP; Malabo ratified ([Wikipedia](https://en.wikipedia.org/wiki/Malabo_Convention)) | Past shutdowns in 2023-24 unrest (BK, n/v) | n/v | Wave and Orange Money (BK); XOF pegged to euro | Medium: Francophone hub, strong mobile money |
| Cote d'Ivoire | 28M / 12M (41.4%) | n/v | French, Dioula | Law 2013-450 (ARTCI) (BK) | n/v | n/v | Orange/MTN/Wave, XOF | Medium |
| Benin | 13M / 4.4M (34%) | n/v | French, Fon, Yoruba | Digital Code 2017; Malabo ratified | n/v | n/v | MTN/Moov, XOF | Low-Medium |
| Togo | 9M / 3.6M (39.5%) | n/v | French, Ewe, Kabiye | Law 2019-014 (BK); shutdowns in 2025 ([Access Now](https://www.accessnow.org/press-release/resilience-and-resistance-internet-shutdowns-in-africa-in-2025/)) | Shutdown history | n/v | T-Money/Flooz, XOF | Low |
| Burkina Faso | 23M / 6.5M (28.3%) | n/v | French, Moore, Dioula | Law 001-2021 (BK) | Junta rule, media restrictions (BK) | n/v | Orange Money, XOF | Low |
| Mali | 23M / 8.5M (36.8%) | n/v | French, Bambara | Law 2013-015 (BK) | OFAC Mali program is list-based only ([summary](https://sanctionslawyers.net/blog-en/ofac-sanctioned-countries-list-2026/)); junta, conflict | n/v | Orange Money, XOF | Low: conflict, targeted sanctions |
| Niger | 28M / 11M (39.5%, 2025) | n/v | French, Hausa, Zarma | Law 2022-059; Malabo ratified | Junta; ECOWAS tensions (BK) | n/v | Airtel/Orange, XOF | Low |
| Guinea | 13M / 4.3M (33.3%) | n/v | French, Fula, Malinke | Law 2016 (BK); shutdown in 2025 ([Access Now](https://www.accessnow.org/press-release/resilience-and-resistance-internet-shutdowns-in-africa-in-2025/)) | Shutdown history | n/v | Orange Money, GNF volatile | Low |
| Guinea-Bissau | 2M / 0.6M (29.8%) | n/v | Portuguese, Kriol | Malabo ratified; domestic law n/v; shutdown in 2025 ([Access Now](https://www.accessnow.org/press-release/resilience-and-resistance-internet-shutdowns-in-africa-in-2025/)) | Coup/instability | n/v | XOF | Low |
| Sierra Leone | 8.6M / 2.2M (25.1%) | n/v | English, Krio | No comprehensive law; expected 2026 ([TechHive](https://www.techhiveadvisory.africa/insights/bimonthly-update-on-privacy-in-africa-january-february-2026)) | n/v | n/v | Orange/Afrimoney, SLE | Low |
| Liberia | 5M / 1.7M (32.2%) | n/v | English | No law; expected 2026 (same source) | n/v | n/v | MTN MoMo, USD widely used | Low |
| Gambia | 2.4M / 1.2M (49.5%) | n/v | English, Mandinka, Wolof | Malabo ratified; domestic law n/v | n/v | n/v | Wave, Afrimoney | Low |
| Cabo Verde | 0.6M / 0.4M (74.7%) | n/v | Portuguese, Kriolu | Law 2001, updated (BK) | n/v | n/v | Cards, ECV pegged to euro | Low: tiny but connected |
| Mauritania | see North | | | | | | | |

#### Central Africa (9)

| Country | Pop / Users | OS | Languages | DP law / localisation | Other legal | Public / Edu | Payments | Rating |
|---|---|---|---|---|---|---|---|---|
| DR Congo | 95M / 19M (19.7%) | n/v | French, Lingala, Swahili, Kikongo, Tshiluba | Digital Code 2023 (BK); OFAC DRC list-based only ([summary](https://sanctionslawyers.net/blog-en/ofac-sanctioned-countries-list-2026/)) | Shutdown in Goma 2025 ([Access Now](https://www.accessnow.org/press-release/resilience-and-resistance-internet-shutdowns-in-africa-in-2025/)); eastern conflict | n/v | M-Pesa, Airtel; USD and CDF dual use (BK) | Low |
| Cameroon | 28M / 13M (46.3%) | n/v | French, English | Law (2024) (BK, n/v) | Shutdown(s) in 2025 ([Access Now](https://www.accessnow.org/press-release/resilience-and-resistance-internet-shutdowns-in-africa-in-2025/)); Anglophone-region history | n/v | MTN/Orange, XAF | Low-Medium |
| Chad | 18M / 2.3M (12.6%) | n/v | French, Arabic | Law 2015; Malabo ratified | Shutdowns 2025 (Access Now, same) | n/v | XAF | Low |
| Central African Rep. | 5.6M / 0.8M (13.8%) | n/v | French, Sango | n/v; OFAC list-based ([summary](https://sanctionslawyers.net/blog-en/ofac-sanctioned-countries-list-2026/)) | Shutdowns 2025 (Access Now) | n/v | XAF | Blocked-ish: Low, targeted sanctions screening needed |
| Republic of Congo | 6M / 2.9M (47.3%) | n/v | French | Law 2019; DPA inaugurated Jan 2026 ([TechHive](https://www.techhiveadvisory.africa/insights/bimonthly-update-on-privacy-in-africa-january-february-2026)); Malabo ratified | n/v | n/v | XAF | Low |
| Gabon | 2.4M / 1.6M (68.7%) | n/v | French | Law 2011; plans to ratify Malabo; stricter DPA oversight (TechHive) | n/v | n/v | XAF | Low |
| Equatorial Guinea | 1.7M / 1.1M (63.3%) | n/v | Spanish, French, Portuguese | n/v | Restrictions on Annobon, listed in 2025 shutdowns ([Access Now](https://www.accessnow.org/press-release/resilience-and-resistance-internet-shutdowns-in-africa-in-2025/)) | n/v | XAF | Low |
| Sao Tome and Principe | about 0.2M (n/v) | n/v | Portuguese | Malabo ratified; law 2016 (BK) | n/v | n/v | STN | Low |
| Burundi | 14M / 1.2M (8.6%) | n/v | Kirundi, French | Data Protection Law adopted 15 Jan 2026 ([TechHive](https://www.techhiveadvisory.africa/insights/bimonthly-update-on-privacy-in-africa-january-february-2026)) | n/v | n/v | Lumicash, BIF controls | Low |

Note: Angola, Rwanda, Burundi are sometimes classed as Central or Southern/East; placed where common in AU/UN usage below.

#### East Africa (14)

| Country | Pop / Users | OS | Languages and scripts | DP law / localisation | Other legal | Public / Edu | Payments | Rating |
|---|---|---|---|---|---|---|---|---|
| Kenya | 54M / 19M (35%, ITU 2024; other sources higher, n/v) | Win 83.1, macOS 8.8, Linux 3.8 | English, Swahili (Latin) | DPA 2019, ss. 48-49; new cross-border guidance (Sept 2026): adequacy, SCCs/BCRs, necessity or consent; cloud access from abroad counts as transfer; strategic-interest data (civil registration, elections, public finance, education, health) needs one serving copy in Kenya ([Cova Africa](https://www.covafrica.com/2026/09/kenya-issues-new-cross-border-data-transfer-guidance-familiar-concepts-but-important-local-differences/)); 110+ ODPC decisions in 2025 ([TechHive](https://www.techhiveadvisory.africa/insights/bimonthly-update-on-privacy-in-africa-january-february-2026)); processors must register with ODPC (BK) | Shutdown(s) in 2025 ([Access Now](https://www.accessnow.org/press-release/resilience-and-resistance-internet-shutdowns-in-africa-in-2025/)) | Digital Literacy Programme school devices (BK, n/v) | M-Pesa (Daraja API), cards, Airtel Money; KES stable (BK) | High: best mobile-money billing, English and Swahili, active regulator; keep cloud copy or SCCs |
| Tanzania | 62M / 19M (31.2%) | n/v | Swahili, English | PDPA 2022; all controllers/processors must register with PDPC by 8 Apr 2026, audits to follow ([TechHive](https://www.techhiveadvisory.africa/insights/bimonthly-update-on-privacy-in-africa-january-february-2026)); Bank of Tanzania bars mission-critical financial systems offshore ([search summary](https://cipesa.org/wp-content/files/publications/Brief-Which-Way-for-Data-Localisation-in-Africa.pdf)) | 8 shutdowns in 2025 incl. 2 at elections ([Access Now](https://www.accessnow.org/press-release/resilience-and-resistance-internet-shutdowns-in-africa-in-2025/)); online-content licensing (BK) | n/v | M-Pesa, Tigo Pesa, Airtel | Medium-Low: Swahili market but shutdown and registration risk |
| Uganda | 48M / 4.3M (8.95%, ITU 2024; looks low, n/v) | n/v | English, Luganda, Swahili | DPPA 2019; localisation via sector laws ([CIPESA summary](https://cipesa.org/wp-content/files/publications/Brief-Which-Way-for-Data-Localisation-in-Africa.pdf)) | Facebook blocked fifth consecutive year ([Access Now](https://www.accessnow.org/press-release/resilience-and-resistance-internet-shutdowns-in-africa-in-2025/)) | n/v | MTN MoMo, Airtel | Low-Medium |
| Ethiopia | 125M / 27M (21.4%) | n/v | Amharic, Oromo, Tigrinya (Ge'ez/Fidel script needs fonts and input), English | Personal Data Protection Proclamation 1321/2024 (BK); localisation via financial laws ([CIPESA summary](https://cipesa.org/wp-content/files/publications/Brief-Which-Way-for-Data-Localisation-in-Africa.pdf)) | Shutdowns recorded in 2025 ([Access Now](https://www.accessnow.org/press-release/resilience-and-resistance-internet-shutdowns-in-africa-in-2025/)); strict FX controls, telecom licensing (BK) | n/v | Telebirr; birr scarce, cards hard (BK) | Low-Medium: huge population, Ge'ez needs, FX and shutdown risk |
| Rwanda | 14M / 4.4M (31.7%) | n/v | Kinyarwanda, English, French | Law 058/2021, NCSA; Central Bank rules require banks' primary data inside Rwanda ([summary](https://cipesa.org/wp-content/files/publications/Brief-Which-Way-for-Data-Localisation-in-Africa.pdf)); transfer authorisation (BK) | Not in 2025 shutdown list | Strong state digital agenda, Digital Ambassadors, Canal Box devices (BK, n/v) | MTN MoMo, Airtel, cards | Medium-High: policy-friendly, small |
| Somalia | 18M / 5M (27.9%) | n/v | Somali, Arabic | Data protection act 2023 (BK, n/v) | OFAC Somalia program (Al-Shabaab, arms) ([summary](https://sanctionslawyers.net/blog-en/ofac-sanctioned-countries-list-2026/)) | n/v | EVC Plus, Hormuud mobile money; USD | Blocked-ish: Low, sanctions screening and weak banking |
| South Sudan | 11M / 0.7M (6.67%, 2019) | n/v | English, Arabic | No law; expected 2026 ([TechHive](https://www.techhiveadvisory.africa/insights/bimonthly-update-on-privacy-in-africa-january-february-2026)) | OFAC South Sudan program ([summary](https://sanctionslawyers.net/blog-en/ofac-sanctioned-countries-list-2026/)); shutdown 2025 ([Access Now](https://www.accessnow.org/press-release/resilience-and-resistance-internet-shutdowns-in-africa-in-2025/)) | n/v | Cash, severe inflation | Blocked |
| Eritrea | 6M / 0.9M (14.3%, 2020) | n/v | Tigrinya, Arabic, English | No law n/v | Single state telecom, tight control (BK) | n/v | No international cards (BK) | Blocked: no workable access or billing (BK) |
| Djibouti | 1.1M / 0.7M (65.3%) | n/v | French, Arabic, Somali, Afar | Law 2022 (BK); developing AI strategy ([TechHive](https://www.techhiveadvisory.africa/insights/bimonthly-update-on-privacy-in-africa-january-february-2026)) | State telecom monopoly (BK) | n/v | DJF pegged to USD | Low |
| Madagascar | 30M / 5.6M (18.7%) | n/v | Malagasy, French | Law 2014-038 (BK) | n/v | n/v | Mvola, Orange Money; MGA | Low |
| Comoros | 0.9M / 0.3M | n/v | Comorian, Arabic, French | n/v | n/v | n/v | KMF pegged to euro | Low |
| Mauritius | 1.3M / 1.0M (73.3%) | n/v | English, French, Creole | DPA 2017, amendment under way; National Data Strategy 2025-29; fine for photo sharing without consent up to MUR 200,000 ([TechHive](https://www.techhiveadvisory.africa/insights/bimonthly-update-on-privacy-in-africa-january-february-2026)) | n/v | n/v | Cards, juice wallet (BK) | Medium: small but easy compliance, hosting hub |
| Seychelles | about 0.1M (n/v) | n/v | English, French, Creole | DPA 2023 (BK) | n/v | n/v | Cards | Low |
| Malawi | 20M / 3.8M (19%) | n/v | English, Chichewa | DPA 2024 (BK) | draft national AI/digital strategies ([TechHive](https://www.techhiveadvisory.africa/insights/bimonthly-update-on-privacy-in-africa-january-february-2026)); FX shortages (BK) | n/v | Airtel Money, TNM Mpamba | Low |

#### Southern Africa (9 plus Malawi/Madagascar above)

| Country | Pop / Users | OS | Languages and scripts | DP law / localisation | Other legal | Public / Edu | Payments | Rating |
|---|---|---|---|---|---|---|---|---|
| South Africa | 60M / 47M (78.4%) | Win 81.5, Linux 5.7, macOS 6.8 | English, Afrikaans, isiZulu, isiXhosa, Sesotho, Setswana and 11 official languages (Latin; click consonants need correct input and fonts) | POPIA with s.72 transfer rules (adequate protection, consent or contract); Information Regulator running compliance monitoring (14-day demands) and leading SADC DPA bloc ([TechHive](https://www.techhiveadvisory.africa/insights/bimonthly-update-on-privacy-in-africa-january-february-2026)); has not ratified Malabo ([DataGuidance via search](https://www.dataguidance.com/jurisdictions/african-bodies)) | No 2025 shutdowns ([Access Now](https://www.accessnow.org/press-release/resilience-and-resistance-internet-shutdowns-in-africa-in-2025/)); load-shedding affects offline-first needs (BK) | Mature Linux and FOSS community, state FOSS policy history (BK, n/v) | Cards (Visa/MC), Peach/PayFast, ZAR convertible but volatile | High: best infrastructure, highest card access, English, highest Linux share among large markets bar Nigeria |
| Zambia | 20M / 3.4M (17.1%) | n/v | English, Bemba, Nyanja | Data Protection Act 2021; Malabo ratified | n/v | n/v | MTN/Airtel, ZMW volatile | Low |
| Zimbabwe | 16M / 6.7M (41.6%) | n/v | English, Shona, Ndebele | Cyber and Data Protection Act 2021; National AI Strategy 2026-30 ([TechHive](https://www.techhiveadvisory.africa/insights/bimonthly-update-on-privacy-in-africa-january-february-2026)) | OFAC Zimbabwe program, SDN designations only ([summary](https://sanctionslawyers.net/blog-en/ofac-sanctioned-countries-list-2026/)); FX and cash controls (BK) | n/v | EcoCash, USD | Low-Medium |
| Mozambique | 35M / 7.2M (20.5%) | n/v | Portuguese, Emakhuwa | No general law; expected 2026; Cloud Computing Regulations published with licensing and registration ([TechHive](https://www.techhiveadvisory.africa/insights/bimonthly-update-on-privacy-in-africa-january-february-2026)) | Cloud registration could apply to hosting | n/v | M-Pesa (Vodacom), mKesh | Low-Medium: Portuguese localisation, cloud rules |
| Angola | 33M / 13M (40.7%) | n/v | Portuguese | Law 22/11 (BK); Malabo ratified | First-ever shutdown July 2025 ([Access Now](https://www.accessnow.org/press-release/resilience-and-resistance-internet-shutdowns-in-africa-in-2025/)); FX controls (BK) | n/v | Multicaixa; kwanza not freely convertible (BK) | Low-Medium: Portuguese |
| Namibia | 2.7M / 1.8M (64.9%) | n/v | English, Afrikaans, Oshiwambo | No law; expected 2026 ([TechHive](https://www.techhiveadvisory.africa/insights/bimonthly-update-on-privacy-in-africa-january-february-2026)); Malabo ratified | n/v | n/v | Cards, pegged to ZAR | Medium: small, connected, tied to ZAR |
| Botswana | 2.6M / 1.5M (57.5%) | n/v | English, Setswana | DPA 2024 (BK) | n/v | n/v | Cards, Orange Money | Low-Medium |
| Lesotho | 2.3M / 1.2M (51.8%) | n/v | Sesotho, English | DPA 2011; Malabo ratified | n/v | n/v | M-Pesa, ZAR-linked | Low |
| Eswatini | 1.2M / 0.8M (63.4%) | n/v | siSwati, English | DPA 2022; data-mapping deadline 31 Mar 2026 ([TechHive](https://www.techhiveadvisory.africa/insights/bimonthly-update-on-privacy-in-africa-january-february-2026)) | n/v | n/v | MTN MoMo, ZAR-linked | Low |
| Malawi, Madagascar | see East | | | | | | | |

Counting check: this table set lists 54 sovereign states plus Western Sahara. Northern 7 (Egypt, Morocco, Algeria, Tunisia, Libya, Sudan, Mauritania counted as West/North; listed under North), West 15 (incl. Cabo Verde), Central 9 incl. Burundi, East 14 incl. Islands, Southern 9 and Malawi, Madagascar under East. A strict one-row-per-country audit by the report writer is recommended; Mauritania appears once in the data and as a pointer row in West.

### Inferences
- Rank for first launch (my judgement from cited and BK data): 1 South Africa, 2 Nigeria, 3 Kenya, 4 Egypt, 5 Morocco, 6 Ghana, 7 Rwanda, 8 Mauritius. Francophone West (Senegal, Cote d'Ivoire) is a second wave once French UI and XOF mobile money billing exist.
- Linux share is highest in Nigeria (8.9%) and South Africa (5.7%) among large markets, consistent with active developer and student communities, but all percentages are web-traffic proxies.
- Windows 10 end-of-support (October 2025, BK) leaves many older, low-spec PCs that cannot upgrade to Windows 11; this is a plausible entry hook, not verified for Africa.

### Gaps
- Per-country StatCounter pages for 48 countries not fetched.
- Population/internet-user figures are a single secondary compilation with partly calculated numbers; Kenya and Uganda looked low versus other sources I did not check. Seychelles, Sao Tome, Western Sahara have no verified figure.
- Public-sector, education, refurbished-PC programmes: search budget exhausted, nothing cited.
- Data-protection laws marked BK need checking against DLA Piper, DataGuidance or the AU Data Hub.

## Q2. What local requirements change the product (languages, low bandwidth and offline, low-end hardware, mobile-money billing)?

### Takeaway
Language and script support, strongly offline-tolerant sync, light-weight sessions for older PCs, and local billing rails (M-Pesa, MTN MoMo, Orange Money, Wave) matter more than any single legal rule. Legal impact is mainly on where mail and files are hosted and who is registered as controller or processor.

### Cited Findings
- Only about 25% of Sub-Saharan Africans use mobile internet on their own device and data is costly (20GB is about 14% of monthly income) — [GSMA](https://www.gsma.com/solutions-and-impact/connectivity-for-good/mobile-for-development/blog/despite-improvements-sub-saharan-africa-has-the-widest-usage-and-coverage-gaps-worldwide/). Implication for a cloud product: delta sync, resumable downloads, small update packages.
- Sub-Saharan Africa holds over half of global mobile-money accounts (1.2B registered across SSA and North Africa in 2025) and 66% of global transaction value, but almost 75% of accounts are inactive monthly; transaction taxes push users back to cash — [Connecting Africa/GSMA](https://www.connectingafrica.com/mobile-money/-1-4t-flowed-through-mobile-money-in-sub-saharan-africa-in-2025-gsma), [WeeTracker](https://weetracker.com/2026/03/30/mobile-money-africa-inactivity-gsma-report-2026/)
- Kenya: cloud access from abroad counts as a cross-border transfer; onward transfers for the recipient's own marketing or analytics are prohibited; strategic-interest data (education, health etc.) needs a serving copy in Kenya — [Cova Africa](https://www.covafrica.com/2026/09/kenya-issues-new-cross-border-data-transfer-guidance-familiar-concepts-but-important-local-differences/)
- Nigeria's CBN requires domestic card payments to be switched locally, so a local card-payment aggregator is needed rather than offshore routing — [CIPIT summary](https://cipit.strathmore.edu/navigating-the-crossroads-the-challenges-of-cross-border-data-flows-under-domestic-laws-in-africa/)
- Mozambique published Cloud Computing Regulations (registration, licensing) — [TechHive](https://www.techhiveadvisory.africa/insights/bimonthly-update-on-privacy-in-africa-january-february-2026)
- Tanzania requires controller/processor registration by 8 April 2026 — [TechHive](https://www.techhiveadvisory.africa/insights/bimonthly-update-on-privacy-in-africa-january-february-2026)

### Inferences
- Language packs priority (BK for scripts): Arabic with RTL and Arabic-language fonts; French; Swahili; Hausa, Yoruba, Igbo with tone-mark input; Amharic/Ge'ez (Fidel) with font and input method; Tifinagh for Moroccan/Algerian Tamazight; Afrikaans and Zulu/Xhosa for South Africa; Portuguese for Angola and Mozambique. Noto fonts cover most of these in Ubuntu.
- Offline-first sync, low-RAM mode (older 4GB machines), and local mirrors or CDN nodes (Cape Town, Lagos, Nairobi, Cairo; BK) would matter for update delivery.
- Billing: Kenya, Tanzania, DRC, Mozambique via M-Pesa; Ghana, Uganda, Rwanda, Zambia via MTN MoMo; Francophone West via Orange Money and Wave; use a regional aggregator (Paystack, Flutterwave, Stripe-equivalents; BK) rather than direct integrations. Offer prepaid monthly/annual vouchers and local-currency prices, as many users lack international cards.
- Hosting: store data in the EU or India under SCCs works for most DP laws on consent/safeguards, but for Kenya (education/health) and Rwanda/Nigeria financial contexts a local or regional node may be needed. A South African or Kenyan region would cover most of East and Southern Africa.

### Gaps
- No verified data on refurbished-PC programmes, hardware type approval (only relevant if bundling devices), or per-country VPN/encryption rules; search budget exhausted.
- Mobile-money coverage per country is BK.

## Q3. Where is distribution or payment blocked or high risk?

### Takeaway
Sudan, South Sudan, Libya, Eritrea and Somalia are effectively blocked (sanctions programmes, conflict, no workable payment or banking). Several countries are medium-high risk because of internet shutdowns (Tanzania, Ethiopia, Uganda, Cameroon, Togo, Chad, Guinea) or FX controls (Egypt, Nigeria, Ethiopia, Algeria, Malawi, Zimbabwe, Angola).

### Cited Findings
- OFAC maintains selective programmes for the Central African Republic, DRC, Libya, Mali, Somalia, South Sudan and Sudan; CAR, DRC and Mali are list-based with no country-wide ban; Zimbabwe also has targeted SDN designations — [sanctionslawyers.net](https://sanctionslawyers.net/blog-en/ofac-sanctioned-countries-list-2026/). Secondary law-firm source; confirm on [OFAC](https://ofac.treasury.gov/) before relying on it.
- Africa had 30 shutdowns in 15 countries in 2025 (Angola, Cameroon, CAR, Chad, DRC, Equatorial Guinea, Ethiopia, Guinea, Guinea-Bissau, Kenya, Nigeria, South Sudan, Tanzania, Togo, Uganda); Tanzania had 8, Angola's first in July 2025; Uganda blocked Facebook for a fifth year — [Access Now](https://www.accessnow.org/press-release/resilience-and-resistance-internet-shutdowns-in-africa-in-2025/), [Access Now 2025 report summary](https://www.accessnow.org/press-release/rising-and-resisting-in-the-darkness-internet-shutdowns-in-2025/)
- Countries with no data-protection law as of early 2026 (laws expected during 2026): Liberia, Libya, Mozambique, Namibia, Sierra Leone, South Sudan, Sudan; Burundi adopted one in January 2026 — [TechHive](https://www.techhiveadvisory.africa/insights/bimonthly-update-on-privacy-in-africa-january-february-2026)
- Malabo Convention entered into force 8 June 2023 after 15 ratifications incl. Angola, Benin, Chad, Congo, Egypt, Gabon (planned later per TechHive), Gambia, Guinea-Bissau, Lesotho, Mauritania, Namibia, Niger, Sao Tome, Senegal, Zambia; South Africa has not ratified — [Wikipedia](https://en.wikipedia.org/wiki/Malabo_Convention), [DataGuidance](https://www.dataguidance.com/jurisdictions/african-bodies). The search summary listed Gabon among the 15, while TechHive says Gabon "announced plans to ratify"; this conflict is unresolved. Africa had about 45 data-protection laws by early 2026 (TechHive).

### Inferences
- Exposure for a free OS is low (a free download is generally not a sanctioned "export"), but accepting payments or serving cloud accounts in Sudan, South Sudan, Libya, Somalia and Eritrea should be geo-blocked at signup; for DRC, CAR, Mali and Zimbabwe run SDN screening on paying customers. India's own export rules and US-sourced components in Ubuntu are separate checks not researched here.
- Shutdown-heavy countries need offline-capable mail clients (IMAP caching, local calendar) so paid accounts remain usable.

### Gaps
- Per-country VPN, encryption-import and telecom-licence rules not verified (BK: Ethiopia and Egypt block or throttle VPN/Tor at times; Algeria has exam-time shutdowns; none cited).
- Whether Eritrea has any consumer payment channel: not verified.

## Narrative notes for the 8 most promising countries (judgement, built on the findings above)

1. **South Africa**: 47M users (78%), English plus Afrikaans/Zulu, POPIA is clear and enforced, card payments work, StatCounter Linux 5.7%. Risks: load-shedding, strong Windows/ChromeOS incumbency. Best launch market.
2. **Nigeria**: 109M users, 80% Windows with 8.9% Linux, English plus Hausa, Yoruba, Igbo; NDPA active enforcement and local card-switching rules; naira volatility. Price locally, use a Nigerian processor.
3. **Kenya**: M-Pesa, English and Swahili, vocal developer community; ODPC strict on cross-border transfer and processor registration; 2025 shutdown episode; new Sept 2026 guidance means a legal review of hosting location.
4. **Egypt**: 82M users, 89.6% Windows, Arabic RTL; PDPL and Data Protection Center licensing; FX friction; Malabo ratified.
5. **Morocco**: 91% penetration, Arabic, French, Tifinagh; Law 09-08 authorisation; EU proximity enables hosting in Europe or a Moroccan region.
6. **Ghana**: stable, English, 72% penetration, Linux 5.2% and ChromeOS 2.4%; DPC fees and registration; MoMo.
7. **Rwanda**: small but pro-digital government, English/French/Kinyarwanda, localisation for banks; good pilot for education and refurbished-device bundles (BK, n/v).
8. **Mauritius / Senegal tie**: Mauritius for easy compliance and hosting hub; Senegal for Francophone West entry (Wave, Orange Money; Malabo party).

## Most restricted or high-risk countries
- **Sudan, South Sudan, Libya, Somalia, Eritrea**: sanctions programmes (all but Eritrea), conflict or state telecom control, no data-protection law in Sudan, South Sudan and Libya, and unworkable billing. Treat as Blocked for paid accounts.
- **Tanzania, Ethiopia, Uganda, Cameroon, Togo, Chad, Guinea**: recurrent shutdowns, content blocking, or registration/FX hurdles; serviceable but high operational risk.
- **Mali, Burkina Faso, Niger, CAR, DRC**: conflict and junta governance; Mali, CAR, DRC under list-based OFAC programmes.
- **Algeria, Egypt, Nigeria, Ethiopia, Malawi, Zimbabwe, Angola**: currency-convertibility or card-acceptance constraints for a paid account.
