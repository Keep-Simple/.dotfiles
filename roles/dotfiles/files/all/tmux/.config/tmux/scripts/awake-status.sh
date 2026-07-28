#!/usr/bin/env bash
# Status-line indicator: ☕ while awake-toggle's caffeinate lock is active.
lockfile="${XDG_CACHE_HOME:-$HOME/.cache}/awake.pid"
if [ -f "$lockfile" ] && kill -0 "$(cat "$lockfile")" 2>/dev/null; then
    printf '#[fg=#f9e2af]☕ #[default]'
fi
