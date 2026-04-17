#!/bin/bash
# moonlight-qt-stream.sh — Wrapper for moonlight-qt launched from ES via runcommand
# Reads .ml ROM files: line 1 = server IP, line 2 = app name (or __PAIRING__ for GUI)
#
# Pipeline: Sunshine HEVC → FFmpeg v4l2_request → CedarX cedrus → NV12 DRM → screen
# ES suspends EGLFS before calling this → moonlight-qt takes DRM master
# Quit: Ctrl+Alt+Shift+Q → moonlight-qt exits → ES resumes

ROM_FILE="$1"

if [ ! -f "${ROM_FILE}" ]; then
    echo "ERROR: ROM file not found: ${ROM_FILE}" >&2
    exit 1
fi

SERVER_IP=$(sed -n '1p' "${ROM_FILE}")
APP_NAME=$(sed -n '2p' "${ROM_FILE}")

export QT_QPA_PLATFORM=eglfs
export HOME="/home/$(logname 2>/dev/null || echo pi)"

if [ "${APP_NAME}" = "__PAIRING__" ]; then
    # Open moonlight-qt GUI for pairing / server discovery / settings
    exec moonlight-qt
else
    # Direct stream — connect to server and launch app
    exec moonlight-qt stream "${SERVER_IP}" "${APP_NAME}"
fi
