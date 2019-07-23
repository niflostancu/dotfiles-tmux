#!/bin/bash
# Tmux integration plugin (tested with bash / zsh)

# Auto-start a TMUX session
#TMUX_AUTOSTART=  # 1 to enable
TMUX_AUTOSTART_SESSION=${TMUX_AUTOSTART_SESSION:-tmp}
#TMUX_AUTOSTART_SSH=  # enable autostart for SSH TTYs
#TMUX_AUTOSTART_CONSOLE=  # enable autostart for console (alt+Fn) TTYs

if [[ "$TMUX_AUTOSTART" == "1" ]]; then
  _SHELL_TMUX_AUTOSTART=1
  if [[ "$TMUX_AUTOSTART_CONSOLE" != "1" && "$(tty)" == "/dev/tty"* ]]; then
    _SHELL_TMUX_AUTOSTART=0
  fi
  if [[ "$TMUX_AUTOSTART_SSH" != "1" && ( "$SSH_CLIENT" || -n "$SSH_TTY" ) ]]; then
    _SHELL_TMUX_AUTOSTART=0
  fi
  # if checks passed, autostart tmux
  if [[ $_SHELL_TMUX_AUTOSTART == "1" && -z "$TMUX" ]]; then
    if tmux has-session -t "$TMUX_AUTOSTART_SESSION" 2>/dev/null; then
      exec tmux -2 attach-session -t "$TMUX_AUTOSTART_SESSION"
    else
      exec tmux -2 new-session -s "$TMUX_AUTOSTART_SESSION"
    fi
  fi
fi

# Restore tmux pane contents (this variable is automatically set from within the
# tmux when the capture-pane plugin is loaded)
if [[ -n "$TMUX_PANE_RESTORE_CMD" ]]; then
  "$TMUX_PANE_RESTORE_CMD"
  export TMUX_PANE_RESTORE_CMD=
fi

