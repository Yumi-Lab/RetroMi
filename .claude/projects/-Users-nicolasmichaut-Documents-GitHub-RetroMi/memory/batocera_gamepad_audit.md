---
name: Batocera gamepad audit 2026-04-17
description: Audit complet de la config Batocera gamepad sur SmartPi One H3 — retroarch.cfg + es_input.cfg + GUIDs
type: project
---

# Audit Batocera Gamepad — SmartPi One H3

**Date** : 2026-04-17
**Batocera live** : `root@192.168.1.104` (linux) — SmartPi One H3, Batocera v38
**RetroMi test** : `pi@192.168.1.129` (yumi) — SmartPi One H3

## Config Batocera retroarch (retroarchcustom.cfg)

```
input_autodetect_enable = "false"
input_joypad_driver = udev
input_enable_hotkey_btn = 8
input_enable_hotkey = "shift"
input_max_users = 16
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
input_player1_l_y_minus_axis = -1
input_player1_l_y_plus_axis = +1
input_player1_l_x_minus_axis = -0
input_player1_l_x_plus_axis = +0
input_player1_r_y_minus_axis = -2
input_player1_r_y_plus_axis = +2
input_player1_r_x_minus_axis = -3
input_player1_r_x_plus_axis = +3
input_player1_joypad_index = 0
input_player1_analog_dpad_mode = 1
input_exit_emulator_btn = 9
input_menu_toggle_btn = 2
input_save_state_btn = 3
input_load_state_btn = 0
input_reset_btn = 1
input_state_slot_increase_btn = h0up
input_state_slot_decrease_btn = h0down
input_rewind_btn = h0left
input_hold_fast_forward_btn = h0right
input_screenshot_btn = 6
input_ai_service_btn = 7
input_shader_prev_btn = 4
input_shader_next_btn = 5
menu_swap_ok_cancel_buttons = "true"
joypad_autoconfig_dir = "/userdata/system/configs/retroarch/inputs/"
```

Le dossier `inputs/` est **VIDE**. Zéro fichier autoconfig.

## Clé : `input_player1_analog_dpad_mode = 1`

Convertit les axes analogiques (ABS_X/ABS_Y) en D-pad digital. Les manettes cheap USB envoient le D-pad sur les mêmes axes qu'un stick analogique → ce setting les rend universellement fonctionnelles, hat OU axes.

## Problème GUIDs ES

RetroPie ES et Batocera ES (fork) calculent les GUIDs différemment.
On ne peut **PAS copier le es_input.cfg de Batocera** tel quel.

GUIDs SmartPi H3 avec **notre ES** (log `es_log.txt`) :
- SNES (081f:e401) : `03004d2a1f08000001e4000010010000`, name `"USB gamepad"` (minuscule g)
- Twin USB (0810:0001) : `03006ce8100800000100000010010000`, name `" USB Gamepad          "` (espaces)

GUIDs sur **Batocera ES** (fork) :
- SNES : `030000001f08000001e4000010010000` (bytes 2-3 = `0000`)
- Twin USB : `03000000100800000100000010010000` (bytes 2-3 = `0000`)

Les bytes 2-3 diffèrent entre les deux versions d'ES sur le même H3.

## Batocera es_input.cfg — entrées pertinentes

### SNES clone (081f:e401) — D-pad AXIS (pas hat)
```xml
<inputConfig type="joystick" deviceName="USB gamepad           " deviceGUID="030000001f08000001e4000010010000">
    <input name="a" type="button" id="1" value="1" code="289" />
    <input name="b" type="button" id="2" value="1" code="290" />
    <input name="down" type="axis" id="1" value="1" code="1" />
    <input name="left" type="axis" id="0" value="-1" code="0" />
    <input name="right" type="axis" id="0" value="1" code="0" />
    <input name="up" type="axis" id="1" value="-1" code="1" />
    <input name="x" type="button" id="0" value="1" code="288" />
    <input name="y" type="button" id="3" value="1" code="291" />
    <input name="select" type="button" id="8" value="1" code="296" />
    <input name="start" type="button" id="9" value="1" code="297" />
    <input name="pageup" type="button" id="4" value="1" code="292" />
    <input name="pagedown" type="button" id="5" value="1" code="293" />
    <input name="hotkey" type="button" id="8" value="1" code="296" />
</inputConfig>
```

### Twin USB (0810:0001) — D-pad HAT
```xml
<inputConfig type="joystick" deviceName="Twin USB Joystick" deviceGUID="03000000100800000100000010010000">
    <input name="a" type="button" id="1" value="1" code="289" />
    <input name="b" type="button" id="2" value="1" code="290" />
    <input name="down" type="hat" id="0" value="4" code="16" />
    <input name="left" type="hat" id="0" value="8" code="16" />
    <input name="right" type="hat" id="0" value="2" code="16" />
    <input name="up" type="hat" id="0" value="1" code="16" />
    <input name="x" type="button" id="0" value="1" code="288" />
    <input name="y" type="button" id="3" value="1" code="291" />
    <input name="select" type="button" id="8" value="1" code="296" />
    <input name="start" type="button" id="9" value="1" code="297" />
    <input name="hotkey" type="button" id="8" value="1" code="296" />
</inputConfig>
```

## Manettes de test — jstest results

### SNES clone (081f:e401) = `"USB gamepad"` (minuscule g)
- 2 axes (X, Y) + 10 buttons
- **Pas de hat** — D-pad sur axes 0/1
- Vendor 081f, Product e401

### Twin USB (0810:0001) = `" USB Gamepad          "` (espaces)
- Vendor 0810, Product 0001
- D-pad ABS_X/ABS_Y axes (PAS hat malgré les built-in RetroArch qui disent hat)

## Prompt prochaine session

```
Objectif : N'importe quelle manette USB branchée sur RetroMi doit fonctionner
immédiatement dans ES et dans les jeux, sans configuration manuelle — comme Batocera.

Branche : Créer feat/gamepad-plug-and-play depuis develop actuel.

Méthode : Batocera tourne sur le même SmartPi One H3 et le plug & play y fonctionne.
Audite la config Batocera via SSH, compare avec RetroMi, et applique les changements.

Accès SSH :
- Batocera (même SmartPi One H3) : root@192.168.1.104 (password: linux)
- RetroMi test (SmartPi One H3) : pi@192.168.1.129 (password: yumi)

Manettes de test connectées au Pi RetroMi :
- Twin USB PSX generic (0810:0001) — "USB Gamepad"
- SNES clone (081f:e401) — "USB gamepad" (minuscule g)

Lire memory/batocera_gamepad_audit.md pour le contexte complet de l'audit.
```
