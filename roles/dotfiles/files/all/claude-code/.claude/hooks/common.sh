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

# Check whether a tmux pane is currently visible to the user.
# "Visible" = frontmost macOS app is kitty AND the most-recently-active tmux client
# has this pane focused (active pane in active window of attached session).
# Handles multiple kitty windows on different macOS workspaces — only the frontmost
# one matters; tmux clients on background kitties don't count as visible.
# Returns 0 if visible, 1 if not.
is_pane_visible() {
    local pane="$1"
    [ -z "$pane" ] && return 1

    local front_app
    front_app=$(osascript -e 'tell application "System Events" to get name of first process whose frontmost is true' 2>/dev/null)
    if [ "$front_app" != "kitty" ]; then
        return 1
    fi

    # Pick most-recently-active client (the one in the frontmost kitty window).
    local focused_client
    focused_client=$(tmux list-clients -F '#{client_activity} #{client_name}' 2>/dev/null \
        | sort -rn | head -1 | cut -d' ' -f2-)
    [ -z "$focused_client" ] && return 1

    local active_pane
    active_pane=$(tmux display-message -p -t "$focused_client" '#{pane_id}' 2>/dev/null)
    [ "$active_pane" = "$pane" ]
}

# Check if notification should be sent based on current context.
# Returns 0 if notification should be sent, 1 otherwise.
should_send_notification() {
    local claude_pane="$1"

    if [ -z "$claude_pane" ]; then
        log_debug "CLAUDE_PANE empty - skipping notification"
        return 1
    fi

    if is_pane_visible "$claude_pane"; then
        log_debug "Pane $claude_pane visible to user - skipping notification"
        return 1
    fi

    log_debug "Pane $claude_pane not visible - sending notification"
    return 0
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
