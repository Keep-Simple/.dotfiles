[[ -n $(ls ~/.zshrc.d/) ]] && for file in ~/.zshrc.d/*; do source "${file}"; done

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="robbyrussell"

export FZF_BASE=/opt/homebrew/bin/fzf

plugins=(
  vi-mode
  zsh-syntax-highlighting
  zsh-autosuggestions
  poetry
  gh
  kubectl
  docker
  docker-compose
)

source $ZSH/oh-my-zsh.sh

# Enable colors and change prompt:
autoload -U colors && colors	# Load colors
zle_highlight+=(paste:none) # no highlight on paste
zstyle ':bracketed-paste-magic' active-widgets '.self-*' # instant paste
setopt autocd		# Automatically cd into typed directory.
stty stop undef		# Disable ctrl-s to freeze terminal.
setopt interactive_comments

# History in cache directory:
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE=~/.cache/zsh/history

# Load aliases and shortcuts if existent.
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc"

export KEYTIMEOUT=35

clear;
