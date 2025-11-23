local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

-- Configuracion para python
vim.lsp.config("ruff", {
    on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        client.server_capabilities.hoverProvider = false -- Desactiva hover en Ruff
    end,
    trace = "messages",
    init_options = {
        settings = {
            logLevel = "warn",
            lint = {
                preview = true,
            },
            format = {
                preview = true,
            },
            args = {
                "--ignore",
                "F821",
                "--ignore",
                "E402",
                "--ignore",
                "E722",
                "--ignore",
                "E712",
            },
        },
    },
})

vim.lsp.config("pyrefly", {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,

    settings = {
        python = {
            analysis = {
                inlayHints = {
                    variableTypes = true,
                    callArgumentNames = "all",
                    functionReturnTypes = true,
                    genericTypes = true,
                    pytestParameters = true,
                },
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                autoImportCompletions = true,
                diagnosticMode = "workspace",
            },
        },
    },
})
