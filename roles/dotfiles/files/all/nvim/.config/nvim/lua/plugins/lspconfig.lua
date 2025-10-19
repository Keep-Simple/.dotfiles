return {
	"neovim/nvim-lspconfig",
	opts = function(_, opts)
		opts.format.timeout_ms = 8000
		opts.codelens.enabled = true
		local keys = require("lazyvim.plugins.lsp.keymaps").get()
		table.remove(keys, 9) -- remove <C-k>
		vim.list_extend(keys, {
			{ "gs", vim.lsp.buf.signature_help, desc = "show signature help" },
			{
				"gl",
				function()
					local float = vim.diagnostic.config().float

					if float then
						local config = type(float) == "table" and float or {}
						config.scope = "line"

						vim.diagnostic.open_float(config)
					end
				end,
				desc = "Show line diagnostics",
			},
			{
				"gd",
				function()
					Snacks.picker.lsp_definitions()
				end,
				desc = "Goto Definition",
				has = "definition",
			},
			{
				"gr",
				function()
					Snacks.picker.lsp_references()
				end,
				nowait = true,
				desc = "References",
			},
			{
				"gI",
				function()
					Snacks.picker.lsp_implementations()
				end,
				desc = "Goto Implementation",
			},
			{
				"gy",
				function()
					Snacks.picker.lsp_type_definitions()
				end,
				desc = "Goto T[y]pe Definition",
			},
			{
				"<leader>ss",
				function()
					Snacks.picker.lsp_symbols({ filter = LazyVim.config.kind_filter })
				end,
				desc = "LSP Symbols",
				has = "documentSymbol",
			},
			{
				"<leader>sS",
				function()
					Snacks.picker.lsp_workspace_symbols({ filter = LazyVim.config.kind_filter })
				end,
				desc = "LSP Workspace Symbols",
				has = "workspace/symbols",
			},
		})
	end,
}
