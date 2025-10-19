return {
	"mason-org/mason.nvim",
	opts = {
		PATH = "append",
		ensure_installed = {
			-- other
			"tree-sitter-cli",
			"gotestsum",

			-- debugers
			"debugpy",
			"codelldb",

			-- lsp servers
			"bash-language-server",
			"ansible-language-server",
			"clangd",
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
			"golangci-lint-langserver",
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
			"golangci-lint",
		},
	},
}
