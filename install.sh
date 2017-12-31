#!/bin/bash
# Tmux dotfiles installation script

SRCDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TMUX_CONF_DIR="${TMUX_CONF_DIR:-$HOME/.config/tmux}"

if [[ -f "$TMUX_CONF_DIR/tmux.conf" ]]; then
  echo "A tmux configuration already exists!"
  ls -l "$TMUX_CONF_DIR/"
  read -p "Are you sure you want to delete it? " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
  fi
fi

echo "Installing tmux config to '$TMUX_CONF_DIR'"

rm -f "$TMUX_CONF_DIR"
ln -s "$SRCDIR" "$TMUX_CONF_DIR"

echo "Done!"

