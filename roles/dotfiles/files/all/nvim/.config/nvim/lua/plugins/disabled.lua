local function disable_plugins(plugins)
	local disabled_plugins = {}
	for _, plugin in ipairs(plugins) do
		table.insert(disabled_plugins, { plugin, enabled = false })
	end
	return disabled_plugins
end

local plugins = {
	"folke/flash.nvim",
	"nvim-neo-tree/neo-tree.nvim",
	"RRethy/vim-illuminate",
	"echasnovski/mini.indentscope",
	"echasnovski/mini.surround",
	"echasnovski/mini.ai",
	"echasnovski/mini.pairs",
	"SmiteshP/nvim-navic",
	"akinsho/bufferline.nvim",
}

return disable_plugins(plugins)
