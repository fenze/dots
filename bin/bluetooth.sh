# Copyright (c) 2022 fenze <contact@fenze.dev>
# See license for more information.

CFG='-x 10 -y 10 -z 1900'

[ -z "$1" ] || {
	INSTALL_PATH=/usr/bin/dmenu_bt
	case "$1" in
		'install') (set -x; cp $0 $INSTALL_PATH);;
		'uninstall') (set -x; rm $INSTALL_PATH);;
	esac
	exit
}

bluetoothctl scan on 2> /dev/null & sleep 2

DEVICES=$(bluetoothctl devices 2> /dev/null | cut -d ' ' -f 3-)
CONNECT_TO=$(printf "$DEVICES" | dmenu -p "Connect to:" $CFG)
MAC=$(bluetoothctl devices 2> /dev/null | grep "$CONNECT_TO" | cut -d' ' -f2)
printf "connect $MAC\n" | bluetoothctl
