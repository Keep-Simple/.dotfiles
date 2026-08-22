#!/bin/bash
# ABOUTME: Hook script that runs when Claude Code sends a notification event
# ABOUTME: Displays a macOS notification with the notification message

# Load common functions
source "$(dirname "$0")/common.sh"

# Setup logging
setup_debug_log "notification"
log_debug "========== Notification Hook Started =========="

# Read the event data from stdin
read -r EVENT
log_debug "EVENT: $EVENT"

# Extract session ID, message, and notification type from event
SESSION_ID=$(jq -r '.session_id' <<< "$EVENT")
log_debug "SESSION_ID: $SESSION_ID"

MESSAGE=$(jq -r '.message' <<< "$EVENT")
log_debug "MESSAGE: $MESSAGE"

NOTIFICATION_TYPE=$(jq -r '.notification_type // "unknown"' <<< "$EVENT")
log_debug "NOTIFICATION_TYPE: $NOTIFICATION_TYPE"

# idle_input/idle_prompt fires periodically (~3min) any time Claude is
# sitting at a normal prompt with nothing to do — NOT a signal that it's
# blocked on the user. That signal is permission_prompt (or other non-idle
# types), which already falls through below unconditionally. Confirmed via
# live logs: idle_prompt recurred for a session with zero permission_prompt
# events (genuinely idle), while a separate session's real permission_prompt
# fired independently and correctly. Ignoring idle here is correct; do not
# reinstate a _completed-marker heuristic — it produced ⏸ markers that never
# clear for ordinary idle sessions.
if [ "$NOTIFICATION_TYPE" = "idle_input" ] || [ "$NOTIFICATION_TYPE" = "idle_prompt" ]; then
    log_debug "Ignoring idle_input/idle_prompt notification"
    log_debug "========== Notification Hook Finished (ignored) =========="
    exit 0
fi

# Everything else (permission_prompt, etc.) means Claude is blocked on the
# user. Write the ⏸ marker straight off this native event — ground truth,
# no dependency on an external tool's own session-state guess. Cleared on
# the next tool activity/Stop/prompt-submit for this session.
: > "/tmp/claude_${SESSION_ID}_waiting"
log_debug "Wrote waiting marker"

# Get the repo name from temp file
REPO_NAME=$(cat "/tmp/claude_${SESSION_ID}_repo" 2>/dev/null)
log_debug "REPO_NAME: $REPO_NAME"

# Get the Claude pane ID from temp file
CLAUDE_PANE=$(cat "/tmp/claude_${SESSION_ID}_pane" 2>/dev/null)
log_debug "CLAUDE_PANE: $CLAUDE_PANE"

# Build title with window label (e.g. ".dotfiles · 1:nvim")
WINDOW_LABEL=$(get_window_label "$CLAUDE_PANE")
TITLE="$REPO_NAME${WINDOW_LABEL:+ · $WINDOW_LABEL}"
log_debug "TITLE: $TITLE"

# Permission prompt → ⏸ counter likely changed; push status refresh.
tmux refresh-client -S 2>/dev/null

# Check if notification should be sent and send it
if should_send_notification; then
    send_notification "$REPO_NAME" "$TITLE" "$MESSAGE" "" "Basso"
fi
log_debug "========== Notification Hook Finished =========="
