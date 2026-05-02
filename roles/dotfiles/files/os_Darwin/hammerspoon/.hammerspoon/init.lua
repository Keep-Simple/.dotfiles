require("hs.ipc")
if hs.ipc.cliInstall then
	pcall(hs.ipc.cliInstall)
end

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
Install:andUse("ClipboardTool", {
	config = {
		hist_size = 30,
		max_size = false,
		show_copied_alert = false,
		show_in_menubar = false,
	},
	start = true,
})

function ToggleClipboard()
	spoon.ClipboardTool:toggleClipboard()
end

hs.notify.show("Hammerspoon started", "", "")
