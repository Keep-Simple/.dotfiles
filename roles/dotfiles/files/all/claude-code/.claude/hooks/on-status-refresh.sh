#!/bin/bash
# Hook for PreToolUse/PostToolUse/PermissionDenied: a prior permission
# prompt got resolved either way — approved (tool runs, Pre/PostToolUse
# fire) or denied (PermissionDenied fires, including a human cancelling the
# interactive prompt — "denials without a classifier verdict" per Claude
# Code docs, which is exactly what defaultMode:auto produces here). Clear
# the ⏸ marker and push an immediate tmux status redraw either way, instead
# of waiting for Stop.
read -r EVENT
SESSION_ID=$(command -v jq >/dev/null && jq -r '.session_id // empty' <<< "$EVENT" 2>/dev/null)
[ -n "$SESSION_ID" ] && rm -f "/tmp/claude_${SESSION_ID}_waiting"
tmux refresh-client -S 2>/dev/null
