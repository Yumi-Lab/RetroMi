#!/bin/bash


standard_setup()
{
        # check for an internet connection
        wget -q --spider http://google.com
        if [ $? -eq 0 ]; then
                if [ ! -d /home/pi/RetroPie/music ]; then
                    mkdir /home/pi/RetroPie/music
                fi
                if [ ! -d /home/pi/RetroPie/music-adult ]; then
                    mkdir /home/pi/RetroPie/music-adult
                fi
                mkdir /home/pi/music_settings
                mkdir /home/pi/music_settings/adult_songs
                mkdir /home/pi/music_settings/music_over_games
                mkdir /home/pi/music_settings/user_switch

                echo "1" > /home/pi/music_settings/onoff.flag
                echo "1" > /home/pi/music_settings/adult_songs/onoff.flag
                echo "0" > /home/pi/music_settings/music_over_games/onoff.flag
                echo "1" > /home/pi/music_settings/user_switch/onoff.flag
    
                # create a backup of autostart.sh
                if [ ! -f /opt/retropie/configs/all/autostart.sh.orig ] && [ -f /opt/retropie/configs/all/autostart.sh ]; then
                    mv /opt/retropie/configs/all/autostart.sh /opt/retropie/configs/all/autostart.sh.orig
                fi

                cp music_files/autostart.sh /opt/retropie/configs/all/

                cp music_files/Startup\ With\ Music\ On.sh /home/pi/RetroPie/retropiemenu/
                cp music_files/Startup\ With\ Music\ Off.sh /home/pi/RetroPie/retropiemenu/
                cp music_files/Music\ Stop.sh /home/pi/RetroPie/retropiemenu/
                cp music_files/Music\ Start.sh /home/pi/RetroPie/retropiemenu/
                cp music_files/info.sh /home/pi/RetroPie/retropiemenu/
                cp music_files/continue\ music\ over\ game\ on.sh /home/pi/RetroPie/retropiemenu/
                cp music_files/continue\ music\ over\ game\ off.sh /home/pi/RetroPie/retropiemenu/
                cp music_files/Adult\ Music\ On\ \(Requires\ Reboot\).sh /home/pi/RetroPie/retropiemenu/
                cp music_files/Adult\ Music\ Off\ \(Requires\ Reboot\).sh /home/pi/RetroPie/retropiemenu/

                # Create a backup of runcommand files IF a backup does not already exist
                if [ ! -f /opt/retropie/configs/all/runcommand-onstart.sh.orig ]; then
                    mv /opt/retropie/configs/all/runcommand-onstart.sh /opt/retropie/configs/all/runcommand-onstart.sh.orig 2>/dev/null
                fi
                if [ ! -f /opt/retropie/configs/all/runcommand-onend.sh.orig ]; then
                    mv /opt/retropie/configs/all/runcommand-onend.sh /opt/retropie/configs/all/runcommand-onend.sh.orig 2>/dev/null
                fi
                
                
                cp music_files/runcommand-onstart.sh /opt/retropie/configs/all/
                cp music_files/runcommand-onend.sh /opt/retropie/configs/all/
    
                sudo apt-get -y install mpg123
                
                echo
                echo
                echo -e "${GREEN}"
    
                # if 2x mp3's are not present then get them
                if [ ! -f /home/pi/RetroPie/music/ADULT-Da\ Shootaz\ \-\ Grand\ Theft\ Auto_PSX.mp3 ]; then
                    echo "Downloading a song for testing.."
                    wget http://installtekz.com/downloads/musicpi/ADULT-Da\ Shootaz\ \-\ Grand\ Theft\ Auto_PSX.mp3 2>/dev/null
                    mv ADULT-Da\ Shootaz\ \-\ Grand\ Theft\ Auto_PSX.mp3 /home/pi/RetroPie/music 2>/dev/null
                fi
    
                if [ ! -f /home/pi/RetroPie/music/aftershocks.mp3 ]; then
                    echo "Downloading a song for testing.."
                    wget http://installtekz.com/downloads/musicpi/aftershocks.mp3 2>/dev/null
                    mv aftershocks.mp3 /home/pi/RetroPie/music 2>/dev/null
                fi
    
                # Hide Menu items
                mv /home/pi/RetroPie/retropiemenu/audiosettings.rp /home/pi/RetroPie/retropiemenu/audiosettings.rp.1
                #mv /home/pi/RetroPie/retropiemenu/bluetooth.rp /home/pi/RetroPie/retropiemenu/bluetooth.rp.1
                mv /home/pi/RetroPie/retropiemenu/configedit.rp /home/pi/RetroPie/retropiemenu/configedit.rp.1
                mv /home/pi/RetroPie/retropiemenu/esthemes.rp /home/pi/RetroPie/retropiemenu/esthemes.rp.1
                mv /home/pi/RetroPie/retropiemenu/filemanager.rp /home/pi/RetroPie/retropiemenu/filemanager.rp.1
                mv /home/pi/RetroPie/retropiemenu/raspiconfig.rp /home/pi/RetroPie/retropiemenu/raspiconfig.rp.1
                mv /home/pi/RetroPie/retropiemenu/retroarch.rp /home/pi/RetroPie/retropiemenu/retroarch.rp.1
                mv /home/pi/RetroPie/retropiemenu/retronetplay.rp /home/pi/RetroPie/retropiemenu/retronetplay.rp.1
                mv /home/pi/RetroPie/retropiemenu/rpsetup.rp /home/pi/RetroPie/retropiemenu/rpsetup.rp.1
                mv /home/pi/RetroPie/retropiemenu/runcommand.rp /home/pi/RetroPie/retropiemenu/runcommand.rp.1
                mv /home/pi/RetroPie/retropiemenu/showip.rp /home/pi/RetroPie/retropiemenu/showip.rp.1
                mv /home/pi/RetroPie/retropiemenu/splashscreen.rp /home/pi/RetroPie/retropiemenu/splashscreen.rp.1
                #mv /home/pi/RetroPie/retropiemenu/wifi.rp /home/pi/RetroPie/retropiemenu/wifi.rp.1
                
                echo
                echo "DONE!"
                echo
                echo "Place ALL your mp3 music files in the folder: /home/pi/RetroPie/music"
                echo "To use the adult music feature, prepend mp3 filename with \"ADULT-\" AND place mp3 file in: /home/pi/RetroPie/music"
                echo -e "${NC}"
                echo
                #echo -n "Reboot Now? If everything seemed to have worked OK then you should select y: [y/n]: "
                #read reboot_now
                #case $reboot_now in
                #    y|Y) sudo reboot
                #    ;;
                #    *) exit 0
                #    ;;
                #esac
        else
            echo "Not connected to internet! Exiting.."
            exit 0
        fi    
}



undo_changes()
{
    echo -n "WARNING: This will attempt to remove files/settings created by this script. Do you wish to continue? [y = YES, or any other key for NO]: "
    read WARNING
    if [ $WARNING == "y" ] 2>/dev/null || [ $WARNING == "Y" ] 2>/dev/null; then
        echo "Omitting music directories"

        
        # Restore files
        if [ -f /opt/retropie/configs/all/autostart.sh.orig ]; then
            mv /opt/retropie/configs/all/autostart.sh.orig /opt/retropie/configs/all/autostart.sh
        fi
        #echo "emulationstation #auto" > /opt/retropie/configs/all/autostart.sh
        
        
        if [ -f /opt/retropie/configs/all/runcommand-onstart.sh.orig ]; then
            mv /opt/retropie/configs/all/runcommand-onstart.sh.orig /opt/retropie/configs/all/runcommand-onstart.sh
        else
            rm /opt/retropie/configs/all/runcommand-onstart.sh
        fi
        
        
        if [ -f /opt/retropie/configs/all/runcommand-onend.sh.orig ]; then
            mv /opt/retropie/configs/all/runcommand-onend.sh.orig /opt/retropie/configs/all/runcommand-onend.sh
        else
            rm /opt/retropie/configs/all/runcommand-onend.sh
        fi
    
    

        # Remove musicPi files & directories
        rm -R /home/pi/music_settings
        
        rm /home/pi/RetroPie/retropiemenu/Startup\ With\ Music\ On.sh
        rm /home/pi/RetroPie/retropiemenu/Startup\ With\ Music\ Off.sh
        rm /home/pi/RetroPie/retropiemenu/Music\ Stop.sh
        rm /home/pi/RetroPie/retropiemenu/Music\ Start.sh
        rm /home/pi/RetroPie/retropiemenu/info.sh
        rm /home/pi/RetroPie/retropiemenu/continue\ music\ over\ game\ on.sh
        rm /home/pi/RetroPie/retropiemenu/continue\ music\ over\ game\ off.sh
        rm /home/pi/RetroPie/retropiemenu/Adult\ Music\ On\ \(Requires\ Reboot\).sh
        rm /home/pi/RetroPie/retropiemenu/Adult\ Music\ Off\ \(Requires\ Reboot\).sh


        # Restore all menu items
        mv /home/pi/RetroPie/retropiemenu/audiosettings.rp.1 /home/pi/RetroPie/retropiemenu/audiosettings.rp 2>/dev/null
        mv /home/pi/RetroPie/retropiemenu/bluetooth.rp.1 /home/pi/RetroPie/retropiemenu/bluetooth.rp 2>/dev/null
        mv /home/pi/RetroPie/retropiemenu/configedit.rp.1 /home/pi/RetroPie/retropiemenu/configedit.rp 2>/dev/null
        mv /home/pi/RetroPie/retropiemenu/esthemes.rp.1 /home/pi/RetroPie/retropiemenu/esthemes.rp 2>/dev/null
        mv /home/pi/RetroPie/retropiemenu/filemanager.rp.1 /home/pi/RetroPie/retropiemenu/filemanager.rp 2>/dev/null
        mv /home/pi/RetroPie/retropiemenu/raspiconfig.rp.1 /home/pi/RetroPie/retropiemenu/raspiconfig.rp 2>/dev/null
        mv /home/pi/RetroPie/retropiemenu/retroarch.rp.1 /home/pi/RetroPie/retropiemenu/retroarch.rp 2>/dev/null
        mv /home/pi/RetroPie/retropiemenu/retronetplay.rp.1 /home/pi/RetroPie/retropiemenu/retronetplay.rp 2>/dev/null
        mv /home/pi/RetroPie/retropiemenu/rpsetup.rp.1 /home/pi/RetroPie/retropiemenu/rpsetup.rp 2>/dev/null
        mv /home/pi/RetroPie/retropiemenu/runcommand.rp.1 /home/pi/RetroPie/retropiemenu/runcommand.rp 2>/dev/null
        mv /home/pi/RetroPie/retropiemenu/showip.rp.1 /home/pi/RetroPie/retropiemenu/showip.rp 2>/dev/null
        mv /home/pi/RetroPie/retropiemenu/splashscreen.rp.1 /home/pi/RetroPie/retropiemenu/splashscreen.rp 2>/dev/null
        mv /home/pi/RetroPie/retropiemenu/wifi.rp.1 /home/pi/RetroPie/retropiemenu/wifi.rp 2>/dev/null
        
        echo "DONE!"
        echo
        echo -n "Reboot Now? (Enter y for YES or any other key for NO): "
        read undo_reboot
        case $undo_reboot in
            y|Y) sudo reboot
            ;;
        esac
    else
        echo "Skipping.."
    fi
        
}



edit_menu_entries()
{
    echo "Do you want to show these settings on the RetroPie menu?"
    echo "Enter y for YES, or any other key for NO"
    echo
    echo -e "${GREEN}"
    echo
    echo -n "Show: Audio Settings? "
    read audio_settings
    if [ $audio_settings == "y" ] 2>/dev/null || [ $audio_settings == "Y" ] 2>/dev/null; then
        mv /home/pi/RetroPie/retropiemenu/audiosettings.rp.1 /home/pi/RetroPie/retropiemenu/audiosettings.rp 2>/dev/null
    else
        mv /home/pi/RetroPie/retropiemenu/audiosettings.rp /home/pi/RetroPie/retropiemenu/audiosettings.rp.1 2>/dev/null
    fi
    
    
    echo -n "Show: Bluetooth Settings? "    
    read bt_settings
    if [ $bt_settings == "y" ] 2>/dev/null || [ $bt_settings == "Y" ] 2>/dev/null; then
        mv /home/pi/RetroPie/retropiemenu/bluetooth.rp.1 /home/pi/RetroPie/retropiemenu/bluetooth.rp 2>/dev/null
    else
        mv /home/pi/RetroPie/retropiemenu/bluetooth.rp /home/pi/RetroPie/retropiemenu/bluetooth.rp.1 2>/dev/null
    fi
    
    
    echo -n "Show: Configuration Editor? "
    read configedit
    if [ $configedit == "y" ] 2>/dev/null || [ $configedit == "Y" ] 2>/dev/null; then
        mv /home/pi/RetroPie/retropiemenu/configedit.rp.1 /home/pi/RetroPie/retropiemenu/configedit.rp 2>/dev/null
    else
        mv /home/pi/RetroPie/retropiemenu/configedit.rp /home/pi/RetroPie/retropiemenu/configedit.rp.1 2>/dev/null
    fi
    
    
    echo -n "Show: ES Themes? "
    read ESthemes
    if [ $ESthemes == "y" ] 2>/dev/null || [ $ESthemes == "Y" ] 2>/dev/null; then
        mv /home/pi/RetroPie/retropiemenu/esthemes.rp.1 /home/pi/RetroPie/retropiemenu/esthemes.rp 2>/dev/null
    else
        mv /home/pi/RetroPie/retropiemenu/esthemes.rp /home/pi/RetroPie/retropiemenu/esthemes.rp.1 2>/dev/null
    fi
    
    
    echo -n "Show: File Manager? "
    read filemanager
    if [ $filemanager == "y" ] 2>/dev/null || [ $filemanager == "Y" ] 2>/dev/null; then
        mv /home/pi/RetroPie/retropiemenu/filemanager.rp.1 /home/pi/RetroPie/retropiemenu/filemanager.rp 2>/dev/null
    else
        mv /home/pi/RetroPie/retropiemenu/filemanager.rp /home/pi/RetroPie/retropiemenu/filemanager.rp.1 2>/dev/null
    fi
    
    
    echo -n "Show: Raspi-Config? "
    read raspiconfig
    if [ $raspiconfig == "y" ] 2>/dev/null || [ $raspiconfig == "Y" ] 2>/dev/null; then
        mv /home/pi/RetroPie/retropiemenu/raspiconfig.rp.1 /home/pi/RetroPie/retropiemenu/raspiconfig.rp 2>/dev/null
    else
        mv /home/pi/RetroPie/retropiemenu/raspiconfig.rp /home/pi/RetroPie/retropiemenu/raspiconfig.rp.1 2>/dev/null
    fi
    
    
    echo -n "Show: RetroArch? "
    read RetroArch
    if [ $RetroArch == "y" ] 2>/dev/null || [ $RetroArch == "Y" ] 2>/dev/null; then
        mv /home/pi/RetroPie/retropiemenu/retroarch.rp.1 /home/pi/RetroPie/retropiemenu/retroarch.rp 2>/dev/null
    else
        mv /home/pi/RetroPie/retropiemenu/retroarch.rp /home/pi/RetroPie/retropiemenu/retroarch.rp.1 2>/dev/null
    fi
    
    
    echo -n "Show: RetroArch Netplay? "
    read retroNetplay
    if [ $retroNetplay == "y" ] 2>/dev/null || [ $retroNetplay == "Y" ] 2>/dev/null; then
        mv /home/pi/RetroPie/retropiemenu/retronetplay.rp.1 /home/pi/RetroPie/retropiemenu/retronetplay.rp 2>/dev/null
    else
        mv /home/pi/RetroPie/retropiemenu/retronetplay.rp /home/pi/RetroPie/retropiemenu/retronetplay.rp.1 2>/dev/null
    fi
    
    
    echo -n "Show: RetroPie Setup? "
    read RPsetup
    if [ $RPsetup == "y" ] 2>/dev/null || [ $RPsetup == "Y" ] 2>/dev/null; then
        mv /home/pi/RetroPie/retropiemenu/rpsetup.rp.1 /home/pi/RetroPie/retropiemenu/rpsetup.rp 2>/dev/null
    else
        mv /home/pi/RetroPie/retropiemenu/rpsetup.rp /home/pi/RetroPie/retropiemenu/rpsetup.rp.1 2>/dev/null
    fi
    
    
    echo -n "Show: Run Command Configuration? "
    read RunCommand
    if [ $RunCommand == "y" ] 2>/dev/null || [ $RunCommand == "Y" ] 2>/dev/null; then
        mv /home/pi/RetroPie/retropiemenu/runcommand.rp.1 /home/pi/RetroPie/retropiemenu/runcommand.rp 2>/dev/null
    else
        mv /home/pi/RetroPie/retropiemenu/runcommand.rp /home/pi/RetroPie/retropiemenu/runcommand.rp.1 2>/dev/null
    fi
    
    
    echo -n "Show: Show IP? "
    read ShowIP
    if [ $ShowIP == "y" ] 2>/dev/null || [ $ShowIP == "Y" ] 2>/dev/null; then
        mv /home/pi/RetroPie/retropiemenu/showip.rp.1 /home/pi/RetroPie/retropiemenu/showip.rp 2>/dev/null
    else
        mv /home/pi/RetroPie/retropiemenu/showip.rp /home/pi/RetroPie/retropiemenu/showip.rp.1 2>/dev/null
    fi
    
    
    echo -n "Show: Splash Screens? "
    read SplashScreen
    if [ $SplashScreen == "y" ] 2>/dev/null || [ $SplashScreen == "Y" ] 2>/dev/null; then
        mv /home/pi/RetroPie/retropiemenu/splashscreen.rp.1 /home/pi/RetroPie/retropiemenu/splashscreen.rp 2>/dev/null
    else
        mv /home/pi/RetroPie/retropiemenu/splashscreen.rp /home/pi/RetroPie/retropiemenu/splashscreen.rp.1 2>/dev/null
    fi
    
    
    echo -n "Show: WiFi? "
    read WiFi
    if [ $WiFi == "y" ] 2>/dev/null || [ $WiFi == "Y" ] 2>/dev/null; then
        mv /home/pi/RetroPie/retropiemenu/wifi.rp.1 /home/pi/RetroPie/retropiemenu/wifi.rp 2>/dev/null
    else
        mv /home/pi/RetroPie/retropiemenu/wifi.rp /home/pi/RetroPie/retropiemenu/wifi.rp.1 2>/dev/null
    fi
    
    echo
    echo -e "${NC}"
    echo "DONE !!"
    
}


standard_setup
