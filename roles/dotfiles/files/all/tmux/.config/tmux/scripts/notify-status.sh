#!/usr/bin/env bash
# Status-line indicator: 🔕 while notify-toggle has notifications muted.
flagfile="${XDG_CACHE_HOME:-$HOME/.cache}/notify-off"
[ -f "$flagfile" ] && printf '#[fg=#f38ba8]🔕 #[default]'
