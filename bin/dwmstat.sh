#!/bin/sh
# dwm status
# Required https://dwm.suckless.org/patches/setstatus
# Copyright (c) 2022 fenze <contact@fenze.dev>

BAT() {
    echo "BAT: $(cat /sys/class/power_supply/BAT0/capacity)"
}

VOL() {
    list=$(pactl list sinks)
    volume=$(echo "$list" | grep '^[[:space:]]Volume:' | head -n $(( $SINK + 1 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,')
    mute=$(echo "$list" | grep Mute | awk -F: '{print $2}')
    [-z $(volume)] && {
      sleep 5
      VOL && exit
    }

    echo "VOL: $volume"
}

case $1 in
    "install") cp -u ./status.sh /usr/bin/status;;
    "uninstall") rm -f /usr/bin/status;;
    *) exec dwm -s "[$(VOL)] [$(BAT)] [$(date +%H:%M)]";;
esac
