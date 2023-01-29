if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -f "$ZINIT_HOME/zinit.zsh" ]]; then
  print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "$ZINIT_HOME/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

[[ -n $(ls ~/.zshrc.d/) ]] && for file in ~/.zshrc.d/*; do source "${file}"; done

ZVM_VI_HIGHLIGHT_FOREGROUND=green
ZVM_VI_HIGHLIGHT_BACKGROUND=white
SHELL="/bin/zsh" # skhd related fix, override back to zsh 
ZVM_CURSOR_STYLE_ENABLED=false
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

# silence asdf-direnv
export DIRENV_LOG_FORMAT=
zinit ice lucid as"program" \
    pick'bin/asdf' atinit'export ASDF_DIR="$PWD"' \
    atclone'_zinit_asdf_install' src'lib/asdf.sh' \
    multisrc'asdf_direnv_hook.zsh' depth=1
zinit light asdf-vm/asdf

zinit ice depth=1
zinit light romkatv/powerlevel10k

zinit ice depth=1 atload'zvm_vi_yank() { zvm_yank; echo ${CUTBUFFER} | xclip -selection c; zvm_exit_visual_mode; }'
zinit light jeffreytse/zsh-vi-mode

# Regular plugins, loaded in turbe mode (wait)
zinit wait lucid light-mode for \
  OMZP::golang \
  OMZP::terraform \
  \
  as"completion" \
  OMZP::docker/_docker \
  \
  as"completion" \
  OMZP::docker-compose/_docker-compose \
  \
  atload'bindkey "^[[A" history-substring-search-up;
        bindkey "^[[B" history-substring-search-down' \
  zsh-users/zsh-history-substring-search \
  \
  atinit"ZINIT[COMPINIT_OPTS]=-C; zpcompinit; zpcdreplay" \
  zdharma/fast-syntax-highlighting \
  \
  atload"_zsh_autosuggest_start; bindkey '^W' forward-word" \
  zsh-users/zsh-autosuggestions \
  \
  blockf atpull'zinit creinstall -q .' \
  zsh-users/zsh-completions \
  \
  as"completion" atclone='kubectl completion zsh > _kubectl' \
  atpull'%atclone' has'kubectl' nocompile blockf \
  id-as'kubectl' \
  zdharma-continuum/null \
  \
  atload='_zinit_lf' \
  id-as'lf' nocompile \
  zdharma-continuum/null \
  \
  atload='_zinit_lvim' \
  id-as'lvim' nocompile \
  zdharma-continuum/null \
  \
  depth'1' nocompile \
  src'shell/key-bindings.zsh' \
  junegunn/fzf

autoload -U colors && colors

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
ulimit -n 10000
