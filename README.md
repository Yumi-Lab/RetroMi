<p align="center">
  <img src="https://raw.githubusercontent.com/Yumi-Lab/RetroMi/develop/src/modules/emulatiostation/filesystem/home/pi/.emulationstation/themes/retromi/art/retromi-logo.png" style="width:50%" onerror="this.style.display='none'">
</p>

<h1 align="center">RetroMi</h1>
<p align="center"><strong>Retrogaming image for SmartPi One — AllWinner H3 / ARMv7</strong></p>

<p align="center">
  <a href="https://github.com/Yumi-Lab/RetroMi/releases"><img alt="GitHub release" src="https://img.shields.io/github/v/release/Yumi-Lab/RetroMi"></a>
  <a href="https://github.com/Yumi-Lab/RetroMi/actions"><img alt="Build" src="https://img.shields.io/github/actions/workflow/status/Yumi-Lab/RetroMi/Release.yml?branch=develop"></a>
  <img alt="License" src="https://img.shields.io/github/license/Yumi-Lab/RetroMi">
</p>

---

RetroMi est une image Armbian Bookworm prête à l'emploi pour le **SmartPi One** (AllWinner H3 — ARMv7 32-bit), transformant votre nano-ordinateur en station de retrogaming complète avec EmulationStation, RetroArch et plus de **80 émulateurs** pré-compilés.

RetroMi is a ready-to-use Armbian Bookworm image for the **SmartPi One** (AllWinner H3 — ARMv7 32-bit), turning your nano-computer into a full retrogaming station with EmulationStation, RetroArch and over **80 pre-compiled emulators**.

---

## ✨ Features / Fonctionnalités

| Feature | Details |
|---------|---------|
| 🎮 **EmulationStation** | Custom RetroMi theme, pre-configured |
| 🕹️ **RetroArch** | 80+ libretro cores, Mali-400 optimized config |
| 📦 **Pre-compiled packages** | 16 groups built for armhf — no compilation on device |
| 🔫 **Sinden Lightgun** | Full support included |
| 🌐 **FileBrowser** | Web-based ROM manager on port 80 |
| 🔌 **USB auto-mount** | Plug a USB drive → ROMs detected automatically |
| 🎵 **Background music** | Retro ambiance music in EmulationStation |
| ⚡ **Fast boot** | ~15 min build, RetroMi-packages pre-compiled separately |

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

## 📥 Installation

### 1. Download / Télécharger

Download the latest `.img.xz` from the [Releases page](https://github.com/Yumi-Lab/RetroMi/releases).

### 2. Flash

Use [Balena Etcher](https://etcher.balena.io/) or `dd` to flash the image to a microSD card (≥ 16 GB recommended).

### 3. Boot

Insert the card into your SmartPi One and power on. First boot takes 2–3 minutes (initial setup).

---

## 🔑 Default credentials

| | Value |
|-|-------|
| **Username** | `pi` |
| **Password** | `yumi` |

---

## 🌐 Adding ROMs — FileBrowser

Access the web file manager at **`http://<device-ip>/`** (port 80):

- Login: `admin` / `admin` *(change after first login)*
- Navigate to `pi/RetroPie/roms/<system>/` and upload your ROM files
- Restart EmulationStation to refresh the game list

---

## 📡 Wi-Fi setup

From the EmulationStation menu → **Wi-Fi**, or via SSH:

```bash
sudo armbian-config
# → Network → Wi-Fi
```

---

## 💾 USB ROMs (plug & play)

Create a `RetroPie` folder on your USB drive with the standard RetroPie folder structure. Plug it in — ROMs are detected and linked automatically.

---

## 🏗️ Architecture

```
Layer 1 — Yumi-Lab/SmartPi-armbian   : Armbian Bookworm server base (armhf)
Layer 2 — Yumi-Lab/RetroMi-packages  : 80+ pre-compiled libretro cores (16 groups)
Layer 3 — Yumi-Lab/RetroMi           : EmulationStation theme, config, modules
```

Layer 2 is built separately via QEMU armhf in Docker — no compilation on the device.

---

## 🛠️ Build from source

```bash
# Trigger a RetroMi image build
gh workflow run Release.yml --repo Yumi-Lab/RetroMi -f version=X.Y.Z

# Trigger a RetroMi-packages build (emulator cores)
gh workflow run build.yml --repo Yumi-Lab/RetroMi-packages -f version=X.Y.Z
```

Requirements: [CustomPiOS-Yumi](https://github.com/Yumi-Lab/CustomPiOS-Yumi)

---

## 🤝 Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Conventional commits required. DCO sign-off enforced.

---

## 📄 License

GPL-3.0 — see [LICENSE](LICENSE).

---

<p align="center">Made with ❤️ by <a href="https://github.com/Yumi-Lab">Yumi Lab</a></p>
