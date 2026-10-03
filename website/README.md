# Nubo websites

Builds two static sites into `dist/`:

| Folder | Address | Content |
|---|---|---|
| `dist/www` | https://nubosuite.tech | company, apps, about, contact, security, privacy, terms |
| `dist/os` | https://os.nubosuite.tech | Nubo OS: desktop story, server, download, releases |

The documentation is a separate project in `../docs-site` (docs.nubosuite.tech).

## Build
```
npm ci
python3 build.py        # writes dist/
```
Local preview: `cd dist/os && python3 -m http.server 8802` (the pages use root-relative paths).

## Files
- `src/page.tpl.html` the animated scroll story (one view per site is kept at build time)
- `pages.py` the other pages (text lives here)
- `build.py` assembles everything, self-hosts fonts and GSAP, writes sitemap/robots/security.txt
- `data/releases.json` the images shown on the download pages; regenerate with `python3 tools/make-releases.py <version>`
- `worker.js` the Cloudflare Worker `nubo-web` that serves both sites from the bucket `nubo-archive` (prefixes `www/` and `os/`) and stores early-access requests in KV `nubo-waitlist`
- `legacy/` the previous nubosuite.tech page, kept for reference

## Deploy
Pushing to `master` runs the Drone job `web` (`ci/deploy-web.sh`), which uploads `dist/www` and `dist/os` to R2. The Worker serves them.

## Early-access list
Entries are in the KV namespace `nubo-waitlist`, keys `wl:<email>`. Export with the Cloudflare dashboard or API. No IP addresses are stored.
