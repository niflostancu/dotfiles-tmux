#!/bin/bash
# Script to start a new editor in separate terminal window

SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
set -e

# use the current pane's working directory
SET_CWD="$(tmux display-message -p '#{pane_current_path}')"
[[ -n "$SET_CWD" ]] || \
	SET_CWD="$(tmux display-message -p '#{session_path}')"
[[ -z "$SET_CWD" ]] || cd "$SET_CWD"

TERM_EDITOR=${TERM_EDITOR:-${EDITOR:-vim}}
case "$TERM_EDITOR" in
	vim|nvim|lvim)
		USE_TERM_EMULATOR=1 ;;
esac

CMD=()
if [[ -n "$USE_TERM_EMULATOR" ]]; then
	CMD=("$SCRIPTS_DIR/new-term.sh")
fi

CMD+=($TERM_EDITOR "$@")

exec "${CMD[@]}"

