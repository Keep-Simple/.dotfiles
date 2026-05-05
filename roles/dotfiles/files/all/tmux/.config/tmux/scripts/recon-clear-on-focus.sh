#!/usr/bin/env bash
# Clear ✓ completion marker for the just-focused tmux pane.
# Reverse-lookup session_id via /tmp/claude_<sid>_pane → matching pane id.
focused_pane="$1"
[ -z "$focused_pane" ] && exit 0

shopt -s nullglob
cleared=0
for f in /tmp/claude_*_pane; do
    [ "$(cat "$f" 2>/dev/null)" = "$focused_pane" ] || continue
    sid=$(basename "$f" | sed 's/^claude_//; s/_pane$//')
    [ -f "/tmp/claude_${sid}_completed" ] && cleared=1
    rm -f "/tmp/claude_${sid}_completed"
done
# Always refresh — focused-pane filter in counter also affects ⏸ output.
tmux refresh-client -S 2>/dev/null
