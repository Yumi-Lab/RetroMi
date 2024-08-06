if [ $(cat /home/pi/music_settings/music_over_games/onoff.flag) == "0" ]; then
        pkill -STOP mpg123
fi