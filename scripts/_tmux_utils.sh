#!/bin/bash
# Tmux utility functions to use for session scripts

_TMUX_SESSION=
_TMUX_WINDOW=
_TMUX_PANE=

DEBUG=

TMUX_WINDOW_ARGS=(-d -P -F "#{session_name}:#{window_index}")
TMUX_SPLIT_ARGS=(-P -F "#{session_name}:#{window_index}")

function @new-session() {
	[[ -z "$DEBUG" ]] || echo "tmux new-session -P -d $@"
	_TMUX_SESSION=$(tmux new-session -P -d "$@")
	_TMUX_WINDOW=$_TMUX_SESSION
	_TMUX_PANE=$_TMUX_WINDOW
}

function @new-window() {
	[[ -z "$DEBUG" ]] || echo "new-window -t $_TMUX_SESSION ${TMUX_WINDOW_ARGS[@]} $@"
	_TMUX_WINDOW=$(tmux new-window -t "$_TMUX_SESSION" "${TMUX_WINDOW_ARGS[@]}" "$@")
	_TMUX_PANE=$_TMUX_WINDOW
} 

function @split-window() {
	[[ -z "$DEBUG" ]] || echo "tmux split-window -t $_TMUX_WINDOW ${TMUX_SPLIT_ARGS[@]} $@"
	_TMUX_PANE=$(tmux split-window -t "$_TMUX_WINDOW" "${TMUX_SPLIT_ARGS[@]}" "$@")
}

function @send-keys() {
	[[ -z "$DEBUG" ]] || echo "tmux send-keys -t $_TMUX_PANE $@"
	tmux send-keys -t "$_TMUX_PANE" "$@"
}

function @select-window() {
	[[ -z "$DEBUG" ]] || echo "tmux select-window $@"
	tmux select-window "$@"
}

function @set-option() {
	# determine option's target (window / session / pane)
	local _ARGS=(-t "$_TMUX_SESSION")
	for opt in "$@"; do
		if [[ "$opt" == "-g" || "$opt" == "-t" ]]; then
			# no target required
			ARGS=(); break;
		elif [[ "$opt" == "-w" ]]; then
			ARGS=(-t "$_TMUX_WINDOW"); break;
		elif [[ "$opt" == "-p" ]]; then
			ARGS=(-t "$_TMUX_PANE"); break;
		fi # defaults to session target
	done
	[[ -z "$DEBUG" ]] || echo "tmux set-option ${_ARGS[@]} $@"
	tmux set-option "${_ARGS[@]}" "$@"
}

function @temporary-option() {
	local SLEEP="$1"; shift
	local VALUE="${@: -1}";
	local _SAVED_OPTION=$(tmux show-option -v "${@:1:$#-1}")
	@set-option "${@:1:$#-1}" off
	{ sleep "$SLEEP"; @set-option "${@:1:$#-1}" "$_SAVED_OPTION"; }&
}

