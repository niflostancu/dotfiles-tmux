#!/usr/bin/env bash
set -e
shopt -s extglob

TMUX_SESSIONS_ENGINE=script

TMUX_SESSIONS_DIR=${TMUX_SESSIONS_DIR:-~/.local/share/tmux/sessions}
TMUXP_SESSIONS_DIR=${TMUXP_CONFIG_DIR:-~/.tmuxp}

_ANSI_ESCAPE=$'\033'
_ANSI_RESET="${_ANSI_ESCAPE}[0m"
_ANSI_CYAN="${_ANSI_ESCAPE}[1;36m"
_ANSI_GREEN="${_ANSI_ESCAPE}[1;32m"
_ANSI_RED="${_ANSI_ESCAPE}[1;31m"

# tmux run-shell doesn't display stderr, so redirect it
exec 2>&1

SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$SRC_DIR/_tmux_utils.sh"

open_session() {
	local SESSION_NAME="$1"
	# trim flags / whitespace
	SESSION_NAME=${SESSION_NAME##+([#* ])}
	SESSION_NAME=${SESSION_NAME%%+([#* ])}
	[[ -n "$SESSION_NAME" ]] || return 0

	#open_session_tmuxp "$SESSION_NAME"
	open_session_script "$SESSION_NAME"
}

open_session_script() {
	local SESSION_NAME="$1"
	if ! tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
		source "$TMUX_SESSIONS_DIR/$SESSION_NAME.tmux"
	fi

	if [[ -z "$TMUX" ]]; then
		tmux attach -t "$SESSION_NAME"
	else
		tmux switch-client -t "$SESSION_NAME"
	fi
}

open_session_tmuxp() {
	local SESSION_NAME="$1"
	local TMUX_SOCKET_NAME=$(echo $TMUX | cut -f1 -d',' | xargs basename)
	if [[ -z "$TMUX_SOCKET_NAME" ]]; then TMUX_SOCKET_NAME=default; fi
	#tmux display-message "$SESSION_NAME"
	if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
		tmux switch-client -t "$SESSION_NAME"
	else
		tmuxp load -y -L "$TMUX_SOCKET_NAME" "$TMUXP_CONFIGDIR/$SESSION_NAME.yaml"
	fi
}

function find_session_files() {
	find "${TMUX_SESSIONS_DIR}" -name '*.tmux' -printf '%f\0' \
			| while read -d $'\0' f; do echo "${f%.tmux}"; done
}

function list_tmux_sessions() {
	local CURRENT_SESSION=$(tmux display-message -p '#{session_name}')
	local LAST_SESSION=$(tmux display-message -p '#{client_last_session}')
	local OPEN_SESSIONS=$(tmux list-sessions -F '#S' | sort)
	local FORMAT=
	# first, output the open sessions with colored text and marker
	echo "$OPEN_SESSIONS" | while read -d $'\n' line; do
		FORMAT=" "
		if [[ "$line" == "$CURRENT_SESSION" ]]; then
			FORMAT="$_ANSI_GREEN*"
		elif [[ "$line" == "$LAST_SESSION" ]]; then
			FORMAT="$_ANSI_CYAN#"
		fi
		echo "${_ANSI_CYAN}$FORMAT ${_ANSI_CYAN}$line${_ANSI_RESET}"
	done
	# next, output all other sessions found in files
	FORMAT=" "
	comm -13 <(echo "$OPEN_SESSIONS") <(find_session_files | sort -u) | \
		sed "s/^/$FORMAT /; s/$/ /"
}

function list_tmux_sessions_tmuxp() {
	find "${TMUXP_SESSIONS_DIR}" -name '*.yaml' -printf '%f\0' \
		| while read -d $'\0' f; do echo "${f%.yaml}"; done
	tmux list-sessions -F '#S'
}

open_session "$(list_tmux_sessions | sort -u | fzf-tmux -- --ansi --reverse )" 

