#!/bin/bash
# Minimal hook: drain stdin, push tmux status redraw. Used for tool events
# (PreToolUse / PostToolUse) so ⏸ counter reflects state changes immediately
# instead of waiting for status-interval tick.
cat > /dev/null
tmux refresh-client -S 2>/dev/null
