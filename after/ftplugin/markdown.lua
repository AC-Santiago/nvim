vim.opt.spell = true
vim.opt.spelllang = "es"

-- TreeSitter configuración
vim.treesitter.start()
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

vim.opt.conceallevel = 1
