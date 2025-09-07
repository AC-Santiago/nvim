-- Green Dusk: un tema dark basado en tonos verdes para NvChad/base46
---@type Base46Table
local M = {}

M.base_30 = {
    white = "#DCEFD9",
    black = "#07120B",
    darker_black = "#031009",
    black2 = "#0B2417",
    one_bg = "#0E2B1E",
    one_bg2 = "#184033",
    one_bg3 = "#274C3D",
    grey = "#355A4A",
    grey_fg = "#5E8E7A",
    grey_fg2 = "#7FB99F",
    light_grey = "#CFEEDD",

    red = "#E06E6E",
    baby_pink = "#FF9FA8",
    pink = "#9CC0A8",

    line = "#0E2B1E",

    green = "#6FD08A", -- color principal / acento verde
    vibrant_green = "#7FE99A",
    nord_blue = "#4FB6A1",
    blue = "#2EA89A",
    seablue = "#2EA89A",

    yellow = "#C7D86A",
    sun = "#C7D86A",
    purple = "#7DAE8A",
    dark_purple = "#294133",

    teal = "#4FB6A1",
    orange = "#C98E59",
    cyan = "#67C3A9",

    statusline_bg = "#0B2417",
    lightbg = "#15402E",
    pmenu_bg = "#0E2B1E",
    folder_bg = "#4FB6A1",
}

M.base_16 = {
    base00 = M.base_30.black, -- background
    base01 = M.base_30.black2,
    base02 = M.base_30.one_bg2,
    base03 = M.base_30.one_bg3,
    base04 = M.base_30.light_grey,
    base05 = M.base_30.white,
    base06 = "#FFFFFF",
    base07 = "#FFFFFF",
    base08 = M.base_30.red, -- red / errors
    base09 = M.base_30.orange, -- orange / warnings
    base0A = M.base_30.yellow, -- yellow / highlights
    base0B = M.base_30.green, -- green / success / comments accent
    base0C = M.base_30.cyan, -- cyan
    base0D = M.base_30.blue, -- blue / functions
    base0E = M.base_30.purple, -- purple / types
    base0F = "#8A5D4A", -- brown accent
}

-- Polish highlights: ajusta grupos concretos para que el tema se integre con NvChad
-- Comentarios usan tono verde como pediste.
M.polish_hl = {
    defaults = {
        Comment = { fg = M.base_30.green, italic = true }, -- comentarios en verde
        Normal = { fg = M.base_30.white, bg = M.base_30.black },
        CursorLine = { bg = M.base_30.darker_black },
        CursorColumn = { bg = M.base_30.darker_black },
        ColorColumn = { bg = M.base_30.one_bg },
        -- StatusLine = { bg = M.base_30.statusline_bg, fg = M.base_30.white },
        Visual = { bg = M.base_30.one_bg2 },
        -- Pmenu = { bg = M.base_30.pmenu_bg, fg = M.base_30.white },
        PmenuSel = { bg = M.base_30.one_bg3, fg = M.base_30.white },

        Function = { fg = M.base_30.nord_blue },
        Keyword = { fg = M.base_30.yellow, bold = true },
        Type = { fg = M.base_30.pink },
        Constant = { fg = M.base_30.pink },
        -- Identifier = { fg = M.base_30.white },

        DiagnosticError = { fg = M.base_30.red },
        DiagnosticWarn = { fg = M.base_30.orange },
        DiagnosticInfo = { fg = M.base_30.nord_blue },
        DiagnosticHint = { fg = M.base_30.cyan },
    },

    treesitter = {
        -- Comentarios
        ["@comment"] = { fg = M.base_30.green, italic = true }, -- comentarios en verde
        ["@comment.documentation"] = { fg = M.base_30.grey_fg, italic = true },

        ["@string"] = { fg = M.base_30.teal },
        ["@function"] = { fg = M.base_30.nord_blue },
        ["@keyword"] = { fg = M.base_30.yellow, bold = true },
        ["@variable"] = { fg = M.base_30.white },
        ["@constant"] = { fg = M.base_30.pink },
        ["@type"] = { fg = M.base_30.pink },
        ["@property"] = { fg = M.base_30.grey_fg2 },
        ["@namespace"] = { fg = M.base_30.pink },
        ["@parameter"] = { fg = M.base_30.white },
        ["@field"] = { fg = M.base_30.white },
        ["@keyword.function"] = { fg = M.base_30.yellow, bold = true },
        ["@constructor"] = { fg = M.base_30.nord_blue },

        ["@variable.member"] = { fg = M.base_30.vibrant_green },
    },
}

M.type = "dark"

M = require("base46").override_theme(M, "green-dusk")

return M
