#!/usr/bin/env zsh

cd $(dirname $0)

echo "Shell installation script for Keep-Simple dotfiles"
echo "-------------------------------------------------"
echo ""

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do
	sudo -n true
	sleep 60
	kill -0 "$$" || exit
done 2>/dev/null &

installSoftware() {
	echo "[INFO] Installing required software (restoring from brew backup)"
	./restore.sh
}

installBrew() {
	if hash brew 2>/dev/null; then
		echo "[INFO] Brew already installed."
	else
		echo "[INFO] Installing rosetta 2"
		softwareupdate --install-rosetta --agree-to-license
		echo "[INFO] Installing xcode cli"
		xcode-select --install
		echo "[INFO] Installing Homebrew package manager..."
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh --output install_script.sh
    chmod +x install_script.sh
    NONINTERACTIVE=1 ./install_script.sh 
    rm install_script.sh
		eval "$(/opt/homebrew/bin/brew shellenv)"
	fi
}

updateBrew() {
	if hash brew 2>/dev/null; then
		echo "[INFO] Updating Homebrew package manager..."
		brew update --force --quiet
	fi
}

installAsdf() {
	echo "[INFO] Installing Asdf runtime env manager"
  export PATH="$PATH:$HOME/.asdf/bin" # can't just reload zinit, because it's waiting for prompt

	for plugin in direnv nodejs python rust golang java yarn poetry; do
		asdf plugin-add $plugin
	done

  asdf install
  export PATH="$PATH:$HOME/.asdf/shims"
}

syncConfig() {
	echo "[INFO] Symlinking dotfiles..."
	cd ..
	./macos-dotfiles
  source ~/.zprofile
  apply-shortcuts
	echo "[INFO] Applying mac settings..."
	cd -
	./mac_settings.sh
	mkdir -p ~/Documents/commercial/
	mkdir -p ~/Documents/personal/
  zsh -i -c -- '@zinit-scheduler burst'
}

installLunarvim() {
	echo "[INFO] Installing LunarVim"
	curl https://raw.githubusercontent.com/lunarvim/lunarvim/rolling/utils/installer/install.sh --output install_script.sh
	chmod +x install_script.sh
	LV_BRANCH=rolling ./install_script.sh -y
	rm install_script.sh
}

doIt() {
	installBrew
	updateBrew
	installSoftware
	syncConfig
	installAsdf
	installLunarvim
}

doIt

echo ""
echo "[INFO] If there isn't any error message, the process is completed."
echo "Now do manual yabai setup"
open -u https://github.com/koekeishiya/yabai/wiki/Disabling-System-Integrity-Protection
exec zsh
