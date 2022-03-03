# Copyright (c) 2022 fenze <contact@fenze.dev>
# See license for more information.

[ -z "$1" ] || {
	INSTALL_PATH=/usr/bin/dmenu_bt
	case "$1" in
		'install') (set -x; cp $0 $INSTALL_PATH);;
		'uninstall') (set -x; rm $INSTALL_PATH);;
		'-h' | '--help')
			echo "usage: todo [-hv] [-fn font] [-m monitor]
			[-nb color] [-nf color] [-sb color]
			[-sf color] [-w windowid] [install/uninstall]";;
	esac
		exit
}

DEVICES=$(bluetoothctl devices | cut -d ' ' -f 3-)
CONNECT_TO=$(printf "$DEVICES" | dmenu)
MAC=$(bluetoothctl devices | grep "$CONNECT_TO" | cut -d' ' -f2)
printf "connect $MAC\n" | bluetoothctl
