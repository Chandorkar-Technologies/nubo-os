# Nubo Secure and Nubo Suite

Product definition: features, packaging and pricing. Internal draft for review. Prices as set by the founder;
items marked **Confirm** are assumptions that need a decision before this is shown to customers.

## Nubo Secure

Managed security for desktops and servers on any operating system: Nubo OS, Windows, macOS, Ubuntu and other
Linux. We watch your devices all day, investigate alerts, and fix problems remotely.

Built from: Wazuh (detection), Velociraptor (investigation and response), Shuffle (automation), OpenSearch
(searchable security logs), SOCFortress CoPilot (one console for every customer) and MeshCentral (remote
fixing), under the Nubo Secure name and the Nubo portal. Each open-source tool keeps its own name and licence.

### Features

| Capability | What the customer gets | Powered by |
|---|---|---|
| **Real-time threat detection** | Every device is monitored around the clock for attacks, suspicious logins, malware traces, changed system files and rootkits. Alerts are raised the moment something looks wrong. | Wazuh |
| **Vulnerability detection** | Finds installed software with known security holes, ranked by seriousness. | Wazuh |
| **Configuration checks** | Checks devices against security benchmarks and flags weak settings. | Wazuh |
| **Compliance reports** | Ready reports mapped to PCI DSS, HIPAA, NIST 800-53 and GDPR. | Wazuh |
| **Automatic first response** | Blocks an attacking address or stops a harmful process automatically, before a person is involved. | Wazuh active response |
| **Investigation** | We collect evidence from any device, search every device for signs of the same attack, and isolate an affected machine. | Velociraptor |
| **Automated playbooks** | Alerts are enriched with threat information, ticketed, sent to the right person and, where approved, acted on without waiting. | Shuffle |
| **One security console** | A dashboard per customer: devices, alerts, incidents and reports. Each customer sees only their own data. | CoPilot |
| **Searchable log history** | Security logs stored and searchable so any incident can be traced back. | OpenSearch |
| **Remote fixing** | Our engineers connect to a device (desktop, terminal or files), fix the problem and leave a session log. Works on Windows, macOS and Linux. | MeshCentral |
| **Monthly security report** | A plain-language report of what was found, what was fixed and what needs attention. | Nubo Secure |

### Devices covered
Nubo OS, Windows, macOS, Ubuntu and other Linux desktops, and Linux or Windows servers.

### Not included in this tool list (decide whether to add)
- **Backups.** None of these six tools backs up data. An add-on built on restic is the natural fit.
- **Antivirus on Windows.** Wazuh detects and responds but is not an antivirus engine. It can use the Windows built-in protection.
- **Patch management.** Wazuh finds what is out of date. Updates are applied by script through MeshCentral, with no dedicated patching tool. (Tactical RMM would be one, but its licence forbids use inside a SaaS product.)
- **Network firewall and email security.**

### Service levels (proposed, **Confirm**)
- Detection and automatic first response: 24 hours a day, every day.
- Human review and remote fixing: business hours, with a stated response time per severity.
- 24-hour human cover: through a partner, as a later higher tier.
- Incident reporting help: we support customers in reporting to CERT-In within the 6 hours it requires.

### Pricing
- **Rs. 4,999 + GST per month**, includes **75 devices**.
- **Each additional device: Rs. 99 + GST per month.**
- Billed monthly.

## Nubo Suite

Everything for the organisation in one yearly plan: **Nubo Email, Nubo OS (Pro), Nubo Office and Nubo Secure**.

- **Rs. 69,999 + 18% GST per year**, which is Rs. 82,598.82 with GST.
- **Each additional device: Rs. 1,199 + GST per year** (Nubo OS Pro, Nubo Office and Nubo Secure for that device).
- Number of devices included: **75 (Confirm)**. Number of Nubo Email mailboxes included: **Confirm**.

### Price examples (without GST)

| Devices | Nubo Secure alone | Nubo Suite |
|---|---|---|
| 75 | Rs. 4,999 a month (Rs. 59,988 a year) | Rs. 69,999 a year |
| 100 | Rs. 7,474 a month (Rs. 89,688 a year) | Rs. 99,974 a year |
| 150 | Rs. 12,424 a month (Rs. 149,088 a year) | Rs. 159,924 a year |

With 18% GST: Nubo Secure for 75 devices is Rs. 5,898.82 a month; an extra device is Rs. 116.82 a month (Nubo Secure)
or Rs. 1,414.82 a year (Nubo Suite).

## Decisions needed before launch
1. **Suite versus the separate prices.** At 75 devices, buying the products separately costs about Rs. 119,913 a year
   (Nubo Secure Rs. 59,988 plus the Nubo OS + Office bundle at Rs. 799 per device, Rs. 59,925), without email. Nubo Suite at
   Rs. 69,999 is 42% less and adds only Rs. 10,011 to the cost of Nubo Secure alone. Intentional? If yes, it pushes
   everyone to the Suite.
2. **What counts as a device.** A server produces much more log data than a laptop. Suggest a fair-use limit per device
   and a higher price or cap for busy servers.
3. **CoPilot depends on Graylog.** CoPilot is built around Graylog, whose SSPL licence is risky for a hosted service.
   Replacing it with OpenSearch needs development work.
4. **AGPL.** CoPilot and Velociraptor are AGPL. Rebranding them means publishing our changed source to our customers.
5. **Hosting in India.** CERT-In requires 180 days of logs kept in India. Our current servers are in Europe.
6. **GST wording.** The flyers show prices including GST; Nubo Secure and Nubo Suite are quoted plus GST. Pick one way
   to quote and use it everywhere.
7. **Staffing.** At Rs. 4,999 a month, one engineer (assume Rs. 60,000 a month all-in) is covered by 12 customers.
   Decide how many customers one engineer can safely look after.
