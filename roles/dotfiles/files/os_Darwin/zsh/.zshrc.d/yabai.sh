YABAI_CERT="${YABAI_CERT:-yabai-cert}"

suyabai() {
    str="$(whoami) ALL = (root) NOPASSWD: sha256:$(shasum -a 256 $(which yabai) | awk "{print \$1;}") $(which yabai) --load-sa"
    echo $str | sudo tee /private/etc/sudoers.d/yabai
}

# Re-sign + reload after brew swapped the binary.
# Triggered automatically by the brew() wrapper on yabai version change.
yabaipostupgrade() {
    local bin="$(brew --prefix yabai)/bin/yabai"
    yabai --stop-service
    sudo yabai --uninstall-sa
    sudo xattr -cr "$bin"
    codesign -fs "$YABAI_CERT" "$bin"
    suyabai
    yabai --start-service
}

# Manual full-cycle update; brew wrapper will fire yabaipostupgrade on the reinstall.
yabaiupdate() {
    brew reinstall koekeishiya/formulae/yabai
}

rmyabai() {
    yabai --uninstall-service
    sudo yabai --uninstall-sa
    brew uninstall yabai
    killall Dock
}
