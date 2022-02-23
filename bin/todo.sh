#!/bin/sh
# Author: fenze <contact@fenze.dev>
# Simple todo list with dmenu

path="$HOME/.cache/.todo"

exit_code=0

help() {
  echo "usage: todo [-hv] [-fn font] [-m monitor]
      [-nb color] [-nf color] [-sb color]
      [-sf color] [-w windowid] [install/uninstall]"
  exit
}

[ -z "$1" ] || {
  INSTALL_PATH=/usr/bin/dmenu_todo
  case "$1" in
    'install')
      (set -x; cp $0 $INSTALL_PATH) || exit 4
      exit 0;;
    'uninstall')
      (set -x; rm $INSTALL_PATH) || exit 4
      exit 0;;
    -h | --help)
      help
      exit 0;;
    -v)
      echo "1.0"
      exit 0;;
    *)
      echo "todo: unknown command"
      exit 3;;
  esac
}

[ -d $(dirname $path) ] || mkdir $path && exit_code=1 || exit 4

[ -f $path ] && {
  tasks=$(cat $path)
  select=$(printf "New task\n$tasks" | dmenu $@ -p "Search:")
} || touch $path & exit_code=2

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
        printf "$tasks" | grep -v "$select" > $path
        exit exit_code;;
      "Rename")
        new_name=$(echo | dmenu $@ -p "New name:")
        printf "$tasks" | sed "s/$select/$new_name/" > $path
        exit exit_code;;
    esac
esac
