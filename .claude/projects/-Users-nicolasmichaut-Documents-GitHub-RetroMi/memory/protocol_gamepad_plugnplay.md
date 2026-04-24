---
name: Protocol Gamepad Plug & Play
description: Activer autodetect RetroArch + supprimer bindings hardcodés + fixer autoconfig Twin USB + menu_toggle dans profiles only
type: project
---

# Protocol — Gamepad Plug & Play

**Status: COMPLETE — all phases validated, manette PSX generic plug & play confirmé sur Pi**
**Project: /Users/nicolasmichaut/Documents/GitHub/RetroMi**
**Branch: feat/gamepad-plug-and-play**
**Created: 2026-04-07**

## Progress
- [x] Phase A — Nettoyer retropie/start_chroot_script validated 07/04/2026
- [x] Phase B — Fixer autoconfig profiles Twin USB + USB Gamepad validated 07/04/2026
- [x] Phase C — Mettre à jour test-gamepad.sh + test SSH sur Pi validated 07/04/2026

## Available verification tools
- grep/read/git diff (primary)
- SSH vers Pi test (pi@192.168.1.129, password yumi) pour Phase C
- bash lint (shellcheck)

## Deploy rules
Pas de deploy — changements dans le build script uniquement. Test sur Pi en Phase C.

---

## Phase A — Nettoyer retropie/start_chroot_script

### Work

#### A1. Passer autodetect de false à true
- File: `src/modules/retropie/start_chroot_script`
- Change: Remplacer `sed -i 's/^input_autodetect_enable = "true"/input_autodetect_enable = "false"/'` par `# Ensure autodetect is enabled (uses 1089 built-in autoconfig presets)`
  et s'assurer que la ligne ne force PAS false. Si RetroPie génère `true` par défaut, ne rien toucher. Sinon forcer `true`.

#### A2. Supprimer les bindings hardcodés player1/player2
- File: `src/modules/retropie/start_chroot_script`
- Change: Supprimer le bloc complet lignes 281-318 (commentaire + `if ! grep` + heredoc JOYEOF)

#### A3. Retirer input_menu_toggle_btn du cfg global
- File: `src/modules/retropie/start_chroot_script`
- Change: Supprimer les lignes 276-278 (`grep -q "input_menu_toggle_btn"` + echo)

#### A4. Mettre à jour les commentaires
- File: `src/modules/retropie/start_chroot_script`
- Change: Remplacer le commentaire lignes 256-261 par un commentaire expliquant la nouvelle approche (autodetect + autoconfig presets)

### Verifications
- [ ] grep `input_autodetect_enable` → doit forcer "true" ou ne pas toucher (RetroPie default = true)
- [ ] grep `input_player1_` dans le fichier → 0 résultats
- [ ] grep `input_player2_` dans le fichier → 0 résultats
- [ ] grep `input_menu_toggle_btn` dans le fichier → 0 résultats
- [ ] `input_enable_hotkey_btn = "8"` toujours présent
- [ ] `input_exit_emulator_btn = "9"` toujours présent
- [ ] `quit_on_close_content = "2"` toujours présent
- [ ] shellcheck passe sans erreur

---

## Phase B — Fixer autoconfig profiles Twin USB + USB Gamepad

### Work

#### B1. Ajouter le device name kernel exact au Twin USB Gamepad
- File: `src/modules/retroarch/filesystem/opt/retropie/configs/all/retroarch-joypads/Twin USB Gamepad.cfg`
- Change: `input_device` doit matcher le nom kernel exact. Vérifier sur le Pi via SSH (`cat /proc/bus/input/devices`). La MEMORY dit que c'est `" USB Gamepad           "` (1 espace devant + 10 trailing).
  Créer un fichier séparé si le device name est différent du "Twin USB Gamepad" actuel.

#### B2. Vérifier/fixer USB Gamepad.cfg
- File: `src/modules/retroarch/filesystem/opt/retropie/configs/all/retroarch-joypads/USB Gamepad.cfg`
- Change: Même vérification device name. Si le kernel rapporte un nom avec espaces, créer le fichier avec le bon nom.

#### B3. S'assurer que input_menu_toggle_btn est dans les autoconfig profiles
- Files: Les 3 fichiers .cfg dans retroarch-joypads/
- Change: Vérifier que `input_menu_toggle_btn = "2"` est présent (Select+✕ combo via hotkey). Déjà fait dans Twin USB et USB Gamepad. Vérifier 8BitDo Pro 2.

### Verifications
- [ ] Chaque .cfg a un `input_device` qui matche le device name kernel exact
- [ ] `input_menu_toggle_btn` présent dans chaque profile custom
- [ ] `input_enable_hotkey_btn` présent dans chaque profile custom
- [ ] vendor_id/product_id corrects

---

### Test Log — Phase B (LIGHT)
**Files reviewed:** Twin USB Gamepad.cfg, USB Gamepad.cfg, SNES USB gamepad.cfg, 8BitDo Pro 2.cfg, retroarch/start_chroot_script
**Kernel device names verified via SSH (pi@192.168.1.129):**
- Twin USB (0810:0001) → `" USB Gamepad          "` (1 leading + 10 trailing spaces)
- SNES clone (081f:e401) → `"USB gamepad"` (lowercase g, no padding)
**Changes made:**
1. Twin USB Gamepad.cfg: `input_device = "Twin USB Gamepad"` → `" USB Gamepad          "` (exact kernel name)
2. retroarch/start_chroot_script: `autoconfig/udev` → `autoconfig-presets/udev` (BUG FIX — path was wrong, built-in cleanup was silently failing)
**Regressions grep:** PASS — all 4 profiles have input_device, input_enable_hotkey_btn, input_menu_toggle_btn
**Dependent code check:** PASS
**Bug found & fixed:** autoconfig-presets path mismatch

---

## Phase C — Mettre à jour test-gamepad.sh + test SSH sur Pi

### Work

#### C1. Réécrire test-gamepad.sh pour la nouvelle approche
- File: `scripts/test-gamepad.sh`
- Change:
  - Test 1: `input_autodetect_enable = "true"` (au lieu de false)
  - Test 1: PAS de `input_player1_*` dans le cfg global (au lieu de vérifier leur présence)
  - Test 1: PAS de `input_menu_toggle_btn` dans le cfg global
  - Test 2: Vérifier les autoconfig profiles custom dans retroarch-joypads/
  - Test 3: Inchangé (per-system nul axis)
  - Test 4: Vérifier que autoconfig-presets/udev/ contient 1000+ fichiers

#### C2. Exécuter le test sur le Pi
- Action: `bash scripts/test-gamepad.sh 192.168.1.129`
- Expected: ALL CHECKS PASSED

### Verifications
- [x] test-gamepad.sh passe en local (syntax) — `bash -n` OK
- [x] test-gamepad.sh exécuté sur le Pi — 4 FAIL attendus (ancienne image sans Phase A/B)
- [ ] shellcheck — non installé sur le Mac, vérifié manuellement

### Test Log — Phase C
**Script rewritten:** test-gamepad.sh updated for plug & play approach
**Changes:**
1. Test 1: checks autodetect=true (was false), verifies NO player1/2 bindings, NO menu_toggle_btn in global cfg
2. Test 2: validates all custom profiles in retroarch-joypads/ (input_device, hotkey, menu_toggle, D-pad)
3. Test 3: unchanged (per-system nul axis)
4. Test 4: checks autoconfig-presets/udev/ has >= 1000 profiles
**SSH test result (old image):** 4 FAIL expected — autodetect=false, 28 player1 + 16 player2 lines, menu_toggle in global, 436 built-in (< 1000). All profile checks (12/12) PASSED. No nul axis.
**Next step:** rebuild image with Phase A+B commits, re-flash, re-run test → expect ALL CHECKS PASSED
**Live test on Pi (192.168.1.129):** ALL CHECKS PASSED (24/24) + manette PSX generic plug & play confirmé par l'utilisateur (07/04/2026)
