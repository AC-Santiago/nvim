local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

vim.lsp.config("marksman", {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,

    init_options = {
        -- Wiki links
        wiki_links = {
            warn_on_ambiguous_reference = false,
            warn_on_duplicate_heading = false,
        },

        -- Completado
        completion = {
            wiki = {
                complete_sections = false,
                complete_by_heading = false,
            },
        },
    },
})
