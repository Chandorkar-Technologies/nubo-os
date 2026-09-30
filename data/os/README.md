# System identity

What the system calls itself, and what is deliberately left alone.

## Changed

| Field | Value | Seen in |
|---|---|---|
| `NAME`, `PRETTY_NAME` | Nubo OS | Settings › About, login console, system info tools |
| `LOGO` | `nubo-logo` | Settings › About |
| `/etc/issue` | Nubo OS 1 | Text console login |
| `/etc/lsb-release` description | Nubo OS 1 | How other installers list this system in dual-boot menus |
| Settings panel "Ubuntu Desktop" | "Desktop" | Settings sidebar |

## Kept as Ubuntu, on purpose

| Field | Value | Why |
|---|---|---|
| `ID` | `ubuntu` | Third-party installers (Docker, Node, Microsoft, most vendor repos) check this exact value and refuse unknown systems |
| `VERSION_ID`, `VERSION_CODENAME`, `UBUNTU_CODENAME` | `26.04`, `resolute` | Package sources and PPAs are selected by these |
| Boot loader name | `Ubuntu` | The signed boot loader looks for its files under `EFI/ubuntu`. Renaming moves them and the machine stops booting with Secure Boot on |

The boot menu is hidden on a normal start, so the boot loader name is not
visible in everyday use.
