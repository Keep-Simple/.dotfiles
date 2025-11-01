return {
	"folke/snacks.nvim",
	keys = {
		{
			"<leader>gp",
			function()
				Snacks.picker.gh_pr()
			end,
			desc = "GitHub Pull Requests (open)",
		},
		{
			"<leader>gP",
			function()
				Snacks.picker.gh_pr({ state = "all" })
			end,
			desc = "GitHub Pull Requests (all)",
		},
	},
	opts = {
		bigfile = { enabled = true },
		notifier = { enabled = true },
		indent = { enabled = false },
		quickfile = { enabled = true },
		statuscolumn = { enabled = true },
		words = { enabled = true },
		scroll = { enabled = false },
		dashboard = { enabled = false },
		gh = { enabled = true },
	},
}
