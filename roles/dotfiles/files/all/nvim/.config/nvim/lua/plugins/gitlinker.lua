return {
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
			print_url = false,
			action_callback = function(url)
				-- yank to unnamed register
				vim.api.nvim_command("let @\" = '" .. url .. "'")
				-- copy to the system clipboard using OSC52
				vim.fn.OSCYank(url)
			end,
		},
	},
}
