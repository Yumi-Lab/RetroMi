#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YEL='\033[1;33m'
NC='\033[0m'        #No Color

adult_music=$(cat /home/pi/music_settings/adult_songs/onoff.flag)
music_start=$(cat /home/pi/music_settings/onoff.flag)
music_over_games=$(cat /home/pi/music_settings/music_over_games/onoff.flag)

if [ $adult_music == "1" ]
then
	adult_music="YES"
else
	adult_music="NO"
fi

if [ $music_start == "1" ]
then
	music_start="YES"
else
	music_start="NO"
fi

if [ $music_over_games == "1" ]
then
        music_over_games="YES"
else
        music_over_games="NO"
fi
echo
echo
echo
echo
echo
echo
echo
echo
echo
echo
echo "                                    ,---------------------------.             "
echo -e "                           ...      |     ${GREEN} Build Date: 2020 ${NC}    |   ...       "
echo "                          (o o)     \`--------------------------(_  (. .)     "
echo "                     -ooO--(_)--Ooo----------------------------ooO--(_)--Ooo- "
echo
echo
echo
echo
echo
echo -e "${GREEN}"
echo "			                    | |         | | | |			"
echo "			  ___ _ __ ___  __ _| |_ ___  __| | | |			"
echo "			 / __| '__/ _ \/ _\` | __/ _ \/ _\` | | '_ \| | | |	"
echo "			| (__| | |  __/ (_| | ||  __/ (_| | | |_) | |_| |	"
echo "			 \___|_|  \___|\__,_|\__\___|\__,_| |_.__/ \__, |	"
echo "			                                            __/ |	"
echo "			                                           |___/	"
echo "			 _           _        _ _ _       _			"
echo "			(_)         | |      | | | |     | |			"
echo "			 _ _ __  ___| |_ __ _| | | |_ ___| | __ ____		"
echo "			| | '_ \/ __| __/ _\` | | | __/ _ \ |/ /|_  /		"
echo "			| | | | \__ \ || (_| | | | ||  __/   <  / / 		"
echo "			|_|_| |_|___/\__\__,_|_|_|\__\___|_|\_\/___|		"
echo
echo "				http://installtekz.com"
echo
echo
echo
echo
echo "                                            __       _______                 "
echo "                                   |\     /|/  \     (  __   )                "
echo "                                   | )   ( |\/) )    | (  )  |                "
echo "                                   | |   | |  | |    | | /   |                "
echo "                                   ( (   ) )  | |    | (/ /) |                "
echo "                                    \ \_/ /   | |    |   / | |                "
echo "                                     \   /  __) (_ _ |  (__) |                "
echo "                                      \_/   \____/(_)(_______)                "
echo -e "${NC}"
echo
echo
echo
echo
echo
echo
echo "				-- M U S I C  S E T T I N G S --"
echo
echo
echo -e "				              Adult Music:"   ${GREEN}$adult_music${NC}
echo -e "			 	    Start Music At Bootup:"   ${GREEN}$music_start${NC}
echo -e -n "			Continue Playing Music Over Games:"   ${GREEN}$music_over_games${NC}
echo "  (Caution: EXPERIMENTAL. May cause instability)"
echo
echo
echo -n "	  			9.."
sleep 1
echo -n "8.."
sleep 1
echo -n "7.."
sleep 1
echo -n "6.."
sleep 1
echo -n "5.."
sleep 1
echo -n "4.."
sleep 1
echo -n "3.."
sleep 1
echo -n "2.."
sleep 1
echo -n "1.."
sleep 1
echo -n ":)"
exit 0

