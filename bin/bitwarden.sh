# Copyright (c) 2022 fenze <contact@fenze.dev>
# See license for more information.

STATUS="Password:"

login() {
  [ -z "$1" ] || STATUS="Invalid password. Try again:"

  PASSWORD=$(printf "" | dmenu -p $STATUS -nb "#0F0F0F" -nf "#0F0F0F")

  [ -z "$PASSWORD" ] && exit

  LIST=$(echo $PASSWORD | bw list items 2> /dev/null) || login && {
    LOGIN=$(echo $LIST | jq -r ".[] | select( has( \"login\" ) ) | \"\\(.name)\"" | dmenu)

    [ -z "$LOGIN" ] && exit

    case $(printf 'Login\nPassword' | dmenu -p "Copy:") in
      "Login")
        echo $LOGIN | xclip -sel clip
        exit;;
      "Password")
        echo $PASSWORD | bw get password $LOGIN | xclip -sel clip
        exit;;
    esac
  }
}

[ -z "$1" ] && login || {
  INSTALL_PATH=/usr/bin/dmenu_bw
  case "$1" in
    'install') (set -x; cp $0 $INSTALL_PATH);;
    'uninstall') (set -x; rm $INSTALL_PATH);;
    '-h' | '--help')
      echo "usage: todo [-hv] [-fn font] [-m monitor]
      [-nb color] [-nf color] [-sb color]
      [-sf color] [-w windowid] [install/uninstall]";;

  esac
}
