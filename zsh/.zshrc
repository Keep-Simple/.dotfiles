# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Disable the cursor style feature
ZVM_CURSOR_STYLE_ENABLED=false
eval $(/opt/homebrew/bin/brew shellenv)
# for completions
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

if [[ ! -d ~/.zplug ]]; then
  git clone https://github.com/zplug/zplug ~/.zplug
  source ~/.zplug/init.zsh && zplug update --self
fi

source ~/.zplug/init.zsh

zplug "romkatv/powerlevel10k", as:theme, depth:1
zplug 'zplug/zplug', hook-build:'zplug --self-manage'
zplug "plugins/tmux", from:oh-my-zsh, defer:3
zplug "jeffreytse/zsh-vi-mode"
zplug "plugins/golang", from:oh-my-zsh
zplug "plugins/kubectl", from:oh-my-zsh, defer:3
zplug "plugins/terraform", from:oh-my-zsh, defer:3
zplug "plugins/docker", from:oh-my-zsh, defer:3
zplug "redxtech/zsh-asdf-direnv" # https://github.com/redxtech/zsh-asdf-direnv
zplug "plugins/docker-compose", from:oh-my-zsh, defer:3
zplug "~/.zshrc.d", use:"*", from:local

zplug "zsh-users/zsh-completions"              
zplug "zsh-users/zsh-autosuggestions",          defer:2, on:"zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting",      defer:3, on:"zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-history-substring-search", defer:3, on:"zsh-users/zsh-syntax-highlighting"
zplug "modules/completion", from:prezto

zstyle ':completion:*' menu select

if ! zplug check; then
  zplug install
fi

zplug load


# Load aliases and shortcuts if existent.
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc"


# autoload -U colors && colors	# Load colors
zle_highlight+=(paste:none) # no highlight on paste
zstyle ':bracketed-paste-magic' active-widgets '.self-*' # instant paste
setopt autocd		# Automatically cd into typed directory.
setopt interactive_comments

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
