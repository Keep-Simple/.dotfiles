return {
	"mikavilpas/yazi.nvim",
	event = "VeryLazy",
	dependencies = { "folke/snacks.nvim", lazy = true },
	keys = {
		{
			"<leader>e",
			mode = { "n", "v" },
			"<cmd>Yazi<cr>",
			desc = "Explorer",
		},
		{
			"<leader>E",
			"<cmd>Yazi toggle<cr>",
			desc = "Resume Explorer",
		},
	},
	opts = {
		open_for_directories = true,
	},
}
