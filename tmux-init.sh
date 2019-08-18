#!/bin/bash
# Script for extra tmux initialization that isn't possible with the tmux
# configuration format alone

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# store the path to the tmux.conf dir (used by other scripts / tmux commands)
tmux set -g "@tmux-path" "$CURRENT_DIR"


# load other shell-based config scripts

# TPM (tmux plugin manager):
TPM_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/tmux/plugins/tpm"
if [[ ! -d "$TPM_DIR" ]]; then
  echo "Installing Tmux Plugin Manager..."
  git clone "https://github.com/tmux-plugins/tpm" "$TPM_DIR"
fi
( source "$TPM_DIR/tpm"; )

# Capture-pane plugin
source "$CURRENT_DIR/capture-pane/capture.tmux.sh"

