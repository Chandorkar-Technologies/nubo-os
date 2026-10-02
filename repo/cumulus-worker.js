// Nubo Cumulus: Nubo's own front door to the places Ubuntu packages and images come from.
// Deployed as Worker "nubo-cumulus", routes archive.nubosuite.tech/cumulus* and /check.
//   /cumulus          Ubuntu archive, x86-64     (archive.ubuntu.com)
//   /cumulus-arm      Ubuntu archive, arm64      (ports.ubuntu.com)
//   /cumulus-images   installer ISOs             (cdimage.ubuntu.com)
//   /cumulus-releases release ISOs               (releases.ubuntu.com)
//   /cumulus-cloud    cloud images               (cloud-images.ubuntu.com)
//   /check            network connectivity check (what NetworkManager asks)
// Nothing is rewritten: files are Ubuntu's, signed by Ubuntu.
const UP = {
  cumulus: 'https://archive.ubuntu.com/ubuntu',
  'cumulus-arm': 'https://ports.ubuntu.com/ubuntu-ports',
  'cumulus-images': 'https://cdimage.ubuntu.com',
  'cumulus-releases': 'https://releases.ubuntu.com',
  'cumulus-cloud': 'https://cloud-images.ubuntu.com',
};
const APT = new Set(['cumulus', 'cumulus-arm']);
const SELF = 'https://archive.nubosuite.tech';
export default {
  async fetch(req) {
    if (req.method !== 'GET' && req.method !== 'HEAD') return new Response('Method not allowed', { status: 405 });
    const u = new URL(req.url);
    if (u.pathname.startsWith('/check')) {
      return new Response('NetworkManager is online\n', { headers: { 'content-type': 'text/plain', 'x-networkmanager-status': 'online', 'cache-control': 'no-store' } });
    }
    const m = u.pathname.match(/^\/(cumulus|cumulus-arm|cumulus-images|cumulus-releases|cumulus-cloud)(\/.*)?$/);
    if (!m) return new Response('Not found', { status: 404 });
    const rest = m[2] || '/';
    if (APT.has(m[1]) && rest === '/mirrors.txt') {
      // apt picks randomly among equal mirrors, so rank them: Cumulus first, Ubuntu only as fallback.
      return new Response(SELF + '/' + m[1] + '\tpriority:1\n' + UP[m[1]] + '\tpriority:2\n', { headers: { 'content-type': 'text/plain', 'cache-control': 'public, max-age=300' } });
    }
    if (rest === '/') return new Response('Nubo Cumulus: a fast, cached route to Ubuntu packages and images. Files are unchanged and signed by Ubuntu.\n', { headers: { 'content-type': 'text/plain' } });
    // Published packages never change; indexes and "current" image links do.
    const immutable = /\/(pool|by-hash)\//.test(rest) || /\.(deb|udeb|dsc|tar\.[a-z0-9]+|diff\.gz)$/.test(rest);
    const image = /\.(iso|img|qcow2|xz|squashfs|tar\.gz|manifest|vmdk|ova)$/.test(rest);
    const ttl = immutable ? 604800 : image ? 3600 : 120;
    const headers = { 'user-agent': 'nubo-cumulus', 'accept-encoding': req.headers.get('accept-encoding') || 'identity' };
    for (const h of ['range', 'if-range', 'if-modified-since', 'if-none-match']) if (req.headers.get(h)) headers[h] = req.headers.get(h);
    const upstream = await fetch(UP[m[1]] + rest + u.search, {
      method: req.method,
      headers,
      redirect: 'follow',
      cf: { cacheEverything: true, cacheTtlByStatus: { '200-299': ttl, '404': 30, '500-599': 0 } },
    });
    const res = new Response(upstream.body, upstream);
    res.headers.set('x-nubo-cumulus', '1');
    res.headers.delete('set-cookie');
    return res;
  },
};
