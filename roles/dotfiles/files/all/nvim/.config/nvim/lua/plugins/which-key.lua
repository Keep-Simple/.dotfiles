return {
	"folke/which-key.nvim",
	opts = {
		prefixes = {
			mode = { "n", "v" },
			["g"] = { name = "+goto" },
			["]"] = { name = "+next" },
			["["] = { name = "+prev" },
			["<leader><tab>"] = { name = "+tabs" },
			["<leader>c"] = { name = "+code" },
			["<leader>d"] = { name = "+debug" },
			["<leader>t"] = { name = "+test" },
			["<leader>g"] = { name = "+git" },
			["<leader>gh"] = { name = "+hunks" },
			["<leader>s"] = { name = "+search" },
			["<leader>u"] = { name = "+ui" },
			["<leader>x"] = { name = "+diagnostics/quickfix" },
		},
	},
	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)
		-- lazynvim has not extensible setup with opts.defaults.
		-- to avoid overwritting each default value, I just introduced my opts.prefixes
		wk.register(opts.prefixes)
	end,
}
