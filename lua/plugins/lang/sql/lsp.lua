local on_attach = require("nvchad.configs.lspconfig").on_attach
local capabilities = require("nvchad.configs.lspconfig").capabilities

-- Configuration for sqlls
vim.lsp.config("sqlls", {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        sqlls = {},
    },
})
