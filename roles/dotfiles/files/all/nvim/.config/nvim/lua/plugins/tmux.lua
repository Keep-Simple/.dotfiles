return {
	"alexghergh/nvim-tmux-navigation",
	keys = {
		{ "<M-h>", "<esc><cmd>NvimTmuxNavigateLeft<cr>", mode = { "n", "v", "i", "t" } },
		{ "<M-l>", "<esc><cmd>NvimTmuxNavigateRight<cr>", mode = { "n", "v", "i", "t" } },
		{ "<M-j>", "<esc><cmd>NvimTmuxNavigateDown<cr>", mode = { "n", "v", "i", "t" } },
		{ "<M-k>", "<esc><cmd>NvimTmuxNavigateUp<cr>", mode = { "n", "v", "i", "t" } },
	},
	opts = {
		disable_when_zoomed = true,
	},
}
