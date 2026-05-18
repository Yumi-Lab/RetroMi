# Batocera ES Menu System — Audit complet

Audit du Batocera v39 (Buildroot 2023.05.1) sur Orange Pi PC (H3).
IP: 192.168.100.104, user: root/linux

## Architecture globale

Batocera n'a PAS de "retropie menu" separé. Tout est integré directement dans
EmulationStation via le menu Start. ES est un fork custom (batocera-emulationstation)
compilé en C++ avec les menus systeme intégrés au code source.

### Comment ca marche

```
[Bouton START] → Menu ES (C++ compilé)
    ├── SYSTEM SETTINGS
    │   ├── WiFi → appelle batocera-wifi (shell, connman)
    │   ├── Bluetooth → appelle batocera-bluetooth (shell + python agent)
    │   ├── Audio → appelle batocera-audio (shell, pactl/pipewire)
    │   ├── Language → batocera-settings-set system.language
    │   ├── Timezone → batocera-timezone (shell, curl ipapi.co)
    │   ├── Hostname → batocera-settings-set system.hostname
    │   ├── Storage → batocera-config storage (shell)
    │   ├── Overclock → batocera-overclock (shell, /boot/config.txt)
    │   ├── Security → batocera-config setRootPassword
    │   └── Power switch → batocera-settings-set system.power.switch
    ├── GAME SETTINGS
    │   ├── Video mode → batocera-resolution (DRM)
    │   ├── Shaders → es_features.cfg presets
    │   ├── Bezels → es_features.cfg presets
    │   ├── Rewind/Runahead → retroarch config via configgen
    │   ├── RetroAchievements → batocera-settings-set
    │   └── AI Translation → batocera-settings-set
    ├── CONTROLLER SETTINGS
    │   ├── Configure → ES built-in wizard (C++)
    │   ├── Battery → batocera-padsinfo (sdl2-jstest + sysfs)
    │   └── Driver PS3 → bluez/sixad/shanwan
    ├── UI SETTINGS
    │   ├── Theme → ES built-in
    │   ├── Screensaver → ES built-in
    │   └── Menu style → default/bartop/none
    ├── UPDATES
    │   ├── Check → batocera-config canupdate
    │   └── Apply → batocera-upgrade (OTA boot.tar.xz)
    ├── CONTENT DOWNLOADER
    │   └── → batocera-store (pacman wrapper)
    └── SERVICES
        └── → batocera-services (enable/disable)
```

## Fichier de configuration central

`/userdata/system/batocera.conf` — format `key=value`, lu par `batocera-settings-get` (binaire C compilé), ecrit par `batocera-settings-set`.

Pas de base de donnees, pas de JSON, pas de XML pour la config utilisateur.
Tout passe par ce fichier unique.

## Scripts récupérés

Voir le dossier `scripts/` pour le code source complet de chaque script.

| Script | Fonction | Backend |
|--------|----------|---------|
| batocera-wifi | Scan/enable/disable WiFi | ConnMan (connmanctl) |
| batocera-bluetooth | Pair/trust/remove/save BT | BlueZ + Python agent |
| batocera-audio | List/set audio device + volume | PipeWire (pactl) |
| batocera-overclock | List/set CPU overclock presets | /boot/config.txt |
| batocera-services | Enable/disable system services | Scripts in /usr/share/batocera/services/ |
| batocera-store | Install/remove packages | pacman |
| batocera-upgrade | OTA system update | curl + tar xz sur /boot |
| batocera-config | Overscan, storage, password, tz, modules | Multi-tool central |
| batocera-padsinfo | Controller info + battery XML | sdl2-jstest + sysfs |
| batocera-resolution | DRM resolution management | batocera-drminfo |
| batocera-timezone | Get/set/detect timezone | curl ipapi.co |
| S08connman | WiFi init service | ConnMan daemon |
| S32bluetooth | Bluetooth init service | bluetoothd + agent |

## Fonctions UNIQUES a Batocera (pas dans RetroMi)

### 1. WiFi intégré dans ES
- **Batocera** : menu Start → System Settings → WiFi, appelle `batocera-wifi` via ConnMan
- **RetroMi** : RetroPie menu → WiFi (script retropie_packages/wifi.sh via dialog)
- **Parallele possible** : OUI, meme concept. RetroMi utilise deja wpa_supplicant. On pourrait ajouter un menu ES natif qui appelle un script `retromi-wifi` similaire.

### 2. Bluetooth intégré dans ES
- **Batocera** : menu Start → Controllers → Pair BT, appelle `batocera-bluetooth` + agent Python dbus
- **RetroMi** : RetroPie menu → Bluetooth (script retropie_packages/bluetooth.sh via dialog)
- **Parallele possible** : OUI. L'agent Python est la piece maitresse. On pourrait l'adapter.

### 3. Audio device selection dans ES
- **Batocera** : menu Start → System → Audio Output, utilise PipeWire/pactl
- **RetroMi** : RetroPie menu → Audio (dialog-based)
- **Parallele possible** : OUI, mais RetroMi utilise ALSA, pas PipeWire.

### 4. OTA Updates
- **Batocera** : menu Start → Updates → Check/Apply, `batocera-upgrade` telecharge boot.tar.xz
- **RetroMi** : Pas d'OTA. Images flashees manuellement.
- **Parallele possible** : OUI, c'est exactement la roadmap OTA de RetroMi.

### 5. Content Downloader (Store)
- **Batocera** : menu Start → Content Downloader, `batocera-store` wraps pacman
- **RetroMi** : Pas equivalent. Les packages sont pre-compiles dans l'image.
- **Parallele possible** : Complexe. Necessite un repo de packages + pacman ou apt.

### 6. Controller Battery Level
- **Batocera** : affiché dans ES, `batocera-padsinfo` lit sysfs + sdl2-jstest
- **RetroMi** : Non disponible.
- **Parallele possible** : OUI, script simple. Juste lire /sys/class/power_supply/.

### 7. Overclock presets
- **Batocera** : menu Start → System → Overclock, presets par board
- **RetroMi** : Non disponible.
- **Parallele possible** : OUI, tres simple. Ecrire dans /boot/armbianEnv.txt ou config.txt.

### 8. Services management
- **Batocera** : menu Start → Services, enable/disable services user/system
- **RetroMi** : Non disponible via ES.
- **Parallele possible** : OUI, concept simple.

### 9. Storage device selection
- **Batocera** : menu Start → System → Storage, switch INTERNAL/EXTERNAL/RAM
- **RetroMi** : USB auto-mount (auto-mount-retromi), mais pas de choix dans ES.
- **Parallele possible** : Partiellement deja fait avec USB auto-mount.

### 10. Security (password management)
- **Batocera** : menu Start → System → Security, password root
- **RetroMi** : Non disponible via ES.
- **Parallele possible** : OUI mais pas prioritaire.

## Difference architecturale cle

| Aspect | Batocera | RetroMi |
|--------|----------|---------|
| ES version | Fork custom C++ | Vanilla RetroPie ES |
| Config | batocera.conf (key=value) | retroarch.cfg + fichiers multiples |
| Network | ConnMan | NetworkManager/wpa_supplicant |
| Audio | PipeWire/PulseAudio | ALSA |
| Bluetooth | Agent Python dbus custom | bluetoothctl manual |
| Packages | pacman | apt (Debian) |
| Init system | Buildroot (S00-S99 scripts) | systemd |
| Menu systeme | Integre dans ES (C++) | Externe (RetroPie menu, scripts dialog) |
| Updates | OTA boot.tar.xz | Pas d'OTA |

## Conclusion — Faisabilite pour RetroMi

Le modele Batocera est **tres different architecturalement** car ils ont forke ES
pour integrer les menus directement en C++. RetroMi utilise le ES vanilla de RetroPie.

**Approches possibles pour RetroMi :**

1. **Garder le RetroPie menu** (actuel) — continuer d'ajouter des scripts dialog
2. **Creer des scripts CLI** inspires de Batocera (`retromi-wifi`, `retromi-bluetooth`, etc.)
   et les appeler depuis le RetroPie menu existant
3. **Forker ES** comme Batocera — TRES lourd, pas recommande
4. **Utiliser le systeme de "scripting" ES** — certaines versions d'ES supportent des
   custom scripts dans le menu. A investiguer si la version RetroPie le permet.

**Recommandation : Option 2** — Creer une suite de scripts `retromi-*` inspires de
l'architecture Batocera, appelables depuis le RetroPie menu. C'est le meilleur ratio
effort/resultat. Les scripts Batocera sont propres, bien documentes, et facilement
adaptables a notre stack Debian/systemd.
