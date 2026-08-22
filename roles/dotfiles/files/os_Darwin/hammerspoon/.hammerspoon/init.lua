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

BRIO_MIC_NAME = "Logitech BRIO"

function PreferBrioMic()
	local brio = hs.audiodevice.findInputByName(BRIO_MIC_NAME)
	if not brio then
		return
	end
	local current = hs.audiodevice.defaultInputDevice()
	if not current or current:name() ~= BRIO_MIC_NAME then
		brio:setDefaultInputDevice()
	end
end

-- ponytail: no unplug fallback, macOS already auto-switches input away from a disconnected device
-- "dIn " catches default-input hijacks (e.g. iPhone Continuity mic), "dev#" catches BRIO plug-in
hs.audiodevice.watcher.setCallback(function(event)
	if event == "dev#" or event == "dIn " then
		PreferBrioMic()
	end
end)
hs.audiodevice.watcher.start()
PreferBrioMic()

hs.notify.show("Hammerspoon started", "", "")
