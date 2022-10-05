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
					{ id = "scopes", size = 0.33 },
					{ id = "breakpoints", size = 0.17 },
					{ id = "stacks", size = 0.25 },
					{ id = "watches", size = 0.25 },
				},
				size = 0.33,
				position = "left",
			},
			{
				elements = {
					"repl",
					-- "console",
				},
				size = 0.25,
				position = "bottom",
			},
			-- controls = {
			-- 	enabled = false,
			--      icons = nil,
			--      element = nil,
			-- element = "repl",
			-- icons = {
			-- 	pause = "",
			-- 	play = "",
			-- 	step_into = "",
			-- 	step_over = "",
			-- 	step_out = "",
			-- 	step_back = "",
			-- 	run_last = "↻",
			-- 	terminate = "□",
			-- },
			-- },
			floating = {
				max_height = 0.9,
				max_width = 0.5, -- Floats will be treated as percentage of your screen.
				border = vim.g.border_chars, -- Border style. Can be 'single', 'double' or 'rounded'
				mappings = {
					close = { "q", "<Esc>" },
				},
			},
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

	require("cmp").setup({
		enabled = function()
			return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or require("cmp_dap").is_dap_buffer()
		end,
	})

	require("cmp").setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
		sources = {
			{ name = "dap" },
		},
	})
end

return M
