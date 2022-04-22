#!/bin/sh

search()
{
	BOOKMARKS='duckduckgo.com reddit.com github.com youtube.com twitter.com devdocs.io'

	SEARCH=$(printf "$BOOKMARKS" | sed 's/ /\n/g' | dmenu -p SEARCH:)

	[ -z "$SEARCH" ] && exit

	[ -z "$(printf "$BOOKMARKS" | grep -w "$SEARCH")" ] && {
		surf https://duckduckgo.com/?q="$SEARCH"
	} || {
		surf https://"$SEARCH"
	}
}

[ -z "$1" ] && search || {
	INSTALL_PATH=/usr/local/bin/surf-open

	case "$1" in
		'install') (set -x; cp $0 $INSTALL_PATH);;
		'uninstall') (set -x; rm $INSTALL_PATH);;
	esac
}