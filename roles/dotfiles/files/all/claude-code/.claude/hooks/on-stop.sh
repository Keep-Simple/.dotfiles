#!/bin/bash
# ABOUTME: Hook script that runs when Claude Code stops/finishes a task
# ABOUTME: Sends a notification if terminal app ($TERMINAL_APP) is not frontmost

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

# Mark session as awaiting user attention (cleared on next UserPromptSubmit /
# SessionEnd / pane-focus-in). Write unconditionally — the status script
# self-heals at render time by dropping this marker if the pane turns out to
# already be visible, which is more reliable than guessing visibility here
# (client_activity/client_focused are flaky with 2+ attached tmux clients).
: > "/tmp/claude_${SESSION_ID}_completed"
# Turn ended — any pending ⏸ (e.g. permission denied, no PostToolUse fired) is moot now.
rm -f "/tmp/claude_${SESSION_ID}_waiting"
tmux refresh-client -S 2>/dev/null  # push status update without waiting for status-interval
log_debug "Wrote completion marker"

# Check if notification should be sent and send it
# No group: each finished turn should alert on its own, not replace the
# previous session's still-unread banner (see common.sh send_notification).
if should_send_notification; then
    send_notification "" "$TITLE" "$SUBTITLE" "" "Glass"
fi

log_debug "========== Stop Hook Finished =========="
