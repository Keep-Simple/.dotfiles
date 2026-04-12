if [ -f '/opt/homebrew/share/google-cloud-sdk/path.zsh.inc' ]; then . '/opt/homebrew/share/google-cloud-sdk/path.zsh.inc'; fi
# if [ -f '/opt/homebrew/share/google-cloud-sdk/completion.zsh.inc' ]; then . '/opt/homebrew/share/google-cloud-sdk/completion.zsh.inc'; fi

bmad-update-all() {
    bmad-update \
        ~/.dotfiles \
        ~/Documents/commercial/snyk-ls \
        ~/Documents/commercial/go-application-framework \
        ~/Documents/commercial/analytics-service \
        ~/Documents/commercial/cli \
        ~/Documents/commercial/snyk-intellij-plugin \
        ~/Documents/commercial/vscode-extension \
        ~/Documents/commercial/ldx-sync \
        ~/Documents/commercial/code-client-go \
        ~/Documents/commercial/snyk-eclipse-plugin \
        ~/Documents/commercial/snyk-visual-studio-plugin \
        "$@"
}
