# Image builds

| Image | Script | Status |
|---|---|---|
| Desktop ISO amd64 | `iso/build-iso.sh` | built before, needs re-run |
| Desktop ISO arm64 | `iso/build-iso.sh` on an arm64 Linux host | script is arch-aware now, untested |
| Raspberry Pi (arm64 .img) | `images/build-pi.sh` | untested |
| Cloud/VM (qcow2, vhd, ova) | `images/build-cloud.sh` | untested |
| Server ISO | not written yet | planned |

Nothing here has run on a real runner yet. Treat first CI runs as debugging.
