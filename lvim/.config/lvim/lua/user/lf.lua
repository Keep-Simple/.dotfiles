local M = {}

M.config = function()
	vim.cmd([[
    let g:lf_map_keys = 0
    let g:lf_replace_netrw = 1
    let g:lf_command_override = 'lf -command "set hidden"'
  ]])
end

return M
