#!/bin/bash
# ABOUTME: Shared functions for Claude Code notification hooks
# ABOUTME: Provides common logging and notification logic used across multiple hooks

# Terminal app name as macOS frontmost-process reports it. Override via env.
TERMINAL_APP="${CLAUDE_HOOK_TERMINAL_APP:-kitty}"

# Setup debug logging
setup_debug_log() {
    local log_name="$1"
    DEBUG_LOG="/tmp/claude-hook-logs/hook-${log_name}.log"
    mkdir -p "$(dirname "$DEBUG_LOG")"
}

log_debug() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$DEBUG_LOG"
}

# Frontmost macOS app name (empty on osascript failure).
frontmost_app() {
    osascript -e 'tell application "System Events" to get name of first process whose frontmost is true' 2>/dev/null
}

# Check whether a tmux pane is currently visible to the user.
# "Visible" = frontmost macOS app is $TERMINAL_APP AND the most-recently-active
# tmux client has this pane focused (active pane in active window of session).
# With multiple terminal windows on different macOS workspaces, only the
# frontmost one counts; clients on background terminals don't.
# Returns 0 if visible, 1 if not.
is_pane_visible() {
    local pane="$1"
    [ -z "$pane" ] && return 1

    [ "$(frontmost_app)" = "$TERMINAL_APP" ] || return 1

    # Pick most-recently-active client (the one in the frontmost terminal window).
    local focused_client
    focused_client=$(tmux list-clients -F '#{client_activity} #{client_name}' 2>/dev/null \
        | sort -rn | head -1 | cut -d' ' -f2-)
    [ -z "$focused_client" ] && return 1

    local active_pane
    active_pane=$(tmux display-message -p -t "$focused_client" '#{pane_id}' 2>/dev/null)
    [ "$active_pane" = "$pane" ]
}

# Desktop notifications only when user is NOT looking at the terminal app.
# Status-bar ⏸/✓ icons surface attention while in terminal+tmux.
should_send_notification() {
    local front
    front=$(frontmost_app)
    log_debug "FRONT_APP: $front (TERMINAL_APP=$TERMINAL_APP)"

    if [ "$front" = "$TERMINAL_APP" ]; then
        log_debug "terminal frontmost - skipping notification (status bar handles it)"
        return 1
    fi

    log_debug "terminal not frontmost - sending notification"
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
