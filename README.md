<h1 align="center">RetroMi</h1>
<p align="center"><strong>Retrogaming image for SmartPi One — AllWinner H3 / ARMv7</strong></p>

<p align="center">
  <a href="https://github.com/Yumi-Lab/RetroMi/releases"><img alt="GitHub release" src="https://img.shields.io/github/v/release/Yumi-Lab/RetroMi"></a>
  <a href="https://github.com/Yumi-Lab/RetroMi/actions"><img alt="Build" src="https://img.shields.io/github/actions/workflow/status/Yumi-Lab/RetroMi/Release.yml?branch=develop"></a>
  <img alt="License" src="https://img.shields.io/github/license/Yumi-Lab/RetroMi">
</p>

---

RetroMi is a ready-to-use Armbian Bookworm image for the **SmartPi One** (AllWinner H3 — ARMv7 32-bit), turning your nano-computer into a full retrogaming station with EmulationStation, RetroArch and over **100 pre-compiled emulators** — including Dreamcast, N64, PSP and PC game streaming via Moonlight.

RetroMi est une image Armbian Bookworm prête à l'emploi pour le **SmartPi One** (AllWinner H3 — ARMv7 32-bit), transformant votre nano-ordinateur en station de retrogaming complète avec EmulationStation, RetroArch et plus de **100 émulateurs** pré-compilés — dont Dreamcast, N64, PSP et streaming PC via Moonlight.

---

## Features / Fonctionnalités

| Feature | Details |
|---------|---------|
| **EmulationStation** | EpicNoir theme + 200+ downloadable themes |
| **RetroArch** | 100+ libretro cores, Mali-400 GPU optimized |
| **Pre-compiled packages** | 20 groups built for armhf — no compilation on device |
| **237 gamepads** | PS3/PS4/PS5, Xbox, Switch Pro, 8BitDo, Logitech — plug & play |
| **Dreamcast** | Flycast GLES2 — Crazy Taxi playable on H3 |
| **Moonlight** | PC game streaming via Sunshine (HEVC HW decode) |
| **Samba shares** | ROMs, BIOS, configs, splashscreens — guest access |
| **Bezels / Overlays** | Per-system decorative bezels from TheBezelProject (19 systems) |
| **FileBrowser** | Web-based ROM manager on port 80 |
| **USB auto-mount** | Plug a USB drive — ROMs detected automatically |
| **Fast boot** | Custom Plymouth splash, ~45 min build |

### Themes

**EpicNoir** pre-installed as default. 200+ additional themes available via the built-in theme downloader (ES menu → RetroPie → ES Themes).

### Supported systems (102 cores across 20 groups)

| Group | Systems |
|-------|---------|
| `retroarch` | RetroArch frontend + assets |
| `arcade` | FBNeo (Arcade / Neo Geo / CPS1-2-3) |
| `arcade-compat` | MAME 2000/2003/2003+/2010, FBAlpha2012 |
| `nintendo` | NES, SNES, GB/GBC, GBA (13 cores) |
| `n64` | N64, PC Engine / TurboGrafx (5 cores) |
| `sega` | Mega Drive, Sega CD, 32X, Master System, Game Gear, Neo Geo CD |
| `sony` | PlayStation 1 |
| `psp` | PlayStation Portable (PPSSPP) |
| `misc` | Doom, Quake, Atari 2600, Pico-8, WASM-4, TIC-80, EasyRPG, Cave Story, Java ME… |
| `openbor` | OpenBOR (Beat 'em Up engine) |
| `scummvm` | ScummVM — 250+ point & click adventures |
| `dosbox` | DOSBox Pure |
| `portables` | NGP, Lynx, VB, WonderSwan, Pokémon Mini, Arduboy, Vectrex, Game & Watch… |
| `computers` | C64, MSX, Atari 8-bit, ZX Spectrum, Amstrad CPC, Atari ST, Apple II, BBC Micro, Enterprise 128 |
| `amiga` | Amiga (uae4arm, PUAE) |
| `japan-computers` | PC-98, PC-88, X68000, Sharp X1 |
| `heavy` | DS, Dreamcast, Saturn, 3DO, Jaguar |
| `emulationstation` | EmulationStation frontend |
| `moonlight` | Moonlight — PC game streaming (Sunshine / NVIDIA) |
| `skyscraper` | Skyscraper — game metadata & artwork scraper |

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

Use [Balena Etcher](https://etcher.balena.io/), [Raspberry Pi Imager](https://www.raspberrypi.com/software/), or `dd`:

```bash
# Linux/macOS
sudo dd if=RetroMi-*.img of=/dev/sdX bs=4M status=progress
```

**Windows** — Use [Balena Etcher](https://etcher.balena.io/), [Win32 Disk Imager](https://sourceforge.net/projects/win32diskimager/), or [Rufus](https://rufus.ie/).

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
Layer 2 — Yumi-Lab/RetroMi-packages  : 102 pre-compiled libretro cores (20 groups)
Layer 3 — Yumi-Lab/RetroMi           : themes, config, modules, controllers, bezels
```

Layer 2 is built separately via QEMU armhf in Docker — no compilation on the device.

### Build modules chain

```
base → udev_fix → controllers → armbian → armbian_net → retropie
     → retroarch → bezels → yumios → plymouth → filebroswer → samba
     → emulatiostation → usb-mount
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
