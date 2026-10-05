#!/usr/bin/env bash
# Clear one claude marker for one tmux pane. $2 picks which:
#   completed (default) — the ✓ status count, cleared on pane-focus-in.
#   done                — the M-i jump list, cleared on pane-focus-out. Leaving
#                         a pane whose turn had already ended means you read it;
#                         clearing on focus-IN instead would drop a session the
#                         moment you watched it finish, which is the bug cfc83c8
#                         fixed.
# Reverse-lookup session_id via /tmp/claude_<sid>_pane → matching pane id.
pane="$1"
marker="${2:-completed}"
[ -z "$pane" ] && exit 0

shopt -s nullglob
for f in /tmp/claude_*_pane; do
    [ "$(cat "$f" 2>/dev/null)" = "$pane" ] || continue
    sid=$(basename "$f" | sed 's/^claude_//; s/_pane$//')
    rm -f "/tmp/claude_${sid}_${marker}"
done
# Always refresh — focused-pane filter in counter also affects ⏸ output.
tmux refresh-client -S 2>/dev/null
