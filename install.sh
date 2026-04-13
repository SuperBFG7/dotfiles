#!/bin/bash

STOW_ARGS="-n"
[[ -n "$1" ]] && STOW_ARGS=""

is_installed() {
	pacman -Qi "$1" &> /dev/null
	return $?
}

#for p in ${!packages[@]}; do
ls | grep -v install.sh | grep -v TODO | while read p; do
	echo "------------------------------------"
	echo " Installing ~/.config/$p"
	echo "------------------------------------"

	packages=($p)
	if [ -f $p/packages.txt ]; then
		packages=( $(cat $p/packages.txt) )
	fi

	missing=()
	for i in ${packages[$p]}; do
		is_installed "$i"
		[[ $? -eq 0 ]] || missing+=($i)
	done
	if [ ${#missing[@]} -gt 0 ]; then
		echo "WARNING: Missing packages - to install run:"
		echo "  pacman -S ${missing[@]}"
	fi

	stow $STOW_ARGS -R -v -t ~ $p
	echo
done
