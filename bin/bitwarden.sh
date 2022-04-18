# Copyright (c) 2022 fenze <contact@fenze.dev>
# See license for more information.

login() {

	PASSWORD=$(printf "" | dmenu -P -p "Password:")

	[ -z "$PASSWORD" ] && exit

	printf "$PASSWORD" | xargs bw unlock --raw --nointeraction > /tmp/bw_session

	[ -z "${SESSION:="$(cat /tmp/bw_session)"}" ] && {
		$0 & exit
	} || {
		SELECT=$(bw list --session $SESSION items 2 | jq -r ".[] | select( has( \"login\" ) ) | \"\\(.name)\"" | dmenu)
		SELECT_PASS=$(bw get --session $SESSION password $SELECT)
		[ -z "$SELECT" ] && exit

		case $(printf 'Login\nPassword' | dmenu -p "Copy:" ) in
			"Login") echo $SELECT | xclip -sel clip;;
			"Password") echo $SELECT_PASS | xclip -sel clip;;
		esac

		rm -f /tmp/bw_session
	}
}

[ -z "$1" ] && login || {
	INSTALL_PATH=/usr/bin/dmenu_bw
	case "$1" in
		'install') (set -x; cp $0 $INSTALL_PATH);;
		'uninstall') (set -x; rm $INSTALL_PATH);;
	esac
}
