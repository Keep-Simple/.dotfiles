local M = {}

M.config = function()
	require("neotest").setup({
		icons = {
			running = "🏃",
			passed = "✨",
			failed = "❗",
			skipped = "💤",
		},
		floating = {
			max_width = 0.8,
			max_height = 0.8,
		},
		output = {
			open_on_run = false,
		},
		summary = {
			expand_errors = true,
			follow = true,
			mappings = {
				attach = "a",
				expand = { "l" },
				expand_all = "e",
				jumpto = "<CR>",
				output = "o",
				short = "O",
				run = "r",
				stop = "q",
			},
		},
		adapters = {
			require("neotest-python")({
				args = { "-vv", "-s" },
				runner = "pytest",
				dap = {
					justMyCode = false,
					env = { ["PYTHONPATH"] = vim.fn.getcwd() },
				},
			}),
			require("neotest-go"),
		},
	})
end

return M
