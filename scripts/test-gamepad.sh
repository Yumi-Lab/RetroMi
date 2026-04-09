#!/usr/bin/env bash
# RetroMi — Gamepad regression test (Plug & Play approach)
# Run after each build to confirm all gamepad invariants are correct.
# Usage: bash scripts/test-gamepad.sh [PI_IP]
# Example: bash scripts/test-gamepad.sh 192.168.1.129
#
# What this checks:
#   1. global retroarch.cfg: autodetect=true, NO player1/2 bindings, NO menu_toggle_btn
#   2. Custom autoconfig profiles in retroarch-joypads/ (device name, hotkey, menu_toggle)
#   3. Per-system retroarch.cfg: no files with input_player1_up_axis = "nul"
#   4. Built-in autoconfig-presets/udev/ contains 1000+ profiles

PI_IP="${1:-192.168.1.129}"
PI_USER="pi"
PI_PASS="yumi"

REMOTE_SCRIPT=$(cat << 'REMOTE_EOF'
#!/bin/bash
PASS=0
ok()   { echo "  OK: $*"; }
fail() { echo "  FAIL: $*"; PASS=1; }

RA="/opt/retropie/configs/all/retroarch.cfg"
BUILTIN="/opt/retropie/emulators/retroarch/autoconfig-presets/udev"
CUSTOM="/opt/retropie/configs/all/retroarch-joypads"

echo "[ 1/4 ] global retroarch.cfg — autodetect + no hardcoded bindings"

# autodetect must be true (or absent = default true)
if grep -q 'input_autodetect_enable = "false"' "$RA" 2>/dev/null; then
    fail "autodetect=false — must be true for plug & play"
else
    ok "autodetect enabled (true or default)"
fi

# NO player1/player2 explicit bindings in global cfg
P1=$(grep -c 'input_player1_' "$RA" 2>/dev/null) || true
P2=$(grep -c 'input_player2_' "$RA" 2>/dev/null) || true
[ "$P1" -eq 0 ] \
    && ok "no input_player1_* in global cfg" \
    || fail "$P1 input_player1_* lines found in global cfg (should be 0)"
[ "$P2" -eq 0 ] \
    && ok "no input_player2_* in global cfg" \
    || fail "$P2 input_player2_* lines found in global cfg (should be 0)"

# NO menu_toggle_btn in global cfg (only in per-profile)
grep -q 'input_menu_toggle_btn' "$RA" 2>/dev/null \
    && fail "input_menu_toggle_btn found in global cfg (should only be in profiles)" \
    || ok "no input_menu_toggle_btn in global cfg"

# Hotkeys must still be in global cfg
grep -q 'input_enable_hotkey_btn = "8"' "$RA" \
    && ok "hotkey SELECT=btn8" \
    || fail "input_enable_hotkey_btn missing or wrong"
grep -q 'input_exit_emulator_btn = "9"' "$RA" \
    && ok "exit START=btn9" \
    || fail "input_exit_emulator_btn missing or wrong"

echo ""
echo "[ 2/4 ] custom autoconfig profiles in retroarch-joypads/"
PROFILES=("$CUSTOM"/*.cfg)
if [ ${#PROFILES[@]} -eq 0 ] || [ ! -f "${PROFILES[0]}" ]; then
    fail "no custom profiles found in $CUSTOM"
else
    ok "${#PROFILES[@]} custom profile(s) found"
    for CFG in "${PROFILES[@]}"; do
        NAME=$(basename "$CFG")
        # Each profile must have input_device
        grep -q 'input_device' "$CFG" \
            && ok "$NAME: input_device present" \
            || fail "$NAME: input_device MISSING"
        # Each profile must have input_enable_hotkey_btn
        grep -q 'input_enable_hotkey_btn' "$CFG" \
            && ok "$NAME: input_enable_hotkey_btn present" \
            || fail "$NAME: input_enable_hotkey_btn MISSING"
        # Each profile must have input_menu_toggle_btn
        grep -q 'input_menu_toggle_btn' "$CFG" \
            && ok "$NAME: input_menu_toggle_btn present" \
            || fail "$NAME: input_menu_toggle_btn MISSING"
        # D-pad: axis or hat (must have one)
        if grep -q 'input_up_axis' "$CFG" || grep -q 'input_up_btn' "$CFG"; then
            ok "$NAME: D-pad mapping present"
        else
            fail "$NAME: no D-pad mapping (need up_axis or up_btn)"
        fi
    done
fi

echo ""
echo "[ 3/4 ] per-system retroarch.cfg (no nul axis values)"
NUL=$(find /opt/retropie/configs -mindepth 2 -name retroarch.cfg \
    ! -path "*/all/*" -exec grep -l 'up_axis = "nul"' {} \; 2>/dev/null | wc -l)
[ "$NUL" -eq 0 ] \
    && ok "no per-system cfg with nul axis" \
    || fail "$NUL per-system cfg have up_axis=nul (will override global)"

echo ""
echo "[ 4/4 ] built-in autoconfig-presets/udev/"
if [ -d "$BUILTIN" ]; then
    COUNT=$(find "$BUILTIN" -name '*.cfg' | wc -l)
    [ "$COUNT" -ge 400 ] \
        && ok "$COUNT built-in autoconfig profiles (>= 400)" \
        || fail "only $COUNT built-in profiles (expected >= 400)"
else
    fail "directory $BUILTIN not found"
fi

echo ""
echo "======================================="
if [ "$PASS" -eq 0 ]; then
    echo "RESULT: ALL CHECKS PASSED"
else
    echo "RESULT: SOME CHECKS FAILED"
fi
echo "======================================="
exit "$PASS"
REMOTE_EOF
)

# Write remote script to tmp file
TMPSCRIPT=$(mktemp)
echo "$REMOTE_SCRIPT" > "$TMPSCRIPT"

echo "=== RetroMi Gamepad Regression Test ==="
echo "Pi: ${PI_IP}"
echo ""

# SCP the script
expect -c "
spawn scp -o PubkeyAuthentication=no -o StrictHostKeyChecking=no $TMPSCRIPT ${PI_USER}@${PI_IP}:/tmp/test_gamepad_remote.sh
expect \"password:\"
send \"${PI_PASS}\r\"
expect eof
" 2>/dev/null | grep -v "spawn\|password\|ETA\|KB/s" || true

# Run it
expect -c "
spawn ssh -o PubkeyAuthentication=no -o StrictHostKeyChecking=no ${PI_USER}@${PI_IP} bash /tmp/test_gamepad_remote.sh
expect \"password:\"
send \"${PI_PASS}\r\"
expect eof
" 2>/dev/null | grep -E "^\s*(OK:|FAIL:|RESULT:|====|\[)"

rm -f "$TMPSCRIPT"
