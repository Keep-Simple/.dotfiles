-- Live markdown preview in browser
return {
	"iamcco/markdown-preview.nvim",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	ft = { "markdown" },
	lazy = true,
	build = function()
		vim.fn["mkdp#util#install"]()
	end,
	keys = {
		{ "<leader>m", "<cmd>MarkdownPreviewToggle<cr>", desc = "Live Markdown" },
	},
}
