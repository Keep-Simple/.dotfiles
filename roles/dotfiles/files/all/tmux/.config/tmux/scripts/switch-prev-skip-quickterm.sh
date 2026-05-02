#!/bin/sh
last=$(tmux display-message -p '#{client_last_session}')
if [ -n "$last" ] && [ "$last" != quickterm ]; then
  tmux switch-client -t "$last"
else
  tmux switch-client -p
  if [ "$(tmux display-message -p '#S')" = quickterm ]; then
    tmux switch-client -p
  fi
fi
