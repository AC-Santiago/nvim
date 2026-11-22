local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = vim.deepcopy(require("nvchad.configs.lspconfig").capabilities)

capabilities.workspace = capabilities.workspace or {}
capabilities.workspace.didChangeWatchedFiles = capabilities.workspace.didChangeWatchedFiles or {}
capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true

return {
    markdown_oxide = {
        on_attach = on_attach,
        on_init = on_init,
        capabilities = capabilities,
    },
}
