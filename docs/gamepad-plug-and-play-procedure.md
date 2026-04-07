# RetroMi — Gamepad Plug & Play (Batocera-style)

## Résumé
Approche Batocera : `input_autodetect_enable = false`, un script bash (`retromi-pad-config`)
lit les manettes connectées, matche dans es_input.cfg par VID+PID, écrit les bindings
`input_player*` directement dans retroarch.cfg.

## Étapes sur image propre

### 1. Déployer le script retromi-pad-config
```bash
sudo cp retromi-pad-config /usr/local/bin/retromi-pad-config
sudo chmod +x /usr/local/bin/retromi-pad-config
```
Fichier : `src/modules/retroarch/filesystem/usr/local/bin/retromi-pad-config`

### 2. Créer le hook runcommand
```bash
cat > /opt/retropie/configs/all/runcommand-onstart.sh << 'EOF'
#!/bin/bash
/usr/local/bin/retromi-pad-config 2>/dev/null &
EOF
chmod +x /opt/retropie/configs/all/runcommand-onstart.sh
```

### 3. Configurer retroarch.cfg
```bash
RA="/opt/retropie/configs/all/retroarch.cfg"

# Désactiver autodetect (Batocera-style)
sed -i 's/^input_autodetect_enable = "true"/input_autodetect_enable = "false"/' "$RA"

# Supprimer les bindings hardcodés
sed -i '/^input_player[0-9]/d' "$RA"
sed -i '/^input_enable_hotkey_btn/d' "$RA"
sed -i '/^input_exit_emulator_btn/d' "$RA"
sed -i '/^input_menu_toggle_btn/d' "$RA"
```

### 4. Ajouter les GUIDs manquants dans es_input.cfg

**CRITIQUE** : ES utilise un GUID avec CRC16 du nom kernel. Le même gamepad peut avoir
des GUIDs différents selon le bus USB. Il faut ajouter TOUTES les variantes.

#### SNES clone (081f:e401) — GUID SmartPi One H3
Le GUID détecté sur SmartPi One est `03004d2a1f08000001e4000010010000` (CRC=4d2a).
Le mapping Batocera (a=1,b=2,x=0,y=3) est DIFFÉRENT de l'entrée "Super Famicom Controller"
dans SDL_GameControllerDB (a=2,b=1,x=3,y=0).

```xml
<inputConfig type="joystick" deviceName="USB gamepad" deviceGUID="03004d2a1f08000001e4000010010000">
    <input name="a" type="button" id="1" value="1" />
    <input name="b" type="button" id="2" value="1" />
    <input name="down" type="axis" id="1" value="1" />
    <input name="hotkey" type="button" id="8" value="1" />
    <input name="left" type="axis" id="0" value="-1" />
    <input name="pagedown" type="button" id="5" value="1" />
    <input name="pageup" type="button" id="4" value="1" />
    <input name="right" type="axis" id="0" value="1" />
    <input name="select" type="button" id="8" value="1" />
    <input name="start" type="button" id="9" value="1" />
    <input name="up" type="axis" id="1" value="-1" />
    <input name="x" type="button" id="0" value="1" />
    <input name="y" type="button" id="3" value="1" />
</inputConfig>
```

### 5. Lancer retromi-pad-config
```bash
sudo /usr/local/bin/retromi-pad-config
cat /tmp/retromi-pad-config.log
```

### 6. Reboot
```bash
sudo reboot
```

## Mapping Batocera (référence)
Obtenu en SSH sur Batocera SmartPi One (root@192.168.1.104, password: linux).

### SNES clone (081f:e401) — retroarchcustom.cfg
```
input_player1_a_btn = 1
input_player1_b_btn = 2
input_player1_x_btn = 0
input_player1_y_btn = 3
input_player1_l_btn = 6
input_player1_r_btn = 7
input_player1_l2_btn = 4
input_player1_r2_btn = 5
input_player1_start_btn = 9
input_player1_select_btn = 8
input_player1_up_btn = h0up
input_player1_down_btn = h0down
input_player1_left_btn = h0left
input_player1_right_btn = h0right
input_enable_hotkey_btn = 8
input_exit_emulator_btn = 9
input_menu_toggle_btn = 2
```

Note: Batocera utilise D-pad HAT (h0up) tandis que le même gamepad sur RetroMi
est détecté avec D-pad AXIS. Les deux fonctionnent, ES matche par GUID pas par
type de D-pad.

## Architecture
```
Boot/Hotplug/Game launch
    ↓
retromi-pad-config
    ↓
Lit /proc/bus/input/devices (joysticks connectés)
    ↓
Pour chaque : VID+PID → cherche dans es_input.cfg
    ↓
Écrit input_player*_*_btn/axis dans retroarch.cfg
```

## Fichiers modifiés (branche feat/gamepad-plug-and-play)
- `src/modules/retroarch/filesystem/usr/local/bin/retromi-pad-config` — script bridge
- `src/modules/retroarch/filesystem/opt/retropie/configs/all/runcommand-onstart.sh` — hook
- `src/modules/retroarch/start_chroot_script` — nettoyage retroarch.cfg
- `src/modules/controllers/start_chroot_script` — déploie systemd service
- `src/modules/controllers/filesystem/etc/systemd/system/retromi-pad-config.service`
- `src/modules/controllers/filesystem/etc/udev/rules.d/80-retromi-pad-config.rules`

## Leçons apprises
1. Le GUID SDL contient un CRC16 du nom kernel — change selon le bus USB/plateforme
2. Batocera n'utilise PAS les autoconfig profiles — il écrit input_player* directement
3. Le mapping "Super Famicom Controller" dans SDL_GameControllerDB a A/B et X/Y inversés vs Batocera
4. Ne JAMAIS `killall emulationstation` — toujours `sudo reboot`
5. es_input.cfg : noms Batocera = pageup/pagedown/hotkey, noms SDL = leftshoulder/rightshoulder/hotkeyenable
