#!/bin/sh
# Outputs formatted directory list for sesh fzf picker
# Format: icon category/name\tfull_path (tab-separated, display + path)
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
  printf "%s  %s/%s\t%s\n", icon, parent, name, $0
}'
