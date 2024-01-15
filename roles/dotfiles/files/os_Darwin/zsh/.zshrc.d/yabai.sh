suyabai() {
    str="$(whoami) ALL = (root) NOPASSWD: sha256:$(shasum -a 256 $(which yabai) | awk "{print \$1;}") $(which yabai) --load-sa"
    echo $str | sudo tee /private/etc/sudoers.d/yabai
}

postbrewyabai() {
    yabai --stop-service
    suyabai
    yabai --start-service
}

# Updating/installing from head additional steps
# codesign -fs "yabai-cert" "$(brew --prefix yabai)/bin/yabai" > /dev/null
# sudo yabai --uninstall-sa
# sudo yabai --load-sa
# pkill -x Dock

rmyabai() {
    yabai --uninstall-service
    sudo yabai --uninstall-sa
    brew uninstall yabai
    killall Dock
}
