# Nubo Secure and Nubo Suite

Product definition: features, packaging and pricing. Internal draft. Prices as set by the founder (all quoted
**plus GST**). Items marked **Confirm** are proposals that need a decision before customers see them.

The aim is volume, and to sell the whole Suite wherever possible.

## Nubo Secure

Managed security for desktops and servers on any operating system: Nubo OS, Windows, macOS, Ubuntu and other
Linux. We watch your devices all day, protect them from malware, keep them patched and backed up, and fix
problems remotely.

| Part | Built from | Notes |
|---|---|---|
| Detection | Wazuh | |
| Investigation and response | Velociraptor | AGPL: our changes must be published |
| Automation | Shuffle | |
| Searchable log store | OpenSearch | Apache 2.0 |
| Customer console | SOCFortress CoPilot, running on OpenSearch | CoPilot is built around Graylog. Moving it to OpenSearch is development work. AGPL |
| Remote fixing | MeshCentral | Apache 2.0, white-label and multi-customer built in |
| **Nubo Shield** (antivirus) | ClamAV on Linux and macOS, Microsoft Defender managed by us on Windows | See below |
| **Nubo Backup** | Kopia | Apache 2.0 |
| **Nubo Patch** | Our playbooks (Shuffle + MeshCentral scripts + Wazuh findings) | See below |

Each open-source project keeps its own name and licence. The product is sold under the Nubo names, and we credit
the open-source parts.

### Features

| Capability | What the customer gets |
|---|---|
| **Real-time threat detection** | Every device monitored all day for attacks, suspicious logins, changed system files, malware traces and rootkits. Alerts the moment something looks wrong. |
| **Antivirus (Nubo Shield)** | Scheduled and on-demand malware scanning on Linux and macOS, with real-time scanning on Linux. On Windows, Microsoft Defender's real-time protection is kept switched on and up to date, with its alerts watched by us. |
| **Patching (Nubo Patch)** | We find missing updates (Wazuh vulnerability detection), then apply them on a schedule that suits the customer: Linux through the package manager, Windows through Windows Update and winget, macOS through the system updater. A report shows what was patched. |
| **Backup (Nubo Backup)** | Automatic encrypted backups of chosen folders, kept in the cloud, with versions so a file can be restored from before an attack. Backups are encrypted on the device before they leave it. |
| **Vulnerability and settings checks** | Software with known security holes and weak settings are listed, ranked by seriousness. |
| **Compliance reports** | Ready reports mapped to PCI DSS, HIPAA, NIST 800-53 and GDPR. |
| **Automatic first response** | Blocks an attacking address or stops a harmful process automatically. |
| **Investigation** | We collect evidence from any device, search every device for signs of the same attack, and isolate an affected machine. |
| **Automated playbooks** | Alerts are enriched, ticketed and sent to the right person. Where approved, they are acted on without waiting. |
| **One security console** | A dashboard per customer: devices, alerts, backups, patches and reports. Each customer sees only their own data. |
| **Searchable log history** | Security logs kept and searchable so any incident can be traced back. |
| **Remote fixing** | We connect to a device (desktop, terminal or files), fix the problem and keep a session log. Works on Windows, macOS and Linux. |
| **Monthly security report** | A plain-language report of what was found, fixed, patched and backed up. |

### Devices covered
Nubo OS, Windows, macOS, Ubuntu and other Linux desktops, and Linux or Windows servers.

### Honest limits
- **Windows antivirus** uses Microsoft Defender. There is no open-source Windows antivirus with real-time protection
  that we can responsibly rebrand: ClamWin is discontinued, and OpenEDR (Windows) collects telemetry and detects
  but does not block.
- **Backup** is file-level. Full-machine image restore ("bare metal") is not included. UrBackup would add it, if wanted later.
- **Patching** is our own automation, not a single off-the-shelf tool: nothing open-source patches Windows, macOS
  and Linux well together. NetLock RMM and OpenFrame list patching and could shorten the work, but their licences
  must be checked first. Tactical RMM's licence does not allow use inside a SaaS product.
- Network firewalls and email-attack filtering are not part of this product.

### Pricing
- **Rs. 4,999 + GST per month**, includes **50 devices**.
- **Each additional device: Rs. 99 + GST per month.**
- Billed monthly.

## Nubo Suite

The whole stack in one yearly plan: **Nubo Email, Nubo OS (Pro), Nubo Office and Nubo Secure.**

- **Rs. 69,999 + 18% GST per year** (Rs. 82,598.82 with GST).
- Includes **50 devices** (Nubo OS Pro, Nubo Office, Nubo Secure) and **50 Nubo Email mailboxes of 5 GB each**.
- **Each additional device: Rs. 1,199 + GST per year.**

### Price examples (without GST)

| Devices | Nubo Secure alone | Nubo Suite |
|---|---|---|
| 50 | Rs. 4,999 a month (Rs. 59,988 a year) | Rs. 69,999 a year |
| 75 | Rs. 7,474 a month (Rs. 89,688 a year) | Rs. 99,974 a year |
| 100 | Rs. 9,949 a month (Rs. 119,388 a year) | Rs. 129,949 a year |
| 150 | Rs. 14,899 a month (Rs. 178,788 a year) | Rs. 189,899 a year |

With 18% GST, 50 devices of Nubo Secure is Rs. 5,898.82 a month, and each extra device is Rs. 116.82 a month
(Nubo Secure) or Rs. 1,414.82 a year (Nubo Suite).

At 50 devices the Suite costs only Rs. 10,011 a year more than Nubo Secure alone. It adds Nubo OS Pro and Nubo
Office for 50 devices and 50 mailboxes. Bought separately, Nubo Secure plus the Nubo OS and Office bundle
(Rs. 799 per device) is Rs. 99,938 a year before email.

## Fair use (proposed, **Confirm**, to be tuned during the pilot)

| Resource | Proposed limit | Why |
|---|---|---|
| **Security logs** | Pooled across devices: about 100 MB a day per desktop and 500 MB a day per server. Above that, low-value log lines are dropped first, then the customer is offered more. | Servers write far more than laptops, and logs must be kept for 180 days |
| **Backup storage** | About 20 GB per device, pooled (1 TB for 50 devices) | Cloud storage is a running cost: roughly Rs. 600 a month per TB at current prices |
| **Backup extra storage** | Add-on, price to be set (cost is about Rs. 600 per TB a month) | |
| **Email** | 5 GB per mailbox, 50 mailboxes | As offered |
| **Server count** | A server counts as one device, within the server log limit above | |

Rough storage cost for a 50-device Suite customer: about Rs. 1,500 to 2,500 a month for backup and logs. That is
25 to 40% of the Rs. 5,833 a month the Suite brings in. These are estimates to be checked during the pilot. Cloud
storage prices used: Backblaze B2 $6.95 per TB a month, Hetzner Storage Box 8.70 EUR per TB a month, Cloudflare R2
about $15 per TB a month.

## Build work needed
1. Move CoPilot from Graylog to OpenSearch.
2. Nubo Backup: Kopia server per customer, with a portal view of backup health.
3. Nubo Patch: playbooks for Linux, Windows and macOS, with reports.
4. Nubo Shield: ClamAV packaged for Linux and macOS under our name (we publish our changes and keep the "ClamAV"
   name out of the product), a private signature mirror, and Defender management for Windows.
5. Hosting: logs for Indian customers kept in India for 180 days (CERT-In).

## Checks before launch
- ClamAV's virus signature database: confirm with Cisco/Talos that commercial use through a private mirror is allowed.
- OpenEDR, NetLock RMM and OpenFrame licence files, if we want to use any of them.
- AGPL: CoPilot and Velociraptor changes must be published to our customers.
- Quote prices the same way everywhere: Nubo Secure and Nubo Suite are plus GST; the flyers say inclusive of GST.
