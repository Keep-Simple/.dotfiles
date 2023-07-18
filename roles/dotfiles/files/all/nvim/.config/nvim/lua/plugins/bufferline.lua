return {
	"akinsho/bufferline.nvim",
	keys = {
		{ "<C-l>", "<cmd>BufferLineCycleNext<cr>" },
		{ "<C-h>", "<cmd>BufferLineCyclePrev<cr>" },
		{ "<C-S-l>", "<cmd>BufferLineMoveNext<cr>" },
		{ "<C-S-h>", "<cmd>BufferLineMovePrev<cr>" },
		{
			"<C-q>",
			function()
				require("mini.bufremove").delete(0, false)
			end,
		},
		{ "<leader>bh", "<cmd>BufferLineCloseLeft<cr>", desc = "Close all to the left" },
		{ "<leader>bl", "<cmd>BufferLineCloseRight<cr>", desc = "Close all to the right" },
	},
}