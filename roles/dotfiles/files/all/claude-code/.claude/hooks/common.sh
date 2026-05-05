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

# Resolve the most-recently-active tmux client's view of (active_pane, focused_session).
# Handles multi-client setups; falls back to local query if no clients attached.
resolve_focused_view() {
    local clients focused_client
    clients=$(tmux list-clients -F '#{client_activity} #{client_name}' 2>/dev/null)
    if [ -n "$clients" ]; then
        focused_client=$(echo "$clients" | sort -rn | head -1 | cut -d' ' -f2-)
    fi

    if [ -n "$focused_client" ]; then
        ACTIVE_PANE=$(tmux display-message -p -t "$focused_client" '#{pane_id}' 2>/dev/null)
        FOCUSED_SESSION=$(tmux display-message -p -t "$focused_client" '#{session_name}' 2>/dev/null)
    else
        ACTIVE_PANE=$(tmux display-message -p '#{pane_id}' 2>/dev/null)
        FOCUSED_SESSION=$(tmux display-message -p '#{session_name}' 2>/dev/null)
    fi
}

# Check if notification should be sent based on current context
# Returns 0 if notification should be sent, 1 otherwise
should_send_notification() {
    local claude_pane="$1"

    if [ -z "$claude_pane" ]; then
        log_debug "CLAUDE_PANE empty - skipping notification"
        return 1
    fi

    resolve_focused_view
    log_debug "ACTIVE_PANE: $ACTIVE_PANE"
    log_debug "FOCUSED_SESSION: $FOCUSED_SESSION"

    # Get Claude's session from the saved pane (empty string if pane no longer exists)
    local claude_session
    claude_session=$(tmux display-message -p -t "$claude_pane" '#{session_name}' 2>/dev/null)
    log_debug "CLAUDE_PANE: $claude_pane"
    log_debug "CLAUDE_SESSION: $claude_session"

    # Pane gone -> user can't see Claude there anyway, notify
    if [ -z "$claude_session" ]; then
        log_debug "Claude pane no longer exists - sending notification"
        return 0
    fi

    # Get frontmost application
    local front_app
    front_app=$(osascript -e 'tell application "System Events" to get name of first process whose frontmost is true' 2>/dev/null)
    log_debug "FRONT_APP: $front_app"

    # Send notification if: not in kitty OR different session OR different pane
    if [ "$front_app" != "kitty" ] || [ "$claude_session" != "$FOCUSED_SESSION" ] || [ "$claude_pane" != "$ACTIVE_PANE" ]; then
        log_debug "Conditions met for notification:"
        log_debug "  - FRONT_APP != kitty: $([ "$front_app" != "kitty" ] && echo "true" || echo "false")"
        log_debug "  - CLAUDE_SESSION != FOCUSED_SESSION: $([ "$claude_session" != "$FOCUSED_SESSION" ] && echo "true" || echo "false")"
        log_debug "  - CLAUDE_PANE != ACTIVE_PANE: $([ "$claude_pane" != "$ACTIVE_PANE" ] && echo "true" || echo "false")"
        return 0
    fi

    log_debug "Notification NOT sent (kitty frontmost, same session, same pane)"
    return 1
}

# Get index of the tmux window hosting the given pane (empty if pane gone)
get_window_label() {
    local pane="$1"
    tmux display-message -p -t "$pane" '#{window_index}' 2>/dev/null
}

# Format seconds as human-readable duration (e.g. 45s, 3m, 1h12m)
format_duration() {
    local secs="$1"
    if [ "$secs" -lt 60 ]; then
        echo "${secs}s"
    elif [ "$secs" -lt 3600 ]; then
        echo "$((secs / 60))m"
    else
        echo "$((secs / 3600))h$(((secs % 3600) / 60))m"
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
