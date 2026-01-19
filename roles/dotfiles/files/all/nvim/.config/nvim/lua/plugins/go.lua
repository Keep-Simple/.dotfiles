return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"fredrikaverpil/neotest-golang",
		},
		opts = {
			adapters = {
				["neotest-golang"] = {
					warn_test_name_dupes = false,
					runner = "gotestsum",
				},
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				gopls = {
					settings = {
						gopls = {
							gofumpt = false, -- I'm using none-ls
							hints = {
								assignVariableTypes = false,
								compositeLiteralFields = true,
								compositeLiteralTypes = false,
								constantValues = false,
								functionTypeParameters = true,
								parameterNames = true,
								rangeVariableTypes = true,
							},
							staticcheck = false, -- I'm using golangci
						},
					},
				},
			},
		},
	},
	{
		"leoluz/nvim-dap-go",
		config = function()
			require("dap-go").setup()

			-- Fix: Replace nvim-dap-go's filtered_pick_process (which shows vim.ui.input + pick_process)
			-- with plain pick_process (single picker via dressing.nvim)
			vim.schedule(function()
				local dap = require("dap")
				if dap.configurations.go then
					for _, config in ipairs(dap.configurations.go) do
						if config.name == "Attach" and config.processId then
							config.processId = function()
								return require("dap.utils").pick_process()
							end
						end
					end
				end
			end)
		end,
	},
}
