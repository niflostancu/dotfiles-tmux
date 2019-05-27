#!/usr/bin/env bash

set -e

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

. "${CURRENT_DIR}/scripts/utils.sh"

mkdir -p "$CAPTURE_PATH" || {
	echo "Unable to create capture path: $CAPTURE_PATH" >&2
	exit 1
}

tmux set-environment -g "TMUX_PANE_RESTORE_CMD" "$CURRENT_DIR/scripts/restore-pane.sh"
# tmux set-option -g "default-command" "$CURRENT_DIR/scripts/restore-pane.sh; exec $SHELL"

# listen on pane change events and save the old pane's contents to file
TMUX_SAVE_CMD="'$CURRENT_DIR/scripts/save-pane.sh'"
TMUX_SAVE_ARGS="#{session_name} #{window_index} #{pane_index}"
# 
# get last pane / window / session
tmux set-hook -g window-pane-changed "run-shell -b -t '{last}' '$TMUX_SAVE_CMD $TMUX_SAVE_ARGS'"
tmux set-hook -g session-window-changed "run-shell -b -t '{last}.' '$TMUX_SAVE_CMD $TMUX_SAVE_ARGS'"
tmux set-hook -g client-session-changed "run-shell -b '$TMUX_SAVE_CMD \"!\"'"
tmux set-hook -g client-detached "run-shell -b '$TMUX_SAVE_CMD $TMUX_SAVE_ARGS'"

