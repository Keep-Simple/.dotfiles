suyabai() {
    str="$(whoami) ALL = (root) NOPASSWD: sha256:$(shasum -a 256 $(which yabai) | awk "{print \$1;}") $(which yabai) --load-sa"
    echo $str | sudo tee /private/etc/sudoers.d/yabai
}

rmfyabai() {
    brew services stop fyabai
    # uninstall the scripting addition
    sudo yabai --uninstall-sa
    # uninstall yabai
    brew uninstall fyabai
    # unload the scripting addition by forcing a restart of Dock.app
    killall Dock
}

rmyabai() {
    brew services stop yabai
    sudo yabai --uninstall-sa
    brew uninstall yabai
    killall Dock
}
