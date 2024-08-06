#disables/enables adult music
if [ $(cat /home/pi/music_settings/adult_songs/onoff.flag) == "0" ]
then
        mv /home/pi/RetroPie/music/ADULT-*.mp3 /home/pi/RetroPie/music-adult/ 2>/dev/null
else
	mv /home/pi/RetroPie/music-adult/ADULT-*.mp3 /home/pi/RetroPie/music/ 2>/dev/null
fi

#resets the switch where the user manually switched off the music in the last session
echo "1" > /home/pi/music_settings/user_switch/onoff.flag

#init play music
while pgrep omxplayer > /dev/null; do sleep 1; done
sleep 2
mpg123 -Z /home/pi/RetroPie/music/*.mp3 > /dev/null 2>&1 &

#If "music off at bootup" is selected then disable it
if [ $(cat /home/pi/music_settings/onoff.flag) == "0" ]
then
	pkill -STOP mpg123
fi



emulationstation #auto
