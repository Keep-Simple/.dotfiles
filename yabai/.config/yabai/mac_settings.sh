#!/bin/sh

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
# sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
# while true; do
# 	sudo -n true
# 	sleep 60
# 	kill -0 "$$" || exit
# done 2>/dev/null &

if [[ "$1" != "-d" ]]; then
	echo "Removing animations, applying settings"
	defaults write -g KeyRepeat -int 2
	defaults write -g InitialKeyRepeat -int 15
	defaults write -g NSAutomaticWindowAnimationsEnabled -bool false
	defaults write -g NSWindowResizeTime -float 0.001
	defaults write -g NSWindowResizeTime -float 0.001
	defaults write -g QLPanelAnimationDuration -float 0
	defaults write -g NSScrollViewRubberbanding -bool false
	defaults write -g NSDocumentRevisionsWindowTransformAnimation -bool false
	defaults write -g NSToolbarFullScreenAnimationDuration -float 0
	defaults write -g NSBrowserColumnAnimationSpeedMultiplier -float 0

	defaults write com.apple.dock mru-spaces -bool false # prevent spaces rearranging
	defaults write com.apple.dock autohide-delay -float 10
	defaults write com.apple.dock autohide -bool true
	defaults write com.apple.dock no-bouncing -bool true
	defaults write com.apple.dock mineffect -string "scale"
	defaults write com.apple.dock minimize-to-application -bool false
	defaults write com.apple.dock tilesize -int 1 # make the dock small
	defaults write com.apple.dock show-recents -bool false
	defaults write com.apple.dock showhidden -bool true

	defaults write com.apple.finder DisableAllAnimations -bool true
	defaults write com.apple.finder ShowPathbar -bool true
	defaults write com.apple.finder AppleShowAllFiles -bool true
	defaults write com.apple.universalaccess showWindowTitlebarIcons -bool false
	defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
	defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

	defaults write com.apple.LaunchServices LSQuarantine -bool false
else
	echo "Back to the defaults"
	defaults delete -g KeyRepeat
	defaults delete -g InitialKeyRepeat
	defaults delete -g NSWindowResizeTime
	defaults delete -g NSAutomaticWindowAnimationsEnabled
	defaults delete -g NSWindowResizeTime
	defaults delete -g QLPanelAnimationDuration
	defaults delete -g NSScrollViewRubberbanding
	defaults delete -g NSDocumentRevisionsWindowTransformAnimation
	defaults delete -g NSToolbarFullScreenAnimationDuration
	defaults delete -g NSBrowserColumnAnimationSpeedMultiplier

	defaults delete com.apple.dock
	defaults delete com.apple.finder

	defaults delete com.apple.LaunchServices LSQuarantine
fi

# Kill affected applications
for app in "Dock" \
	"Finder"; do
	killall "${app}" &
	>/dev/null
done
echo "Done. Note that some of these changes require a logout/restart to take effect."
