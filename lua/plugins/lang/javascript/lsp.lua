local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local organize_imports = function()
    local params = {
        command = "_typescript.organizeImports",
        arguments = { vim.api.nvim_buf_get_name(0) },
    }
    vim.lsp.buf.execute_command(params)
end

vim.lsp.config("vtsls", {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,

    filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact" },

    init_options = {
        preferences = {
            disableSuggestions = true,
            importModuleSpecifierPreference = "relative",
        },
    },

    settings = {
        javascript = {
            format = {
                enable = false,
            },
        },
        typescript = {
            format = {
                enable = false,
            },
        },
    },
    commands = {
        OrganizeImports = {
            organize_imports,
            description = "Organize Imports",
        },
    },
})
