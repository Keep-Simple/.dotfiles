local M = {}

M.config = function()
	require("neotest").setup({
		floating = {
			max_width = 0.8,
			max_height = 0.8,
		},
		output = {
			open_on_run = false,
		},
		discovery = {
			concurrent = 1,
			enabled = true,
		},
		summary = {
			follow = true,
			expand_errors = false,
			mappings = {
				attach = "a",
				expand = { "l" },
				expand_all = "L",
				jumpto = "<CR>",
				output = "o",
				short = "s",
				run = "r",
				mark = "m",
				run_marked = "R",
				clear_marked = "c",
				stop = "q",
			},
		},
		adapters = {
			require("neotest-python")({
				args = { "-vv", "-s" },
				runner = "pytest",
				dap = {
					justMyCode = false,
					-- env = { ["PYTHONPATH"] = vim.fn.getcwd() },
				},
			}),
			require("neotest-go"),
		},
	})
end

return M
