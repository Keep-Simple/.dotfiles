#!/bin/bash
# ABOUTME: Hook script that runs when a Claude Code session ends
# ABOUTME: Cleans up per-session temp files and sweeps stale ones older than 7 days

# Load common functions
source "$(dirname "$0")/common.sh"

# Setup logging
setup_debug_log "session-end"
log_debug "========== SessionEnd Hook Started =========="

# Read the event data from stdin
read -r EVENT
log_debug "EVENT: $EVENT"

SESSION_ID=$(jq -r '.session_id' <<< "$EVENT")
log_debug "SESSION_ID: $SESSION_ID"

# Remove this session's temp files
if [ -n "$SESSION_ID" ] && [ "$SESSION_ID" != "null" ]; then
    rm -f "/tmp/claude_${SESSION_ID}_pane" \
          "/tmp/claude_${SESSION_ID}_repo" \
          "/tmp/claude_${SESSION_ID}_started" \
          "/tmp/claude_${SESSION_ID}_completed" \
          "/tmp/claude_${SESSION_ID}_waiting"
    log_debug "Removed /tmp/claude_${SESSION_ID}_{pane,repo,started,completed,waiting}"
fi

# Sweep stale files (>7 days) from any prior crashed/killed sessions
find /tmp -maxdepth 1 -name 'claude_*_pane' -mtime +7 -delete 2>/dev/null
find /tmp -maxdepth 1 -name 'claude_*_repo' -mtime +7 -delete 2>/dev/null
find /tmp -maxdepth 1 -name 'claude_*_started' -mtime +7 -delete 2>/dev/null
find /tmp -maxdepth 1 -name 'claude_*_completed' -mtime +7 -delete 2>/dev/null
find /tmp -maxdepth 1 -name 'claude_*_waiting' -mtime +7 -delete 2>/dev/null
log_debug "Swept stale claude_*_{pane,repo,started,completed,waiting} files older than 7 days"

log_debug "========== SessionEnd Hook Finished =========="
