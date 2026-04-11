BREWFILE="$HOME/.dotfiles/roles/packages/files/macos/Brewfile"

brew() {
    command brew "$@"
    local exit_code=$?

    case "$1" in
        install|uninstall|remove|tap|untap|reinstall)
            if [[ $exit_code -eq 0 ]]; then
                command brew bundle dump --force --file="$BREWFILE" --brews --casks --taps
            fi
            ;;
    esac

    return $exit_code
}
