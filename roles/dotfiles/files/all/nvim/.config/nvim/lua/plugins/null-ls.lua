local eslint_config = {
	prefer_local = "node_modules/.bin",
	condition = function(utils)
		return utils.root_has_file({
			".eslintrc.js",
			".eslintrc.cjs",
			".eslintrc.yaml",
			"eslintrc.yml",
			".eslintrc.json",
		})
	end,
}

return {
	"nvimtools/none-ls.nvim",
	opts = function(_, opts)
		local nls = require("null-ls")
		local base = nls.builtins
		local u = require("null-ls.utils")
		local h = require("null-ls.helpers")
		opts.sources = vim.list_extend(opts.sources or {}, {
			base.formatting.stylua,
			--base.formatting.rustfmt,
			base.formatting.qmlformat,
			base.formatting.buf,
			base.formatting.google_java_format,
			base.formatting.terraform_fmt,
			base.formatting.prettierd.with({
				env = {
					PRETTIERD_LOCAL_PRETTIER_ONLY = 1,
				},
				filetypes = {
					"javascript",
					"javascriptreact",
					"typescript",
					"typescriptreact",
					"vue",
					"css",
					"scss",
					"less",
					"html",
				},
			}),
			--base.formatting.eslint_d.with(eslint_config),
			base.formatting.isort.with({ prefer_local = ".venv/bin" }),
			base.formatting.black.with({
				prefer_local = ".venv/bin",
				cwd = h.cache.by_bufnr(function(params)
					return u.root_pattern("pyproject.toml")(params.bufname)
				end),
			}),

			--base.code_actions.eslint_d.with(eslint_config),
			base.code_actions.refactoring,

			--base.diagnostics.eslint_d.with(eslint_config),
			--base.diagnostics.flake8.with({ prefer_local = ".venv/bin" }),
			base.diagnostics.qmllint,
			base.diagnostics.buf,
			base.diagnostics.hadolint,
			base.diagnostics.terraform_validate,
			base.diagnostics.actionlint,
			base.diagnostics.golangci_lint.with({
				prefer_local = ".bin",
				method = nls.methods.DIAGNOSTICS_ON_SAVE,
				timeout = 10000, -- ms
			}),
			-- { name = "mypy", prefer_local = ".venv/bin" },
		})
	end,
}
