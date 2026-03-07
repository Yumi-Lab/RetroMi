#!/bin/bash
# RetroMi — Background music setup for EmulationStation
# Usage:
#   ./setup.sh           — interactive menu (run from SmartPi)
#   ./setup.sh --install — non-interactive install (used by image build)
#   ./setup.sh --remove  — remove music setup (interactive)

GREEN='\033[0;32m'
NC='\033[0m'

# ──────────────────────────────────────────────
# Core install — identical result in both modes
# ──────────────────────────────────────────────
standard_setup() {
    mkdir -p /home/pi/RetroPie/music
    mkdir -p /home/pi/RetroPie/music-adult
    mkdir -p /home/pi/music_settings/adult_songs
    mkdir -p /home/pi/music_settings/music_over_games
    mkdir -p /home/pi/music_settings/user_switch

    echo "1" > /home/pi/music_settings/onoff.flag
    echo "1" > /home/pi/music_settings/adult_songs/onoff.flag
    echo "0" > /home/pi/music_settings/music_over_games/onoff.flag
    echo "1" > /home/pi/music_settings/user_switch/onoff.flag

    # Backup and deploy autostart.sh
    if [ ! -f /opt/retropie/configs/all/autostart.sh.orig ] && [ -f /opt/retropie/configs/all/autostart.sh ]; then
        mv /opt/retropie/configs/all/autostart.sh /opt/retropie/configs/all/autostart.sh.orig
    fi
    cp music_files/autostart.sh /opt/retropie/configs/all/

    # Backup and deploy runcommand hooks
    if [ ! -f /opt/retropie/configs/all/runcommand-onstart.sh.orig ]; then
        mv /opt/retropie/configs/all/runcommand-onstart.sh /opt/retropie/configs/all/runcommand-onstart.sh.orig 2>/dev/null || true
    fi
    if [ ! -f /opt/retropie/configs/all/runcommand-onend.sh.orig ]; then
        mv /opt/retropie/configs/all/runcommand-onend.sh /opt/retropie/configs/all/runcommand-onend.sh.orig 2>/dev/null || true
    fi
    cp music_files/runcommand-onstart.sh /opt/retropie/configs/all/
    cp music_files/runcommand-onend.sh /opt/retropie/configs/all/

    # Deploy RetroPie menu shortcuts
    mkdir -p /home/pi/RetroPie/retropiemenu
    cp "music_files/Startup With Music On.sh"            /home/pi/RetroPie/retropiemenu/
    cp "music_files/Startup With Music Off.sh"           /home/pi/RetroPie/retropiemenu/
    cp "music_files/Music Stop.sh"                       /home/pi/RetroPie/retropiemenu/
    cp "music_files/Music Start.sh"                      /home/pi/RetroPie/retropiemenu/
    cp music_files/info.sh                               /home/pi/RetroPie/retropiemenu/
    cp "music_files/continue music over game on.sh"      /home/pi/RetroPie/retropiemenu/
    cp "music_files/continue music over game off.sh"     /home/pi/RetroPie/retropiemenu/
    cp "music_files/Adult Music On (Requires Reboot).sh" /home/pi/RetroPie/retropiemenu/
    cp "music_files/Adult Music Off (Requires Reboot).sh" /home/pi/RetroPie/retropiemenu/

    # Hide default RetroPie menu items (non-fatal if already hidden or missing)
    for item in audiosettings configedit esthemes filemanager raspiconfig \
                retroarch retronetplay rpsetup runcommand showip splashscreen; do
        mv /home/pi/RetroPie/retropiemenu/${item}.rp \
           /home/pi/RetroPie/retropiemenu/${item}.rp.1 2>/dev/null || true
    done

    echo -e "${GREEN}DONE!${NC}"
    echo "Place MP3 files in: /home/pi/RetroPie/music"
    echo "Adult music: prefix filename with ADULT- and place in /home/pi/RetroPie/music"
}


# ──────────────────────────────────────────────
# Remove music setup
# ──────────────────────────────────────────────
undo_changes() {
    echo -n "WARNING: This will remove the music setup. Continue? [y/N]: "
    read -r WARNING
    if [ "${WARNING}" = "y" ] || [ "${WARNING}" = "Y" ]; then
        [ -f /opt/retropie/configs/all/autostart.sh.orig ] && \
            mv /opt/retropie/configs/all/autostart.sh.orig /opt/retropie/configs/all/autostart.sh
        [ -f /opt/retropie/configs/all/runcommand-onstart.sh.orig ] && \
            mv /opt/retropie/configs/all/runcommand-onstart.sh.orig /opt/retropie/configs/all/runcommand-onstart.sh || \
            rm -f /opt/retropie/configs/all/runcommand-onstart.sh
        [ -f /opt/retropie/configs/all/runcommand-onend.sh.orig ] && \
            mv /opt/retropie/configs/all/runcommand-onend.sh.orig /opt/retropie/configs/all/runcommand-onend.sh || \
            rm -f /opt/retropie/configs/all/runcommand-onend.sh

        rm -rf /home/pi/music_settings
        rm -f /home/pi/RetroPie/retropiemenu/Music\ *.sh \
              /home/pi/RetroPie/retropiemenu/Startup\ *.sh \
              /home/pi/RetroPie/retropiemenu/info.sh \
              "/home/pi/RetroPie/retropiemenu/continue music over game on.sh" \
              "/home/pi/RetroPie/retropiemenu/continue music over game off.sh" \
              "/home/pi/RetroPie/retropiemenu/Adult Music On (Requires Reboot).sh" \
              "/home/pi/RetroPie/retropiemenu/Adult Music Off (Requires Reboot).sh"

        for item in audiosettings configedit esthemes filemanager raspiconfig \
                    retroarch retronetplay rpsetup runcommand showip splashscreen; do
            mv /home/pi/RetroPie/retropiemenu/${item}.rp.1 \
               /home/pi/RetroPie/retropiemenu/${item}.rp 2>/dev/null || true
        done

        echo "DONE!"
        echo -n "Reboot now? [y/N]: "
        read -r reboot_now
        [ "${reboot_now}" = "y" ] || [ "${reboot_now}" = "Y" ] && sudo reboot
    else
        echo "Skipping."
    fi
}


# ──────────────────────────────────────────────
# Entry point
# ──────────────────────────────────────────────
case "${1:-}" in
    --install)
        # Non-interactive mode — used by RetroMi image build
        standard_setup
        ;;
    --remove)
        undo_changes
        ;;
    *)
        # Interactive mode — run from SmartPi terminal
        echo "RetroMi — Background Music Setup"
        echo "1) Install music"
        echo "2) Remove music"
        echo -n "Choice [1/2]: "
        read -r choice
        case "${choice}" in
            1) standard_setup ;;
            2) undo_changes ;;
            *) echo "Invalid choice." ; exit 1 ;;
        esac
        ;;
esac
