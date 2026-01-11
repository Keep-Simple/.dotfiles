# zmodload zsh/zprof
SHELL="/bin/zsh" # skhd related fix, override back to zsh
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

[[ -n $(ls ~/.zshrc.d/) ]] && for file in ~/.zshrc.d/*; do source "${file}"; done

test -f /opt/homebrew/bin/brew && eval $(/opt/homebrew/bin/brew shellenv)

if [[ -n "$HOMEBREW_PREFIX" ]]; then
  export HOMEBREW_NO_ANALYTICS=1
  export HOMEBREW_BUNDLE_FILE="$HOME/.dotfiles/roles/packages/files/macos/Brewfile"
  # linux utils for macos
  PATH="${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnubin:$PATH"
  PATH="${HOMEBREW_PREFIX}/opt/gnu-sed/libexec/gnubin:$PATH"
  PATH="${HOMEBREW_PREFIX}/opt/gnu-tar/libexec/gnubin:$PATH"
  PATH="${HOMEBREW_PREFIX}/opt/util-linux/bin:$PATH"
  PATH="${HOMEBREW_PREFIX}/opt/util-linux/sbin:$PATH"
fi

ZVM_VI_HIGHLIGHT_FOREGROUND=white
ZVM_VI_HIGHLIGHT_BACKGROUND=black
ZVM_CURSOR_STYLE_ENABLED=false
ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
ZVM_INIT_MODE=sourcing
zstyle ':completion:*' menu select
zle_highlight+=(paste:none) # no highlight on paste

setopt autocd	interactive_comments
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt share_history          # share command history data

ZSH_AUTOSUGGEST_MANUAL_REBIND=1

zinit ice depth=1 atload'zvm_vi_yank() { zvm_yank; echo ${CUTBUFFER} | pbcopy; zvm_exit_visual_mode; }'
zinit light jeffreytse/zsh-vi-mode

# silence direnv
export DIRENV_LOG_FORMAT=
zinit as"program" make'!' atclone'./direnv hook zsh > zhook.zsh' \
    atpull'%atclone' pick"direnv" src"zhook.zsh" for \
        direnv/direnv

# Regular plugins, loaded in turbe mode (wait)
zinit wait lucid light-mode for \
    OMZP::golang \
    OMZP::terraform \
    \
    as"completion" \
    OMZP::docker/completions/_docker \
    \
    as"completion" \
    OMZP::docker-compose/_docker-compose \
    \
    atload'bindkey "^[[A" history-substring-search-up; bindkey "^[[B" history-substring-search-down; source <(fzf --zsh)' \
    zsh-users/zsh-history-substring-search \
    \
    atload='_zinit_yazi' \
    id-as'yazi' nocompile \
    zdharma-continuum/null \
    \
    atload='_zinit_nvim' \
    id-as'nvim' nocompile \
    zdharma-continuum/null \
    \
    atinit"ZINIT[COMPINIT_OPTS]=-C; zpcompinit; zicdreplay" \
    zdharma/fast-syntax-highlighting \
    \
    blockf \
    zsh-users/zsh-completions \
    \
    atload"!_zsh_autosuggest_start; bindkey '^W' forward-word" \
    zsh-users/zsh-autosuggestions

autoload -U colors && colors

eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/tokyonight_storm.omp.json)"
# zprof >> ~/Documents/zprof
