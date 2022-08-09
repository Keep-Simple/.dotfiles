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
		expand_lines = vim.fn.has("nvim-0.7"),
		layouts = {
			{
				elements = {
					"scopes",
					"breakpoints",
					"watches",
					"stacks",
				},
				size = 0.3,
				position = "left",
			},
			{
				elements = {
					"repl",
					-- "console",
				},
				size = 0.2,
				position = "bottom",
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
		},
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
		dap.repl.toggle()
	end
	dap.listeners.before.event_exited["dapui_config"] = function()
		dapui.close()
		dap.repl.toggle()
	end
end

return M
