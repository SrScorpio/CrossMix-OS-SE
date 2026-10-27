<div align="center">
    <img src="_assets/readme/banner-se.png" alt="CrossMix-OS SE — Scorpio Edition">
</div>

<div align="center">

**Scorpio Edition** — red is the new blue. Same soul, sharper edge.  
_Get the best from your TrimUI Smart Pro_

</div>

> **CrossMix-OS SE** — Scorpio Edition, maintained fork by [SrScorpio](https://github.com/SrScorpio).
> Based on [CrossMix-OS](https://github.com/cizia64/CrossMix-OS) by **cizia64** and contributors — all credit for the original work is theirs. Same license: GPL-3.0.
> Visible branding, what it covers and what stays firmware-owned: [docs/BRANDING.md](docs/BRANDING.md).
>
> **SE at a glance:** authenticated OTA updates (TLS, fail-closed) · no fixed firmware passwords (root locked, SSH by key only, enabled from System Tools → Network → SSH Server) · PortMaster framework 2026.09.30 · PPSSPP 1.19.0 with GL-first entries · SE-branded info screens · optional swap (off by default). Requires firmware ≥ `v1.1.1 / 20251128` — see the [firmware runbook](docs/FIRMWARE-UPDATE.md).

<div align="center">
  <a href="https://github.com/SrScorpio/CrossMix-OS-SE/releases/latest">
    <img src="_assets/readme/download-se.png" alt="Download" style="width: 300px;">
  </a>
</div>

<div align="center">

<a href="https://nan.builders/?ref=built-with-nan">
 <picture>
 <source media="(prefers-color-scheme: light)" srcset="https://nan.builders/badge/built-with-nan-light.svg">
 <img width="266" src="https://nan.builders/badge/built-with-nan-dark.svg" alt="Built with NaN">
 </picture>
</a>

[![Built with NaN](https://nan.builders/badge/built-with-nan-compact.svg)](https://nan.builders/?ref=built-with-nan)

_Built with [NaN](https://nan.builders/?ref=built-with-nan) — the agent platform behind this fork._

</div>

&nbsp;<br/>



<p>&nbsp;</p>

![bar](https://github.com/user-attachments/assets/730a4dd6-5f33-4274-9959-b188f3013142)

<p>&nbsp;</p>

<p align="center"><img src="https://github.com/user-attachments/assets/2339e8fd-cdac-4d2b-938b-edae23facb82" width="200"></p>

&nbsp;<br/>


# Introduction

CrossMix-OS, the OS which elevates your TrimUI Smart Pro to new heights. 

CrossMix-OS uses TrimUI Stock user interface with refined configurations, new features, new emulators and new apps. There are so many differences that CrossMix can be considered an dédicated OS in its own right.

Designed with the community in mind, CrossMix-OS caters to developers and creators alike. It supports a wide range of customizations, including themes, icon packs, background packs, templates for "Best" collections, and automatic overlay configurations.

As a completely free and open-source platform, CrossMix-OS invites you to explore, contribute, and customize to your heart's content.

&nbsp;<br/>&nbsp;<br/>


![bar](https://github.com/user-attachments/assets/730a4dd6-5f33-4274-9959-b188f3013142)

&nbsp;<br/>

# Getting Started

First take a look to CrossMix Wiki, below are the different sections:

&nbsp;<br/>

## 🏠[Home](https://github.com/cizia64/CrossMix-OS/wiki/Home)

## 🛠️ [Installation](https://github.com/cizia64/CrossMix-OS/wiki/Installation)

## 🎮 [Emulators](https://github.com/cizia64/CrossMix-OS/wiki/Emulators)

## <img src="https://avatars.githubusercontent.com/u/96267164?s=200&v=4" width="20"> [PortMaster](https://github.com/cizia64/CrossMix-OS/wiki/PortMaster)

## :iphone: [Apps](https://github.com/cizia64/CrossMix-OS/wiki/apps)

## ⌨️ [Shortcuts](https://github.com/cizia64/CrossMix-OS/wiki/shortcuts)

## ❔ [FAQ](https://github.com/cizia64/CrossMix-OS/wiki/FAQ)

## 🔧 [Advanced Guides](https://github.com/cizia64/CrossMix-OS/wiki/Advanced-Guides)

## 🛈 [About](https://github.com/cizia64/CrossMix-OS/wiki/About)

## 🎁 [Contributing](https://github.com/cizia64/CrossMix-OS/wiki/Contributing)

&nbsp;<br/>&nbsp;<br/>

![bar](https://github.com/user-attachments/assets/730a4dd6-5f33-4274-9959-b188f3013142)

<p>&nbsp;</p>

# CrossMix-OS SE — install, migrate, update

## 🆕 Install from scratch (SE image)

1. Download the latest SE image (`CrossMix-OS_v<version>.7z`) from **[Releases](https://github.com/SrScorpio/CrossMix-OS-SE/releases/latest)** and extract it at the **root** of a blank/expendable SD card (FAT32 or exFAT).
2. Check the firmware first: System Tools → Information must report ≥ `v1.1.1 / 20251128`. If not, the in-OS **Firmware Update wizard** guides you — verified steps and evidence in [docs/FIRMWARE-UPDATE.md](docs/FIRMWARE-UPDATE.md).
3. Boot. From then on, updates arrive **over the air** (next section) — the full image is only needed for a clean install.

## 🔁 Migrate from upstream CrossMix (cizia64 1.2.1 / 1.3.0 / 1.3.9 / 1.3.9.1)

No reflash needed. Use the **CE-Migration kit** from the latest release (`CE-Migration-<version>.zip`):

1. **Back up your SD first** (full image on your PC). Do not skip this.
2. With the SD in your PC, unzip the kit at the **root** of the SD card (accept replacing files; it only adds/overwrites the files it contains).
3. The kit stamps the version key to the SE channel, installs the current updater chain and the **CA bundle** — so even your first update check is TLS-authenticated.
4. SD back in the console, boot, then **Check Update / OTA-update**. From that point the console follows `SrScorpio/CrossMix-OS-SE`.
5. Future changes arrive as KB-sized **hotfixes**; the big image is never re-downloaded.

Step-by-step details (Spanish): `MIGRAR-LEEME.txt` inside the kit.

## 📡 Update (OTA)

- **Check Update** (or the OTA-update app) queries this repo. Versions are compared against `crossmix-version.txt` on the card.
- Downloads are **TLS-authenticated, fail-closed**: the console validates every host against the Mozilla CA bundle shipped at `System/etc/ssl/ca-certificates.crt`. There is no insecure fallback — if validation cannot be done, the download is refused. Design and hardware evidence: [docs/ota-security-design.md](docs/ota-security-design.md).
- Hotfix releases are small `.sh`+`.zip` pairs under `_assets/hotfixes/`; consoles still carrying an upstream version key get a **stub** that safely delegates to the current SE hotfix.

## 📚 SE documentation index

| Doc | What it covers |
| --- | --- |
| [docs/BRANDING.md](docs/BRANDING.md) | What the SE branding changes and what stays firmware-owned |
| [docs/FIRMWARE-UPDATE.md](docs/FIRMWARE-UPDATE.md) | TrimUI firmware runbook (≥ v1.1.1), verified on hardware |
| [docs/ota-security-design.md](docs/ota-security-design.md) | Why and how OTA downloads are TLS-authenticated, with hardware probes |
| [docs/RELEASE-MANIFEST.md](docs/RELEASE-MANIFEST.md) | Audit manifests for published images and hotfixes |
| [docs/QA-COVERAGE.md](docs/QA-COVERAGE.md) | What the QA harness checks on every PR |
| [docs/emulators-matrix.md](docs/emulators-matrix.md) | Emulator/core inventory of the SE image |
| [docs/SLIM-OPTIONS.md](docs/SLIM-OPTIONS.md) | Measured slimming options (space savings) |

## 🛟 Support

- **SE-specific problems** (updater, migration kit, branding): open an issue in **this repo**.
- Everything that is shared base with upstream: the cizia64 wiki links above still apply, and bugs found there belong in [cizia64/CrossMix-OS issues](https://github.com/cizia64/CrossMix-OS/issues).

&nbsp;<br/>&nbsp;<br/>


# Some words from the author

I'm Cizia, a passionate retrogamer. I love the TrimUI Smart Pro, but I felt it deserved a more mature OS, better configured, and with more options. I worked tirelessly to create an image that meets my standards, and today, I'm sharing it with you.

There are some features I'm particularly proud of, such as:

- **Background and icon selectors**: it completes well the native theme selector.
- **Overlay selector**: Configure your default display ratio and overlay in one click for all platforms, plus new dedicated overlays.
- **SwanStation 16/9 mode launcher**.
- **Extensive work on emulator launchers and configuration**.
- **Default customization of the OS**: custom theme, icons and backgrounds, Polish language added and many new tools.
- **Firmware Update Wizard**: an automatic guide to help user to update if necessary.
- **Best packs standardization**: generic launcher, game shortcuts support and images on folders.

I would also like to extend a warm thank you to Kloptops for [PortMaster and his tools](https://github.com/kloptops/TRIMUI_EX) which are deeply used in CrossMix-OS.

Thanks to Schmurtzm for his numerous scripts, I have revised and integrated them into CrossMix-OS, which have greatly enhanced the available features:
- [PSX Analog Detector](https://github.com/schmurtzm/TrimUI-Smart-Pro/blob/main/SystemTools/Apps/SystemTools/Menu/EMULATORS/PSX%20Analog%20Detector.sh): Detects PSX games compatible with analog sticks and automatically sets the correct controller configuration.
- [BootLogo](https://github.com/schmurtzm/TrimUI-Smart-Pro/tree/main/Bootlogo): An app for easy boot logo flashing on TrimUI Smart Pro.
- [EmuCleaner](https://github.com/schmurtzm/TrimUI-Smart-Pro/tree/main/EmuCleaner): An app to display only emulators with ROMs installed.
- [System Tools](https://github.com/schmurtzm/TrimUI-Smart-Pro/tree/main/SystemTools): An app to centralize different apps/scripts in one place.
- [Resume at Boot](https://github.com/schmurtzm/TrimUI-Smart-Pro/tree/main/ResumeAtBoot): A set of scripts to add a resume game on startup feature.
- [Subfolder config override finder](https://github.com/libretro/RetroArch/issues/12021#issuecomment-2107300989) is also used in CrossMix-OS.
- [Scraper](https://github.com/schmurtzm/TrimUI-Smart-Pro/tree/main/Scraper): an app to automatically download boxarts.


I hope CrossMix-OS will become a reference among OSes based on the stock OS and continue to improve with community support.

&nbsp;<br/>&nbsp;<br/>

![bar](https://github.com/user-attachments/assets/730a4dd6-5f33-4274-9959-b188f3013142)

<p>&nbsp;</p>

## Help the CrossMix-OS project

I have more ideas and improvements for this project, and you might have some too. Don't hesitate to share them!

Contribute to this repo by making a Pull Request. If you have an improvement to propose and don't know how to use GitHub, send me a message!

Feel free to reach out to me to report bugs, request features, or just chat on **[Discord](https://discord.gg/Jd2azKX)** or on **[Github Issues](https://github.com/cizia64/CrossMix-OS/issues?q=is%3Aissue+is%3Aopen+sort%3Aupdated-desc)**

If you enjoy my work and want to support the countless hours/days invested, here are my sponsors:

- [![Patreon](_assets/readme/patreon.png)](https://patreon.com/Cizia)
- [![Buy Me a Coffee](_assets/readme/bmc.png)](https://www.buymeacoffee.com/cizia)
- [![ko-fi](_assets/readme/ko-fi.png)](https://ko-fi.com/H2H7YPH3H)


