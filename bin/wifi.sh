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

CFG='-x 10 -y 10 -z 1900'
SELECT=$(nmcli -g SSID,BARS device wifi list | grep "\w" | awk -F: '{ print $1" "$2 }' | dmenu -p "Connect to:" $CFG)

[ -z "$SELECT" ] && exit

passwd() {
	PASSWORD=$(echo | dmenu -p "Password:" -P $CFG)
	[ -z "$PASSWORD" ] && {
		doas nmcli d w c $(echo $SELECT | cut -f1 -d" ")
	} || {
		doas nmcli d w c $(echo $SELECT | cut -f1 -d" ") password "$PASSWORD"
	}
}

passwd
