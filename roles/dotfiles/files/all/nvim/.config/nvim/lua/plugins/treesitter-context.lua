return {
	"nvim-treesitter/nvim-treesitter-context",
	opts = {
		max_lines = 0,
	},
	event = { "BufReadPost", "BufNewFile" },
	keys = {
		{
			"[o",
			function()
				require("treesitter-context").go_to_context()
			end,
			desc = "upwards jump (ts context)",
		},
	},
}
