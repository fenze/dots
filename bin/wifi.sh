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

networks() {
	printf "$(doas nmcli d w r && nmcli -g SSID,BARS d w l)\npower off\nrescan" | grep "\w" | awk -F: '{ print $1" "$2 }' | dmenu
}

is_known() {
	echo $(doas cat /etc/NetworkManager/system-connections/"$1".nmconnection | grep psk= | cut -d "=" -f2)
}

connect_to() {
	LENGHT=$(expr $(echo "$1" | wc -w) - 1)
	SSID=$(echo "$1" | cut -f-$LENGHT -d" ")

	[ -z "$(is_known $1)" ] && {
		PASSWORD=$(echo | dmenu -p "Password:" -P)
		doas nmcli d w c $SSID password $PASSWORD
	} || {
		doas nmcli d w c $SSID || {
			doas rm /etc/NetworkManager/system-connections/"$1".nmconnection
			PASSWORD=$(echo | dmenu -p "Password:" -P)
			doas nmcli d w c $SSID password $PASSWORD
		}
	}
}

STATUS=$(nmcli r w)

[ "$STATUS" = disabled ] && {
	[ "$(echo "power on" | dmenu)" = power\ on ] && nmcli r w on
}

SELECT=$(networks)

[ -z "$SELECT" ] && exit

[ "$SELECT" = "power off" ] && nmcli r w off && exit

case $SELECT in
	*rescan*) nmcli d w r && $($0) & exit;;
	*) connect_to "$SELECT";;
esac
