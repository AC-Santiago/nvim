return {
    "mrcjkb/rustaceanvim",
    version = "^6", -- Recommended
    ft = { "rust" },
    config = function()
        vim.g.rustaceanvim = {
            -- Plugin configuration
            tools = {
                hover_actions = {
                    auto_focus = true,
                },
                code_actions = {
                    ui_select_fallback = true,
                },
                -- Ejecutar tests en background y mostrar los resultados como diagnósticos
                test_executor = "background", -- Puede ser "background", "quickfix" o "terminal"
                -- float term settings
                float_win_config = {
                    border = "rounded",
                    -- Ajuste de estilo para las ventanas flotantes
                    style = "minimal",
                    row = 1,
                    col = 1,
                    width = math.floor(vim.o.columns * 0.8),
                    height = math.floor(vim.o.lines * 0.8),
                },
            },
            -- Configuración del servidor LSP
            server = {
                on_attach = function(client, bufnr)
                    -- Habilitar completion activada por el servidor LSP
                    vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
                end,

                -- Configuración por defecto de rust-analyzer
                default_settings = {
                    ["rust-analyzer"] = {
                        cargo = {
                            allFeatures = true,
                            loadOutDirsFromCheck = true,
                            runBuildScripts = true,
                        },
                        -- Habilitar características experimentales
                        checkOnSave = {
                            command = "clippy",
                            allFeatures = true,
                        },
                        procMacro = {
                            enable = true,
                            ignored = {
                                ["async-trait"] = { "async_trait" },
                                ["napi-derive"] = { "napi" },
                                ["async-recursion"] = { "async_recursion" },
                            },
                        },
                        diagnostics = {
                            enable = true,
                            experimental = {
                                enable = true,
                            },
                        },
                        inlayHints = {
                            enable = true,
                            typeHints = true,
                            parameterHints = true,
                            chainingHints = true,
                        },
                        hover = {
                            actions = {
                                enable = true,
                                debug = true,
                                gotoTypeDef = true,
                                implementations = true,
                                run = true,
                            },
                        },
                        completion = {
                            autoimport = {
                                enable = true,
                            },
                            autoself = {
                                enable = true,
                            },
                            postfix = {
                                enable = true,
                            },
                        },
                    },
                },
            },
            -- Configuración del DAP (Debug Adapter Protocol)
            dap = {
                autoload_configurations = true, -- Cargar configuraciones DAP automáticamente
            },
        }
    end,
}
