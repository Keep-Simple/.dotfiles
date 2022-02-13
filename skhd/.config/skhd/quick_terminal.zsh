#! /usr/bin/env zsh

local QuickTerminal=$(yabai -m query --windows | jq -r 'map(select(.title=="QuickTerminal")) | .[0]')
local QuickTerminal_ID=$(echo $QuickTerminal | jq -r '.id')
local QuickTerminal_PID=$(echo $QuickTerminal | jq -r '.pid')

if [[ $(echo $QuickTerminal) == 'null' ]] 
  then
    open -n /Applications/Alacritty.app --args --title QuickTerminal
  elif [[ $(echo $QuickTerminal | jq -r '."has-focus"') == 'true'  ]]
    then
    osascript -e "tell application \"System Events\" to set visible of first process ¬" \
              -e "whose unix id = ${QuickTerminal_PID} to false"
  else  
    yabai -m window $QuickTerminal_ID --focus
fi

