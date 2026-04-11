#!/bin/sh

# Focusable window: visible and not sticky (sticky = screenshare overlays like Tuple Host, Meet indicator)
is_focusable='select(."is-visible" == true and ."is-sticky" == false)'

case "$1" in
    prev) yabai -m space --focus prev || yabai -m space --focus last ;;
    next) yabai -m space --focus next || yabai -m space --focus first ;;
    recent) yabai -m space --focus recent ;;
    *)
        if [[ -z $1 ]]; then
            if yabai -m query --windows --window 2>/dev/null | jq -e "$is_focusable" &>/dev/null; then
                exit 0
            fi

            if yabai -m window --focus mouse &> /dev/null \
                && yabai -m query --windows --window 2>/dev/null | jq -e "$is_focusable" &>/dev/null; then
                exit 0
            fi

            first_window_id=$(yabai -m query --windows --space | jq -r "[.[] | $is_focusable][0].id" 2>/dev/null)
            if [[ -n "$first_window_id" && "$first_window_id" != "null" ]]; then
                yabai -m window --focus "$first_window_id" &> /dev/null
            fi
        else
            yabai -m space --focus $1
        fi
        ;;
esac
