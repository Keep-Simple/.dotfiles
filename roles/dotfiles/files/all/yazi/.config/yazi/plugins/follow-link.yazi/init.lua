return {
	entry = function()
		local h = cx.active.current.hovered
		local original_url = h.link_to
		if h and original_url then
			ya.manager_emit("cd", { original_url })
		end
	end,
}
