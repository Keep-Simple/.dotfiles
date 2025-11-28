#!/bin/bash
# ABOUTME: Shared functions for Claude Code notification hooks
# ABOUTME: Provides common logging and notification logic used across multiple hooks

# Setup debug logging
setup_debug_log() {
    local log_name="$1"
    DEBUG_LOG="/tmp/claude-hook-logs/hook-${log_name}.log"
    mkdir -p "$(dirname "$DEBUG_LOG")"
}

log_debug() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$DEBUG_LOG"
}

# Check if notification should be sent based on current context
# Returns 0 if notification should be sent, 1 otherwise
should_send_notification() {
    local claude_pane="$1"

    # Get the focused/active tmux session (the one user is currently viewing)
    # This gets the most recently active client's session
    local focused_session=$(tmux list-clients -F '#{client_activity} #{client_session}' 2>/dev/null | sort -rn | head -1 | cut -d' ' -f2)
    log_debug "FOCUSED_SESSION: $focused_session"

    # Get Claude's session from the pane
    local claude_session=$(tmux display-message -p -t "$claude_pane" '#{session_name}' 2>/dev/null)
    log_debug "CLAUDE_SESSION: $claude_session"

    # Get frontmost application
    local front_app=$(osascript -e 'tell application "System Events" to get name of first process whose frontmost is true')
    log_debug "FRONT_APP: $front_app"

    # Check if notification should be sent
    # Send notification if: not in kitty OR in different session
    if { [ "$front_app" != "kitty" ] || [ "$claude_session" != "$focused_session" ]; } && [ -n "$claude_pane" ]; then
        log_debug "Conditions met for notification:"
        log_debug "  - FRONT_APP != kitty: $([ "$front_app" != "kitty" ] && echo "true" || echo "false")"
        log_debug "  - CLAUDE_SESSION != FOCUSED_SESSION: $([ "$claude_session" != "$focused_session" ] && echo "true" || echo "false")"
        log_debug "  - CLAUDE_PANE is set: $([ -n "$claude_pane" ] && echo "true" || echo "false")"
        return 0
    else
        log_debug "Notification NOT sent. Reasons:"
        log_debug "  - FRONT_APP == kitty: $([ "$front_app" = "kitty" ] && echo "true" || echo "false")"
        log_debug "  - CLAUDE_SESSION == FOCUSED_SESSION: $([ "$claude_session" = "$focused_session" ] && echo "true" || echo "false")"
        log_debug "  - CLAUDE_PANE is empty: $([ -z "$claude_pane" ] && echo "true" || echo "false")"
        return 1
    fi
}

# Send a terminal notification
send_notification() {
    local group="$1"
    local title="$2"
    local subtitle="$3"
    local message="$4"
    local sound="$5"

    terminal-notifier \
        -group "$group" \
        -contentImage "$HOME/.claude/claude.webp" \
        -title "$title" \
        -subtitle "$subtitle" \
        -message "$message" \
        -sound "$sound"

    log_debug "Notification sent successfully"
}
