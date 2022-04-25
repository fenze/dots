#!/bin/sh

search()
{
	BOOKMARKS='duckduckgo.com reddit.com github.com youtube.com twitter.com devdocs.io'

	SEARCH=$(printf "$BOOKMARKS" | sed 's/ /\n/g' | cut -f1 -d"." | dmenu -p SEARCH:)

	[ -z "$SEARCH" ] && exit

	[ -z "$(printf "$BOOKMARKS" | grep -w "$SEARCH")" ] && {
		surf https://duckduckgo.com/?q="$SEARCH"
	} || {
		[ $SEARCH = devdocs ] && {
			surf https://"$SEARCH".io
		} || {
			surf https://"$SEARCH".com
		}
	}
}

[ -z "$1" ] && search || {
	INSTALL_PATH=/usr/local/bin/surf-open

	case "$1" in
		'install') (set -x; cp $0 $INSTALL_PATH);;
		'uninstall') (set -x; rm $INSTALL_PATH);;
	esac
}
