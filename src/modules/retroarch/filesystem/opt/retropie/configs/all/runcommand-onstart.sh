#!/bin/bash
# RetroMi — Pre-launch gamepad config refresh
# Ensures RetroArch autoconfig profiles are up-to-date before each game launch.
/usr/local/bin/retromi-pad-config 2>/dev/null &
