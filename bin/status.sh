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

UPDATES() {
	updates=$(printf "$(yay -Qu && checkupdates)" 2> /dev/null | wc -l)

	[ "0" = "$updates" ] || {
		exec dwm -s "↑ $updates  $(VOL)  $(BAT)  $(WIFI)  $(date +%H:%M) "
	}
}

VOL() {
		bluetooth=$(pactl list sinks short | grep bluez)

		[ -z "$bluetooth" ] && {
			list=$(pactl list sinks)
			volume=$(echo "$list" | grep '^[[:space:]]Volume:' | head -n $(( $SINK + 1 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,')
			mute=$(echo "$list" | grep Mute | cut -f2 -d" ")

			[ "$mute" = yes ] && echo "婢" || {
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
		} || {
			echo 
		}
}

INSTALL_PATH=/usr/bin/status
case $1 in
		'install') (set -x; cp $0 $INSTALL_PATH);;
		'uninstall') (set -x; rm $INSTALL_PATH);;
		"with updates") $INSTALL_PATH & UPDATES && exit;;
		*) exec dwm -s "$(VOL)  $(BAT)  $(WIFI)  $(date +%H:%M) " && exit;;
esac
