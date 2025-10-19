local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

-- Configuracion para python
vim.lsp.config("html", {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,

    settings = {
        html = {
            format = {
                enable = true, -- Habilita el formateo
            },
            hover = {
                documentation = true, -- Habilita la documentación en hover
            },
            validate = true, -- Habilita la validación
        },
    },
})
