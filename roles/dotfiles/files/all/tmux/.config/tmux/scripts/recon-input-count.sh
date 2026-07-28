#!/usr/bin/env bash
# Status-line indicators:
#   ⏸N — sessions awaiting permission (Notification-hook markers, written on
#         permission_prompt — native Claude Code event, not a poll/guess).
#         Persist even when focused — only an approve/deny resolves the
#         prompt, focus alone doesn't.
#   ✓M — sessions completed since last user prompt (Stop-hook markers).
#         Self-heals here: any marker whose pane is visible right now gets
#         dropped before counting, so a missed/late pane-focus-in event can't
#         leave it stuck — the next redraw (any tool call anywhere, or the
#         60s fallback tick) clears it instead of waiting on that one event.
shopt -s nullglob
source "$HOME/.claude/hooks/common.sh"

waiting=(/tmp/claude_*_waiting)
n_input=${#waiting[@]}

n_done=0
for f in /tmp/claude_*_completed; do
    sid=$(basename "$f")
    sid=${sid#claude_}
    sid=${sid%_completed}
    pane=$(cat "/tmp/claude_${sid}_pane" 2>/dev/null)
    if [ -n "$pane" ] && is_pane_visible "$pane"; then
        rm -f "$f"
        continue
    fi
    n_done=$((n_done + 1))
done

out=""
[ "${n_input:-0}" -gt 0 ] && out+="#[fg=#fab387]⏸${n_input} #[default]"
[ "${n_done:-0}" -gt 0 ]  && out+="#[fg=#a6e3a1]✓${n_done} #[default]"
printf '%s' "$out"
