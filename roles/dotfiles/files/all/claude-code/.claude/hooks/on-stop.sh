#!/bin/bash
# ABOUTME: Hook script that runs when Claude Code stops/finishes a task
# ABOUTME: Sends a notification if kitty terminal is not frontmost or Claude pane is not current

# Load common functions
source "$(dirname "$0")/common.sh"

# Setup logging
setup_debug_log "stop"
log_debug "========== Stop Hook Started =========="

# Read the event data from stdin
read -r EVENT
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

# Build title with window label (e.g. ".dotfiles · 1:nvim")
WINDOW_LABEL=$(get_window_label "$CLAUDE_PANE")
TITLE="$REPO_NAME${WINDOW_LABEL:+ · $WINDOW_LABEL}"
log_debug "TITLE: $TITLE"

# Compute task duration from saved prompt-submit timestamp
SUBTITLE="✅ Claude task finished"
STARTED=$(cat "/tmp/claude_${SESSION_ID}_started" 2>/dev/null)
if [ -n "$STARTED" ]; then
    DURATION=$(format_duration $(( $(date +%s) - STARTED )))
    SUBTITLE="✅ done · $DURATION"
    log_debug "DURATION: $DURATION"
fi

# Check if notification should be sent and send it
if should_send_notification "$CLAUDE_PANE"; then
    send_notification "$SESSION_ID" "$TITLE" "$SUBTITLE" "" "Glass"
fi

log_debug "========== Stop Hook Finished =========="
