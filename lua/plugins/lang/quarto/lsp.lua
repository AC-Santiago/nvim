local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

-- Configuración para Quarto LSP
vim.lsp.config("quarto", {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
    filetypes = { "quarto", "qmd" },
    root_dir = function(fname)
        return vim.fs.dirname(vim.fs.find({ "_quarto.yml", ".git" }, { upward = true, path = fname })[1])
    end,
})
