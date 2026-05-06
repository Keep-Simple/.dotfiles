#!/usr/bin/env bash
# Compose Claude reply in zen-mode nvim, paste into target pane via bracketed paste.
# $1 = target tmux pane id (e.g. %37)
set -u
target="${1:?target pane id required}"
f=$(mktemp "${TMPDIR:-/tmp}/claude-reply.XXXXXX.md")
trap 'rm -f "$f"' EXIT
nvim "$f"
[ -s "$f" ] || exit 0
buffer="claude-reply-${target#%}"
printf '%s' "$(cat "$f")" | tmux load-buffer -b "$buffer" -
# Wrap paste in bracketed-paste markers manually via send-keys so Claude
# Code's vim-mode input inserts bytes verbatim regardless of mode. We do
# this manually instead of relying on `paste-buffer -p` because tmux only
# emits the markers when the pane's screen has MODE_BRACKETPASTE set
# (toggled by app via DECSET/DECRST 2004) — which Claude doesn't always
# leave on, leading to silent fallthrough where vim normal-mode keys like
# h/j/k/w/a/o eat the first chars of the payload.
tmux send-keys -t "$target" Escape "[200~"
tmux paste-buffer -b "$buffer" -d -r -t "$target"
tmux send-keys -t "$target" Escape "[201~"
