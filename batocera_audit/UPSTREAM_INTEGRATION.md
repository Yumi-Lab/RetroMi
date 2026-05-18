# Integration des scripts Batocera upstream dans RetroMi

## Source upstream

Repo : `batocera-linux/batocera.linux` (branche `master`)
Licence : GPL v2

### Chemins des scripts dans le repo Batocera

```
BATOCERA_REPO=https://raw.githubusercontent.com/batocera-linux/batocera.linux/master

# Scripts shell simples (copie directe)
$REPO/package/batocera/core/batocera-scripts/scripts/batocera-wifi
$REPO/package/batocera/core/batocera-scripts/scripts/batocera-overclock
$REPO/package/batocera/core/batocera-scripts/scripts/batocera-services
$REPO/package/batocera/core/batocera-scripts/scripts/batocera-padsinfo
$REPO/package/batocera/core/batocera-scripts/scripts/batocera-config
$REPO/package/batocera/core/batocera-scripts/scripts/batocera-info
$REPO/package/batocera/core/batocera-scripts/scripts/batocera-store
$REPO/package/batocera/core/batocera-scripts/scripts/batocera-upgrade
$REPO/package/batocera/core/batocera-scripts/scripts/batocera-timezone
$REPO/package/batocera/core/batocera-scripts/scripts/batocera-brightness
$REPO/package/batocera/core/batocera-scripts/scripts/batocera-save-overlay

# Bluetooth (scripts + agent Python)
$REPO/package/batocera/core/batocera-scripts/scripts/bluetooth/batocera-bluetooth
$REPO/package/batocera/core/batocera-scripts/scripts/bluetooth/batocera-bluetooth-agent
$REPO/package/batocera/core/batocera-scripts/scripts/bluetooth/bluezutils.py

# Init scripts
$REPO/package/batocera/core/batocera-bluetooth/S32bluetooth.template
$REPO/package/batocera/core/batocera-audio/S27audioconfig
$REPO/package/batocera/core/batocera-audio/soundconfig

# Settings (binaire C — source a compiler)
$REPO/package/batocera/core/batocera-settings/batocera-settings.mk
# Note: batocera-settings-get/set sont des binaires C, pas des scripts.
# On peut les remplacer par un simple wrapper shell pour notre stack.

# Resolution (binaire C + scripts)
$REPO/package/batocera/core/batocera-resolution/
```

## Faisabilite par script

| Script | Utilisable tel quel dans RetroMi ? | Adaptation necessaire |
|--------|-----------------------------------|----------------------|
| batocera-wifi | NON | ConnMan → wpa_supplicant/NetworkManager |
| batocera-bluetooth | PARTIEL | Agent Python OK, init script a adapter (systemd vs SysV) |
| batocera-bluetooth-agent | OUI | Python + dbus, universel |
| bluezutils.py | OUI | Lib Python BlueZ, universelle |
| batocera-padsinfo | OUI | sdl2-jstest + sysfs, universel |
| batocera-overclock | PARTIEL | Fonctionne pour RPi, a adapter pour H3/Allwinner |
| batocera-services | NON | Concept SysV, RetroMi = systemd |
| batocera-store | NON | pacman → apt |
| batocera-upgrade | PARTIEL | Concept OTA reutilisable, URLs a changer |
| batocera-config | PARTIEL | Sous-commandes a cherry-pick |
| batocera-timezone | OUI | curl + timedatectl |
| batocera-brightness | OUI | sysfs backlight universel |
| batocera-settings-get/set | NON | Binaire C pour format batocera.conf — on utilise retroarch.cfg |

## Strategie recommandee

### Option A : wget raw pendant le chroot (simple, fragile)

```bash
# Dans un module RetroMi (ex: src/modules/batocera-tools/start_chroot_script)
BATOCERA_RAW="https://raw.githubusercontent.com/batocera-linux/batocera.linux/master"
SCRIPTS_PATH="package/batocera/core/batocera-scripts/scripts"

# Telecharger les scripts qu'on veut
for script in batocera-padsinfo batocera-brightness batocera-timezone; do
    wget -O "/usr/local/bin/${script}" \
        "${BATOCERA_RAW}/${SCRIPTS_PATH}/${script}"
    chmod +x "/usr/local/bin/${script}"
done

# Bluetooth agent
BT_PATH="${SCRIPTS_PATH}/bluetooth"
wget -O /usr/local/bin/batocera-bluetooth-agent \
    "${BATOCERA_RAW}/${BT_PATH}/batocera-bluetooth-agent"
wget -O /usr/lib/python3/dist-packages/bluezutils.py \
    "${BATOCERA_RAW}/${BT_PATH}/bluezutils.py"
```

**Avantages** : simple, toujours upstream
**Inconvenients** : fragile (si Batocera rename un fichier), pas de versioning

### Option B : git sparse-checkout dans le chroot (robuste)

```bash
# Clone partiel — uniquement les scripts
cd /tmp
git clone --depth 1 --filter=blob:none --sparse \
    https://github.com/batocera-linux/batocera.linux.git batocera-upstream
cd batocera-upstream
git sparse-checkout set \
    package/batocera/core/batocera-scripts/scripts \
    package/batocera/core/batocera-bluetooth

# Copier ce qu'on veut
cp scripts/bluetooth/batocera-bluetooth-agent /usr/local/bin/
cp scripts/bluetooth/bluezutils.py /usr/lib/python3/dist-packages/
cp scripts/batocera-padsinfo /usr/local/bin/
# etc.

cd /tmp && rm -rf batocera-upstream
```

**Avantages** : versionnement git, on peut pinner un commit
**Inconvenients** : git dans le chroot (deja present), ~50MB de metadata

### Option C : submodule ou copie vendored (controle total)

```bash
# Dans le repo RetroMi, ajouter un dossier vendor/batocera/
# avec les scripts copies et un UPSTREAM_COMMIT file
# Script de mise a jour : scripts/update-batocera-vendor.sh
```

**Avantages** : zero dependance reseau au build, diff visible dans git
**Inconvenients** : maintenance manuelle des mises a jour

## Recommandation

**Option B (sparse-checkout)** pour le build CI, avec fallback sur les fichiers
deja presents dans `batocera_audit/scripts/` si le reseau est indisponible.

Pinner un tag/commit specifique de Batocera pour la reproductibilite :
```bash
BATOCERA_COMMIT="abc1234"  # a mettre a jour periodiquement
git clone --depth 1 --filter=blob:none --sparse \
    https://github.com/batocera-linux/batocera.linux.git \
    --branch master batocera-upstream
cd batocera-upstream && git checkout ${BATOCERA_COMMIT}
```

## Scripts a integrer en priorite

1. **batocera-bluetooth-agent + bluezutils.py** — resout notre probleme de pairing auto BT
2. **batocera-padsinfo** — battery level dans ES (besoin sdl2-jstest)
3. **batocera-brightness** — utile pour les handhelds
4. **batocera-upgrade** (adapte) — base pour notre roadmap OTA

## Adaptation necessaire pour chaque script

Les scripts Batocera appellent `batocera-settings-get/set` pour lire/ecrire
`batocera.conf`. Dans RetroMi, on doit remplacer par :
- Lecture de `/opt/retropie/configs/all/retroarch.cfg` pour les settings RetroArch
- Un fichier `retromi.conf` (format key=value simple) pour les settings systeme
- Ou directement les outils systemd (`nmcli`, `timedatectl`, etc.)
