#!/bin/bash
set -e

tmux_complete_help() {
	local ARGS=()
	IFS=" " read -a ARGS || return 0
	# tmux display-message "ce ${ARGS[0]}"
	tmux command-prompt -I "${ARGS[0]} " -p "(${ARGS[*]:1}) ::"
}

tmux list-commands | fzf-tmux -- --reverse | tmux_complete_help 2>&1

