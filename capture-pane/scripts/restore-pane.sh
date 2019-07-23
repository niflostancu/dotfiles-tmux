#!/usr/bin/env bash

set -e

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

. "${CURRENT_DIR}/utils.sh"

[[ -n "$TMUX_PANE" ]] || exit 0

TARGET_PANE=$(tmux display -t "$TMUX_PANE" -p "#{session_name}:#{window_index}.#{pane_index}")
TARGET_FILE="$CAPTURE_PATH/pane-${TARGET_PANE}"

if [[ -f "$TARGET_FILE" ]]; then
	cat "$TARGET_FILE"
fi

