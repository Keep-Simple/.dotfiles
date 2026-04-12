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

# List installed brew packages not tracked in the Brewfile
brew-orphans() {
    local brewfile_formulae installed_formulae brewfile_casks installed_casks

    # Formulae: compare leaves (top-level) against Brewfile, using short names
    brewfile_formulae=$(awk -F'"' '/^brew / {split($2, a, "/"); print a[length(a)]}' "$BREWFILE" | sort)
    installed_formulae=$(command brew leaves | awk -F/ '{print $NF}' | sort)

    echo "Formulae not in Brewfile:"
    comm -23 <(echo "$installed_formulae") <(echo "$brewfile_formulae") | sed 's/^/  /'

    # Casks: compare installed against Brewfile
    brewfile_casks=$(awk -F'"' '/^cask / {print $2}' "$BREWFILE" | sort)
    installed_casks=$(command brew list --cask -1 | sort)

    echo "\nCasks not in Brewfile:"
    comm -23 <(echo "$installed_casks") <(echo "$brewfile_casks") | sed 's/^/  /'
}
