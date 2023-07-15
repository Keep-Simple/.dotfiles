return {
	"tpope/vim-fugitive",
	cmd = {
		"G",
		"Git",
		"Gdiffsplit",
		"Gread",
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
}
