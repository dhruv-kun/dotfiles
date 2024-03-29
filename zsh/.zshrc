autoload -U +X compinit && compinit

source_scripts=(
     ~/.aliases
     ~/.config/plugins/git/git.plugin.zsh
     ~/.config/plugins/colored-man-pages/colored-man-pages.plugin.zsh
     ~/.config/plugins/mvn/mvn.plugin.zsh
     ~/.config/plugins/forgit/forgit.plugin.zsh
     ~/.config/plugins/vi-mode/vi-mode.plugin.zsh
     # ~/.config/plugins/zsh-vi-mode/zsh-vi-mode.zsh
     ~/.config/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
     ~/.config/plugins/zsh-histdb/sqlite-history.zsh
     ~/.config/plugins/zsh-histdb/histdb-interactive.zsh
     ~/.config/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
     ~/.config/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
)

for script in "${source_scripts[@]}"; do
    # [[ $script ]] && source $script
    if [[ -f $script ]]; then 
        source $script
    else
        echo "File not found: $script"
    fi
done

autoload -Uz add-zsh-hook

## TODO: Check this out later, zsh-vi-mode not working with history search

# function my_init() {
#     if [[ -n "$terminfo[kcuu1]" ]]; then
#         bindkey -M emacs "$terminfo[kcuu1]" history-substring-search-up
#         bindkey -M viins "$terminfo[kcuu1]" history-substring-search-up
#     fi
#     if [[ -n "$terminfo[kcud1]" ]]; then
#         bindkey -M emacs "$terminfo[kcud1]" history-substring-search-down
#         bindkey -M viins "$terminfo[kcud1]" history-substring-search-down
#     fi
# }

# zvm_after_init_commands+=(my_init)

# Bind terminal-specific up and down keys

if [[ -n "$terminfo[kcuu1]" ]]; then
  bindkey -M emacs "$terminfo[kcuu1]" history-substring-search-up
  bindkey -M viins "$terminfo[kcuu1]" history-substring-search-up
fi
if [[ -n "$terminfo[kcud1]" ]]; then
  bindkey -M emacs "$terminfo[kcud1]" history-substring-search-down
  bindkey -M viins "$terminfo[kcud1]" history-substring-search-down
fi


_zsh_autosuggest_strategy_histdb_top_here() {
    local query="select commands.argv from
history left join commands on history.command_id = commands.rowid
left join places on history.place_id = places.rowid
where places.dir LIKE '$(sql_escape $PWD)%'
and commands.argv LIKE '$(sql_escape $1)%'
group by commands.argv order by count(*) desc limit 1"
    suggestion=$(_histdb_query "$query")
}

ZSH_AUTOSUGGEST_STRATEGY=histdb_top_here


HISTORY_SUBSTRING_SEARCH_PREFIXED=true
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=true
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='fg=blue,bold'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='fg=red,bold'


HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000
# HIST_IGNORE_ALL_DUPS=false
HISTCONTROL=ignoredups

setopt auto_cd
setopt share_history
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_SPACE
setopt HIST_EXPIRE_DUPS_FIRST

export EDITOR=nvim
export VISUAL=code
export JAVA_HOME='/opt/homebrew/opt/openjdk@17'
export FZF_DEFAULT_OPTS='--border=rounded --extended'
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"

# bindkey "^[[A" history-beginning-search-backward
# bindkey "^[[B" history-beginning-search-forward

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

bindkey '^r' _histdb-isearch
# nnn shortcut
bindkey -s '^p' 'n\n'
# vi mode
bindkey -v

# eval "$(fasd --init auto)"
. /opt/homebrew/etc/profile.d/z.sh


n ()
{
    # Block nesting of nnn in subshells
    if [ -n $NNNLVL ] && [ "${NNNLVL:-0}" -ge 1 ]; then
        echo "nnn is already running"
        return
    fi

    # The behaviour is set to cd on quit (nnn checks if NNN_TMPFILE is set)
    # To cd on quit only on ^G, either remove the "export" as in:
    #    NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    #    (or, to a custom path: NNN_TMPFILE=/tmp/.lastd)
    # or, export NNN_TMPFILE after nnn invocation
    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
    # stty start undef
    # stty stop undef
    # stty lwrap undef
    # stty lnext undef

    nnn "$@"

    if [ -f "$NNN_TMPFILE" ]; then
            . "$NNN_TMPFILE"
            rm -f "$NNN_TMPFILE" > /dev/null
    fi
}


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/dhruv/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/dhruv/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/dhruv/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/dhruv/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<



export KEYTIMEOUT=1

function zle-keymap-select {
	if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
		echo -ne '\e[1 q'
	elif [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == main ]]; then
		echo -ne '\e[5 q'
	fi
}

zle -N zle-keymap-select

echo -ne '\e[5 q'

preexec() {
	echo -ne '\e[5 q'
}
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '$HOME.zshrc'

# End of lines added by compinstall


# starship prompt
eval "$(starship init zsh)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# fzf
export FZF_DEFAULT_COMMAND='fd --type f --color=never --hidden'
export FZF_DEFAULT_OPTS='--no-height --color=bg+:#343d46,gutter:-1,pointer:#ff3c3c,info:#0dbc79,hl:#0dbc79,hl+:#23d18b'

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :50 {}'"

export FZF_ALT_C_COMMAND='fd --type d . --color=never --hidden'
export FZF_ALT_C_OPTS="--preview 'exa -lT --icons -a --git {} | head -50'"



export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
export PATH="/Users/dhruv/Tools/apache-maven-3.9.3/bin:$PATH"
export PATH="/Users/dhruv/Tools/flutter/bin:$PATH"
export PATH="/Users/dhruv/go/bin:$PATH"
