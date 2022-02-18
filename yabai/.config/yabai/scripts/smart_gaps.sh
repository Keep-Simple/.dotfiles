#!/bin/sh

p=8

if [[ $(yabai -m query --windows --space |
	jq 'map(select(."is-floating" == false)) | length') -eq 1 ||
$(yabai -m query --windows --space |
	jq 'map(select(."has-fullscreen-zoom" == true)) | length') -ge 1 ||
$(yabai -m query --spaces --space |
	jq 'select(.type =="stack")') ]]; then
	p=0
fi

yabai -m space --padding abs:$p:$p:$p:$p
