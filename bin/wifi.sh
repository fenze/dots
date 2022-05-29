#!/bin/sh

# POSTCMDS="status"

menu()
{
	printf "$1" | dmenu -p "$2"
}

STATUS=$(nmcli r w)

[ $STATUS = disabled ] && {
	[ -z "$(echo "power on" | dmenu)" ] || {
		doas nmcli r w on && ($0;exit)
	}
}

NETWORKS="$(nmcli -g IN-USE,SSID,BARS d w 2> /dev/null)"
UNIQ=$(printf "$NETWORKS" | grep -P ".:\w" | sort -u -k2)
SELECT=$(menu "Settings\n$(echo "$UNIQ" | cut -f2- -d":" | tr ":" " ")" "Wi-Fi:")

is_known()
{
	echo "$(doas cat /etc/NetworkManager/system-connections/"$1".nmconnection 2> /dev/null \
	       | grep psk= | cut -d "=" -f2)"
}

with_passwd()
{
	local -a PASSWD
	PASSWD=$(printf "" | dmenu -p "Password:" -P)

	[ -z "$PASSWD" ] && exit
	nmcli d w c "$1" password "$PASSWD" \
		|| with_passwd "$1"
}

connect()
{
	LENGHT=$(($(echo "$1" | wc -w) - 1))
	SSID=$(echo "$1" | cut -f-$LENGHT -d" ")

	case $(menu "Connect\nForget" "$SSID") in
		'') exit;;
		Forget)
			nmcli c d "$SSID" > /dev/null
			exit;;
	esac


	[ -z "${PASSWD:=$(is_known "$SSID")}" ] && {
		with_passwd "$SSID"
	} || {
		echo "wqfw"
		nmcli d w c "$SSID" password "$PASSWD"
	}
}

settings()
{
	case $(printf "Poweroff\nRescan" | dmenu) in
		Poweroff) nmcli r w off > /dev/null;;
		Rescan) nmcli d w r > /dev/null && sleep 2 && ($0;exit);;
		'') ($0;exit);;
	esac
}

case $SELECT in
	'') exit;;
	Settings) settings;;
	*) connect "$SELECT";;
esac

eval "$POSTCMDS"
