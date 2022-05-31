#!/bin/sh

ICONS=(
	'|'  # SEPARATOR
	''   # TIME
	'↑'  # UPDATE
	'⚡' # BATTERY
	''  # WIFI
)

FORMAT()
{
	echo "$1 $2 ${ICONS[0]}"
}

TIME()
{
	echo "${ICONS[1]} "
	date +"%H:%M"
}

UPDATES()
{
	# for only pacman replace
	# yay with pacman
	local -a AMOUNT
	AMOUNT=$(pacman -Qu 2> /dev/null | wc -l)

	[ $AMOUNT = 0 ] || {
		FORMAT ${ICONS[2]} $AMOUNT
	}
}

BATTERY()
{
	FORMAT \
		${ICONS[3]} \
		$(cat /sys/class/power_supply/BAT0/capacity)%
}

WIFI()
{
	nmcli d w s > /dev/null || return
	FORMAT \
		${ICONS[4]} \
		"$(nmcli d w s 2> /dev/null | sed -ne 's/SSID: //p')"
}

MODULES=(
	$(UPDATES)
	$(WIFI)
	$(BATTERY)
	$(TIME)
)

dwm -s "${MODULES[*]} "
