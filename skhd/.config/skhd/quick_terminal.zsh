#! /usr/bin/env zsh

local QuickTerminal=$(yabai -m query --windows | jq -r 'map(select(.title=="QuickTerminal")) | .[0]')
local QuickTerminal_ID=$(echo $QuickTerminal | jq -r '.id')

if [[ $(echo $QuickTerminal) == 'null' ]] 
  then
    open -n /Applications/Alacritty.app --args --title QuickTerminal
  elif [[ $(echo $QuickTerminal | jq -r '."has-focus"') == 'true'  ]]
  then
    yabai -m window $QuickTerminal_ID --minimize
    yabai -m window --focus recent
  else  
    yabai -m window $QuickTerminal_ID --focus
fi

