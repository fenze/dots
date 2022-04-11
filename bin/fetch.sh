# Copyright (c) 2022 fenze <contact@fenze.dev>
# See license for more information.

[ -z "$1" ] || {
	INSTALL_PATH=/usr/bin/fetch
	case "$1" in
		'install') (set -x; cp $0 $INSTALL_PATH);;
		'uninstall') (set -x; rm $INSTALL_PATH);;
	esac
	exit
}


echo "os: $(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2 | cut -d " " -f1)"
echo "kernel: $(uname -r | sed 's/-.*//')"
echo "packages: $(pacman -Qe | wc -l)"
echo "colors: $(for i in $(seq 6); do printf "\033[0;3%im██" "$i"; done)"
