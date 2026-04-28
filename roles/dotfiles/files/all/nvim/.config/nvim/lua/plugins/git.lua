return {
	{
		"tpope/vim-fugitive",
		lazy = false,
		keys = {
			{
				"<leader>gm",
				"<cmd>Git<cr>",
				desc = "Git menu",
			},
		},
	},
	{
		"ruifm/gitlinker.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		lazy = true,
		keys = {
			{
				"<leader>gy",
				function()
					require("gitlinker").get_buf_range_url("n")
				end,
				desc = "Copy link",
				mode = "n",
			},
			{
				"<leader>gy",
				function()
					require("gitlinker").get_buf_range_url("v")
				end,
				desc = "Copy link",
				mode = "v",
			},
		},
		opts = {
			opts = {
				mappings = nil,
				print_url = false,
				add_current_line_on_normal_mode = false,
				action_callback = function(url)
					vim.fn.setreg('"', url)
					vim.fn.setreg("+", url)
				end,
			},
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		dependencies = {
			"folke/snacks.nvim",
		},
		opts = {
			current_line_blame = true,
		},
	},
	{
		"sindrets/diffview.nvim",
		keys = {
			{
				"<leader>gM",
				"<cmd>DiffviewOpen origin/HEAD<cr>",
				desc = "Diff against main (origin/HEAD)",
			},
		},
		opts = {
			file_panel = {
				win_config = {
					win_opts = {
						relativenumber = true,
						number = true,
					},
				},
			},
		},
		cmd = {
			"DiffviewClose",
			"DiffviewOpen",
			"DiffviewFileHistory",
		},
	},
}
