# Nord tmux theme
# Original Repository: https://github.com/arcticicestudio/nord-tmux
# 
# Copyright (c) 2017-present Arctic Ice Studio <development@arcticicestudio.com>
# Copyright (c) 2017-present Sven Greb <code@svengreb.de>
# License:    MIT

#+--------+
#+ Status +
#+--------+
#+--- Layout ---+
set -g status-justify left

#+--- Colors ---+
set -g status-style "fg=white,bg=black"

#+-------+
#+ Panes +
#+-------+
set -g pane-border-style "fg=cyan,bg=black"
set -g pane-active-border-style "fg=green,bg=black"
set -g display-panes-colour black
set -g display-panes-active-colour brightblack

#+------------+
#+ Clock Mode +
#+------------+
setw -g clock-mode-colour cyan

#+----------+
#+ Messages +
#+---------+
set -g message-style "fg=cyan,bg=brightblack"
set -g message-command-style "fg=cyan,bg=brightblack"

#+--- tmux-prefix-highlight ---+
set -g @prefix_highlight_fg black
set -g @prefix_highlight_bg brightcyan

set -g @prefix_highlight_output_prefix "#[fg=brightcyan]#[bg=black]#[nobold]#[noitalics]#[nounderscore]#[bg=brightcyan]#[fg=black]"
set -g @prefix_highlight_output_suffix ""
set -g @prefix_highlight_copy_mode_attr "fg=brightcyan,bg=black,bold"

#+--------+
#+ Status +
#+--------+
#+--- Bars ---+
#set -g status-left "#[fg=black,bg=blue,bold] #S#[fg=blue,bg=black,nobold,noitalics,nounderscore]"
set -g status-left-length 25
set -g status-left "#[fg=black,bg=blue] #S #[fg=blue,bg=black,nobold,noitalics,nounderscore]"
set -g status-right "#{prefix_highlight}#[fg=brightblack,bg=black,nobold,noitalics,nounderscore]#[fg=white,bg=brightblack] %Y-%m-%d #[fg=white,bg=brightblack,nobold,noitalics,nounderscore]#[fg=white,bg=brightblack] %H:%M #[fg=cyan,bg=brightblack,nobold,noitalics,nounderscore]#[fg=black,bg=cyan,bold] #H "

#+--- Windows ---+
set -g window-status-format "#[fg=black,bg=brightblack,nobold,noitalics,nounderscore]#[fg=white,bg=brightblack]#{?window_activity_flag,#[fg=cyan],}#{?window_bell_flag,#[fg=green],} #I #W #[fg=brightblack,bg=black,nobold,noitalics,nounderscore]"
set -g window-status-current-format "#[fg=black,bg=cyan,nobold,noitalics,nounderscore]#[fg=black,bg=cyan] #I #W #[fg=cyan,bg=black,nobold,noitalics,nounderscore]"
set -g window-status-separator ""
set -g window-status-style ""
set -g window-status-activity-style ""

set -g visual-activity off

