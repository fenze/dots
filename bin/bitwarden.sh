# Copyright (c) 2022 fenze <contact@fenze.dev>
# See license for more information.

login() {

	[ -f /tmp/bw_session ] && [ ! -z "$(cat /tmp/bw_session)" ] && {
		SESSION=$(cat /tmp/bw_session)
	} || {
		PASSWORD=$(printf "" | dmenu -P -p "Password:")
		[ -z "$PASSWORD" ] && exit
		printf "$PASSWORD" | xargs bw unlock --raw --nointeraction > /tmp/bw_session

		[ -z "${SESSION:="$(cat /tmp/bw_session)"}" ] && {
			$0 & exit
		}
	}

	[ -f /tmp/bw_cache ] && [ ! -z "$(cat /tmp/bw_cache)" ] && {
		ITEMS=$(cat /tmp/bw_cache)
	} || {
		ITEMS=$(bw list --session $SESSION --nointeraction items > /tmp/bw_cache)
	}

	SELECT=$(echo $ITEMS | jq -r ".[] | select( has( \"login\" ) ) | \"\\(.name)\"" | dmenu)

	case $(printf 'Login\nPassword' | dmenu -p "Copy:" ) in
		"Login")
			echo $SELECT | xclip -sel clip;;
		"Password")
			bw get --session $SESSION --nointeraction password $SELECT | xclip -sel clip;;
	esac
}

[ -z "$1" ] && login || {
	INSTALL_PATH=/usr/bin/dmenu_bw
	case "$1" in
		'install') (set -x; cp $0 $INSTALL_PATH);;
		'uninstall') (set -x; rm $INSTALL_PATH);;
	esac
}
