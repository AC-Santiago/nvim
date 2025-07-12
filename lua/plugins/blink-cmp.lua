local icons = function()
    local icons_nvchad = require("nvchad.icons.lspkind")
    local icons = {}
    for kind, icon in pairs(icons_nvchad) do
        if type(icon) == "string" then
            icons[kind] = icon
        elseif type(icon) == "table" then
            icons[kind] = icon[1] -- Usar el primer ícono de la tabla
        end
    end
    return icons
end
return {
    { import = "nvchad.blink.lazyspec" },
    {
        "Saghen/blink.cmp",
        dependencies = {
            "fang2hou/blink-copilot",
            "rcarriga/cmp-dap",
            "Kaiser-Yang/blink-cmp-avante",
            "ribru17/blink-cmp-spell",
            {
                "saghen/blink.compat",
                version = "2.*",
                lazy = true,
                opts = {},
            },
        },
        opts = {
            sources = {
                default = function()
                    local sources = { "lazydev", "copilot", "avante", "lsp", "path", "snippets", "buffer" }
                    -- Add spell source when spell is enabled in the buffer
                    if vim.wo.spell then
                        table.insert(sources, "spell")
                    end
                    if require("cmp_dap").is_dap_buffer() then
                        return vim.list_extend(sources, { "dap" })
                    else
                        return sources
                    end
                end,
                providers = {
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        score_offset = 100,
                    },
                    copilot = {
                        name = "copilot",
                        module = "blink-copilot",
                        score_offset = 100,
                        async = true,
                        opts = {
                            max_completions = 1,
                            max_attempts = 2,
                        },
                    },
                    avante = {
                        module = "blink-cmp-avante",
                        name = "Avante",
                        opts = {},
                    },
                    dap = {
                        name = "dap",
                        module = "blink.compat.source",
                    },
                    spell = {
                        name = "Spell",
                        module = "blink-cmp-spell",
                        opts = {
                            max_entries = 5,
                            preselect_current_word = true,
                            keep_all_entries = false,
                            use_cmp_spell_sorting = true,
                            enable_in_context = function()
                                if not vim.wo.spell then
                                    return false
                                end

                                local has_ts, ts = pcall(require, "vim.treesitter")
                                if not has_ts then
                                    return true
                                end

                                local curpos = vim.api.nvim_win_get_cursor(0)
                                local ok, captures = pcall(ts.get_captures_at_pos, 0, curpos[1] - 1, curpos[2] - 1)

                                if not ok then
                                    return true
                                end

                                local in_spell_capture = false
                                for _, cap in ipairs(captures) do
                                    if cap.capture == "spell" then
                                        in_spell_capture = true
                                    elseif cap.capture == "nospell" then
                                        return false
                                    end
                                end

                                if not in_spell_capture then
                                    for _, cap in ipairs(captures) do
                                        if cap.capture == "comment" or cap.capture == "string" then
                                            return true
                                        end
                                    end
                                end

                                return in_spell_capture
                            end,
                        },
                        -- Transformar los items para añadir ícono y estilo distintivo
                        transform_items = function(_, items)
                            for _, item in ipairs(items) do
                                -- Añadir ícono de spell check
                                item.kind = vim.lsp.protocol.CompletionItemKind.Text

                                -- Modificar la etiqueta para incluir ícono
                                if item.preselect then
                                    -- Para la palabra actual correcta
                                    item.label = "✓ " .. item.label
                                    item.labelDetails = {
                                        detail = " [Correcta]",
                                        description = "Ortografía",
                                    }
                                else
                                    -- Para sugerencias de corrección
                                    item.label = "📝 " .. item.label
                                    item.labelDetails = {
                                        detail = " [Sugerencia]",
                                        description = "Ortografía",
                                    }
                                end

                                -- Añadir información adicional
                                item.detail = "Corrección ortográfica"

                                -- Modificar el menú para que sea más distintivo
                                item.menu = "Spell"
                            end
                            return items
                        end,
                    },
                },
            },

            -- Configuración de apariencia personalizada
            appearance = {
                use_nvim_cmp_as_default = true,
                nerd_font_variant = "mono",

                kind_icons = icons(),
            },

            -- Configuración de ordenamiento optimizada
            fuzzy = {
                sorts = {
                    function(a, b)
                        local sort = require("blink.cmp.fuzzy.sort")
                        if a.source_id == "spell" and b.source_id == "spell" then
                            return sort.label(a, b)
                        end
                        if a.source_id == "spell" and b.source_id == "buffer" then
                            return true
                        elseif a.source_id == "buffer" and b.source_id == "spell" then
                            return false
                        end
                    end,
                    "score",
                    "kind",
                    "label",
                },
            },

            -- Configuración de ventana personalizada
            completion = {
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 200,
                    window = {
                        border = "rounded",
                        max_width = 60,
                        max_height = 20,
                    },
                },
                menu = {
                    border = "rounded",
                    winblend = 0, -- Transparencia de la ventana
                    scrollbar = true,
                    direction_priority = { "s", "n" },
                    auto_show = true,
                    draw = {
                        columns = {
                            { "kind_icon", "label", "label_description", gap = 1 },
                            { "kind", "source_name", gap = 1 },
                        },
                        components = {
                            kind_icon = {
                                ellipsis = false,
                                text = function(ctx)
                                    -- Iconos personalizados por fuente
                                    if ctx.source_id == "spell" then
                                        return ctx.item.preselect and "✓" or "📝"
                                    elseif ctx.source_id == "avante" then
                                        return "🧠"
                                    end
                                    return ctx.kind_icon .. ctx.icon_gap
                                end,
                            },
                            label = {
                                width = { fill = true, max = 60 },
                                text = function(ctx)
                                    return ctx.label .. ctx.label_detail
                                end,
                                highlight = function(ctx)
                                    -- Resaltar matches
                                    return ctx.deprecated and "BlinkCmpLabelDeprecated" or "BlinkCmpLabel"
                                end,
                            },
                            label_description = {
                                width = { max = 30 },
                                text = function(ctx)
                                    return ctx.label_description
                                end,
                                highlight = "BlinkCmpLabelDescription",
                            },
                            kind = {
                                width = { max = 10 },
                                text = function(ctx)
                                    return ctx.kind
                                end,
                                highlight = function(ctx)
                                    return "BlinkCmpKind" .. ctx.kind
                                end,
                            },
                            source_name = {
                                width = { max = 15 },
                                text = function(ctx)
                                    -- Nombres personalizados de fuentes
                                    local source_names = {
                                        spell = "Spell",
                                        copilot = "Copilot",
                                        avante = "AI",
                                        path = "Path",
                                        buffer = "Buffer",
                                        snippets = "Snippet",
                                        lsp = "LSP",
                                        lazydev = "Dev",
                                        dap = "DAP",
                                    }
                                    return "[" .. (source_names[ctx.source_id] or ctx.source_name) .. "]"
                                end,
                            },
                        },
                    },
                },
            },
        },
    },
}
