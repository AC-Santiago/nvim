vim.opt.spell = true
vim.opt.spelllang = "es,en"

-- TreeSitter configuración
vim.b.molten_cell_delimiter = "```"
vim.b["quarto_is_r_mode"] = nil
vim.b["reticulate_running"] = false

vim.bo.commentstring = "<!-- %s -->"

-- wrap text, but by word no character
-- indent the wrappped line
vim.wo.wrap = true
vim.wo.linebreak = true
vim.wo.breakindent = true
vim.wo.showbreak = "|"
