#!/bin/sh

# Only have borders/gaps/padding if there is >1 VISIBLE window

YABAI="$HOME/.config/yabai/scripts"
windows_ids=$(yabai -m query --windows --space | jq '.[] | select(."is-floating"==false and .title!="QuickTerminal").id')
windows_count=$(echo $windows_ids | wc -w)

if [[ $windows_count -le 1 ]]; then
	p=0
	yabai -m space --padding abs:$p:$p:$p:$p
	echo $windows_ids | xargs -n1 -P10 $YABAI/border_off.sh
else
	p=8
	yabai -m space --padding abs:$p:$p:$p:$p
	echo $windows_ids | xargs -n1 -P10 $YABAI/border_on.sh
fi
