# Batocera vs Recalbox — Comparaison technique pour upstream RetroMi

## Stack RetroMi (notre cible)

- OS : Debian Bookworm (Armbian)
- Init : **systemd**
- WiFi : **wpa_supplicant** (via NetworkManager ou direct)
- Bluetooth : **BlueZ 5** (bluetoothctl)
- Audio : **ALSA** (pas PipeWire, pas PulseAudio)
- Config : fichiers multiples (retroarch.cfg, etc.)
- Packages : **apt** (Debian)
- Python : Python 3.11 (Bookworm)
- ES : vanilla RetroPie (pas forke)

## Comparaison technique detaillee

### WiFi

| | Batocera | Recalbox | RetroMi |
|---|----------|----------|---------|
| Backend | **ConnMan** (connmanctl) | **wpa_supplicant** (wpa_cli) | **wpa_supplicant** |
| Config | batocera.conf → connman .config files | recalbox.conf → wpa_cli | retroarch.cfg / wpa_supplicant.conf |
| Scan | `connmanctl scan wifi` | `wpa_cli -i wlan0 scan` | `wpa_cli scan` |
| Enable | `connmanctl enable wifi` | `/etc/init.d/S09wifi restart` | `systemctl restart wpa_supplicant` |

**Verdict WiFi : Recalbox gagne** — meme backend wpa_supplicant que RetroMi.
Le script `recalbox-config.sh wifi` est quasi directement reutilisable.

### Bluetooth

| | Batocera | Recalbox | RetroMi |
|---|----------|----------|---------|
| Agent | **Python dbus custom** (batocera-bluetooth-agent) | **Python dbus custom** (test-discovery + recalpair) | Aucun (bluetoothctl manuel) |
| Pairing | Signal SIGUSR1 → discovery → auto-pair | `test-discovery` scan 15s → `recalpair` | Manuel pair/trust/connect |
| Sauvegarde | tar /var/lib/bluetooth | Non documente | Aucune |
| 8BitDo | Pas de traitement special | **Udev rules injection** pour 8BitDo | Pas de traitement special |
| bluezutils.py | OUI | OUI (meme fichier, fork commun) | Non |

**Verdict BT : Match nul** — les deux ont un agent Python dbus.
- Batocera : agent monolithique plus mature (reconnexion auto, battery, discovery events)
- Recalbox : plus simple (scan + pair en 2 scripts separes), gere les 8BitDo

### Audio

| | Batocera | Recalbox | RetroMi |
|---|----------|----------|---------|
| Backend | **PipeWire** (pactl) | **ALSA** (amixer) | **ALSA** (amixer) |
| Volume | `pactl set-sink-volume` | `amixer sset` | `amixer sset` |
| Devices | `pactl list sinks` | `aplay -l` | `aplay -l` |

**Verdict Audio : Recalbox gagne** — meme stack ALSA que RetroMi.

### Config systeme

| | Batocera | Recalbox | RetroMi |
|---|----------|----------|---------|
| Fichier central | batocera.conf | recalbox.conf | Pas de fichier central |
| Format | key=value | key=value | N/A |
| Lecteur | batocera-settings-get (binaire C) | `recalbox_settings` (binaire) | N/A |
| Ecrivain | batocera-settings-set (binaire C) | `recalbox_settings` (binaire) | N/A |

**Verdict Config : Egalite** — les deux utilisent un binaire custom.
Pour RetroMi on peut faire un simple shell wrapper avec grep/sed.

### Init system

| | Batocera | Recalbox | RetroMi |
|---|----------|----------|---------|
| Init | SysV (S00-S99) | SysV (S00-S99) | **systemd** |

**Verdict Init : Ni l'un ni l'autre** — les deux sont SysV, on est systemd.
Les init scripts doivent etre convertis en services systemd dans tous les cas.

### OTA Updates

| | Batocera | Recalbox |
|---|----------|----------|
| Methode | boot.tar.xz sur /boot | boot.tar.xz sur /boot |
| Check | wget version file | wget version file |
| Rollback | Non | Non |

**Verdict OTA : Egalite** — meme concept, meme implementation.

### Structure des scripts

| | Batocera | Recalbox |
|---|----------|----------|
| Organisation | 1 script = 1 fonction (`batocera-wifi`, `batocera-bluetooth`, etc.) | **1 script monolithique** (`recalbox-config.sh` fait tout) |
| Maintenabilite | Meilleure (modulaire) | Moins bonne (1 gros fichier) |
| Nombre scripts | ~50 | ~10 |
| Qualite code | Bonne, bien documentee | Correcte, plus compacte |

**Verdict Structure : Batocera gagne** — modulaire, plus facile a cherry-pick.

## Tableau recapitulatif

| Critere | Gagnant pour RetroMi | Raison |
|---------|---------------------|--------|
| WiFi | **Recalbox** | wpa_supplicant (meme stack) |
| Bluetooth | **Egalite** | Les deux ont un agent Python dbus |
| Audio | **Recalbox** | ALSA (meme stack) |
| Config | Egalite | Les deux ont un binaire custom |
| Init | Aucun | On est systemd, les deux sont SysV |
| OTA | Egalite | Meme concept |
| Structure | **Batocera** | Modulaire, plus propre |
| Licence | **Batocera** | LGPL v3 vs propriétaire |
| Activite | **Batocera** | Plus actif, 45+ boards |

## Recommandation finale

**Approche hybride** — prendre le meilleur des deux :

1. **WiFi** : s'inspirer de **Recalbox** (`recalbox-config.sh wifi`)
   car il utilise wpa_cli comme nous. Adapter en script `retromi-wifi`.

2. **Bluetooth** : s'inspirer de **Batocera** (`batocera-bluetooth-agent`)
   car l'agent est plus mature et modulaire. Le bluezutils.py est le meme
   dans les deux projets (heritage commun). Adapter en `retromi-bt-agent`.

3. **Audio** : s'inspirer de **Recalbox** (amixer, meme stack ALSA)
   Script simple `retromi-audio`.

4. **OTA** : s'inspirer de **Batocera** (`batocera-upgrade`)
   Car mieux structure, facilement adaptable.

5. **Pads info / Battery** : prendre **Batocera** (`batocera-padsinfo`)
   Universel, fonctionne tel quel.

6. **Overclock** : prendre **Batocera** (`batocera-overclock`)
   Plus de boards supportees, ajouter H3/Allwinner.

7. **Config centrale** : creer un `retromi.conf` format key=value
   avec un wrapper shell `retromi-settings-get/set` (pas besoin de binaire C).

## URLs sources

- Batocera scripts : `github.com/batocera-linux/batocera.linux/tree/master/package/batocera/core/batocera-scripts/scripts/`
- Recalbox config : `gitlab.com/recalbox/recalbox/-/blob/master/board/recalbox/fsoverlay/recalbox/scripts/recalbox-config.sh`
- Recalbox BT : `gitlab.com/recalbox/recalbox/-/tree/master/board/recalbox/fsoverlay/recalbox/scripts/bluetooth/`
