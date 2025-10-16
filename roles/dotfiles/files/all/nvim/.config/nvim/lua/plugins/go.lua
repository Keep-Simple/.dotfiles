return {
	"nvim-neotest/neotest",
	optional = true,
	dependencies = {
		"fredrikaverpil/neotest-golang",
	},
	opts = {
		adapters = {
			["neotest-golang"] = {
				warn_test_name_dupes = true,
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
							hints = {
								assignVariableTypes = false,
								compositeLiteralFields = false,
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
