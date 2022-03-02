case $1 in
	'install')
			exe_path=$(dirname $0)
			cp $exe_path/bitwarden.sh /usr/bin/dmenu_bw \
				&& echo "Installed." & exit;;

	'uninstall')
		rm /usr/bin/dmenu_bw && echo "Uninstalled."  & exit;;
esac

PASSWORD=$(printf "" | dmenu -p 'Password:' -nb "#0f0f0f" -nf "#0f0f0f")
LOGIN=$(echo $PASSWORD | bw list items | jq -r ".[] | select( has( \"login\" ) ) | \"\\(.name)\"" | dmenu)

[ -z "$LOGIN" ] && exit

case $(printf 'Login\nPassword' | dmenu -p "Copy:") in
	"Login") echo $LOGIN | xclip -sel clip;;
	"Password")
		echo $PASSWORD | bw get password $LOGIN | xclip -sel clip
		$(sleep 30 && echo -n "" | xclip -selection clipboard -r) &;;
esac
