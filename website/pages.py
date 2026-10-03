"""Static page content for the Nubo websites. build_all(ctx) returns {(site, path): (title, description, body_html)}."""
import html

DOCS = 'https://docs.nubosuite.tech'
SUITE = [
    # name, versus, description, status, url
    ('Nubo Pass', 'vs 1Password', 'Passwords and passkeys, synced peer to peer.', 'live', 'https://pass.nubosuite.tech'),
    ('Nubo Send', 'vs WeTransfer', 'Send any file directly, end to end encrypted. Nothing is uploaded.', 'live', 'https://send.nubosuite.tech'),
    ('Nubo Vault', 'vs Doppler', 'Team secrets and API keys, usable as a .env file.', 'beta', 'https://vault.nubosuite.tech'),
    ('Nubo Tunnel', 'vs Termius', 'Remote shell to any device with no open ports.', 'beta', 'https://tunnel.nubosuite.tech'),
    ('Nubo Clip', 'vs Paste', 'Clipboard synced across your devices.', 'beta', 'https://clip.nubosuite.tech'),
    ('Nubo Chat', 'vs Signal', 'Private messaging with no phone number and no server.', 'soon', ''),
    ('Nubo Screen', 'vs TeamViewer', 'Remote desktop and support by a 6-digit code.', 'soon', ''),
    ('Nubo AI', 'on device', 'A private assistant that runs on your machine.', 'soon', ''),
    ('Nubo Workspace', 'vs Notion', 'Docs, notes, tasks and drive, local first.', 'soon', ''),
    ('Nubo Mesh', 'vs Tailscale', 'A private mesh network for all your devices.', 'soon', ''),
]
STATUS = {'live': 'Live', 'beta': 'Beta', 'soon': 'Coming soon'}
FLAVOURS = {
    'server': ('Server', 'The base server: secure defaults, automatic security updates, and the everyday tools.', 'Web and app servers, small services, a good first server.'),
    'virt': ('Virtualization', 'The base server with Incus and QEMU for system containers and virtual machines.', 'A home lab or a small virtualization host.'),
    'containers': ('Containers', 'The base server with rootless Podman, Buildah and Skopeo.', 'Container workloads, with or without compose files.'),
    'edge': ('Edge', 'The smallest image: the core and automatic security updates, nothing else.', 'Raspberry Pi, old hardware and appliances.'),
}


def esc(s):
    return html.escape(s, quote=True)


def server_table(ctx):
    rel = ctx['REL']
    rows = []
    for key, (name, desc, use) in FLAVOURS.items():
        cells = []
        for arch, label in (('amd64', 'Intel and AMD (amd64)'), ('arm64', 'Arm (arm64)')):
            img = next((i for i in rel['server'] if i['flavour'] == key and i['arch'] == arch), None)
            if img:
                cells.append('<a class="in" href="%s">%s</a><br><span style="font-size:13px">%s</span><br><code style="font-size:11px">%s</code>'
                             % (esc(img['url']), label, ctx['fmt'](img['size']), esc(img['sha256'])))
            else:
                cells.append('Not available yet')
        rows.append('<tr><td><b style="color:#fff">%s</b><br><span style="font-size:14px">%s</span></td><td>%s</td><td>%s</td></tr>' % (name, esc(desc), cells[0], cells[1]))
    return ('<div class="tablewrap"><table><thead><tr><th>Edition</th><th>Intel and AMD</th><th>Arm</th></tr></thead><tbody>%s</tbody></table></div>'
            '<p style="font-size:14px">Version %s. Each image is about 3 GB. The line under each link is its SHA-256 checksum.</p>' % (''.join(rows), esc(rel['version'])))


def verify_block(ctx):
    img = ctx['REL']['server'][0]
    return ('<h3>Check your download</h3><p>Compare the checksum before you write the image to a disk. On Linux or macOS:</p>'
            '<pre><code>sha256sum %s     # Linux\nshasum -a 256 %s   # macOS</code></pre>'
            '<p>On Windows, in PowerShell: <code>Get-FileHash %s -Algorithm SHA256</code>. The result must match the line shown with the image.</p>'
            % (esc(img['file']), esc(img['file']), esc(img['file'])))


def build_all(ctx):
    P = {}
    rel = ctx['REL']

    # ---------------------------------------------------------------- 404 (both sites)
    nf = ('<p class="eyebrow">404</p><h1>That page is not here.</h1><p class="lead">It may have moved. Try the start page, or search the documentation.</p>'
          '<div class="row"><a class="btn" href="/">Go to the start page</a><a class="btn2" href="%s/">Open the docs</a></div>' % DOCS)
    for s in ('www', 'os'):
        P[(s, '/404.html')] = ('Page not found | Nubo', 'The page you asked for does not exist.', nf)

    # ---------------------------------------------------------------- www
    cards = ''.join(
        '<%s class="card"%s><span class="tag %s">%s</span><b>%s</b><span style="color:#6E7380;font-size:13px">%s</span><span>%s</span></%s>'
        % ('a' if url else 'div', ' href="%s"' % url if url else '', st, STATUS[st], n, vs, d, 'a' if url else 'div')
        for n, vs, d, st, url in SUITE)
    P[('www', '/apps/')] = ('Nubo Suite apps', 'Private apps from Nubo: Pass, Send, Vault, Tunnel, Clip and more, alongside Nubo OS and Nubo Email.', f"""
<p class="eyebrow">Nubo Suite</p><h1>Private apps, and the system they run on.</h1>
<p class="lead">Each Nubo Suite app copies a category leader and removes the server in the middle. One Nubo ID unlocks them all.</p>
<h2>The platform</h2>
<div class="grid">
<a class="card" href="https://os.nubosuite.tech/"><span class="tag live">Early access</span><b>Nubo OS</b><span>A free desktop and a minimal server, built on Ubuntu 26.04 LTS.</span></a>
<a class="card" href="https://nubo.email"><span class="tag live">Live</span><b>Nubo Email</b><span>Privacy-first business email on the JMAP protocol, with calendar, drive, meetings and chat.</span></a>
</div>
<h2>The apps</h2>
<div class="grid">{cards}</div>
<p>Status labels are the current state: Live apps are ready to use, Beta apps work and are still changing, and the rest are planned. The apps are built on the Holepunch and Pear peer-to-peer stack.</p>
""")

    P[('www', '/about/')] = ('About Nubo and Chandorkar Technologies', 'Chandorkar Technologies builds Nubo OS, Nubo Email and the Nubo Suite of private apps in India.', f"""
<p class="eyebrow">About</p><h1>We make software that works for you and for no one else.</h1>
<p class="lead">Chandorkar Technologies is an India-based software company. Nubo is what we build.</p>
<h2>What we make</h2>
<ul>
<li><b>Nubo OS</b>: a free operating system for desktops and servers, built on Ubuntu 26.04 LTS. <a class="in" href="https://os.nubosuite.tech/">Read more</a>.</li>
<li><b>Nubo Email</b>: business email, calendar, drive, meetings and chat on the JMAP protocol. <a class="in" href="https://nubo.email">Visit nubo.email</a>.</li>
<li><b>Nubo Suite</b>: private peer-to-peer apps for passwords, files, secrets, remote access and more. <a class="in" href="/apps/">See the apps</a>.</li>
</ul>
<h2>How we work</h2>
<p>Nubo OS is open. The source code, the build scripts and the documentation are public on <a class="in" href="https://github.com/Chandorkar-Technologies/nubo-os">GitHub</a>, and every update is signed. Where Nubo OS uses someone else's work, such as Ubuntu, GNOME and Flathub, we say so and keep their licences.</p>
<p>We keep claims to what we can show. If something is early access or planned, the page says so, and the <a class="in" href="{DOCS}/reference/known-issues/">known issues</a> page lists what is not finished.</p>
<h2>Get in touch</h2>
<p>Questions, partnerships and press: <a class="in" href="/contact/">contact page</a>.</p>
""")

    P[('www', '/contact/')] = ('Contact Nubo', 'How to reach Nubo support, report a security problem, or open an issue.', f"""
<p class="eyebrow">Contact</p><h1>Talk to us.</h1>
<p class="lead">We read everything that arrives.</p>
<div class="grid">
<div class="card"><b>Help and questions</b><span>Email <a class="in" href="mailto:support@nubo.email">support@nubo.email</a>. Please say which edition you use and what you tried.</span></div>
<div class="card"><b>Security reports</b><span>Email <a class="in" href="mailto:security@nubosuite.tech">security@nubosuite.tech</a>. See the <a class="in" href="/security/">security page</a> first.</span></div>
<div class="card"><b>Bugs and ideas</b><span>Open an issue on <a class="in" href="https://github.com/Chandorkar-Technologies/nubo-os/issues">GitHub</a>.</span></div>
<div class="card"><b>Documentation</b><span>Most answers are in the <a class="in" href="{DOCS}/">documentation</a>, including <a class="in" href="{DOCS}/desktop/troubleshooting/">troubleshooting</a>.</span></div>
</div>
<p>Chandorkar Technologies. Nubo is a trademark of Chandorkar Technologies.</p>
""")

    P[('www', '/security/')] = ('Security at Nubo', 'How to report a security problem in Nubo OS or our sites, how updates are signed, and what we cover.', f"""
<p class="eyebrow">Security</p><h1>Report a problem, check our updates.</h1>
<p class="lead">If you find a security problem, tell us privately first so we can fix it before it is used against anyone.</p>
<h2>Report a vulnerability</h2>
<p>Email <a class="in" href="mailto:security@nubosuite.tech">security@nubosuite.tech</a> with:</p>
<ul><li>what you found and where (the page, package or image);</li><li>the steps to reproduce it, and the version (for example <code>nubo-os 0.8.0~beta4</code>);</li><li>how you would like to be credited, if at all.</li></ul>
<p>Please do not access other people's data, disrupt services, or publish details before we have had a chance to fix the problem. We do not run a paid bounty program at this time.</p>
<h2>What is in scope</h2>
<ul>
<li>The Nubo OS packages and images (desktop and server), built from our <a class="in" href="https://github.com/Chandorkar-Technologies/nubo-os">repository</a>.</li>
<li>The package archive at <code>archive.nubosuite.tech</code> and Nubo Cumulus.</li>
<li>Our websites on <code>nubosuite.tech</code> and its subdomains.</li>
</ul>
<p>Problems in Ubuntu, GNOME or other upstream software itself should go to those projects, for example <a class="in" href="https://ubuntu.com/security/report">Ubuntu's security team</a>. Nubo OS follows Ubuntu's security updates through the same archive.</p>
<h2>Check that updates are ours</h2>
<p>The Nubo package archive is signed. The signing key fingerprint is:</p>
<pre><code>EE1A 4B74 9E23 2015 01F2  0336 0F74 01D7 AF7D 2593</code></pre>
<p>The public key is installed by the <code>nubo-archive</code> package at <code>/usr/share/keyrings/nubo-archive-keyring.gpg</code>. Ubuntu's own packages stay signed by Ubuntu, including when they come through Nubo Cumulus. More in the <a class="in" href="{DOCS}/updates/verify-signatures-and-checksums/">documentation</a>.</p>
<h2>Supported versions</h2>
<p>Nubo OS 1 is built on a long-term support base with five years of security updates, to April 2031. Early access builds receive updates through the beta channel.</p>
""")

    P[('www', '/privacy/')] = ('Privacy', 'What Nubo collects on its websites, what the waitlist stores, and what Nubo OS itself contacts.', f"""
<p class="eyebrow">Privacy</p><h1>Privacy.</h1>
<p class="lead">We collect as little as we can. This page lists exactly what we do collect.</p>
<h2>Our websites</h2>
<p>This site and the other Nubo sites are served by Cloudflare. Like any web host, Cloudflare receives the address of your device, the page you ask for and your browser's identifying string, and keeps standard server logs for security and to deliver the pages. We do not run advertising or analytics scripts, we do not set cookies, and the pages load their fonts and scripts from our own servers, not from third parties.</p>
<h2>Early access list</h2>
<p>If you ask for early access on the download page, we store your email address and the kind of machine you chose. We use it only to tell you when a build is ready and how to get it. It is kept in Cloudflare's storage. To remove it, email <a class="in" href="mailto:support@nubo.email">support@nubo.email</a> from that address and we delete it.</p>
<h2>Downloads</h2>
<p>Images and packages are served from <code>archive.nubosuite.tech</code> through Cloudflare. We do not tie downloads to a person.</p>
<h2>Nubo OS itself</h2>
<p>Nubo OS checks for updates at <code>archive.nubosuite.tech</code>. Ubuntu's own packages come through Nubo Cumulus, a cache of Ubuntu's archive, with Ubuntu's servers as a fallback. Nubo OS turns off Canonical's crash reports, login news and Ubuntu Pro messages, and checks the network and time against neutral servers. The full list, including the few remaining contacts, is in the <a class="in" href="{DOCS}/updates/privacy-and-network-endpoints/">documentation</a>.</p>
<p>If you sign in with a Nubo account, that account is handled by the Nubo services you sign in to, under their own terms.</p>
<h2>Your rights and contact</h2>
<p>You can ask what we hold about you, and ask us to correct or delete it. Email <a class="in" href="mailto:support@nubo.email">support@nubo.email</a>.</p>
<p>Last updated 3 October 2026. We will change this page when what we collect changes.</p>
""")

    P[('www', '/terms/')] = ('Terms', 'Terms for using the Nubo websites and the Nubo OS software.', f"""
<p class="eyebrow">Terms</p><h1>Terms.</h1>
<p class="lead">Plain terms for our websites and for Nubo OS.</p>
<h2>The software</h2>
<p>Nubo OS is a collection of software. Each part keeps its own licence, which you can read on your system and in the <a class="in" href="https://github.com/Chandorkar-Technologies/nubo-os">source repository</a>. The Nubo-written parts are under the licence in that repository, and the Nubo name, logo and artwork are covered by the brand licence there. The software is provided as it is, without a warranty of any kind. Early access builds can change or break, so keep backups.</p>
<h2>Trademarks</h2>
<p>Nubo and the Nubo mark are trademarks of Chandorkar Technologies. Ubuntu is a trademark of Canonical Ltd. Other product names, logos and app icons belong to their owners and appear only to identify the apps.</p>
<h2>The websites</h2>
<p>You may read, link to and share these pages. Please do not misuse the sites or try to disrupt them. We may change or remove pages at any time.</p>
<h2>Third-party services</h2>
<p>Nubo OS can install software from Flathub and other sources you choose. That software is provided by others, under their terms.</p>
<h2>Contact</h2>
<p>Questions about these terms: <a class="in" href="mailto:support@nubo.email">support@nubo.email</a>. Last updated 3 October 2026.</p>
""")

    # ---------------------------------------------------------------- os
    flav_cards = ''.join('<div class="card"><b>%s</b><span>%s</span><span style="color:#6E7380;font-size:14px">Good for: %s</span></div>' % (n, d, u) for n, d, u in FLAVOURS.values())
    P[('os', '/server/')] = ('Nubo OS Server: minimal, secure, in four editions', 'Nubo OS Server is a minimal server on Ubuntu 26.04 LTS with secure defaults. Choose Server, Virtualization, Containers or Edge. Free, for Intel, AMD and Arm.', f"""
<p class="eyebrow">Nubo OS Server</p><h1>A small, secure base for any server.</h1>
<p class="lead">Install it, and it is already locked down: SSH without root login, a firewall closed except SSH, automatic security updates and a quiet network.</p>
<div class="row"><a class="btn" href="#download">Download</a><a class="btn2" href="{DOCS}/server/">Read the server guide</a></div>
<h2>Four editions</h2>
<div class="grid">{flav_cards}</div>
<h2>What every edition has</h2>
<ul>
<li>The Nubo identity and a quiet console, with no Canonical adverts or crash reports.</li>
<li>SSH without root login, and a firewall that allows only SSH until you open more.</li>
<li>Kernel network hardening, time sync with neutral servers, AppArmor.</li>
<li>Updates from a signed Nubo archive, with Ubuntu's packages through Nubo Cumulus. Five years of security updates, to April 2031.</li>
<li>Intel, AMD and Arm images. One installer for all four editions.</li>
</ul>
<p>Server and Virtualization and Containers also install automatic updates, brute-force protection and everyday tools. Edge keeps only the core and automatic updates. <a class="in" href="{DOCS}/server/security/what-the-defaults-do/">See exactly what the defaults do</a>.</p>
<h2 id="download">Download</h2>
{server_table(ctx)}
{verify_block(ctx)}
<h3>Install it</h3>
<ol><li>Write the image to a USB stick, or attach it to a virtual machine. <a class="in" href="{DOCS}/server/install/choose-an-image/">Which image to pick</a>.</li>
<li>Start from it and follow the installer. <a class="in" href="{DOCS}/server/install/installer-screens-explained/">The screens explained</a>.</li>
<li>Run the <a class="in" href="{DOCS}/server/install/first-boot-checklist/">first-boot checklist</a>.</li></ol>
<div class="note">These are early access builds. They install and update, but they have had limited testing on real hardware. Please keep backups, and tell us what you find.</div>
""")

    P[('os', '/download/')] = ('Download Nubo OS', 'Get Nubo OS: request desktop early access, or download the Nubo OS Server images for Intel, AMD and Arm today.', f"""
<p class="eyebrow">Download</p><h1>Get Nubo OS.</h1>
<p class="lead">The server images are ready to download. The desktop is in early access.</p>
<h2 id="desktop">Desktop: early access</h2>
<p>The Nubo OS desktop is built and working in our tests, and we are preparing a public image that includes the package archive and automatic updates. Leave your email and we will send you the download link as soon as it is ready. We use your address only for that.</p>
<form class="wl" id="wl" novalidate>
<input type="email" id="wlemail" name="email" placeholder="you@example.com" autocomplete="email" required aria-label="Email address">
<select id="wlarch" name="arch" aria-label="Your computer"><option value="amd64">Intel or AMD PC</option><option value="arm64">Arm (for example a Mac with Apple silicon in a VM)</option><option value="unsure">Not sure</option></select>
<input class="hp" type="text" id="wlcompany" name="company" tabindex="-1" autocomplete="off" aria-hidden="true">
<button class="btn" type="submit">Notify me</button>
</form>
<div id="wlmsg" role="status"></div>
<p style="font-size:14px">By sending your address you agree to the use described on the <a class="in" href="https://nubosuite.tech/privacy/">privacy page</a>.</p>
<h2 id="server">Server: download now</h2>
{server_table(ctx)}
{verify_block(ctx)}
<h3>Write it to a USB stick</h3>
<p>Use Rufus on Windows, balenaEtcher on macOS or Windows, or the <code>dd</code> command on Linux. Step by step: <a class="in" href="{DOCS}/desktop/get-started/write-the-installer-usb/">writing the installer USB</a>.</p>
<h3>Run it in a virtual machine</h3>
<p>On a Mac with Apple silicon, take the Arm image and use UTM. <a class="in" href="{DOCS}/server/install/install-in-utm/">Install in UTM</a>. Other hypervisors: <a class="in" href="{DOCS}/server/install/install-in-kvm-vmware-hyperv-virtualbox/">KVM, VMware, Hyper-V and VirtualBox</a>.
</p>
<div class="note">Free to download and use. Early access builds can change, and have had limited testing on real hardware.</div>
""")

    P[('os', '/releases/')] = ('Nubo OS releases', 'Release history and checksums for Nubo OS images and packages.', f"""
<p class="eyebrow">Releases</p><h1>Releases.</h1>
<p class="lead">Every image published, with its checksum.</p>
<h2>{esc(rel['version'])}</h2>
<p>Early access. Server images for four editions, on Intel, AMD and Arm, with the package archive, the Cumulus mirror and the installer's minimal server install.</p>
{server_table(ctx)}
<h2>Updates between images</h2>
<p>Installed systems update from the package archive, not by downloading a new image. A new release goes to the <b>beta</b> channel first and moves to <b>stable</b> after testing. Switch with <code>sudo nubo-channel beta</code> or <code>sudo nubo-channel stable</code>. Details: <a class="in" href="{DOCS}/updates/channels-stable-and-beta/">channels</a>. Release notes: <a class="in" href="{DOCS}/reference/release-notes/">documentation</a>.</p>
""")
    return P


WAITLIST_JS = """<script>
(function(){
  var f = document.getElementById('wl'); if (!f) return;
  var msg = document.getElementById('wlmsg');
  f.addEventListener('submit', function(e){
    e.preventDefault();
    var email = document.getElementById('wlemail').value.trim();
    if (!/^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$/.test(email)) { msg.style.color = '#F2A65A'; msg.textContent = 'Please enter a valid email address.'; return; }
    msg.style.color = '#A1A1A6'; msg.textContent = 'Sending...';
    fetch('/api/waitlist', { method: 'POST', headers: { 'content-type': 'application/json' },
      body: JSON.stringify({ email: email, arch: document.getElementById('wlarch').value, company: document.getElementById('wlcompany').value }) })
      .then(function(r){ return r.json().then(function(j){ return { ok: r.ok, j: j }; }); })
      .then(function(x){ if (x.ok) { msg.style.color = '#7FE0A8'; msg.textContent = 'Thank you. We will email you when the desktop image is ready.'; f.reset(); } else { msg.style.color = '#F2A65A'; msg.textContent = (x.j && x.j.error) || 'Something went wrong. Please try again.'; } })
      .catch(function(){ msg.style.color = '#F2A65A'; msg.textContent = 'Could not reach the server. Please try again in a moment.'; });
  });
})();
</script>
"""
SCRIPTS = {'/download/': WAITLIST_JS}
