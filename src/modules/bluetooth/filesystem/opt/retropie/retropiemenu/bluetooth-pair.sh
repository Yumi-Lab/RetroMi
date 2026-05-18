#!/bin/bash
# bluetooth-pair.sh — RetroMi Bluetooth gamepad pairing menu entry
# Launched from EmulationStation retropiemenu

DIALOG="$(which dialog)"

"$DIALOG" --backtitle "RetroMi — Bluetooth" \
    --title "Pair Bluetooth Controller" \
    --yes-label "Start" --no-label "Cancel" \
    --yesno "\nPut your controller in pairing mode:\n\n  DS4/DS5:  PS + Share (3 seconds)\n  Xbox:     Sync button (top)\n  Switch:   Sync button (side)\n  8BitDo:   Power on + pairing combo\n\nRetroMi will scan for 60 seconds.\nES will restart after pairing.\n" 16 50

if [ $? -ne 0 ]; then
    exit 0
fi

# Run pairing with progress display
/usr/local/bin/retromi-bt-pair 60 2>&1 | \
    "$DIALOG" --backtitle "RetroMi — Bluetooth" \
    --title "Scanning..." \
    --programbox 20 60

# Show result
PAIRED=$(grep -c "Paired and connected" /tmp/retromi-bt-pair.log 2>/dev/null || echo "0")
if [ "$PAIRED" -gt 0 ]; then
    "$DIALOG" --backtitle "RetroMi — Bluetooth" \
        --title "Success" \
        --msgbox "\n  ${PAIRED} controller(s) paired!\n\n  ES will restart to detect them." 10 45
else
    "$DIALOG" --backtitle "RetroMi — Bluetooth" \
        --title "No controllers found" \
        --msgbox "\n  No gamepads detected.\n\n  Make sure the controller is in\n  pairing mode and try again." 11 45
fi
