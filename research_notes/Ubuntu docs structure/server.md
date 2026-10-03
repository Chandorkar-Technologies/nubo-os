# Ubuntu Server documentation: structure study for Nubo OS

Research date: 2026-10-03. Method: WebFetch only. Page text is summarised by a small model, so titles are reliable but layout details (admonitions, exact headings) are approximate. Nothing is copied from source pages.

## 0. Sources and load status

Loaded OK:
- https://ubuntu.com/server/docs/ (documentation.ubuntu.com/server/ 301-redirects here; so do /how-to/, /explanation/, /reference/, /tutorial/)
- https://ubuntu.com/server/docs/how-to/
- https://ubuntu.com/server/docs/explanation/
- https://ubuntu.com/server/docs/reference/
- https://ubuntu.com/server/docs/tutorial/
- https://ubuntu.com/server/docs/tutorial/basic-installation/
- https://ubuntu.com/server/docs/reference/glossary/
- https://ubuntu.com/server/docs/how-to/networking/serve-ntp-with-chrony/ (pattern sample)
- https://ubuntu.com/server/docs/system-requirements/ (only a redirect stub)
- https://canonical-subiquity.readthedocs-hosted.com/ (installer/autoinstall landing + nav)
- https://canonical-subiquity.readthedocs-hosted.com/en/latest/reference/autoinstall-reference.html
- https://canonical-subiquity.readthedocs-hosted.com/en/latest/howto/autoinstall-quickstart.html
- https://canonical-subiquity.readthedocs-hosted.com/en/latest/howto/autoinstall-validation.html
- https://canonical.com/lxd/docs/ (documentation.ubuntu.com/lxd/ redirects here)
- https://ubuntu.com/pro/docs/ (documentation.ubuntu.com/pro/ redirects here)
- https://documentation.ubuntu.com/core/ (ubuntu.com/core/docs redirects here)
- https://documentation.ubuntu.com/security/

Failed to load (404, guessed URLs, so no content): 
- https://ubuntu.com/server/docs/how-to/networking/install-dhcp-isc-kea/
- https://canonical-subiquity.readthedocs-hosted.com/en/latest/howto/autoinstall-quick-start.html
- https://canonical-subiquity.readthedocs-hosted.com/en/latest/howto/installer-storage.html
- https://canonical-subiquity.readthedocs-hosted.com/en/latest/howto/autoinstall-storage.html

Not verified: the exact sub-page tree inside LXD, Pro and Core (only the second-level nav was returned), the contents of the Subiquity "Configuring storage" page (so storage details below come from the reference summary and general knowledge, flagged), and rendered visual details (admonition colours, copy buttons), which the fetcher cannot show.

## 1. Ubuntu Server docs: framework and full section tree

### 1.1 Framework and grouping

- Diataxis, with four top-level buckets in this order: Tutorial (singular), How-to guides, Reference, Explanation, plus a fifth, Contributing. The landing page also carries thematic "topic clusters" (Getting started, Networking, Security, Managing your system, Data and storage, Web and mail services, Virtualisation and containers, Performance) that cut across the four buckets. So there are two navigation axes: by document type (sidebar) and by topic (landing page cards).
- Inside How-to and Explanation the same topic names repeat (Security, Networking, Managing software, Data and storage, Web services, Virtualisation, High availability...). A topic is therefore split across two trees, with an "Introduction to X" in Explanation and "Install/Configure X" in How-to.
- Reference is thin (3 core pages plus 2 small groups). Most "reference" material lives inside how-to pages (config examples) or upstream man pages.
- Software-per-package granularity: one how-to per daemon (Postfix, Exim4, Dovecot, Apache2, nginx, Squid, Bacula...). Large topics become a folder with sub-pages (Kerberos 6, SSSD 4, Samba 9, OpenLDAP 9-10, WireGuard 7).
- Hosting: the canonical docs source is documentation.ubuntu.com/server (Sphinx, Canonical Starter Pack / Furo-style theme), reverse-proxied/redirected to ubuntu.com/server/docs. Pages have breadcrumbs, a right-hand "Contents" TOC, and a "Contribute to this page" link to GitHub.

### 1.2 Tutorial (5 pages)
- Basic installation
- Welcome to the terminal
- The command line in depth
- Managing your software
- Attach your Ubuntu Pro subscription

### 1.3 How-to guides

Server installation (9)
- amd64 netboot install
- arm64 netboot install
- Choose between the arm64 and arm64+largemem installer options
- ppc64el netboot install
- Virtual CD-ROM and Petitboot install on ppc64el
- s390x install via z/VM
- Non-interactive IBM z/VM autoinstall (s390x)
- s390x install via LPAR
- Non-interactive IBM Z LPAR autoinstall (s390x)

Security
- User management
- Firewalls
- AppArmor
- Console security
- TPM-backed LUKS decryption with Clevis
- Kerberos: Install a Kerberos server; Configure service principals; Kerberos encryption types; Set up secondary KDC; Basic workstation authentication; Kerberos with OpenLDAP backend
- Network user authentication with SSSD: SSSD with Active Directory; SSSD with LDAP; SSSD with LDAP and Kerberos; Troubleshooting SSSD
- Smart cards: Smart card authentication; Smart card authentication with SSH
- OpenSSH: 2FA with TOTP/HOTP; 2FA with U2F/FIDO; GSSAPI/Kerberos authentication
- Obtain TLS certificates
- Install a root CA certificate
- OpenVPN
- WireGuard VPN: Peer-to-site (on router); Peer-to-site (inside device); Site-to-site; Default gateway; Common tasks; Security tips; Troubleshooting

Networking
- File transfers with FTP
- Set up a name server (DNS)
- Set up DNS Security Extensions (DNSSEC)
- DNSSEC troubleshooting
- Use Open vSwitch with DPDK
- Install DOCA-OFED
- Install DHCP isc-kea
- Install DHCP isc-dhcp-server
- Time sync with chrony
- Time sync with timedatectl and timesyncd
- Serving time with chrony
- Network File System (NFS) sharing
- Samba: Set up a Samba AD Domain Controller; Join an Active Directory domain; Set up a file server; Set up a print server; Share access controls; Create AppArmor profile; Mount CIFS shares permanently; NT4 domain controller; OpenLDAP backend
- Active Directory integration: Prepare to join a domain; Join a simple domain with the rid backend; Join a forest with the rid backend; Join a forest with the autorid backend
- Traffic shaping with tc and CAKE
- Set up a CUPS print server

Managing software
- Package management
- Automatic updates
- Upgrade your release
- Snapshot service
- Reporting bugs

Data and storage
- OpenLDAP: Install OpenLDAP; Set up access control; OpenLDAP with replication; User and group management; OpenLDAP and TLS; Backup and restore; Introduction to passthrough authentication; Passthrough authentication with Kerberos; Set up an LDAP client
- Databases: MySQL; PostgreSQL
- Storage: Manage logical volumes; iSCSI
- Backups and version control: Install Bacula; Install rsnapshot; Backup with shell scripts; etckeeper; Install gitolite

Mail services
- Install Postfix
- Install Exim4
- Install Dovecot

Web services
- Install a Squid server
- Install Apache2; Apache2 settings; Apache2 modules
- Install nginx; nginx settings; nginx modules
- Install PHP
- Install Ruby on Rails

Graphics
- Install NVIDIA drivers
- vGPU with QEMU/KVM

Virtualisation
- LXD
- Multipass
- UVtool
- QEMU
- AMD SEV
- Intel TDX
- Hardware enablement virtualization stack
- Libvirt and virsh
- virt-manager
- Nested virtualization
- Ubuntu on Hyper-V

Containers
- LXD
- Docker for sysadmins
- How to run rocks on your server
- Skopeo for sysadmins

High availability
- Distributed Replicated Block Device (DRBD)

Observability
- Set up your LMA stack
- Install Logwatch
- Install Munin
- Install Nagios Core 4
- Use Nagios with Munin

Debugging
- About debuginfod
- Debug symbol packages
- Kernel crash dump
- eBPF

### 1.4 Reference (small)
- Glossary (A-Z, roughly 300 entries, each with definition, "See also", "Related topics"; many are "work in progress" stubs)
- Command-line cheat sheet
- System requirements (the old URL is only a redirect stub)
- High availability: Migrate from crmsh to pcs
- Other tools: Terminal multiplexers; pam_motd; sudo-rs

### 1.5 Explanation

Security
- Introduction to security
- Security suggestions
- Introduction to Kerberos
- Introduction to network user authentication with SSSD
- DNSSEC
- Cryptography: Introduction to cryptographic libraries; OpenSSL; GnuTLS; Network Security Services (NSS); Java cryptography configuration; BIND 9 DNSSEC cryptography selection; OpenSSH crypto configuration; Troubleshooting TLS/SSL
- Certificates
- Introduction to WireGuard VPN
- OpenVPN clients

Networking
- Introduction to networking
- Networking key concepts
- About Netplan
- Configuring networks
- The DPDK library
- About DHCP
- Time synchronisation
- Introduction to Samba
- Active Directory integration: Introduction; Choosing an integration method; Security identifiers (SIDs); Identity mapping (idmap) backends; The rid idmap backend; The autorid idmap backend

Managing software
- Third party repository usage
- Changing package files
- Configuration managers
- About apt upgrade and phased updates
- Advance testing of updates in best practice server deployments

Data and storage
- Introduction to OpenLDAP
- Introduction to databases
- Storage: About LVM
- Multipath: Introduction to device mapper multipathing; Configuration options and overview; Configuration examples; Common tasks and procedures

Web services
- Introduction to web services
- About web servers
- About Squid proxy servers

Virtualisation and containers
- Introduction to virtualization
- VM tools overview
- QEMU microvm
- QEMU/libvirt live migration
- QEMU machine types
- Container tools overview
- About rock images
- Docker storage, networking, and logging
- About OpenStack

Clouds
- About cloud-init
- Cloud images

High availability
- Introduction to HA
- Pacemaker resource agents
- Pacemaker fence agents

Performance
- Profile-Guided Optimization
- hwloc
- CPU power (states)
- cpupower (tool)
- TuneD
- CPU affinity and NUMA

### 1.6 Contributing (7)
- Contribute to this documentation
- Types of contributions
- Local development
- Guidance for writing
- AI tools in this project
- Getting help
- Our contributors

Observations on the tree: about 170 leaf pages; heavy bias to legacy network/identity daemons; installation how-tos are mostly per-architecture netboot recipes; the primary x86 ISO install lives in the Tutorial; Ubuntu Pro appears only as one tutorial page.

## 2. Installer and autoinstall docs (Subiquity)

Site: https://canonical-subiquity.readthedocs-hosted.com/ (Diataxis, "Ubuntu installation guide"; Subiquity is described as the installer framework giving Server its text UI and Ubuntu Core first-boot configuration).

### 2.1 Page list
Tutorials
- Creating autoinstall configuration
- Providing autoinstall configuration
- Operating the server installer
- Screen-by-screen installer walk-through

How-to guides
- Autoinstall quick start
- Autoinstall quick start for s390x
- Basic server installation
- Configuring storage
- Autoinstall validation
- Use ubuntu-image to build classical images
- Troubleshooting

Reference
- Autoinstall configuration (the key-by-key manual)
- Autoinstall JSON schema
- ubuntu-image reference

Explanation
- Cloud-init and autoinstall interaction
- Zero-touch deployment with autoinstall
- Subiquity security overview
- ubuntu-image security overview

### 2.2 Main concepts (from the reference page and quick start/validation pages)
- Config is YAML, delivered through cloud-init: either inside user-data under an `autoinstall:` key (needs the `#cloud-config` header) or as a plain autoinstall file on install media (validator flag for this form). Delivery paths: NoCloud network seed via kernel arg (`autoinstall ds=nocloud-net;s=http://host:port/`), or a second volume/ISO labelled for NoCloud (made with `cloud-localds`). The kernel argument `autoinstall` is the safety latch that stops accidental disk wipes.
- `version` (must be 1).
- Command hooks: `early-commands` (before device probing), `late-commands` (after success), `error-commands` (on failure). The reference page has a dedicated section explaining command lists.
- `interactive-sections`: list of keys whose screens are still shown to the user, so you can pre-seed most of the install and ask only for, say, storage or identity. Keys that can be interactive: locale, refresh-installer, keyboard, source, network, proxy, apt, storage, identity, active-directory, ubuntu-pro, ssh, drivers, oem, snaps.
- Identity and access: `identity` (required unless user-data creates a user), `ssh`, `active-directory`, `ubuntu-pro` (contract token), `user-data` (cloud-init alternative to identity).
- Localisation: `locale`, `keyboard`, `timezone`.
- Network and source: `network` (Netplan format), `proxy`, `source` (minimal vs standard), `refresh-installer`.
- Storage: `storage` with `layout` presets (lvm, direct, zfs) plus the lower-level action-based syntax, and `match` specs to pick a disk by size, model, path or serial. The "Configuring storage" how-to exists but did not load, so its internals are unverified.
- Packages: `apt` (mirrors, fallback, geoip), `packages`, `snaps` (with channels), `codecs`, `drivers`, `kernel`, `oem`, `debconf-selections`.
- System: `kernel-crash-dumps`, `updates` (security or all), `shutdown` (reboot or poweroff), `zdevs` (IBM Z).
- `reporting`: progress destinations (print, webhook, rsyslog).
- Validation: a JSON schema, plus a validate script from the Subiquity repo; exit code 0/1; verbose flags show schema errors; limitations are documented (assumes ubuntu-server sources, cannot verify real hardware data). Common mistakes called out: missing cloud-config header, misspelt `autoinstall`, mixing the two formats.
- Quick start has two tracks, network seed and volume seed, both on a VM, with a throwaway known password for testing.

Lesson for Nubo: this site is the best-structured Canonical docs (tutorials that teach, one key-by-key reference, one schema, explanation of cloud-init interplay). Nubo should mirror it and document its own differences (default package set, Incus flavour keys, flavour selection).

## 3. Sibling Canonical docs (structure only)

LXD (https://canonical.com/lxd/docs/): Diataxis, four buckets. Getting started: install, initialise, UI, local docs. Core operations: server/client config, instances, images, projects, storage, networking, clustering. Production: benchmarking, metrics, logging, backup and recovery, security hardening. Support: troubleshooting, FAQ, contributing, community links (forum, GitHub). Furo theme. Closest model for Nubo's Incus flavour.

Ubuntu Pro (https://ubuntu.com/pro/docs/): not Diataxis; goal-based cards. Start here (account setup, troubleshooting account problems, attach a machine, open a support case); Understanding Ubuntu Pro (what is included, the token, Landscape intro, support overview, offline use); Managing Ubuntu Pro (shop subscriptions, user management, update token); Using the Pro client (external link). A "Popular questions" callout on the landing page. Good model for a "subscription and support" area.

Ubuntu Core (https://documentation.ubuntu.com/core/): Diataxis plus Contributing. Tutorials: try pre-built images; build your first image. How-to: using Core, create an image, deploy an image, manage Core, work with containers, run CUDA workloads. Reference: system requirements, testing platforms, support duration, release notes, gadget snap format, kernel boot parameters, SBOM, assertions. Explanation: recovery modes, refresh control, remodeling, how installation works, full disk encryption, security and sandboxing, core elements, stores, system snaps. Good model for Nubo Edge (support duration and release notes as reference pages).

Ubuntu Security (https://documentation.ubuntu.com/security/): topic-led, not Diataxis. Software integrity (image integrity verification, archive integrity verification); Security updates (ESM, OVAL, OSV, VEX data); Ubuntu security features (overview, platform protections, privilege restriction, cryptography, process and memory protections, kernel protections, storage and filesystem, network and firewalls, SBOM with VEX); Compliance automation (Ubuntu Security Guide with CIS/DISA-STIG, FIPS 140); Common security mistakes (six categories). Good model for a "Nubo security model" section.

Pattern across the family: Diataxis everywhere except Pro and Security; each product is a separate site; Server docs link out to them rather than embedding.

## 4. Page patterns worth copying

Observed (limited to what the fetcher returned):
- Breadcrumbs at the top, right-hand "Contents" TOC, "Contribute to this page" link to GitHub at the bottom.
- Tutorial (Basic installation): Preparing to install; System requirements; Perform a system backup; Download the server ISO; Create a bootable USB; Boot the installer; Using the installer. One screenshot, links out to Subiquity and platform guides. No admonitions.
- How-to (serve NTP with chrony): title phrased "How to ..."; Install; Enable the feature; View status; optional advanced sections (PPS, NTS); Further reading. Terminal blocks with `$` prompt plus sample output; config file snippets; inline version notes ("default as of release X"); many cross-links to sibling how-tos; external further-reading list.
- Reference (glossary): A-Z anchors; per-term heading, definition, See also, Related topics; internal cross-links; stub entries marked work in progress.
- Reference (autoinstall): intro, schema validation, command lists, then each top-level key as its own subsection, with a trailing list of interactive-capable keys.
- Validation how-to: what the tool is, formats supported, limitations, common mistakes, debugging flags.

Weakly observed: Ubuntu pages seldom use boxed admonitions in the fetched samples; the Sphinx theme supports note/warning/tip, but usage is light. No explicit "Prerequisites", "Verify", "Troubleshooting" headings on the pages sampled (chrony has "View status" in place of verify). Versioning is informal prose, not a version badge.

### Worked structure example A: how-to (headings only)
- How to <do task> on Nubo OS
  - Before you start (prerequisites: release, flavour, privileges, network, packages)
  - Install
  - Configure (numbered steps, one action each)
  - Start and enable
  - Verify it works (command plus expected output)
  - Common problems (symptom, cause, fix)
  - Undo or remove
  - Next steps (links to explanation, reference, related how-tos)
  - Related reading (external)

### Worked structure example B: reference config page (headings only)
- <Tool or file> reference
  - Summary table (path, package, service name, default port, since release)
  - Synopsis or file layout
  - Options (one subsection per key: type, default, allowed values, example, since version)
  - Defaults on Nubo OS (what differs from Ubuntu)
  - Examples (minimal, typical, hardened)
  - Exit codes or log locations
  - See also

Recommended site-wide conventions: a one-line "Applies to: Nubo OS 26.04, Server, Virtualization" badge per page; a "Last reviewed" date; a "Differs from Ubuntu" admonition; consistent admonition set (Note, Tip, Warning, Danger, Version, Ubuntu difference); copy button on every code block; prompt-free commands (so copy gives runnable text) with separate output blocks.

## 5. Gaps and weak spots a competitor can beat

1. Two navigation axes with no bridge. Same topic appears in How-to and Explanation, and the landing page clusters differ from the sidebar. Fix: topic hubs ("Everything about DNS") listing the explanation, how-tos and reference in one place.
2. Long flat how-to sidebar (about 120 entries). Fix: collapse by task area, add "I want to..." entry points.
3. No task-based front door. Landing page is a topic list, not goals such as "set up a web server", "host VMs", "harden a server". Fix: outcome cards and role paths (new admin, homelab, platform engineer).
4. Reference is nearly empty. No package/port/service/path tables, no CLI reference, no config-file reference, no release matrix. Fix: generated reference (default ports, services, files, kernel parameters, package sets per flavour).
5. Glossary is large but unfinished (many stubs) and the system-requirements page is a redirect stub. Fix: complete, and tie each term to a page.
6. Inconsistent granularity and age: legacy tools (Nagios, Munin, Exim4, Ruby on Rails) alongside current ones; version notes are informal ("as of release X"). Fix: version badges, review dates, deprecation labels.
7. Install docs split across Server and Subiquity sites, with per-architecture netboot recipes dominating. Fix: one install section with a decision page ("which install method") and a single autoinstall path.
8. Little guided learning: only 5 tutorials, three being generic shell lessons. Fix: end-to-end scenario tutorials (first server hardening, first web app, first VM).
9. Few verification and troubleshooting sections; no consistent "verify" and "undo" steps. Fix: make them mandatory in the how-to template.
10. Search and discoverability: no evidence of faceted search, filters by release/flavour, or "was this helpful" feedback in the sampled pages; the docs are split over several hosts (ubuntu.com, documentation.ubuntu.com, canonical.com, readthedocs-hosted) with redirects, so cross-site search does not exist. Fix: single domain, one search index, filters, recent changes page.
11. Copy buttons, tabs for alternative commands, and checklists were not confirmable; plan for them anyway.
12. Release notes, upgrade paths, support lifecycle, and Pro/ESM are scattered across Ubuntu sites; Server docs barely mention them. Fix: lifecycle and "what changed since Ubuntu" pages.
13. Security hardening and compliance (Security site) are separate from server how-tos. Fix: integrate a hardening checklist and per-feature "secure this" subsections.

## 6. Recommended documentation outline for Nubo OS Server (and flavours)

Principles: Diataxis tree (Tutorials, How-to guides, Explanation, Reference) as the sidebar, plus topic hubs and "I want to" cards on the landing page, plus per-flavour filter badges (Server, Virtualization with Incus, Containers with Podman, Edge). Where a page belongs to a flavour, say so in the title area. Titles below are proposed, not Ubuntu's. Count is about 125 pages.

### Landing and Start here
- Welcome to Nubo OS Server
- Choose your flavour (Server, Virtualization, Containers, Edge)
- What is different from Ubuntu 26.04
- Release and support lifecycle
- Where to get help

### Tutorials (14)
- Install Nubo OS Server on a VM
- Install Nubo OS Server on bare metal from USB
- Your first 30 minutes on a new server
- Secure a new server (users, SSH keys, firewall, updates)
- Host a website with nginx and TLS
- Run your first virtual machine with Incus (Virtualization)
- Run your first system container with Incus (Virtualization)
- Run your first container with Podman (Containers)
- Run a multi-container app with Podman and Quadlet (Containers)
- Deploy an Edge node and enrol it (Edge)
- Automate an install with autoinstall
- Build a custom Nubo OS image
- Back up and restore a server
- Upgrade between Nubo OS releases

### How-to guides

Installation and images (14)
- Install from ISO (amd64)
- Install on arm64 and Raspberry Pi
- Install on a cloud provider
- Netboot (PXE) install
- Install on Hyper-V, VMware, KVM, VirtualBox
- Write the installer USB (Linux, macOS, Windows)
- Autoinstall: serve configuration over HTTP
- Autoinstall: use a second volume (NoCloud)
- Autoinstall: partially interactive installs
- Autoinstall: configure storage layouts
- Autoinstall: validate a configuration
- Autoinstall: troubleshoot a failed install
- Pick a flavour at install time and switch later
- Build ISO, cloud and Pi images

Accounts, access and security (16)
- Manage users and groups
- Configure sudo
- Harden SSH
- Two-factor authentication for SSH
- Configure a firewall (nftables, ufw)
- Use AppArmor profiles
- Enable full-disk encryption and TPM unlock
- Manage secrets and credentials
- Obtain and renew TLS certificates
- Install a private root CA
- Set up WireGuard VPN
- Set up OpenVPN
- Join Active Directory or LDAP with SSSD
- Set up Kerberos
- Apply a compliance baseline (CIS-style)
- Audit and log security events

System management (12)
- Manage packages with apt
- Add and pin third-party repositories
- Configure automatic security updates
- Reboot and live-patch strategy
- Upgrade your release
- Manage services with systemd
- Schedule tasks with systemd timers and cron
- Configure the network with Netplan
- Set the time with chrony
- Manage logs with journald
- Configure kernel parameters and sysctl
- Capture a kernel crash dump

Storage and backups (10)
- Partition and format disks
- Manage logical volumes (LVM)
- Set up software RAID
- Use ZFS or Btrfs snapshots
- Set up NFS
- Set up Samba file sharing
- Set up iSCSI
- Back up with restic or rsnapshot
- Back up databases
- Restore from backup

Networking services (8)
- Run a DNS server
- Run DHCP (Kea)
- Set up a proxy (Squid)
- Set up a reverse proxy
- Shape traffic
- Set up a print server
- Set up bonding, VLANs, bridges
- Use IPv6

Web, mail and databases (10)
- Install nginx
- Install Apache
- Run PHP or Python apps
- Install PostgreSQL
- Install MySQL or MariaDB
- Install Redis
- Set up a mail server (Postfix, Dovecot)
- Set up SMTP relay
- Tune a database
- Back up and replicate a database

Virtualization with Incus (14)
- Install and initialise Incus
- Create and manage instances (containers and VMs)
- Manage images and remotes
- Configure storage pools
- Configure networks and bridges
- Use profiles and projects
- Cluster Incus nodes
- Live migrate instances
- Pass through GPU and USB devices
- Snapshots and backups
- Use the Incus web UI
- Run Windows guests
- Use libvirt and QEMU directly
- Use Multipass-style cloud-init on Incus

Containers with Podman (12)
- Install Podman and rootless setup
- Run and manage containers
- Pull and manage images, registries and Skopeo
- Build images with Buildah
- Use pods
- Run containers as systemd services with Quadlet
- Podman networks and DNS
- Volumes and storage
- Compose files with Podman
- Auto-update containers
- Secure containers (SELinux/AppArmor, seccomp, user namespaces)
- Migrate from Docker

Edge (10)
- Prepare an Edge image
- Enrol and provision a device
- Read-only root and atomic updates
- Roll back a failed update
- Remote management and fleet updates
- Configure offline and intermittent networks
- Run workloads on Edge
- Secure boot and device identity
- Monitor an Edge node
- Recover a device

Observability and debugging (6)
- Set up Prometheus and node exporter
- Set up Grafana dashboards
- Centralised logging
- Alerting
- Use eBPF and perf tools
- Debug with core dumps and debug symbols

Cloud and automation (5)
- Use cloud-init
- Configure with Ansible
- Use Terraform or OpenTofu with Nubo OS images
- Build golden images
- High availability basics (keepalived, Pacemaker)

### Explanation (24)
- How Nubo OS relates to Ubuntu 26.04
- Flavours and what each includes
- Release model and support lifecycle
- Package sources, repositories and priorities
- How updates and phased rollouts work
- Security model overview
- Cryptography on Nubo OS
- Certificates and trust
- Networking basics and Netplan
- Storage concepts (LVM, filesystems, RAID)
- How autoinstall and cloud-init interact
- Zero-touch deployment
- Virtual machines vs system containers vs application containers
- Incus architecture
- Podman architecture and rootless model
- Quadlet and systemd integration
- Edge update and rollback design
- Identity and directory services overview
- Time synchronisation
- Performance tuning concepts (CPU, NUMA, power)
- Logging and observability concepts
- High availability concepts
- Choosing a web server or database
- Compliance and hardening rationale

### Reference (20)
- System requirements per flavour
- Release notes (per version)
- Support duration and lifecycle table
- Package sets per flavour
- Default services, ports and firewall rules
- Important files and directories
- Autoinstall configuration reference (every key)
- Autoinstall JSON schema
- Nubo-specific autoinstall keys
- Image build options (ISO, cloud, Pi)
- Kernel parameters and installer boot options
- Incus configuration keys quick reference
- Podman and Quadlet option reference
- Edge configuration reference
- Command-line cheat sheet
- Netplan quick reference
- Security baseline checklist
- Glossary
- Differences from Ubuntu
- Known issues

### Support, community and contributing (7)
- Troubleshooting index (symptom to page)
- FAQ
- Report a bug
- Get support and subscriptions
- Contribute to the docs
- Writing guide and page templates
- Docs changelog

### Landing page features to build in
- "I want to..." cards: install, secure, host a site, run VMs, run containers, deploy at the edge, automate installs, upgrade.
- Per-flavour filter and badge on every page; release selector.
- Topic hubs (Networking, Security, Storage, Web) that gather tutorial, how-to, explanation and reference links.
- Mandatory sections in how-to template: prerequisites, steps, verify, troubleshooting, undo, next steps.
- Copy buttons, tabbed alternatives (CLI/autoinstall/cloud-init), last-reviewed date, edit-on-GitHub, feedback widget, one-domain search.
