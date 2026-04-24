#!/bin/bash
# moonlight-stream.sh — Wrapper for moonlight-qt launched from ES via runcommand
# Reads .ml ROM files: line 1 = app name (or __PAIRING__), line 2 = server IP (optional)
#
# If no IP in .ml file, auto-discovers Sunshine server via avahi mDNS (~100ms).
# Pipeline: Sunshine HEVC → FFmpeg v4l2_request → CedarX cedrus → NV12 DRM → screen
# Quit: Ctrl+Alt+Shift+Q → moonlight-qt exits → ES resumes

ROM_FILE="$1"

if [ ! -f "${ROM_FILE}" ]; then
    echo "ERROR: ROM file not found: ${ROM_FILE}" >&2
    exit 1
fi

APP_NAME=$(sed -n '1p' "${ROM_FILE}")
SERVER_IP=$(sed -n '2p' "${ROM_FILE}")

export QT_QPA_PLATFORM=eglfs
HOME="/home/$(logname 2>/dev/null || echo pi)"
export HOME

# Auto-discover Sunshine server via avahi mDNS
if [ -z "${SERVER_IP}" ] && [ "${APP_NAME}" != "__PAIRING__" ]; then
    SERVER_IP=$(avahi-browse -t -r -p _nvstream._tcp 2>/dev/null | grep '^=' | head -1 | cut -d';' -f8)
fi

if [ "${APP_NAME}" = "__PAIRING__" ]; then
    exec moonlight-qt
elif [ -n "${SERVER_IP}" ]; then
    exec moonlight-qt stream "${SERVER_IP}" "${APP_NAME}"
else
    # No Sunshine server found on network — open GUI
    exec moonlight-qt
fi
