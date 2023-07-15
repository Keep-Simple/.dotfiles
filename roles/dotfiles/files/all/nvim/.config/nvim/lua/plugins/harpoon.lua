return {
	"Keep-Simple/harpoon",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		require("harpoon").setup({ menu = {
			width = vim.api.nvim_win_get_width(0) - 20,
		} })
	end,
	keys = {
		{
			"<leader>a",
			"<cmd>lua require('harpoon.mark').add_file()<cr>",
			desc = "Add Mark",
		},
		{ "<leader><leader>", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", desc = "Harpoon" },
		{ "<leader>C", "<cmd>lua require('harpoon.cmd-ui').toggle_quick_menu()<cr>", desc = "Commands" },
	},
}
