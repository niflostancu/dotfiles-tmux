#!/usr/bin/env bash

# helper functions
get_tmux_option() {
	local option="$1"
	local default_value="$2"
	local option_value=$(tmux show-option -gqv "$option")
	if [ -z "$option_value" ]; then
		echo "$default_value"
	else
		echo "$option_value"
	fi
}

CAPTURE_PATH=$(get_tmux_option "@capture-pane-path" "$HOME/.local/share/tmux/capture-pane")

