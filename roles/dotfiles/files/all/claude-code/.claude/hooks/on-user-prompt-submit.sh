#!/bin/bash
# ABOUTME: Hook script that runs when user submits a prompt to Claude Code
# ABOUTME: Captures current tmux pane ID and repository name for later notification use

# Enable debugging
DEBUG_LOG="/tmp/claude-hook-logs/hook-user-prompt-submit.log"
mkdir -p "$(dirname "$DEBUG_LOG")"

log_debug() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$DEBUG_LOG"
}

log_debug "========== UserPromptSubmit Hook Started =========="

# Read the event data from stdin
read EVENT
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

log_debug "========== UserPromptSubmit Hook Finished =========="
