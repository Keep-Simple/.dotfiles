#!/bin/sh
# Setup pyren BLE development session with main-vertical layout

if ! command -v ble-serial >/dev/null 2>&1; then
    echo "ble-serial not found, installing via pip..."
    pip install ble-serial
fi

tmux split-window -v -c "$PWD"
tmux send-keys -t :.2 "./run.sh" C-m
tmux select-layout main-vertical
tmux select-pane -t :.1
exec ble-serial \
    -d 96396EFC-5D60-1D65-3634-9DEA1CEE6916 \
    -r BEF8D6C9-9C21-4C9E-B632-BD58C1009F9F \
    -w BEF8D6C9-9C21-4C9E-B632-BD58C1009F9F \
    -p ~/obd2
