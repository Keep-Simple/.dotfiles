return {
	{
		"tpope/vim-fugitive",
		cmd = {
			"G",
			"Git",
			"Gdiffsplit",
			"Gvdiffsplit",
			"Gdiff",
			"Gread",
			"Gclog",
			"Gwrite",
			"Ggrep",
			"GMove",
			"GDelete",
			"GBrowse",
			"GRemove",
			"GRename",
			"Glgrep",
			"Gedit",
		},
		ft = { "fugitive" },
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
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{
				"ojroques/vim-oscyank",
				keys = { { "<leader>Y", "<cmd>OSCYankVisual<cr>", desc = "OSC52 Copy (for ssh)", mode = "v" } },
			},
		},
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
					-- yank to unnamed register
					vim.api.nvim_command("let @\" = '" .. url .. "'")
					-- copy to the system clipboard using OSC52
					vim.fn.OSCYank(url)
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
