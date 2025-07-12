-- Ejemplos adicionales de personalización para blink.cmp
-- Este archivo contiene configuraciones opcionales que puedes usar

local M = {}

-- Ejemplo 1: Agregar componente de ranking/score a la ventana
M.add_score_component = {
    score = {
        width = { max = 5 },
        text = function(ctx)
            return string.format("%.1f", ctx.score or 0)
        end,
        highlight = function(ctx)
            if (ctx.score or 0) > 0.8 then
                return "BlinkCmpScoreHigh"
            elseif (ctx.score or 0) > 0.5 then
                return "BlinkCmpScoreMed"
            else
                return "BlinkCmpScoreLow"
            end
        end,
    },
}

-- Ejemplo 2: Agregar indicador de disponibilidad del item
M.add_availability_indicator = {
    availability = {
        width = { max = 3 },
        text = function(ctx)
            if ctx.item.deprecated then
                return "⚠️"
            elseif ctx.item.preselect then
                return "⭐"
            else
                return "✓"
            end
        end,
        highlight = function(ctx)
            if ctx.item.deprecated then
                return "BlinkCmpDeprecated"
            elseif ctx.item.preselect then
                return "BlinkCmpPreselect"
            else
                return "BlinkCmpAvailable"
            end
        end,
    },
}

-- Ejemplo 3: Agregar información de detalle expandida
M.add_detail_component = {
    detail = {
        width = { max = 40 },
        text = function(ctx)
            local detail = ctx.item.detail or ""
            if #detail > 40 then
                return detail:sub(1, 37) .. "..."
            end
            return detail
        end,
        highlight = "BlinkCmpDetail",
    },
}

-- Ejemplo 4: Configuración de ventana con más columnas
M.extended_columns_config = {
    columns = {
        { "availability", "kind_icon", "label", gap = 1 },
        { "detail", "score", gap = 1 },
        { "source_name", gap = 1 },
    },
}

-- Ejemplo 5: Configuración de ventana minimalista
M.minimal_columns_config = {
    columns = {
        { "kind_icon", "label", gap = 1 },
    },
}

-- Ejemplo 6: Configuración de ventana con información completa
M.full_info_columns_config = {
    columns = {
        { "kind_icon", "label", "label_description", gap = 1 },
        { "detail", gap = 1 },
        { "kind", "source_name", gap = 1 },
    },
}

-- Ejemplo 7: Personalización de iconos por tipo de archivo
M.custom_file_icons = function(ctx)
    local filename = ctx.label
    local extension = filename:match("%.([^%.]+)$")

    local file_icons = {
        lua = "🌙",
        py = "🐍",
        js = "📜",
        ts = "🔷",
        json = "📋",
        md = "📝",
        html = "🌐",
        css = "🎨",
        scss = "🎨",
        vue = "💚",
        react = "⚛️",
        go = "🐹",
        rust = "🦀",
        cpp = "⚙️",
        c = "⚙️",
        java = "☕",
        php = "🐘",
        rb = "💎",
    }

    return file_icons[extension] or "📄"
end

-- Ejemplo 8: Configuración de bordes personalizados
M.custom_borders = {
    completion = {
        menu = {
            border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
        },
        documentation = {
            window = {
                border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
            },
        },
    },
}

-- Ejemplo 9: Configuración con transparencia
M.transparent_config = {
    completion = {
        menu = {
            winblend = 20, -- 20% de transparencia
            winhighlight = "Normal:Pmenu,FloatBorder:PmenuBorder,CursorLine:PmenuSel",
        },
    },
}

-- Ejemplo 10: Función para aplicar configuración personalizada
function M.apply_custom_config(config_name)
    local blink_cmp = require("blink.cmp")

    if config_name == "extended" then
        -- Aplicar configuración extendida
        blink_cmp.setup({
            completion = {
                menu = {
                    draw = {
                        columns = M.extended_columns_config.columns,
                        components = vim.tbl_extend(
                            "force",
                            require("blink.cmp.config").default.completion.menu.draw.components,
                            M.add_score_component,
                            M.add_availability_indicator,
                            M.add_detail_component
                        ),
                    },
                },
            },
        })
    elseif config_name == "minimal" then
        -- Aplicar configuración minimalista
        blink_cmp.setup({
            completion = {
                menu = {
                    draw = {
                        columns = M.minimal_columns_config.columns,
                    },
                },
            },
        })
    end
end

-- Ejemplo 11: Highlight groups adicionales para los nuevos componentes
M.additional_highlights = {
    BlinkCmpScoreHigh = { fg = "#50fa7b", bold = true },
    BlinkCmpScoreMed = { fg = "#ffb86c" },
    BlinkCmpScoreLow = { fg = "#6272a4" },
    BlinkCmpDeprecated = { fg = "#ff5555", strikethrough = true },
    BlinkCmpPreselect = { fg = "#f1fa8c", bold = true },
    BlinkCmpAvailable = { fg = "#50fa7b" },
    BlinkCmpDetail = { fg = "#8be9fd", italic = true },
}

-- Función para aplicar highlights adicionales
function M.setup_additional_highlights()
    for group, opts in pairs(M.additional_highlights) do
        vim.api.nvim_set_hl(0, group, opts)
    end
end

return M
