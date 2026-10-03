#!/usr/bin/env python3
"""Write data/releases.json from the images published at archive.nubosuite.tech/iso/<version>/.
Usage: make-releases.py 0.8.0-beta11 [--desktop-url URL --desktop-sha SHA --desktop-size BYTES]"""
import json, sys, urllib.request
UA = {'User-Agent': 'nubo-website-build/1.0'}
ver = sys.argv[1]
BASE = 'https://archive.nubosuite.tech/iso/' + ver
FLAV = [('server','Server'),('virt','Virtualization'),('containers','Containers'),('edge','Edge')]
out = {'version': ver, 'desktop': None, 'server': []}
for key, name in FLAV:
    for arch in ('amd64','arm64'):
        f = f'nubo-os-{key}-{ver}-{arch}.iso'
        url = f'{BASE}/{f}'
        try:
            r = urllib.request.urlopen(urllib.request.Request(url, method='HEAD', headers=UA), timeout=30)
            size = int(r.headers['Content-Length'])
            sha = urllib.request.urlopen(urllib.request.Request(url + '.sha256', headers=UA), timeout=30).read().decode().split()[0]
        except Exception as e:
            print('missing', f, e, file=sys.stderr); continue
        out['server'].append({'flavour': key, 'name': name, 'arch': arch, 'file': f, 'url': url, 'size': size, 'sha256': sha})
json.dump(out, open('data/releases.json', 'w'), indent=2)
print(len(out['server']), 'images')
