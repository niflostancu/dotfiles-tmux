#!/bin/bash
# Kills the current session and selects the previous one

tmux switch-client -l
tmux kill-session -t "$(tmux display-message -p "#S")"

