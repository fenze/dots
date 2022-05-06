#!/bin/sh

search()
{
	BOOKMARKS='duckduckgo.com reddit.com github.com youtube.com twitter.com devdocs.io'
	CURRENT_ID=$(xdotool getactivewindow)
	SEARCH=$(printf "$BOOKMARKS" | sed 's/ /\n/g' | cut -f1 -d"." | dmenu -p SEARCH:)

	SURF_GO=$(xprop -id "$CURRENT_ID" | grep _SURF_URI)

	[ -z "$1" ] || SURF_GO=''

	[ -z "$SURF_GO" ] || {
		[ -z "$(printf "$BOOKMARKS" | grep -w "$SEARCH")" ] && {
			[ -z "$SEARCH"] && exit
			xprop -id "$CURRENT_ID" -f "_SURF_GO" 8u -set "_SURF_GO" https://duckduckgo.com/?q="$SEARCH"
			exit
		} || {
			[ $SEARCH = devdocs ] && {
				xprop -id "$CURRENT_ID" -f "_SURF_GO" 8u -set "_SURF_GO" https://"$SEARCH".io
				exit
			} || {
				xprop -id "$CURRENT_ID" -f "_SURF_GO" 8u -set "_SURF_GO" https://"$SEARCH".com
				exit
			}
		}
	}

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
		install) (set -x; cp $0 $INSTALL_PATH);;
		uninstall) (set -x; rm $INSTALL_PATH);;
		new_window) search new;;
	esac
}
