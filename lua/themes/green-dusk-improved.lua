-- Green Dusk
---@type Base46Table
local M = {}

M.base_30 = {
    -- Fondos (progresión de más oscuro a más claro)
    white = "#E2F5DF", -- Texto principal (mejor contraste)
    black = "#07120B", -- Fondo principal
    darker_black = "#031009", -- Fondo más oscuro
    black2 = "#0C2518", -- Fondo secundario (ajustado)
    one_bg = "#10301F", -- Un nivel más claro
    one_bg2 = "#1A3F2F", -- Dos niveles más claro
    one_bg3 = "#26503F", -- Tres niveles más claro

    -- Grises verdosos (mejor progresión)
    grey = "#3A6050", -- Gris base
    grey_fg = "#658B75", -- Gris foreground (mejor contraste)
    grey_fg2 = "#85AB95", -- Gris foreground claro
    light_grey = "#D5F0E5", -- Gris muy claro

    line = "#10301F", -- Línea divisoria

    -- Paleta Verde Cohesiva (reducida a 4 tonos principales)
    green = "#5FD080", -- Verde principal (más vibrante)
    vibrant_green = "#7FE99A", -- Verde acento brillante
    teal = "#4FB6A1", -- Verde-azul neutro
    forest_green = "#2D5A3D", -- Verde oscuro para fondos especiales

    -- Colores de Estado (más consistentes)
    red = "#E85D75", -- Rojo error (mejor contraste)
    orange = "#D4965C", -- Naranja warning (ajustado)
    yellow = "#D1DC6A", -- Amarillo info (más brillante)

    -- Colores Secundarios (más neutros y coherentes)
    baby_pink = "#FF9FA8", -- Mantenido
    pink = "#A8C4B8", -- Rosa más neutro y verdoso

    nord_blue = "#4FB6A1", -- Unificado con teal
    blue = "#3EAAA0", -- Azul principal (ajustado)
    seablue = "#3EAAA0", -- Unificado con blue

    sun = "#D1DC6A", -- Unificado con yellow
    purple = "#8BC4A0", -- Púrpura más verdoso
    dark_purple = "#2D4538", -- Púrpura oscuro ajustado

    cyan = "#6DD4B5", -- Cyan más brillante

    -- Elementos de interfaz
    statusline_bg = "#0C2518",
    lightbg = "#1A3F2F",
    pmenu_bg = "#10301F",
    folder_bg = "#4FB6A1",
}

M.base_16 = {
    base00 = M.base_30.black, -- background
    base01 = M.base_30.black2, -- lighter background
    base02 = M.base_30.one_bg2, -- selection background
    base03 = M.base_30.one_bg3, -- comments, invisibles
    base04 = M.base_30.grey_fg, -- dark foreground
    base05 = M.base_30.white, -- default foreground
    base06 = "#F0FBED", -- light foreground
    base07 = "#FFFFFF", -- lightest foreground
    base08 = M.base_30.red, -- red / errors
    base09 = M.base_30.orange, -- orange / warnings
    base0A = M.base_30.yellow, -- yellow / highlights
    base0B = M.base_30.green, -- green / success
    base0C = M.base_30.cyan, -- cyan
    base0D = M.base_30.blue, -- blue / functions
    base0E = M.base_30.purple, -- purple / types
    base0F = "#8A6B4A", -- brown accent (ajustado)
}

-- Polish highlights mejorado con más elementos y mejor consistencia
M.polish_hl = {
    defaults = {
        -- Elementos básicos
        Comment = { fg = M.base_30.green, italic = true }, -- comentarios en verde
        Normal = { fg = M.base_30.white, bg = M.base_30.black },
        NormalFloat = { fg = M.base_30.white, bg = M.base_30.one_bg },

        -- Cursor y selección
        CursorLine = { bg = M.base_30.darker_black },
        CursorColumn = { bg = M.base_30.darker_black },
        Visual = { bg = M.base_30.one_bg2 },
        VisualNOS = { bg = M.base_30.one_bg2 },

        -- Líneas y columnas
        ColorColumn = { bg = M.base_30.one_bg },
        LineNr = { fg = M.base_30.grey },
        CursorLineNr = { fg = M.base_30.green, bold = true },
        SignColumn = { bg = M.base_30.black },

        -- Menús
        Pmenu = { bg = M.base_30.pmenu_bg, fg = M.base_30.white },
        PmenuSel = { bg = M.base_30.one_bg3, fg = M.base_30.white, bold = true },
        PmenuSbar = { bg = M.base_30.one_bg2 },
        PmenuThumb = { bg = M.base_30.green },

        -- StatusLine
        StatusLine = { bg = M.base_30.statusline_bg, fg = M.base_30.white },
        StatusLineNC = { bg = M.base_30.black2, fg = M.base_30.grey_fg },

        -- Sintaxis general
        Function = { fg = M.base_30.blue, bold = true },
        Keyword = { fg = M.base_30.vibrant_green, bold = true },
        Type = { fg = M.base_30.purple },
        Constant = { fg = M.base_30.pink },
        String = { fg = M.base_30.teal },
        Number = { fg = M.base_30.pink },
        Boolean = { fg = M.base_30.pink, bold = true },
        Identifier = { fg = M.base_30.white },

        -- Diagnósticos
        DiagnosticError = { fg = M.base_30.red },
        DiagnosticWarn = { fg = M.base_30.orange },
        DiagnosticInfo = { fg = M.base_30.blue },
        DiagnosticHint = { fg = M.base_30.cyan },

        -- Search
        Search = { bg = M.base_30.yellow, fg = M.base_30.black },
        IncSearch = { bg = M.base_30.green, fg = M.base_30.black },

        -- Folding
        Folded = { bg = M.base_30.one_bg, fg = M.base_30.grey_fg },
        FoldColumn = { bg = M.base_30.black, fg = M.base_30.grey },
    },

    treesitter = {
        -- Comentarios (temática verde)
        ["@comment"] = { fg = M.base_30.green, italic = true },
        ["@comment.documentation"] = { fg = M.base_30.grey_fg2, italic = true },
        ["@comment.todo"] = { fg = M.base_30.yellow, bg = M.base_30.one_bg, bold = true },
        ["@comment.warning"] = { fg = M.base_30.orange, bg = M.base_30.one_bg, bold = true },
        ["@comment.error"] = { fg = M.base_30.red, bg = M.base_30.one_bg, bold = true },

        -- Strings y caracteres
        ["@string"] = { fg = M.base_30.teal },
        ["@string.escape"] = { fg = M.base_30.cyan, bold = true },
        ["@string.regex"] = { fg = M.base_30.vibrant_green },
        ["@character"] = { fg = M.base_30.teal },
        ["@character.special"] = { fg = M.base_30.cyan },

        -- Números y constantes
        ["@number"] = { fg = M.base_30.pink },
        ["@number.float"] = { fg = M.base_30.pink },
        ["@boolean"] = { fg = M.base_30.pink, bold = true },
        ["@constant"] = { fg = M.base_30.pink },
        ["@constant.builtin"] = { fg = M.base_30.pink, bold = true },
        ["@constant.macro"] = { fg = M.base_30.pink, bold = true },

        -- Funciones
        ["@function"] = { fg = M.base_30.blue, bold = true },
        ["@function.builtin"] = { fg = M.base_30.blue, bold = true },
        ["@function.call"] = { fg = M.base_30.blue },
        ["@function.macro"] = { fg = M.base_30.cyan, bold = true },
        ["@method"] = { fg = M.base_30.blue },
        ["@method.call"] = { fg = M.base_30.blue },
        ["@constructor"] = { fg = M.base_30.purple, bold = true },

        -- Keywords
        ["@keyword"] = { fg = M.base_30.yellow, bold = true },
        ["@keyword.function"] = { fg = M.base_30.yellow, bold = true },
        ["@keyword.return"] = { fg = M.base_30.yellow, bold = true },
        ["@keyword.operator"] = { fg = M.base_30.yellow },
        ["@keyword.conditional"] = { fg = M.base_30.yellow, bold = true },
        ["@keyword.repeat"] = { fg = M.base_30.yellow, bold = true },
        ["@keyword.exception"] = { fg = M.base_30.red, bold = true },

        -- Variables y identificadores
        ["@variable"] = { fg = M.base_30.white },
        ["@variable.builtin"] = { fg = M.base_30.vibrant_green, italic = true },
        ["@variable.member"] = { fg = M.base_30.vibrant_green },
        ["@variable.parameter"] = { fg = M.base_30.grey_fg2, italic = true },
        ["@parameter"] = { fg = M.base_30.grey_fg2, italic = true },

        -- Tipos y namespaces
        ["@type"] = { fg = M.base_30.purple },
        ["@type.builtin"] = { fg = M.base_30.purple, bold = true },
        ["@type.definition"] = { fg = M.base_30.purple, bold = true },
        ["@namespace"] = { fg = M.base_30.purple },

        -- Propiedades y campos
        ["@property"] = { fg = M.base_30.vibrant_green },
        ["@field"] = { fg = M.base_30.white },
        ["@attribute"] = { fg = M.base_30.cyan },

        -- Operadores y puntuación
        ["@operator"] = { fg = M.base_30.yellow },
        ["@punctuation.delimiter"] = { fg = M.base_30.grey_fg2 },
        ["@punctuation.bracket"] = { fg = M.base_30.grey_fg2 },
        ["@punctuation.special"] = { fg = M.base_30.cyan },

        -- Tags (HTML/XML)
        ["@tag"] = { fg = M.base_30.red },
        ["@tag.attribute"] = { fg = M.base_30.yellow },
        ["@tag.delimiter"] = { fg = M.base_30.grey_fg2 },

        -- Markup
        ["@markup.heading"] = { fg = M.base_30.green, bold = true },
        ["@markup.strong"] = { bold = true },
        ["@markup.italic"] = { italic = true },
        ["@markup.link"] = { fg = M.base_30.blue, underline = true },
        ["@markup.code"] = { fg = M.base_30.teal, bg = M.base_30.one_bg },
    },
}

M.type = "dark"

M = require("base46").override_theme(M, "green-dusk-improve")

return M
