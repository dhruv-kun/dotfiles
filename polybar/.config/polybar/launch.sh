#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar
# If all your bars have ipc enabled, you can also use 
# polybar-msg cmd quit

# Launch bar1 and bar2
echo "---" | tee -a /tmp/ploybar_main.log 
polybar main 2>&1 | tee -a /tmp/polybar_main.log & disown

echo "Bars launched..."