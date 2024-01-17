return {
	"rcarriga/nvim-dap-ui",
	keys = {
		{
			"ge",
			require("dapui").eval,
			desc = "Eval",
			mode = { "n", "v" },
		},
		{
			"<leader>dU",
			function()
				require("dapui").toggle({ reset = true })
			end,
			desc = "Dap UI (reset size)",
		},
	},
	opts = {
		icons = { expanded = "▾", collapsed = "▸" },
		mappings = {
			expand = { "<CR>", "l" },
			open = "o",
			remove = "d",
			edit = "e",
			repl = "r",
			toggle = "t",
		},
		layouts = {
			{
				elements = {
					{ id = "scopes", size = 0.5 },
					{ id = "watches", size = 0.3 },
					{ id = "breakpoints", size = 0.1 },
					{ id = "stacks", size = 0.1 },
				},
				size = 0.28,
				position = "left",
			},
			{
				elements = {
					{ id = "console", size = 1 },
					-- { id = "console", size = 0.75 },
					-- { id = "repl", size = 0.25 },
				},
				size = 0.25,
				position = "bottom",
			},
			floating = {
				max_height = 0.9,
				max_width = 0.5, -- Floats will be treated as percentage of your screen.
				border = vim.g.border_chars, -- Border style. Can be 'single', 'double' or 'rounded'
				mappings = {
					close = { "q", "<Esc>" },
				},
			},
		},
	},
}
