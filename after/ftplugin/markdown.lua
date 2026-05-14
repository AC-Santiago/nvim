vim.opt.spell = true
vim.opt.spelllang = "es"

-- TreeSitter configuración
vim.treesitter.start()
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

vim.opt.conceallevel = 2

-- Patch obsidian-lsp capabilities para que solo markdown-oxide maneje gd/go-to-definition
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == "obsidian-ls" then
      client.server_capabilities.definitionProvider = false
      client.server_capabilities.referencesProvider = false
    end
  end,
})
