#!/bin/sh

# Only have borders/gaps/padding if there is >1 VISIBLE window

YABAI="$HOME/.config/yabai/scripts"
p=8

if [[ $(yabai -m query --windows --space |
	jq 'map(select(."is-floating" == false)) | length') -eq 1 ||
$(yabai -m query --windows --space |
	jq 'map(select(."is-visible" == true)) | length') -eq 1 ||
$(yabai -m query --windows --space |
	jq 'map(select(."has-fullscreen-zoom" == true)) | length') -ge 1 ]]; then
	p=0
	yabai -m query --spaces --space | jq '.windows | .[]' | xargs -n1 $YABAI/border_off.sh
else
	yabai -m query --spaces --space | jq '.windows | .[]' | xargs -n1 $YABAI/border_on.sh
fi

yabai -m space --padding abs:$p:$p:$p:$p

# yabai -m space --gap abs:$p
# ||
# $(yabai -m query --spaces --space |
# 	jq 'select(.type =="stack")')
