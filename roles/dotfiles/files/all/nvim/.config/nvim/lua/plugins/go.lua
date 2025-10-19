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
}
