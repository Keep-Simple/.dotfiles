return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			indent = {
				enable = true,
				disable = { "python" },
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		opts = {
			select = {
				-- Automatically jump forward to textobj, similar to targets.vim
				lookahead = true,
			},
		},
	},
}
