# Copyright (c) 2022 fenze <contact@fenze.dev>
# See license for more information.

path="$HOME/.cache/dmenu_todo"

[ -d $(dirname $path) ] || mkdir $path

[ -f $path ] || touch $path

todo()
{
	tasks=$(cat $path)
	select=$(printf "New task\n$tasks" | dmenu $@ -p "Search:")
	case $select in
		"New task")
			new_task=$(dmenu $@ -p "New task:" <&-)
			[ -z "$new_task" ] && exit 5
			[ -z "$(cat $path | grep -E "^$new_task$")" ] && {
				printf "$new_task\n" >> $path
			} || {
				printf "Already added." | dmenu $@ -p "" -nf "#000" > /dev/null
			};;
		'') exit 5;;
		*)
			option=$(printf "Remove\nRename" | dmenu $@ -p "Select option:")
			case $option in
				"Remove")
					printf "$tasks" | grep -v "$select" > $path;;
				"Rename")
					new_name=$(printf "" | dmenu $@ -p "New name:")
					[ -z "$new_name" ] && exit
					printf "$tasks" | sed "s/$select/$new_name/" > $path;;
			esac
	esac
}


[ -z "$1" ] && todo || {
	INSTALL_PATH=/usr/bin/dmenu_todo
	case "$1" in
		'install') (set -x; cp $0 $INSTALL_PATH);;
		'uninstall') (set -x; rm $INSTALL_PATH);;
	esac
}
