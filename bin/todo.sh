#!/bin/sh
# Author: fenze <contact@fenze.dev>
# Simple todo list with dmenu

path="$HOME/.cache/.todo"

help() {
  echo "usage: todo [-hv] [-fn font] [-m monitor]
      [-nb color] [-nf color] [-sb color]
      [-sf color] [-w windowid] [install/uninstall]"
  exit
}

[ -z "$1" ] || {
  INSTALL_PATH=/usr/bin/dmenu_todo
  case "$1" in
    'install') (set -x; cp $0 $INSTALL_PATH);;
    'uninstall') (set -x; rm $INSTALL_PATH);;
    -h | --help) help;;
  esac
  exit
}

[ -f $path ] && {
  tasks=$(cat $path)
  select=$(printf "New task\n$tasks" | dmenu -p "Search:")
} || touch $path

case $select in
  "New task")
    new_task=$(dmenu -p "New task:" <&-)
    [ -z "$new_task" ] && exit
    [ -z "$(cat $path | grep -E "^$new_task$")" ] && {
      printf "$new_task\n" >> $path
    } || {
      printf "Already added." | dmenu -p "" -nf "#000" > /dev/null
    };;
  '') exit;;
  *)
    option=$(printf "Remove\nRename" | dmenu -p "Select option:")
    case $option in
      "Remove")
        printf "$tasks" | grep -v "$select" > $path
        exit;;
      "Rename")
        new_name=$(echo | dmenu -p "New name:")
        printf "$tasks" | sed "s/$select/$new_name/" > $path
        exit;;
    esac
esac
