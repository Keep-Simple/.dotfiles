-- :Codi [name] opens buffers with [name] language interpreter
return {
	"metakirby5/codi.vim",
	cmd = "Codi",
	config = function()
		vim.cmd([[
    let g:codi#interpreters = {
    \ 'python': {
        \ 'bin': 'python',
        \ 'prompt': '^\(>>>\|\.\.\.\) ',
        \ },
    \ }
  ]])
	end,
}
