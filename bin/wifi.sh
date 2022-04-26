#!/bin/sh

[ -z "$1" ] || {
	INSTALL_PATH=/usr/bin/dmenu_wifi
	case "$1" in
		'install')
			(set -x; cp $0 $INSTALL_PATH)
			exit;;
		'uninstall')
			(set -x; rm $INSTALL_PATH)
			exit;;
	esac
}

# returns selected in dmenu network
networks() {
	printf "$(doas nmcli d w r && nmcli -g SSID,BARS d w l | sed 's/[[:blank:]]*$//' | sed 's/:/ /g' | grep -e '\w:*')\npower off\nrescan" | dmenu
}

# returns password of known network
is_known() {
	echo $(doas cat /etc/NetworkManager/system-connections/"$1".nmconnection | grep psk= | cut -d "=" -f2)
}

connect_to() {
	LENGHT=$(expr $(echo "$1" | wc -w) - 1)
	SSID=$(echo "$1" | cut -f-$LENGHT -d" ")

	[ -z "$(is_known $1)" ] && {
		PASSWORD=$(echo | dmenu -p "Password:" -P)
		(doas nmcli d w c $SSID password $PASSWORD) || ($0;exit)
	} || {
		doas nmcli d w c $SSID || {
			doas rm /etc/NetworkManager/system-connections/"$1".nmconnection
			PASSWORD=$(echo | dmenu -p "Password:" -P)
			(doas nmcli d w c $SSID password $PASSWORD) || ($0;exit)
		}
	}
}

STATUS=$(nmcli r w)

[ "$STATUS" = disabled ] && {
	[ "$(echo "power on" | dmenu)" = power\ on ] && {
		doas nmcli r w on && ($0;exit)
	}
}

SELECT=$(networks)

case $SELECT in
	*rescan*) doas nmcli d w r && ($0;exit);;
	*power\ off*) doas nmcli r w off && exit;;
	'') exit;;
	*) connect_to "$SELECT" && status;;
esac
