# Copyright (c) 2022 fenze <contact@fenze.dev>
# See license for more information.

[ -z "$1" ] || {
	INSTALL_PATH=/usr/bin/dmenu_bt
	case "$1" in
		'install') (set -x; cp $0 $INSTALL_PATH);;
		'uninstall') (set -x; rm $INSTALL_PATH);;
	esac
	exit
}

set -x

$(bluetoothctl show | grep -q "Powered: yes") && {
	DEVICES=$(bluetoothctl devices 2> /dev/null | cut -d ' ' -f 3-)
	CONNECT_TO=$(printf "$DEVICES\npower off\nrescan" | dmenu -p "Connect to:")
	case $CONNECT_TO in
		power\ off) bluetoothctl power off &> /dev/null && exit;;
		rescan) bluetoothctl scan on & sleep 2 && killall bluetoothctl && $0 && exit;;
		*)
			MAC=$(bluetoothctl devices 2> /dev/null | grep "$CONNECT_TO" | cut -d' ' -f2)
			printf "connect $MAC\n" | bluetoothctl;;
	esac
} || {
	[ "$(echo "power on" | dmenu)" = "power on" ] && bluetoothctl power on
}
