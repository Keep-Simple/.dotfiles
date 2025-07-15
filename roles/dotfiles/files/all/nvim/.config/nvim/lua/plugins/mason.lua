return {
	"mason-org/mason.nvim",
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
			"omnisharp",
			"json-lsp",
			"kotlin-language-server",
			"lua-language-server",
			"basedpyright",
			"rust-analyzer",
			"solidity",
			"html-lsp",
			"terraform-ls",
			"typescript-language-server",
			"vim-language-server",
			"yaml-language-server",
			"marksman",

			-- formatters and linters
			"shfmt",
			"taplo",
			"buf",
			"hadolint",
			"stylua",
			"prettierd",
			"eslint_d",
			"ruff",
			"ansible-lint",
			"fixjson",
			"beautysh", -- shell fmt
			"actionlint", -- github workflows linter
			"yamlfmt",
			"markdownlint",
		},
	},
}
