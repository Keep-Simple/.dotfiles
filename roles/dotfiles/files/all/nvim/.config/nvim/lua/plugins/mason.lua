return {
	"williamboman/mason.nvim",
	opts = {
		ensure_installed = {
			-- debugers
			"chrome-debug-adapter",
			"delve",
			"debugpy",
			"node-debug2-adapter",
			"codelldb",

			-- lsp servers
			"bash-language-server",
			"ansible-language-server",
			"clangd",
			"gopls",
			"json-lsp",
			"kotlin-language-server",
			"lua-language-server",
			"pyright",
			"rust-analyzer",
			"solidity",
			"html-lsp",
			"tailwindcss-language-server",
			"terraform-ls",
			"typescript-language-server",
			"vim-language-server",
			"yaml-language-server",
			"marksman",

			-- formatters and linters
			"shfmt",
			"taplo",
			"buf",
			"stylua",
			"prettierd",
			"eslint_d",
			"flake8",
			"black",
			"isort",
			"ansible-lint",
			"fixjson",
			"beautysh", -- shell fmt
			"actionlint", -- github workflows linter
			"yamlfmt",
			"markdownlint",
		},
	},
}
