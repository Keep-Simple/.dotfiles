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
}
