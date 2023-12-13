#!/bin/sh

# Only have indicator if there is >1 window

if [[ -z "${YABAI_SPACE_ID}" ]]; then
    space_sel="mouse"
else
    space_sel=$(yabai -m query --spaces | jq -r '.[] | select(.id==(env.YABAI_SPACE_ID|tonumber)).index')
fi

windows_ids=$(yabai -m query --windows --space $space_sel | jq '.[] | select(."is-visible"==true).id')
windows_count=$(echo $windows_ids | wc -w)

if [[ $windows_count -ge 2 ]]; then
    hs -c "ToggleMultiWindowIcon(true)"
else
    hs -c "ToggleMultiWindowIcon(false)"
fi
