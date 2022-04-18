local M = {}

M.config = function()
	local dapui = require("dapui")
	dapui.setup({
		icons = { expanded = "▾", collapsed = "▸" },
		mappings = {
			expand = { "<CR>", "l" },
			open = "o",
			remove = "d",
			edit = "e",
			repl = "r",
			toggle = "t",
		},
		sidebar = {
			elements = {
				{
					id = "scopes",
					size = 1.5, -- Can be float or integer > 1
				},
				{ id = "breakpoints", size = 0.20 },
				-- { id = "stacks", size = 0.15 },
				-- { id = "watches", size = 0.10 },
			},
			size = 50,
			position = "left",
		},
		tray = {
			elements = { "repl" },
			size = 15,
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
		vim.cmd([[
      vnoremap ge <Cmd>lua require("dapui").eval()<CR>
      map ge <Cmd>lua require("dapui").eval()<CR>
    ]])
		dapui.open()
	end
	dap.listeners.before.event_terminated["dapui_config"] = function()
		dapui.close()
		dap.repl.close()
	end
	dap.listeners.before.event_exited["dapui_config"] = function()
		dapui.close()
		dap.repl.close()
	end
end

return M
