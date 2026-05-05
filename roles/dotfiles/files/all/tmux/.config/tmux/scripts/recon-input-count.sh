#!/usr/bin/env bash
# Status-line indicators:
#   ⏸N — sessions awaiting permission (recon Input). Persist even when focused —
#         only an approve/deny resolves the prompt, focus alone doesn't.
#   ✓M — sessions completed since last user prompt (Stop-hook markers).
#         Cleared by pane-focus-in hook (focus = ack).
shopt -s nullglob

n_input=$(recon json 2>/dev/null | jq -r '[.sessions[]?|select(.status=="Input")]|length // 0' 2>/dev/null)
markers=(/tmp/claude_*_completed)
n_done=${#markers[@]}

out=""
[ "${n_input:-0}" -gt 0 ] && out+="#[fg=#fab387]⏸${n_input} #[default]"
[ "${n_done:-0}" -gt 0 ]  && out+="#[fg=#a6e3a1]✓${n_done} #[default]"
printf '%s' "$out"
