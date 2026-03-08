<h1 align="center">RetroMi</h1>
<p align="center"><strong>Retrogaming image for SmartPi One — AllWinner H3 / ARMv7</strong></p>

<p align="center">
  <a href="https://github.com/Yumi-Lab/RetroMi/releases"><img alt="GitHub release" src="https://img.shields.io/github/v/release/Yumi-Lab/RetroMi"></a>
  <a href="https://github.com/Yumi-Lab/RetroMi/actions"><img alt="Build" src="https://img.shields.io/github/actions/workflow/status/Yumi-Lab/RetroMi/Release.yml?branch=develop"></a>
  <img alt="License" src="https://img.shields.io/github/license/Yumi-Lab/RetroMi">
</p>

---

RetroMi is a ready-to-use Armbian Bookworm image for the **SmartPi One** (AllWinner H3 — ARMv7 32-bit), turning your nano-computer into a full retrogaming station with EmulationStation, RetroArch and over **80 pre-compiled emulators**.

RetroMi est une image Armbian Bookworm prête à l'emploi pour le **SmartPi One** (AllWinner H3 — ARMv7 32-bit), transformant votre nano-ordinateur en station de retrogaming complète avec EmulationStation, RetroArch et plus de **80 émulateurs** pré-compilés.

---

## Features / Fonctionnalités

| Feature | Details |
|---------|---------|
| **EmulationStation** | 17 themes pre-installed (EpicNoir default) |
| **RetroArch** | 80+ libretro cores, Mali-400 GPU optimized |
| **Pre-compiled packages** | 16 groups built for armhf — no compilation on device |
| **235 gamepads** | PS3/PS4/PS5, Xbox, Switch Pro, 8BitDo, Logitech — auto-configured |
| **Bezels / Overlays** | Per-system decorative bezels from TheBezelProject (19 systems) |
| **FileBrowser** | Web-based ROM manager on port 80 |
| **USB auto-mount** | Plug a USB drive — ROMs detected automatically |
| **Fast boot** | Custom Plymouth splash, ~25 min build |

### Pre-installed themes (17)

| Source | Themes |
|--------|--------|
| Bundled (7z) | EpicNoir (default), Carbon 2021, Switch Black v2, Switch, ArkOS Carbon, Epic, Freeplay, GBZ35 Mod, Magical Pixel, Minimal ArkOS, NES Box |
| Community | Art Book Next, Elementerial (MIT), Chicuelo, Not-so-Epic, LCARS (CC0), Tronkyfran |

### Supported systems (80+ cores across 16 groups)

| Group | Systems |
|-------|---------|
| `retroarch` | RetroArch frontend |
| `arcade` | FBNeo |
| `arcade-compat` | MAME 2000/2003/2003+/2010, FBAlpha2012 |
| `nintendo` | NES, SNES, GB/GBC, GBA (13 cores) |
| `n64` | N64, PC Engine / TurboGrafx (5 cores) |
| `sega` | Mega Drive, Sega CD, 32X, Master System, Game Gear, Neo Geo CD |
| `sony` | PlayStation 1 |
| `psp` | PlayStation Portable (PPSSPP) |
| `misc` | Doom, Quake, Atari 2600, Pico-8, WASM-4, EasyRPG, Cave Story… |
| `scummvm` | ScummVM — 250+ point & click adventures |
| `dosbox` | DOSBox Pure |
| `portables` | NGP, Lynx, VB, WonderSwan, Pokémon Mini, Arduboy… |
| `computers` | C64, MSX, Atari 8-bit, ZX Spectrum, Amstrad CPC, Atari ST, Apple II, BBC Micro, Enterprise 128 |
| `amiga` | Amiga (uae4arm, PUAE) |
| `japan-computers` | PC-98, PC-88, X68000, Sharp X1 |
| `heavy` | DS, Dreamcast, Saturn, 3DO, Jaguar |

---

## Installation

### 1. Download / Télécharger

Download the image parts (`.7z.001`, `.7z.002`) from the [Releases page](https://github.com/Yumi-Lab/RetroMi/releases).

The image is split into two parts due to GitHub's 2 GiB file size limit.

### 2. Extract / Extraire

**Windows** — Use [7-Zip](https://7-zip.org/): right-click on `.7z.001` → Extract Here

**macOS** — Use [Keka](https://www.keka.io/) or [The Unarchiver](https://theunarchiver.com/): open `.7z.001`

**Linux** :
```bash
7z x RetroMi-*.img.7z.001
```

Verify integrity:
```bash
sha256sum -c *.sha256
```

### 3. Flash

> **Important:** Balena Etcher is NOT compatible with AllWinner H3 images. Use `dd` instead.

```bash
# Linux/macOS
sudo dd if=RetroMi-*.img of=/dev/sdX bs=4M status=progress
```

**Windows** — Use [Win32 Disk Imager](https://sourceforge.net/projects/win32diskimager/) or [Rufus](https://rufus.ie/) (DD mode).

### 4. Boot

Insert the card into your SmartPi One and power on. First boot takes 2–3 minutes (initial setup).

---

## Default credentials

| Service | User | Password |
|---------|------|----------|
| **SSH** | `pi` | `yumi` |
| **FileBrowser** (port 80) | `admin` | `RetroMi2026!` |
| **FileBrowser** (port 80) | `pi` | `YumiRetroMi25` |

---

## Adding ROMs

### FileBrowser (web)

Access **`http://<device-ip>/`** (port 80), navigate to `RetroPie/roms/<system>/` and upload your ROM files. Restart EmulationStation to refresh the game list.

### USB (plug & play)

Create a `RetroPie/roms/<system>/` folder structure on a USB drive. Plug it in — ROMs are detected and linked automatically.

### SCP (SSH)

```bash
scp game.zip pi@<device-ip>:/home/pi/RetroPie/roms/<system>/
```

---

## Wi-Fi setup

From the EmulationStation menu → **RetroPie** → **Wi-Fi**, or via SSH:

```bash
sudo nmtui
```

---

## Architecture

```
Layer 1 — Yumi-Lab/SmartPi-armbian   : Armbian Bookworm server base (armhf)
Layer 2 — Yumi-Lab/RetroMi-packages  : 80+ pre-compiled libretro cores (16 groups)
Layer 3 — Yumi-Lab/RetroMi           : EmulationStation themes, config, modules
```

Layer 2 is built separately via QEMU armhf in Docker — no compilation on the device.

### Build modules chain

```
base → pkgupgrade → udev_fix → controllers → armbian → armbian_net → retropie
     → retroarch → bezels → yumios → plymouth → filebroswer → emulatiostation → usb-mount
```

---

## Build from source

```bash
# Trigger a RetroMi image build
gh workflow run Release.yml --repo Yumi-Lab/RetroMi -f version=X.Y.Z

# Trigger a RetroMi-packages build (emulator cores)
gh workflow run build.yml --repo Yumi-Lab/RetroMi-packages -f version=X.Y.Z
```

Requirements: [CustomPiOS-Yumi v1.5.0](https://github.com/Yumi-Lab/CustomPiOS-Yumi)

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Conventional commits required. DCO sign-off enforced.

---

## License

GPL-3.0 — see [LICENSE](LICENSE).

---

<p align="center">Made with ❤️ by <a href="https://github.com/Yumi-Lab">Yumi Lab</a></p>
