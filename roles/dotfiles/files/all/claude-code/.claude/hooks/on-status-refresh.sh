#!/bin/bash
# Hook for PreToolUse/PostToolUse: any tool activity in a session means a
# prior permission prompt (if any) got resolved, so clear its ⏸ marker and
# push an immediate tmux status redraw instead of waiting for status-interval.
read -r EVENT
SESSION_ID=$(command -v jq >/dev/null && jq -r '.session_id // empty' <<< "$EVENT" 2>/dev/null)
[ -n "$SESSION_ID" ] && rm -f "/tmp/claude_${SESSION_ID}_waiting"
tmux refresh-client -S 2>/dev/null
