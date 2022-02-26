# Author: fenze <contact@fenze.dev>
# Simple fetch for arch linux

echo "os: $(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2 | cut -d " " -f1)"
echo "kernel: $(uname -r | sed 's/-.*//')"
echo "packages: $(pacman -Qe | wc -l)"
echo "colors: $(for i in $(seq 6); do printf "\033[0;3%im██" "$i"; done)"
