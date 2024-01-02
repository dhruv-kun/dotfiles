#!/bin/sh
tf() {
    selected=$(tmux ls | fzf --print-query | tail -n 1 | cut -f 1 -d ':')
    if [ $selected ]; then
        session=$(tmux ls | grep $selected)
        if [ -z "$session" ]; then
            tmux new-session -d -s $selected
        fi
        tmux switch-client -t $selected
    fi
}
