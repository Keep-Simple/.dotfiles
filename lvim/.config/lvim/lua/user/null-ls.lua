local null_ls = require("null-ls")
local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
	null_ls.builtins.formatting.prettierd.with({
		env = {
			PRETTIERD_LOCAL_PRETTIER_ONLY = 1,
		},
	}),
	null_ls.builtins.formatting.eslint_d.with({
		prefer_local = "node_modules/.bin",
	}),
	{ command = "black" },
	{ command = "stylua" },
	{ command = "rustfmt" },
	{ command = "gofmt" },
	{ command = "shfmt" },
	{ command = "qmlformat" },
})

local linters = require("lvim.lsp.null-ls.linters")
linters.setup({
	null_ls.builtins.diagnostics.eslint_d.with({
		prefer_local = "node_modules/.bin",
	}),
	{ command = "flake8" },
	{ command = "qmllint" },
})

local actions = require("lvim.lsp.null-ls.code_actions")
actions.setup({
	null_ls.builtins.code_actions.eslint_d.with({
		prefer_local = "node_modules/.bin",
	}),
})
