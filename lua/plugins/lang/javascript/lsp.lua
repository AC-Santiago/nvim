local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local function organize_imports(_, context)
    local client = vim.lsp.get_client_by_id(context.client_id)
    if client then
        client:exec_cmd({
            command = "_typescript.organizeImports",
            arguments = { vim.api.nvim_buf_get_name(context.bufnr) },
        }, { bufnr = context.bufnr })
    end
end

return {
    vtsls = {
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
            OrganizeImports = organize_imports,
        },
    },
}
