-- Live markdown preview in browser
return {
	"iamcco/markdown-preview.nvim",
	build = "cd app && npm install",
	ft = "markdown",
	cmd = { "MarkdownPreview" },
	dependencies = { "zhaozg/vim-diagram", "aklt/plantuml-syntax" },
	keys = {
		{ "<leader>m", "<cmd>MarkdownPreviewToggle<cr>", desc = "Live Markdown" },
	},
}
