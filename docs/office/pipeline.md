# Pipeline for Nubo Office

**Applies to:** Developers

:::caution[Not run end to end yet]
`ci/build-office.sh` and the `office-amd64` pipeline are written. The first run needs watching.
:::

## Trigger

A Git tag that starts with `office-`:

```bash
git tag office-26.04.3.3-1 && git push origin office-26.04.3.3-1
```

The tag `office-26.04.3.3-1` builds Collabora's `coda-26.04.3.3-1` as version `26.04.3.3-nubo1`. These tags have their own pipeline because the build takes hours. The normal release pipelines ignore them.

## What the script does

`ci/build-office.sh UPSTREAM_TAG NUBO_VERSION` runs on an amd64 build machine that Drone reaches with its exec runner (see [Drone](/developers/ci-with-drone/)):

1. Clones Collabora's tag.
2. Applies `office/rebrand.py`. If a Collabora product name is still in the interface, it stops.
3. Installs the Flatpak runtimes (`org.kde.Platform` and `Sdk` 6.10, the node20 extension, the Qt WebEngine base app).
4. Builds `tech.nubosuite.Office` with `flatpak-builder`. The engine is built inside, with the product name Nubo Office.
5. Signs the repository, writes `nubo.flatpakrepo` with the key, and syncs it to `archive.nubosuite.tech/flatpak`.

It needs these Drone secrets: `nubo_gpg_private_key`, `r2_access_key_id`, `r2_secret_access_key` and `r2_endpoint`.

## Install from it

```bash
flatpak remote-add --if-not-exists nubo https://archive.nubosuite.tech/flatpak/nubo.flatpakrepo
flatpak install nubo tech.nubosuite.Office
```

## Verify

After a run, `https://archive.nubosuite.tech/flatpak/nubo.flatpakrepo` answers, and `flatpak remote-ls nubo` lists `tech.nubosuite.Office`.

## Troubleshooting

- **The build runs out of disk.** The Flatpak build needs about 60 GB. Free space on the build machine.
- **The first run is slow.** Without cached work the engine builds from scratch. `--ccache` keeps results between runs on the same machine.

## See also

- [Source and build](source-and-build.md)
- [Publishing releases](/developers/publishing-releases/)
