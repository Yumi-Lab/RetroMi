#!/bin/bash
# moonlight-stream.sh — Wrapper for moonlight-qt launched from ES via runcommand
# Reads .ml ROM files: line 1 = app name (or __PAIRING__), line 2 = server IP (optional, auto-discover if absent)
#
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
export HOME="/home/$(logname 2>/dev/null || echo pi)"

if [ "${APP_NAME}" = "__PAIRING__" ]; then
    # Open moonlight-qt GUI for pairing / server discovery / settings
    exec moonlight-qt
elif [ -n "${SERVER_IP}" ]; then
    # Direct stream with explicit server IP
    exec moonlight-qt stream "${SERVER_IP}" "${APP_NAME}"
else
    # Direct stream — moonlight-qt auto-discovers server
    exec moonlight-qt stream "${APP_NAME}"
fi
