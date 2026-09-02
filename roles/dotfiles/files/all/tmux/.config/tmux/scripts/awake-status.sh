#!/usr/bin/env bash
# Status-line indicator: ☕ while awake-toggle has macOS sleep disabled.
[ "$(pmset -g | awk '/SleepDisabled/ { print $2 }')" = "1" ] && printf '#[fg=#f9e2af]☕ #[default]'
