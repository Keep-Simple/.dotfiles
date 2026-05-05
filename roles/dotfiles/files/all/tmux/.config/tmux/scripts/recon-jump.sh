#!/usr/bin/env bash
# Jump to next session needing user attention.
# Priority: recon Input (awaiting permission) → most-recent Stop-hook completion.
set -u

has_input=$(recon json 2>/dev/null | jq -r '[.sessions[]?|select(.status=="Input")]|length // 0' 2>/dev/null)
if [ "${has_input:-0}" -gt 0 ]; then
    exec recon next
fi

shopt -s nullglob
markers=(/tmp/claude_*_completed)
newest=$(printf '%s\n' "${markers[@]}" | xargs -I{} stat -f '%m {}' {} 2>/dev/null | sort -rn | head -1 | cut -d' ' -f2-)

if [ -z "$newest" ]; then
    tmux display-message "No sessions waiting"
    exit 0
fi

session_id=$(basename "$newest" | sed 's/^claude_//; s/_completed$//')
pane=$(cat "/tmp/claude_${session_id}_pane" 2>/dev/null)
if [ -z "$pane" ]; then
    tmux display-message "Pane unknown for $session_id"
    rm -f "$newest"
    exit 0
fi

target=$(tmux display-message -p -t "$pane" '#{session_name}:#{window_index}.#{pane_index}' 2>/dev/null)
if [ -z "$target" ]; then
    tmux display-message "Pane $pane gone"
    rm -f "$newest"
    exit 0
fi

# Single switch-client -t SESSION:WIN.PANE form switches session, window, and pane atomically.
if tmux switch-client -t "$target" 2>/dev/null; then
    rm -f "$newest"
else
    tmux display-message "switch-client failed for $target"
fi
