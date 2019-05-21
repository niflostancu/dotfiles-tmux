#!/usr/bin/env bash

set -e

TMUX_SESSION_NAME="$1"
TMUX_WINDOW_ID="$2"
TMUX_PANE_ID="$3"
TMUX_CAPTURE_DEBUG=

if [[ "$TMUX_SESSION_NAME" == '!' ]]; then
	TMUX_SESSION_NAME=$(tmux display -p "#{client_last_session}")
	TMUX_WINDOW_ID=$(tmux display -p -t "$TMUX_SESSION_NAME:" "#{window_index}")
	TMUX_PANE_ID=$(tmux display -p -t "$TMUX_SESSION_NAME:" "#{pane_index}")
fi

[[ -z "$TMUX_SESSION_NAME" ]] && exit 0
[[ -z "$TMUX_WINDOW_ID" ]] && exit 0
[[ -z "$TMUX_PANE_ID" ]] && exit 0

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

. "${CURRENT_DIR}/utils.sh"

TARGET_PANE="$TMUX_SESSION_NAME:$TMUX_WINDOW_ID.$TMUX_PANE_ID"

CAPTURE_STRIP_ANSI=$(get_tmux_option "@capture-pane-strip-ansi" "")
CAPTURE_ENABLED_GLOBAL=$(get_tmux_option "@capture-pane-enable" "0")
CAPTURE_ENABLED_SESSION=$(tmux show-option -t "$TMUX_SESSION_NAME" -qv "@capture-pane-enable")
if [[ -z "$CAPTURE_ENABLED_SESSION" ]]; then
	CAPTURE_ENABLED_SESSION=${CAPTURE_ENABLED_GLOBAL}
fi
[[ "$CAPTURE_ENABLED_SESSION" == "1" ]] || exit 0

#tmux display "$TARGET_PANE"

function strip_ansi() {
	sed "s,\x1B\[[0-9;]*[a-zA-Z],,g"
}

TARGET_FILE="$CAPTURE_PATH/pane-${TARGET_PANE}"
CONTENTS=$(tmux capture-pane -t "$TARGET_PANE" -epJ -S -)
OLD_CONTENTS_FOR_DIFF=$(cat "$TARGET_FILE" 2>/dev/null | strip_ansi || true)

DIFF_COUNT=$(diff -y --suppress-common-lines <(echo -n "$CONTENTS" | strip_ansi) <(echo -n "$OLD_CONTENTS_FOR_DIFF") \
	| paste | wc -l)

# tmux display "$TARGET_PANE COUNT: $DIFF_COUNT"

if [[ -n "$TMUX_CAPTURE_DEBUG" ]]; then
	diff -y --suppress-common-lines <(echo -n "$CONTENTS" | strip_ansi) <(cat "$TARGET_FILE" | strip_ansi) \
		> "$TARGET_FILE.d.txt" || true
fi

if [[ "$DIFF_COUNT" -gt 5 ]]; then
	# guard against storing empty prompts (when a pane is left unused)
	if [[ -n "$CAPTURE_STRIP_ANSI" ]]; then
		echo "$CONTENTS" | strip_ansi > "$TARGET_FILE"
	else
		echo "$CONTENTS" > "$TARGET_FILE"
	fi
fi

