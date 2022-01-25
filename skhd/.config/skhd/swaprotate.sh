#!/bin/bash
[[ "$1" == "--reverse" ]] || reverse="| reverse "
yabai -m query --windows --space  | \
jq -re '
  map(select(.minimized != 1))
  | sort_by(.frame.x, .frame.y, ."stack-index", .id)
  '"$reverse"'
  | first as $first
  | map( $first.id, .id )
  | .[]' | \
tail -n +3 | \
xargs -n2 sh -c 'yabai -m window $1 --swap $2' sh
