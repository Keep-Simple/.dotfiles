return {
	"danymat/neogen",
	dependencies = "nvim-treesitter/nvim-treesitter",
	config = true,
	opts = {
		snippet_engine = "luasnip",
	},
	keys = {
		{
			"<leader>cd",
			desc = "Generate docs",
			function()
				require("neogen").generate()
			end,
		},
	},
}
