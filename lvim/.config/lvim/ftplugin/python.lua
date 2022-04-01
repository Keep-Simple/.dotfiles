local dap_install = require("dap-install")
dap_install.config("python", {})

local opts = {}

require("lvim.lsp.manager").setup("jedi_language_server", opts)
