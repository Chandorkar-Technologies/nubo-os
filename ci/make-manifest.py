#!/usr/bin/env python3
"""Print the manifest of one release as JSON.
Usage: make-manifest.py VERSION LIST_JSON SUMS_DIR BASE_URL
LIST_JSON is `rclone lsjson` of the release folder; SUMS_DIR holds the .sha256 files."""
import json, os, re, sys, time
ver, listing, sums, base = sys.argv[1:5]
files = {e['Name']: e for e in json.load(open(listing)) if not e['IsDir']}
FLAV = {'desktop': 'Desktop', 'server': 'Server', 'virt': 'Virtualization', 'containers': 'Containers', 'edge': 'Edge', 'base': 'Container base'}
# extension -> (format key, what it is for, kind)
FMT = [
  ('iso',                    'ISO installer',            'installer'),
  ('qcow2',                  'qcow2 (KVM, Proxmox, OpenStack, UTM)', 'vm'),
  ('raw.xz',                 'Raw disk, xz (AWS, DigitalOcean, Linode, bare metal)', 'vm'),
  ('vmdk',                   'VMDK (VMware)',            'vm'),
  ('ova',                    'OVA (VMware, VirtualBox)', 'vm'),
  ('vhdx',                   'VHDX (Hyper-V)',           'vm'),
  ('vhd',                    'VHD fixed (Azure)',        'vm'),
  ('vdi',                    'VDI (VirtualBox)',         'vm'),
  ('gcp.tar.gz',             'Google Cloud image',       'vm'),
  ('incus-vm.tar.xz',        'Incus VM metadata (use with the qcow2)', 'vm'),
  ('img.xz',                 'Raspberry Pi image',       'sbc'),
  ('oci.tar',                'OCI container image',      'container'),
  ('wsl',                    'WSL distribution',         'container'),
  ('incus-container.tar.xz', 'Incus container metadata (use with the squashfs)', 'container'),
  ('incus-container.squashfs','Incus container root file system', 'container'),
  ('netboot.tar.xz',         'PXE / iPXE boot files',    'netboot'),
]
pat = re.compile(r'^nubo-os-(?P<flavour>[a-z]+)-' + re.escape(ver) + r'-(?P<arch>amd64|arm64)(?:-(?P<variant>raspi))?\.(?P<ext>.+)$')
items = []
for name, e in sorted(files.items()):
    if name.endswith(('.sha256', '.torrent')) or not name.startswith('nubo-os-'):
        continue
    m = pat.match(name)
    if not m:
        continue
    ext = m['ext']
    fmt = next((f for f in FMT if f[0] == ext), None)
    if not fmt:
        continue
    sp = os.path.join(sums, name + '.sha256')
    sha = open(sp).read().split()[0] if os.path.exists(sp) else None
    items.append({
        'flavour': m['flavour'], 'name': FLAV.get(m['flavour'], m['flavour']), 'arch': m['arch'],
        'format': ext, 'label': fmt[1], 'kind': fmt[2], 'file': name, 'url': f'{base}/{ver}/{name}',
        'size': e['Size'], 'sha256': sha, 'torrent': f'{base}/{ver}/{name}.torrent' if (name + '.torrent') in files else None,
    })
json.dump({'version': ver, 'base': base, 'generated': time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime()), 'images': items}, sys.stdout, indent=1)
