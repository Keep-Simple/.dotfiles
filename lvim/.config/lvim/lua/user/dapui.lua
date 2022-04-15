local M = {}

M.config = function()
	local dapui = require("dapui")
	dapui.setup({
		icons = { expanded = "▾", collapsed = "▸" },
		mappings = {
			-- Use a table to apply multiple mappings
			expand = { "<CR>", "<2-LeftMouse>" },
			open = "o",
			remove = "d",
			edit = "e",
			repl = "r",
			toggle = "t",
		},
		sidebar = {
			-- You can change the order of elements in the sidebar
			elements = {
				-- Provide as ID strings or tables with "id" and "size" keys
				{
					id = "scopes",
					size = 0.55, -- Can be float or integer > 1
				},
				{ id = "breakpoints", size = 0.20 },
				{ id = "stacks", size = 0.15 },
				{ id = "watches", size = 00.10 },
			},
			size = 40,
			position = "left", -- Can be "left", "right", "top", "bottom"
		},
		tray = {
			elements = { "repl" },
			size = 12,
			position = "bottom", -- Can be "left", "right", "top", "bottom"
		},
		floating = {
			max_height = nil, -- These can be integers or a float between 0 and 1.
			max_width = nil, -- Floats will be treated as percentage of your screen.
			border = "single", -- Border style. Can be "single", "double" or "rounded"
			mappings = {
				close = { "q", "<Esc>" },
			},
		},
		windows = { indent = 1 },
	})

	local dap = require("dap")
	dap.listeners.after.event_initialized["dapui_config"] = function()
		dapui.open()
	end
	dap.listeners.before.event_terminated["dapui_config"] = function()
		dapui.close()
	end
	dap.listeners.before.event_exited["dapui_config"] = function()
		dapui.close()
	end
end

return M
