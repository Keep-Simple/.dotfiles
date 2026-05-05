#!/bin/bash
# ABOUTME: Hook script that runs when user submits a prompt to Claude Code
# ABOUTME: Captures current tmux pane ID and repository name for later notification use

# Load common functions
source "$(dirname "$0")/common.sh"

# Setup logging
setup_debug_log "user-prompt-submit"
log_debug "========== UserPromptSubmit Hook Started =========="

# Read the event data from stdin
read -r EVENT
log_debug "EVENT: $EVENT"

# Extract session ID from event
SESSION_ID=$(jq -r '.session_id' <<< "$EVENT")
log_debug "SESSION_ID: $SESSION_ID"

# Get current tmux pane ID and save to temp file
PANE_ID=$(tmux display-message -p '#{pane_id}')
echo "$PANE_ID" > "/tmp/claude_${SESSION_ID}_pane"
log_debug "Saved PANE_ID to /tmp/claude_${SESSION_ID}_pane: $PANE_ID"

# Get repository name (or current directory name if not in git repo)
REPO_PATH=$(git rev-parse --show-toplevel 2>/dev/null || echo "$PWD")
REPO_NAME=$(basename "$REPO_PATH")
echo "$REPO_NAME" > "/tmp/claude_${SESSION_ID}_repo"
log_debug "Saved REPO_NAME to /tmp/claude_${SESSION_ID}_repo: $REPO_NAME (from $REPO_PATH)"

# Record prompt-submit timestamp for Stop-hook duration calc
date +%s > "/tmp/claude_${SESSION_ID}_started"
log_debug "Saved start timestamp to /tmp/claude_${SESSION_ID}_started"

# Clear completion marker — user is engaging again, prior completion was seen
rm -f "/tmp/claude_${SESSION_ID}_completed"

log_debug "========== UserPromptSubmit Hook Finished =========="
