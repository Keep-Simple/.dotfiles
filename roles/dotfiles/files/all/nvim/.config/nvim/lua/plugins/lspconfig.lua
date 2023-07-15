return {
	"neovim/nvim-lspconfig",
	init = function()
		local keys = require("lazyvim.plugins.lsp.keymaps").get()
		keys[#keys + 1] = { "gs", vim.lsp.buf.signature_help, desc = "show signature help" }
		keys[#keys + 1] = {
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
		}
	end,
}
