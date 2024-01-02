return {
	"iamcco/markdown-preview.nvim",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	ft = { "markdown" },
	build = function()
		vim.fn["mkdp#util#install"]()
	end,
	init = function()
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "markdown",
			callback = function()
				vim.api.nvim_buf_set_keymap(
					0,
					"n",
					"<leader>m",
					"<cmd>MarkdownPreviewToggle<cr>",
					{ noremap = true, silent = true, desc = "Browser markdown preview" }
				)
			end,
		})
	end,
}
