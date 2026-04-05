#!/usr/bin/env bash
# RetroMi — Gamepad regression test
# Run after each build to confirm all gamepad invariants are correct.
# Usage: bash scripts/test-gamepad.sh [PI_IP]
# Example: bash scripts/test-gamepad.sh 192.168.1.129
#
# What this checks (USB Gamepad 0810:0001 / Twin USB Gamepad):
#   1. global retroarch.cfg: autodetect=true, no explicit player1/2 axis/btn bindings
#   2. Built-in autoconfig: USB_Gamepad.cfg uses axis mapping (not hat)
#   3. Per-system retroarch.cfg: no files with input_player1_up_axis = "nul"
#   4. Hotkeys present: input_enable_hotkey_btn + input_exit_emulator_btn

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

echo "[ 1/4 ] global retroarch.cfg"
grep -q 'input_autodetect_enable = "true"' "$RA" \
    && ok "autodetect=true" \
    || fail "autodetect != true (got: $(grep input_autodetect "$RA" || echo MISSING))"

COUNT=$(grep -cE 'input_player[12].*(axis|_btn|joypad_index|analog_dpad)' "$RA" 2>/dev/null) || COUNT=0
[ "${COUNT:-0}" -eq 0 ] \
    && ok "No explicit player1/2 axis/btn bindings" \
    || fail "${COUNT} explicit player bindings found (cause button conflicts with other gamepads)"

grep -q 'input_enable_hotkey_btn = "8"' "$RA" \
    && ok "hotkey SELECT=btn8" \
    || fail "input_enable_hotkey_btn missing or wrong"

grep -q 'input_exit_emulator_btn = "9"' "$RA" \
    && ok "exit START=btn9" \
    || fail "input_exit_emulator_btn missing or wrong"

echo ""
echo "[ 2/4 ] USB Gamepad autoconfig (built-in dir)"
for CFG in USB_Gamepad.cfg Twin_USB_Gamepad.cfg; do
    FILE="$BUILTIN/$CFG"
    if [ ! -f "$FILE" ]; then
        fail "$CFG: file not found in $BUILTIN"; continue
    fi
    grep -q 'input_up_axis = "-1"' "$FILE" \
        && ok "$CFG: D-pad uses axis (up_axis=-1)" \
        || fail "$CFG: wrong up_axis (expected -1, got: $(grep input_up "$FILE" || echo MISSING))"
    grep -qE 'h0up|_hat' "$FILE" \
        && fail "$CFG: hat mapping detected (breaks D-pad)" \
        || ok "$CFG: no hat mapping"
done

echo ""
echo "[ 3/4 ] Per-system retroarch.cfg (no nul axis values)"
NUL=$(find /opt/retropie/configs -mindepth 2 -name retroarch.cfg \
    ! -path "*/all/*" -exec grep -l 'up_axis = "nul"' {} \; 2>/dev/null | wc -l)
[ "$NUL" -eq 0 ] \
    && ok "No per-system cfg with nul axis" \
    || fail "$NUL per-system cfg have up_axis=nul (will override global)"

echo ""
echo "[ 4/4 ] joypad_autoconfig_dir"
ACDIR=$(grep 'joypad_autoconfig_dir' "$RA" 2>/dev/null || echo "")
if echo "$ACDIR" | grep -q "autoconfig-presets/udev"; then
    ok "joypad_autoconfig_dir → autoconfig-presets/udev"
elif [ -z "$ACDIR" ]; then
    ok "joypad_autoconfig_dir not set (uses compiled-in default)"
else
    fail "unexpected joypad_autoconfig_dir: $ACDIR"
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
