lvim.format_on_save = true

lvim.colorscheme = "onedarker"

require("user.keys")
require("user.plugins")
require("user.treesitter")
require("user.settings")
require("user.dap")
require("user.builtins")
require("user.null-ls")
-- for gui
require("user.neovide")

vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, {
	"clangd",
	"gopls",
	"rust_analyzer",
	"pyright",
	"tsserver",
})
