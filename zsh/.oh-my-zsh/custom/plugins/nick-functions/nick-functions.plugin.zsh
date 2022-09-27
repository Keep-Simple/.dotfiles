# it's for changing dir on lf quit with button Q (not regular q)
lf () {
    local tempfile="$(mktemp)"
    command lf -command "map Q \$echo \$PWD >$tempfile; lf -remote \"send \$id quit\"" "$@"
	  
    if [[ -f "$tempfile" ]] && [[ "$(cat -- "$tempfile")" != "$(echo -n $(pwd))" ]]; then
		  cd -- "$(cat "$tempfile")" || return
    fi
    command rm -f -- "$tempfile" 2>/dev/null
}


zle     -N            lf
bindkey -M emacs '^O' lf
bindkey -M vicmd '^O' lf
bindkey -M viins '^O' lf
