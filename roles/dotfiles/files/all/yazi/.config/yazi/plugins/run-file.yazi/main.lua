return {
	entry = function(_, job)
		local args = job.args
		if not args[1] then
			return
		end

		local block, with_args
		if args[1] == "1" then
			block = true
			with_args = false
		elseif args[1] == "2" then
			block = true
			with_args = true
		elseif args[1] == "3" then
			block = false
			with_args = true
		end

		if with_args then
			local cmd_args, event = ya.input({
				title = block and "Sync run with args:" or "Async run with args:",
				position = { "hovered", y = 1, w = 50 },
			})

			if event == 1 then
				ya.manager_emit("shell", {
					"$0 " .. cmd_args,
					block = block,
					confirm = true,
				})
			end
		else
			ya.manager_emit("shell", {
				"$0",
				block = block,
				confirm = true,
			})
		end
	end,
}
