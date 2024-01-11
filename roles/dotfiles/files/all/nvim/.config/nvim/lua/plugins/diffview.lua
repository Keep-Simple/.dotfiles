return {
	"sindrets/diffview.nvim",
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
}
