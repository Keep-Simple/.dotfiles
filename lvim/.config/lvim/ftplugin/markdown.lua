vim.cmd([[setlocal nospell]])
vim.cmd([[setlocal conceallevel=2]])
vim.list_extend(lvim.lsp.override, { "ltex", "tailwindcss" })
