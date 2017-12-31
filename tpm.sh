#!/bin/bash
# Helper script to install and run Tmux Plugin Manager

TPM_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/tmux/plugins/tpm"

if [[ ! -d "$TPM_DIR" ]]; then
  echo "Installing Tmux Plugin Manager..."
  git clone "https://github.com/tmux-plugins/tpm" "$TPM_DIR"
fi

exec "$TPM_DIR/tpm"

