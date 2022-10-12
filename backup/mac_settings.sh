#!/bin/sh

cd $(dirname "${BASH_SOURCE[0]}")
# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

if [[ "$1" != "-d" ]]; then
	echo "Removing animations, applying settings"

	defaults write -g KeyRepeat -int 2
	defaults write -g InitialKeyRepeat -int 15
	defaults write -g NSAutomaticWindowAnimationsEnabled -bool false
	defaults write -g NSWindowResizeTime -float 0.001
	defaults write -g NSWindowResizeTime -float 0.001
	defaults write -g QLPanelAnimationDuration -float 0
	defaults write -g NSUseAnimatedFocusRing -bool false
	defaults write -g NSScrollViewRubberbanding -bool false
	defaults write -g NSDocumentRevisionsWindowTransformAnimation -bool false
	defaults write -g NSToolbarFullScreenAnimationDuration -float 0
	defaults write -g NSBrowserColumnAnimationSpeedMultiplier -float 0
	# Trackpad: enable tap to click for this user and for the login screen
	defaults -currentHost write -g com.apple.mouse.tapBehavior -int 1
	defaults write -g com.apple.mouse.tapBehavior -int 1
	defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
	# (e.g. enable Tab in modal dialogs)
	defaults write -g AppleKeyboardUIMode -int 3

	defaults write com.apple.dock mru-spaces -bool false # prevent spaces rearranging
	defaults write com.apple.dock autohide-delay -float 10
	defaults write com.apple.dock autohide -bool true
	defaults write com.apple.dock no-bouncing -bool true
	defaults write com.apple.dock mineffect -string "scale"
	defaults write com.apple.dock minimize-to-application -bool false
	defaults write com.apple.dock tilesize -int 1 # make the dock small
	defaults write com.apple.dock expose-group-by-app -bool false
	defaults write com.apple.dock show-recents -bool false
	defaults write com.apple.dock showhidden -bool true
	defaults write com.apple.dock expose-animation-duration -float 0.1

	defaults write com.apple.finder DisableAllAnimations -bool true
	defaults write com.apple.finder ShowPathbar -bool true
	defaults write com.apple.finder AppleShowAllFiles -bool true
	defaults write com.apple.universalaccess showWindowTitlebarIcons -bool false
	defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
	defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

	defaults write com.apple.LaunchServices LSQuarantine -bool false
	defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

	defaults import com.apple.symbolichotkeys ./mac_shortcuts
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
	defaults delete -g NSUseAnimatedFocusRing

	defaults delete com.apple.dock
	defaults delete com.apple.finder

	defaults delete com.apple.LaunchServices LSQuarantine

	defaults delete com.apple.symbolichotkeys AppleSymbolicHotKeys
fi

# Kill affected applications
for app in "Dock" \
	"Finder" \
	"SystemUIServer"; do
	killall "${app}" &
	>/dev/null
done
echo "Done. Note that some of these changes require a logout/restart to take effect."
