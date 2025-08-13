local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require("lspconfig")

-- Configuracion para python
lspconfig.html.setup({
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
