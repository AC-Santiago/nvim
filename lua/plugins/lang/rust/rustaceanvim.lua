return {
    "mrcjkb/rustaceanvim",
    version = "^6",
    ft = { "rust" },
    config = function()
        vim.g.rustaceanvim = {
            -- Plugin configuration
            tools = {
                hover_actions = {
                    auto_focus = true,
                },
                inlay_hints = {
                    highlight = "NonText",
                },
                on_initialized = function()
                    vim.lsp.inlay_hint.enable(true)
                end,
                test_executor = "background",
            },
            server = {
                on_attach = function(client, bufnr)
                    vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr()")

                    if client.server_capabilities.documentHighlightProvider then
                        vim.cmd([[
                            augroup lsp_document_highlight
                                autocmd! * <buffer>
                                autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
                                autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
                            augroup END
                        ]])
                    end
                end,
                default_settings = {
                    -- rust-analyzer language server configuration
                    ["rust-analyzer"] = {
                        cargo = {
                            allFeatures = true,
                            loadOutDirsFromCheck = true,
                            runBuildScripts = true,
                        },
                        -- Habilitar checkOnSave
                        checkOnSave = true,
                        check = {
                            command = "clippy",
                            extraArgs = { "--all-targets", "--all-features" },
                        },
                        diagnostics = {
                            enable = true,
                            experimental = {
                                enable = true,
                            },
                        },
                        -- Habilitar procMacros
                        procMacro = {
                            enable = true,
                            ignored = {
                                ["async-trait"] = { "async_trait" },
                                ["napi-derive"] = { "napi" },
                                ["async-recursion"] = { "async_recursion" },
                            },
                        },
                        -- Configuraciones adicionales
                        lens = {
                            enable = true,
                            debug = true,
                            implementations = true,
                            run = true,
                            methodReferences = true,
                            references = true,
                        },
                        files = {
                            excludeDirs = {
                                ".direnv",
                                ".git",
                                ".github",
                                ".gitlab",
                                "bin",
                                "node_modules",
                                "target",
                                "venv",
                                ".venv",
                            },
                        },
                        workspace = {
                            symbol = {
                                search = {
                                    scope = "workspace_and_dependencies",
                                },
                            },
                        },
                    },
                },
            },
            -- DAP configuration
            dap = {
                autoload_configurations = true,
            },
        }
    end,
}
