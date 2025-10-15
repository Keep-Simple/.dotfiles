return {
	"mason-org/mason.nvim",
	opts = {
		ensure_installed = {
			"tree-sitter-cli",
			-- debugers
			"delve",
			"debugpy",
			"codelldb",

			-- lsp servers
			"bash-language-server",
			"ansible-language-server",
			"clangd",
			"gopls",
			"omnisharp",
			"json-lsp",
			"lua-language-server",
			"basedpyright",
			"rust-analyzer",
			"solidity",
			"html-lsp",
			"terraform-ls",
			"typescript-language-server",
			"vim-language-server",
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
			"beautysh", -- shell fmt
			"actionlint", -- github workflows linter
		},
	},
}
