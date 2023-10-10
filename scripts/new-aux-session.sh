#!/bin/bash
# Script to start a new companion session named '#{session_name}-aux'
# Inherits the parent session's working directory and environment.

if [[ -z "$TERMINAL_EMULATOR" ]]; then
	if command -v "alacritty" &>/dev/null; then
		TERMINAL_EMULATOR=alacritty
	elif command -v "kitty" &>/dev/null; then
		TERMINAL_EMULATOR=kitty
	elif command -v "konsole" &>/dev/null; then
		TERMINAL_EMULATOR=konsole
	elif command -v "gnome-terminal" &>/dev/null; then
		TERMINAL_EMULATOR=gnome-terminal
	elif command -v "xfce4-terminal" &>/dev/null; then
		TERMINAL_EMULATOR=xfce4-terminal
	elif command -v "urxvt" &>/dev/null; then
		TERMINAL_EMULATOR=urxvt
	else
		TERMINAL_EMULATOR=xterm
	fi
fi

SESSION_NAME=$(tmux display-message -p '#{session_name}')
SESSION_PATH=$(tmux display-message -p '#{session_path}')

TMUX_CMD=(tmux new -A -s "$SESSION_NAME-aux" -c "$SESSION_PATH")
CMD=("$TERMINAL_EMULATOR" -e)

# echo "${CMD[@]}" "${TMUX_CMD[@]}"
exec "${CMD[@]}" "${TMUX_CMD[@]}"

