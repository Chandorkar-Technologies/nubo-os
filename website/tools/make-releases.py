#!/usr/bin/env python3
"""Write data/releases.json from the two release channels at archive.nubosuite.tech/dl/channels/.
Each channel file points at that release's manifest.json (written by ci/publish-release.sh).
A channel with no release yet is null. If the channel files cannot be read at all, the
existing data/releases.json is kept, so a network problem never blanks the download page.
Usage: make-releases.py"""
import json, os, sys, urllib.request, urllib.error
UA = {'User-Agent': 'nubo-website-build/1.0'}
BASE = 'https://archive.nubosuite.tech/dl/channels/'
OUT = os.path.join(os.path.dirname(__file__), '..', 'data', 'releases.json')

def get(url):
    return json.load(urllib.request.urlopen(urllib.request.Request(url, headers=UA), timeout=30))

channels, reached = {}, False
for ch in ('stable', 'beta'):
    try:
        ptr = get(BASE + ch + '.json'); reached = True
        channels[ch] = get(ptr['manifest'])
    except urllib.error.HTTPError as e:
        if e.code == 404: reached = True; channels[ch] = None
        else: print('cannot read', ch, e, file=sys.stderr)
    except Exception as e:
        print('cannot read', ch, e, file=sys.stderr)
if not reached:
    print('channels not reachable; keeping the current releases.json', file=sys.stderr); sys.exit(0)
try:
    old = json.load(open(OUT))['channels']
except Exception:
    old = {}
for ch in ('stable', 'beta'):
    # A channel with no pointer yet must not blank what the page already shows.
    if not channels.get(ch):
        channels[ch] = old.get(ch)
json.dump({'channels': channels}, open(OUT, 'w'), indent=1)
print({k: (v['version'], len(v['images'])) if v else None for k, v in channels.items()})


# --- Nubo Office downloads: the build writes dl/office/latest-<arch>.json for each architecture
OFFICE = os.path.join(os.path.dirname(__file__), '..', 'data', 'office.json')
try:
    office = json.load(open(OFFICE))
    for arch in ('x86_64', 'aarch64', 'windows', 'android', 'macos'):
        try:
            latest = get('https://archive.nubosuite.tech/dl/office/latest-%s.json' % arch)
        except Exception:
            continue                       # not published yet, keep the planned row
        office['version'] = office.get('version') or latest.get('version')
        if arch in ('x86_64', 'aarch64'):
            office['version'] = latest.get('version')
        for new in latest.get('variants', []):
            for row in office['variants']:
                if row['name'] == new['name']:
                    row.update(new)
    json.dump(office, open(OFFICE, 'w'), indent=2)
    print('office:', office.get('version'))
except Exception as e:
    print('office downloads not updated:', e, file=sys.stderr)
