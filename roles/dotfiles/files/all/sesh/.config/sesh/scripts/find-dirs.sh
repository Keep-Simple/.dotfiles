#!/bin/sh
# Outputs formatted directory list for sesh fzf picker
# Format: icon name\tfull_path (tab-separated, display + path)
# Name only (no parent prefix) so fzf matches by project name, not category.
printf '⚙️  dotfiles\t%s/.dotfiles\n' "$HOME"
fd -d 1 -t d . \
    "$HOME/Documents/commercial" \
    "$HOME/Documents/personal/labs" \
    "$HOME/Documents/personal/projects" \
    | sed 's:/$::' \
    | awk -F/ '{
  name=$NF
  parent=$(NF-1)
  if (parent=="commercial") icon="🏢"
  else if (parent=="labs") icon="🧪"
  else if (parent=="projects") icon="🔨"
  else icon="📂"
  printf "%s  %s\t%s\n", icon, name, $0
}'
