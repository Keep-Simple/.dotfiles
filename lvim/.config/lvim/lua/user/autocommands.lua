lvim.autocommands = {
	-- could also created file fugitive.lua in ftplugin
	{
		"FileType",
		{
			pattern = { "fugitive" },
			callback = function()
				vim.cmd([[
          nnoremap <silent> <buffer> q :close<CR>
          set nobuflisted
        ]])
			end,
		},
	},
	{
		"FileType",
		{
			pattern = { "gitcommit" },
			callback = function()
				vim.cmd([[
          nnoremap <silent> <buffer> <leader>w :noautocmd w<CR>
        ]])
			end,
		},
	},
	{
		"BufWritePost",
		{
			pattern = { "*/.vscode/launch.json" },
			callback = function()
				require("dap.ext.vscode").load_launchjs()
			end,
		},
	},
	-- {
	-- 	{ "BufWinEnter", "BufRead", "BufNewFile" },
	-- 	{
	-- 		group = "_format_options",
	-- 		pattern = "*",
	-- 		command = "setlocal formatoptions-=c formatoptions-=r formatoptions-=o",
	-- 	},
	-- },
}
