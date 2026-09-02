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

# Frontmost macOS app name (empty on lookup failure — e.g. lock screen).
# lsappinfo (Launch Services) over osascript/System Events: the latter flakes
# with transient AppleEvents/XPC errors (-600, -10810) that silently return
# empty and defeat the "am I frontmost" check. lsappinfo has no such failure
# mode and needs no TCC grant.
frontmost_app() {
    lsappinfo info -only name "$(lsappinfo front)" 2>/dev/null \
        | sed -n 's/.*"LSDisplayName"="\([^"]*\)".*/\1/p'
}

# Check whether a tmux pane is currently visible to the user.
# "Visible" = frontmost macOS app is $TERMINAL_APP AND the client tmux
# reports as actually focused (#{client_focused}) has this pane active.
# With multiple attached clients (one per terminal window), client_activity
# (last-touched timestamp) is NOT a reliable proxy for "on screen right now" —
# mouse-reporting/resize noise on a background client can out-tick the client
# you're actually looking at, so fall back to it only if no client reports
# client_focused (unsupported terminal/tmux).
# Returns 0 if visible, 1 if not.
is_pane_visible() {
    local pane="$1"
    [ -z "$pane" ] && return 1

    [ "$(frontmost_app)" = "$TERMINAL_APP" ] || return 1

    local focused_client
    focused_client=$(tmux list-clients -F '#{client_focused} #{client_name}' 2>/dev/null \
        | awk '$1==1{print substr($0, index($0,$2)); exit}')

    if [ -z "$focused_client" ]; then
        focused_client=$(tmux list-clients -F '#{client_activity} #{client_name}' 2>/dev/null \
            | sort -rn | head -1 | cut -d' ' -f2-)
    fi
    [ -z "$focused_client" ] && return 1

    local active_pane
    active_pane=$(tmux display-message -p -t "$focused_client" '#{pane_id}' 2>/dev/null)
    [ "$active_pane" = "$pane" ]
}

# Desktop notifications only when user is NOT looking at the terminal app.
# Status-bar ⏸/✓ icons surface attention while in terminal+tmux.
should_send_notification() {
    # Manual mute via notify-toggle (M-z in tmux); 🔕 shows in the status bar.
    if [ -f "${XDG_CACHE_HOME:-$HOME/.cache}/notify-off" ]; then
        log_debug "notifications muted via notify-toggle - skipping"
        return 1
    fi

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

# Send a terminal notification. Empty $group skips -group (a repeated group
# replaces the prior banner instead of adding a new one — fine for the
# ⏸-waiting notice where only the latest matters, wrong for Stop where every
# finished turn should alert on its own).
send_notification() {
    local group="$1"
    local title="$2"
    local subtitle="$3"
    local message="$4"
    local sound="$5"

    # terminal-notifier v3 treats an empty/whitespace -message as not provided
    # and prints help instead of sending (exit 1) — move subtitle into message
    # (not copy: leaving both set renders the same text on two lines).
    if [ -z "${message// }" ]; then
        message="$subtitle"
        subtitle=""
    fi

    local -a group_args=()
    [ -n "$group" ] && group_args=(-group "$group")

    # terminal-notifier moves the attachment into its data store, which fails
    # on a symlink (our ~/.claude/* files are all stow symlinks) — resolve first.
    local content_image
    content_image=$(readlink -f "$HOME/.claude/claude.png" 2>/dev/null) || content_image="$HOME/.claude/claude.png"

    if terminal-notifier \
        "${group_args[@]}" \
        -contentImage "$content_image" \
        -title "$title" \
        -subtitle "$subtitle" \
        -message "$message" \
        -sound "$sound"; then
        log_debug "Notification sent (exit 0)"
    else
        log_debug "Notification FAILED (exit $?)"
    fi
}

# ---------------------------------------------------------------------------
# Self-check: bash ~/.claude/hooks/common.sh --selfcheck
# Smallest thing that fails if frontmost_app, format_duration, or the
# on-notification.sh idle-guard (Fault B) regress. terminal-notifier is
# stubbed so this never fires a real desktop notification.
# ---------------------------------------------------------------------------
if [ "${BASH_SOURCE[0]}" = "$0" ] && [ "$1" = "--selfcheck" ]; then
    fail=0
    assert_eq() { [ "$1" = "$2" ] || { echo "FAIL: $3 (got '$1', want '$2')"; fail=1; }; }

    front=$(frontmost_app)
    [ -n "$front" ] || { echo "FAIL: frontmost_app returned empty"; fail=1; }
    case "$front" in *$'\n'*) echo "FAIL: frontmost_app returned multiple lines: '$front'"; fail=1 ;; esac

    assert_eq "$(format_duration 59)" "59s" "format_duration(59)"
    assert_eq "$(format_duration 60)" "1m" "format_duration(60)"
    assert_eq "$(format_duration 3600)" "1h0m" "format_duration(3600)"

    # idle_prompt is periodic background noise (fires ~every 3min at any
    # normal idle prompt, not just when blocked) — must never write the ⏸
    # marker. permission_prompt is the real block signal and must.
    sid="selfcheck-$$"
    hooks_dir="$(dirname "${BASH_SOURCE[0]}")"
    stub_bin=$(mktemp -d)
    printf '#!/bin/bash\nexit 0\n' > "$stub_bin/terminal-notifier"
    chmod +x "$stub_bin/terminal-notifier"
    cleanup_selfcheck() {
        rm -rf "$stub_bin"
        rm -f "/tmp/claude_${sid}_completed" "/tmp/claude_${sid}_waiting"
    }
    trap cleanup_selfcheck EXIT

    echo "{\"session_id\":\"$sid\",\"notification_type\":\"idle_prompt\"}" \
        | PATH="$stub_bin:$PATH" "$hooks_dir/on-notification.sh" >/dev/null 2>&1
    [ -f "/tmp/claude_${sid}_waiting" ] && { echo "FAIL: idle_prompt wrote a waiting marker (must be ignored — it's not a block signal)"; fail=1; }

    rm -f "/tmp/claude_${sid}_waiting"
    echo "{\"session_id\":\"$sid\",\"message\":\"test\",\"notification_type\":\"permission_prompt\"}" \
        | PATH="$stub_bin:$PATH" "$hooks_dir/on-notification.sh" >/dev/null 2>&1
    [ -f "/tmp/claude_${sid}_waiting" ] || { echo "FAIL: permission_prompt did not write a waiting marker"; fail=1; }

    [ "$fail" -eq 0 ] && echo "OK: common.sh selfcheck passed"
    exit "$fail"
fi
