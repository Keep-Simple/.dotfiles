local M = {}

M.config = function()
	vim.cmd([[
    let g:floaterm_title=''
    let g:floaterm_width=0.8
    let g:floaterm_height=0.8
  ]])
end

return M
