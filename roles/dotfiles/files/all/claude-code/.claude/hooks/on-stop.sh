#!/bin/bash
# ABOUTME: Hook script that runs when Claude Code stops/finishes a task
# ABOUTME: Sends a notification if kitty terminal is not frontmost or Claude pane is not current

# Load common functions
source "$(dirname "$0")/common.sh"

# Setup logging
setup_debug_log "stop"
log_debug "========== Stop Hook Started =========="

# Read the event data from stdin
read EVENT
log_debug "EVENT: $EVENT"

# Extract session ID from event
SESSION_ID=$(jq -r '.session_id' <<< "$EVENT")
log_debug "SESSION_ID: $SESSION_ID"

# Get the Claude pane ID from temp file
CLAUDE_PANE=$(cat "/tmp/claude_${SESSION_ID}_pane" 2>/dev/null)
log_debug "CLAUDE_PANE: $CLAUDE_PANE"

# Get the repo name from temp file
REPO_NAME=$(cat "/tmp/claude_${SESSION_ID}_repo" 2>/dev/null)
log_debug "REPO_NAME: $REPO_NAME"

# Check if notification should be sent and send it
if should_send_notification "$CLAUDE_PANE"; then
    send_notification "$SESSION_ID" "$REPO_NAME" "✅ Claude task finished" "" "Glass"
fi

log_debug "========== Stop Hook Finished =========="
