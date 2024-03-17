require("hs.ipc")
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

hs.notify.show("Hammerspoon started", "", "")
