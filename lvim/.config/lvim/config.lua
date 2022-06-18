lvim.format_on_save = true

lvim.colorscheme = "onedarker"

require("user.keys")
require("user.bufferline")
require("user.plugins")
require("user.treesitter")
require("user.settings")
require("user.dap")
require("user.builtins")
require("user.null-ls")

require("lsp-servers.clangd")
require("lsp-servers.tsserver")

vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, {
	"clangd",
	"gopls",
	"rust_analyzer",
	"pyright",
	"tsserver",
})
