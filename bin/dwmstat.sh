#!/bin/sh
# dwm status
# Required https://dwm.suckless.org/patches/setstatus
# Copyright (c) 2022 fenze <contact@fenze.dev>

WIFI() {
	NET=$(nmcli -g IN-USE,SSID device wifi list | grep "\*" | cut -f2 -d":")
	[ -z "$NET" ] || echo  ""
}


BAT() {
	STATUS=$(cat /sys/class/power_supply/BAT0/status)

	[ $STATUS = Charging ] && echo  && exit

	CAPACITY=$(cat /sys/class/power_supply/BAT0/capacity)

	case $CAPACITY in
		100) echo   && exit;;
		1*)  echo   && exit;;
		2*)  echo   && exit;;
		3*)  echo   && exit;;
		4*)  echo   && exit;;
		5*)  echo   && exit;;
		6*)  echo   && exit;;
		7*)  echo   && exit;;
		8*)  echo   && exit;;
		9*)  echo   && exit;;
	esac
}

VOL() {
    list=$(pactl list sinks)
    volume=$(echo "$list" | grep '^[[:space:]]Volume:' | head -n $(( $SINK + 1 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,')
    mute=$(echo "$list" | grep Mute | awk -F: '{print $2}')

		[ $mute = yes ] && echo 婢&& exit

		[ -z "volume" ] && {
			sleep 5
			VOL && exit
		}

	case $volume in
		0 | 5 | 10 | 15 | 2* | 3*) echo  && exit;;
		4* | 5* | 6*) echo  && exit;;
		7* | 8* | 9* | 1*) echo  && exit;;
	esac
}

case $1 in
    "install") cp -u ./status.sh /usr/bin/status;;
    "uninstall") rm -f /usr/bin/status;;
		*) exec dwm -s "$(VOL)  $(BAT)  $(WIFI)  $(date +%H:%M) ";;
esac
