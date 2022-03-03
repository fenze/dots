# Copyright (c) 2022 fenze <contact@fenze.dev>
# See license for more information.

[ -z "$1" ] || {
	INSTALL_PATH=/usr/bin/dmenu_bw
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

PASSWORD=$(printf "" | dmenu -p 'Password:' -nb "#0f0f0f" -nf "#0f0f0f")
LOGIN=$(echo $PASSWORD | bw list items | jq -r ".[] | select( has( \"login\" ) ) | \"\\(.name)\"" | dmenu)

[ -z "$LOGIN" ] && exit

case $(printf 'Login\nPassword' | dmenu -p "Copy:") in
	"Login") echo $LOGIN | xclip -sel clip;;
	"Password")
		echo $PASSWORD | bw get password $LOGIN | xclip -sel clip
		sleep 30 && echo -n "" | xclip -selection clipboard -r &;;
esac
