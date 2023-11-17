#!/bin/bash
# Script to start a new terminal window running a custom command

SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
set -e

# set a different working directory, if requested
if [[ -n "$SET_CWD" ]]; then cd "$SET_CWD"; fi

if [[ -z "$TERM_EMULATOR" ]]; then
	if command -v "alacritty" &>/dev/null; then
		TERM_EMULATOR=alacritty
	elif command -v "kitty" &>/dev/null; then
		TERM_EMULATOR=kitty
	elif command -v "konsole" &>/dev/null; then
		TERM_EMULATOR=konsole
	elif command -v "gnome-terminal" &>/dev/null; then
		TERM_EMULATOR=gnome-terminal
	elif command -v "xfce4-terminal" &>/dev/null; then
		TERM_EMULATOR=xfce4-terminal
	elif command -v "urxvt" &>/dev/null; then
		TERM_EMULATOR=urxvt
	else
		TERM_EMULATOR=xterm
	fi
fi

CMD=("$TERM_EMULATOR" -e "$@")

# echo "${CMD[@]}"
exec "${CMD[@]}"

