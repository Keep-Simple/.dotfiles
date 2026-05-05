#!/usr/bin/env bash
# Status-line indicators:
#   ⏸N — sessions awaiting permission (recon Input), excluding focused pane
#   ✓M — sessions completed since last user prompt (Stop-hook markers)
shopt -s nullglob

focused_pane=$(tmux display-message -p '#{pane_id}' 2>/dev/null)
focused_sid=""
for f in /tmp/claude_*_pane; do
    if [ "$(cat "$f" 2>/dev/null)" = "$focused_pane" ]; then
        focused_sid=$(basename "$f" | sed 's/^claude_//; s/_pane$//')
        break
    fi
done

n_input=$(recon json 2>/dev/null | jq -r --arg fsid "$focused_sid" \
    '[.sessions[]?|select(.status=="Input" and .session_id != $fsid)]|length // 0' 2>/dev/null)
markers=(/tmp/claude_*_completed)
n_done=${#markers[@]}

out=""
[ "${n_input:-0}" -gt 0 ] && out+="#[fg=#fab387]⏸${n_input} #[default]"
[ "${n_done:-0}" -gt 0 ]  && out+="#[fg=#a6e3a1]✓${n_done} #[default]"
printf '%s' "$out"
