local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

-- Astro LSP Configuration
-- El servidor LSP de Astro se instala a través de Mason como "astro"
vim.lsp.config("astro", {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,

    filetypes = { "astro" },

    init_options = {
        configuration = {
            -- Configuraciones del lenguaje Astro
            typescript = {
                -- Usar la versión de TypeScript del proyecto
                serverPath = "",
            },
            astro = {
                -- Habilitar completados de Astro
                completions = {
                    enabled = true,
                },
            },
        },
    },

    settings = {
        astro = {
            -- Habilitar diagnóstico automático
            diagnostics = {
                enable = true,
            },
            -- Completions
            completions = {
                enabled = true,
            },
            -- Habilitar hover
            hover = {
                enabled = true,
            },
        },
        -- Heredar configuraciones de TypeScript y JSON
        typescript = {
            inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
            },
        },
    },
})

-- Configurar Astro para que funcione correctamente con otros servidores
-- Astro usa TypeScript internamente, así que necesitamos coordinar con tsserver/vtsls
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("AstroLspCoordination", { clear = true }),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then return end

        -- Si es el servidor Astro, configurar el buffer
        if client.name == "astro" then
            -- Establecer configuraciones específicas del buffer para Astro
            vim.bo[args.buf].shiftwidth = 2
            vim.bo[args.buf].tabstop = 2
            vim.bo[args.buf].expandtab = true
        end
    end,
    desc = "Configure Astro LSP buffer settings",
})