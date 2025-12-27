vim.opt.spell = true
vim.opt.spelllang = "es,en"

-- TreeSitter configuración
vim.treesitter.start()
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- Quarto specific settings
vim.opt_local.wrap = true
vim.opt_local.linebreak = true
