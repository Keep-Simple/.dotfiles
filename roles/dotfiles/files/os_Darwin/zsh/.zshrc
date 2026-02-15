# zmodload zsh/zprof
SHELL="/bin/zsh" # skhd related fix, override back to zsh
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Load .zshrc.d files early (they're already fast)
[[ -n $(ls ~/.zshrc.d/) ]] && for file in ~/.zshrc.d/*; do source "${file}"; done

# Deep cache brew shellenv - expand ALL evals for maximum speed
zinit ice id-as'brew-shellenv' lucid \
  atclone'
    if [[ -f /opt/homebrew/bin/brew ]]; then
      # Execute brew shellenv and all nested evals, then export final state
      eval "$(/opt/homebrew/bin/brew shellenv)"
      {
        echo "export HOMEBREW_PREFIX=\"$HOMEBREW_PREFIX\""
        echo "export HOMEBREW_CELLAR=\"$HOMEBREW_CELLAR\""
        echo "export HOMEBREW_REPOSITORY=\"$HOMEBREW_REPOSITORY\""
        echo "export HOMEBREW_NO_ANALYTICS=1"
        echo "export HOMEBREW_BUNDLE_FILE=\"$HOME/.dotfiles/roles/packages/files/macos/Brewfile\""
        echo "fpath=($HOMEBREW_PREFIX/share/zsh/site-functions \$fpath)"
        echo "export PATH=\"$PATH\""
        echo "export MANPATH=\"$MANPATH\""
        echo "export INFOPATH=\"$INFOPATH\""
      } > brew.zsh
    fi
  ' \
  atpull'%atclone' \
  src'brew.zsh' nocompile'!' \
  run-atpull
zinit light zdharma-continuum/null

# Add additional GNU tools to PATH
if [[ -n "$HOMEBREW_PREFIX" ]]; then
  PATH="${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnubin:$PATH"
  PATH="${HOMEBREW_PREFIX}/opt/gnu-sed/libexec/gnubin:$PATH"
  PATH="${HOMEBREW_PREFIX}/opt/gnu-tar/libexec/gnubin:$PATH"
  PATH="${HOMEBREW_PREFIX}/opt/util-linux/bin:$PATH"
  PATH="${HOMEBREW_PREFIX}/opt/util-linux/sbin:$PATH"
fi

PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

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

# Load zsh-vi-mode immediately (needs to be early for keybindings)
zinit ice depth=1 atload'zvm_vi_yank() { zvm_yank; echo ${CUTBUFFER} | pbcopy; zvm_exit_visual_mode; }'
zinit light jeffreytse/zsh-vi-mode

# Silence direnv and load in turbo mode
export DIRENV_LOG_FORMAT=
zinit ice wait'0b' lucid as"program" make'!' \
  atclone'./direnv hook zsh > zhook.zsh' \
  atpull'%atclone' pick"direnv" src"zhook.zsh"
zinit light direnv/direnv

# oh-my-posh with zinit caching (loads immediately, cached for speed)
zinit ice id-as'oh-my-posh' lucid \
  atclone'oh-my-posh init zsh --config ~/.config/ohmyposh/tokyonight_storm.omp.json > omp.zsh' \
  atpull'%atclone' \
  src'omp.zsh' nocompile'!' \
  run-atpull
zinit light zdharma-continuum/null

# fzf integration in turbo mode
zinit ice wait'0c' lucid \
  atclone'fzf --zsh > fzf.zsh' \
  atpull'%atclone' \
  src'fzf.zsh' nocompile'!' \
  id-as'fzf-integration' \
  run-atpull
zinit light zdharma-continuum/null

# OMZ plugins in turbo mode (wait'0d' for slightly later load)
zinit wait'0d' lucid light-mode for \
    OMZP::golang \
    OMZP::terraform

# Completions (load early in turbo)
zinit wait'0b' lucid light-mode for \
    as"completion" \
    OMZP::docker/completions/_docker \
    \
    as"completion" \
    OMZP::docker-compose/_docker-compose \
    \
    blockf \
    zsh-users/zsh-completions

# History substring search with keybindings
zinit wait'0c' lucid light-mode \
  atload'bindkey "^[[A" history-substring-search-up; bindkey "^[[B" history-substring-search-down' \
  for zsh-users/zsh-history-substring-search

# Custom zinit hooks for yazi and nvim
zinit wait'0d' lucid light-mode for \
    atload='_zinit_yazi' \
    id-as'yazi' nocompile \
    zdharma-continuum/null \
    \
    atload='_zinit_nvim' \
    id-as'nvim' nocompile \
    zdharma-continuum/null

# Fast syntax highlighting with compinit
zinit wait'0c' lucid light-mode \
  atinit"ZINIT[COMPINIT_OPTS]=-C; zpcompinit; zicdreplay" \
  for zdharma/fast-syntax-highlighting

# Autosuggestions (load last to not interfere)
zinit wait'0e' lucid light-mode \
  atload"!_zsh_autosuggest_start; bindkey '^W' forward-word" \
  for zsh-users/zsh-autosuggestions

autoload -U colors && colors

# zprof >> ~/Documents/zprof
