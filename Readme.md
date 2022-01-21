# My Tmux Dotfiles - Personal tmux configuration files

This repository contains my configuration for the tmux multiplexer.

Features:

- using [tmux plugin manager](https://github.com/tmux-plugins/tpm/) and several third-party plugins;
- custom key bindings (prefix is `Ctrl+A`, reachable with one hand);
- Includes several themes (I prefer `onedark`) + true color support;
- Integrates my custom [fzf-based workspace switcher plugin](https://github.com/niflostancu/tmux-workspaces) for session management!
- Other helper scripts (still WIP);

To install, clone this repository anywhere you want and run the `install.sh`
script to create symlinks to `~/.config/tmux`, e.g.:
```bash
mkdir ~/.local/configs
git clone https://github.com/niflostancu/dotfiles-tmux 
cd dotfiles-tmux
./install.sh

# ... or simply clone it to ~/.config/tmux, if you prefer that:
git clone https://github.com/niflostancu/dotfiles-tmux ~/.config/tmux

# ... then start tmux!
tmux
```

