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
	printf "$(nmcli -g SSID,BARS device wifi list)\n rescan" | grep "\w" | awk -F: '{ print $1" "$2 }' | dmenu
}

is_known() {
	echo $(doas cat /etc/NetworkManager/system-connections/"$1".nmconnection | grep psk= | cut -d "=" -f2)
}

connect_to() {
	LENGHT=$(expr $(echo "$1" | wc -w) - 1)
	SSID=$(echo "$1" | cut -f-$LENGHT -d" ")

	[ -z "$(is_known $1)" ] && {
		PASSWORD=$(echo | dmenu -p "Password:" -P)
		nmcli d w c $SSID password $PASSWORD
	} || {
		nmcli d w c $SSID
	}
}

SELECT=$(networks)

case $SELECT in
	*rescan*) nmcli d w r && $($0) & exit;;
	*) connect_to "$SELECT";;
esac
