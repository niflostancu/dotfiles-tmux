#!/bin/bash
# Script to start a new companion session named '#{session_name}-aux'
# Inherits the parent session's working directory and environment.

SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
set -e

SESSION_NAME=$(tmux display-message -p '#{session_name}')
SESSION_CWD=$(tmux display-message -p '#{session_path}')

TMUX_CMD=(tmux new -A -s "$SESSION_NAME-aux" -c "$SESSION_CWD")

exec "$SCRIPTS_DIR/new-term.sh" "${TMUX_CMD[@]}"

