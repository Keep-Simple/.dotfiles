-- Sudo save
return {
	"lambdalisue/suda.vim",
	dependencies = {
		"folke/which-key.nvim",
		opts = {
			prefixes = {
				["<leader>W"] = { name = "+save options" },
			},
		},
	},
	keys = {
		{ "<leader>Ws", "<cmd>SudaWrite<cr>", desc = "sudo save" },
		{ "<leader>Wn", "<cmd>noautocmd w<cr>", desc = "no format save" },
		{ "<leader>Wa", "<cmd>wa<cr>", desc = "save all" },
		{ "<leader>WN", "<cmd>noautocmd wa<cr>", desc = "no format save all" },
	},
}
