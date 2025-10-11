require("hs.ipc")
hs.loadSpoon("SpoonInstall")
menubarIcon = hs.menubar.new(false, "MultiWindowIcon")
icon = hs.image.imageFromPath("./two-overlapping-square.png"):setSize({ w = 16, h = 16 })

menubarIcon:setIcon(icon)
function ToggleMultiWindowIcon(flag)
	if flag then
		menubarIcon:returnToMenuBar()
		menubarIcon:setIcon(icon)
	else
		menubarIcon:removeFromMenuBar()
	end
end

Install = spoon.SpoonInstall
Install:andUse("MicMute", {
	hotkeys = {
		toggle = { { "ctrl", "cmd", "alt" }, "m" },
	},
})
Install:andUse("ClipboardTool", {
	hotkeys = {
		toggle_clipboard = { { "ctrl", "cmd", "alt" }, "\\" },
	},
	config = {
		hist_size = 30,
		max_size = false,
		show_copied_alert = false,
		show_in_menubar = false,
	},
	start = true,
})

hs.notify.show("Hammerspoon started", "", "")
