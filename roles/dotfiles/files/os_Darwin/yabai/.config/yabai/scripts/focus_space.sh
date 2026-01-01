#!/bin/sh

case "$1" in
    prev) yabai -m space --focus prev || yabai -m space --focus last ;;
    next) yabai -m space --focus next || yabai -m space --focus first ;;
    recent) yabai -m space --focus recent ;;
    *)
        if [[ -z $1 ]]; then
            yabai -m query --windows --window &> /dev/null || yabai -m window --focus mouse &> /dev/null || yabai -m window --focus $(yabai -m query --windows --space | jq .[0].id) &> /dev/null || true
        else
            yabai -m space --focus $1
        fi
        ;;
esac
