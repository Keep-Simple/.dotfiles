return {
	"folke/which-key.nvim",
	opts = {
		defaults = {
			["<leader>q"] = false,
			["<leader>w"] = false,
			["gz"] = false,
		},
	},
	config = function(_, opts)
		local wk = require("which-key")
		local function filterTable(table)
			local filteredTable = {}
			for key, value in pairs(table) do
				if value ~= false then
					filteredTable[key] = value
				end
			end
			return filteredTable
		end

		wk.setup(opts)
		wk.register(filterTable(opts.defaults))
	end,
}
