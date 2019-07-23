#!/usr/bin/env bash

set -e

export TMUXP_CONFIGDIR=${TMUXP_CONFIG_DIR:-~/.tmuxp}
tmux_open_session() {
	local SESSION_NAME="$1"
	if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
		tmux switch-client -t "$SESSION_NAME"
	else
		tmuxp load -y "$TMUXP_CONFIGDIR/$SESSION_NAME.yaml"
	fi
}
export -f tmux_open_session

{ find "${TMUXP_CONFIGDIR}" -name '*.yaml' -printf '%f\0' \
		| while read -d $'\0' f; do echo "${f%.yaml}"; done; \
	tmux list-sessions -F '#S'; \
} | sort -u \
	| fzf --reverse | xargs bash -c 'tmux_open_session "$1"' -

