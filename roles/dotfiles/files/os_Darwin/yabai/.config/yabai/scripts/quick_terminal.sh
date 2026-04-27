#!/bin/sh

QuickTerminal=$(yabai -m query --windows | jq 'map(select(.title=="QuickTerminal")) | .[0].pid')


launch_ghostty() {
    { open -na Ghostty --args --title=QuickTerminal --working-directory="${HOME}" -e tmux new -A -s quickterm & } &> /dev/null
    ghostty_pid=$!
    disown -r "${ghostty_pid}"
}

quick_term_toggle() {
    osascript -e "
        tell application \"System Events\"
            if frontmost of the first process whose unix id is $1 then
                set visible of the first process whose unix id is $1 to false
            else
                set frontmost of the first process whose unix id is $1 to true
            end if
        end tell
    "
}


if [[ $QuickTerminal == "null" ]]; then
    launch_ghostty
else
    quick_term_toggle $QuickTerminal
fi
