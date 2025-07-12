-- Configuración de highlight groups personalizados para blink.cmp
-- Compatible con el sistema de theming base46 de NvChad

local M = {}

-- Función para aplicar los highlight groups personalizados
function M.setup()
    -- Obtener colores del tema actual de base46
    local colors = require("base46").get_theme_tb("base_30")

    -- Highlight groups para las diferentes fuentes de blink.cmp
    local highlights = {
        -- Grupos principales de blink.cmp
        BlinkCmpMenu = { bg = colors.darker_black, fg = colors.white },
        BlinkCmpMenuBorder = { fg = colors.grey_fg },
        BlinkCmpMenuSelection = { bg = colors.black2, fg = colors.white },
        BlinkCmpLabel = { fg = colors.white },
        BlinkCmpLabelDeprecated = { fg = colors.light_grey, strikethrough = true },
        BlinkCmpLabelDescription = { fg = colors.grey_fg },

        -- Grupos para diferentes fuentes de completado
        BlinkCmpSpellCorrect = { fg = colors.green, bold = true },
        BlinkCmpSpellSuggestion = { fg = colors.yellow },
        BlinkCmpSpellSource = { fg = colors.green, italic = true },

        BlinkCmpCopilot = { fg = colors.orange, bold = true },
        BlinkCmpCopilotSource = { fg = colors.orange, italic = true },

        BlinkCmpAvante = { fg = colors.purple, bold = true },
        BlinkCmpAvanteSource = { fg = colors.purple, italic = true },

        BlinkCmpPath = { fg = colors.blue },
        BlinkCmpPathSource = { fg = colors.blue, italic = true },

        BlinkCmpBuffer = { fg = colors.cyan },
        BlinkCmpBufferSource = { fg = colors.cyan, italic = true },

        BlinkCmpSnippet = { fg = colors.red },
        BlinkCmpSnippetSource = { fg = colors.red, italic = true },

        BlinkCmpLspSource = { fg = colors.white, italic = true },
        BlinkCmpLazydevSource = { fg = colors.green, italic = true },
        BlinkCmpDapSource = { fg = colors.yellow, italic = true },

        -- Grupos para diferentes tipos de completado (LSP kinds)
        BlinkCmpKindText = { fg = colors.white },
        BlinkCmpKindMethod = { fg = colors.blue },
        BlinkCmpKindFunction = { fg = colors.blue },
        BlinkCmpKindConstructor = { fg = colors.yellow },
        BlinkCmpKindField = { fg = colors.green },
        BlinkCmpKindVariable = { fg = colors.purple },
        BlinkCmpKindClass = { fg = colors.orange },
        BlinkCmpKindInterface = { fg = colors.cyan },
        BlinkCmpKindModule = { fg = colors.red },
        BlinkCmpKindProperty = { fg = colors.green },
        BlinkCmpKindUnit = { fg = colors.grey_fg },
        BlinkCmpKindValue = { fg = colors.yellow },
        BlinkCmpKindEnum = { fg = colors.orange },
        BlinkCmpKindKeyword = { fg = colors.purple },
        BlinkCmpKindSnippet = { fg = colors.red },
        BlinkCmpKindColor = { fg = colors.pink },
        BlinkCmpKindFile = { fg = colors.blue },
        BlinkCmpKindReference = { fg = colors.cyan },
        BlinkCmpKindFolder = { fg = colors.blue },
        BlinkCmpKindEnumMember = { fg = colors.orange },
        BlinkCmpKindConstant = { fg = colors.red },
        BlinkCmpKindStruct = { fg = colors.orange },
        BlinkCmpKindEvent = { fg = colors.purple },
        BlinkCmpKindOperator = { fg = colors.white },
        BlinkCmpKindTypeParameter = { fg = colors.cyan },
    }

    -- Aplicar los highlight groups
    for group, opts in pairs(highlights) do
        vim.api.nvim_set_hl(0, group, opts)
    end
end

-- Función para personalizar colores específicos según el tema
function M.setup_theme_specific()
    local current_theme = require("nvconfig").base46.theme

    -- Configuraciones específicas por tema
    if current_theme == "tokyonight" then
        -- Ajustes específicos para el tema Tokyo Night
        vim.api.nvim_set_hl(0, "BlinkCmpMenu", { bg = "#1a1b26", fg = "#c0caf5" })
        vim.api.nvim_set_hl(0, "BlinkCmpMenuSelection", { bg = "#283457", fg = "#c0caf5" })
        vim.api.nvim_set_hl(0, "BlinkCmpCopilot", { fg = "#ff9e64", bold = true })
        vim.api.nvim_set_hl(0, "BlinkCmpAvante", { fg = "#bb9af7", bold = true })
    elseif current_theme == "onedark" then
        -- Ajustes específicos para el tema One Dark
        vim.api.nvim_set_hl(0, "BlinkCmpMenu", { bg = "#282c34", fg = "#abb2bf" })
        vim.api.nvim_set_hl(0, "BlinkCmpMenuSelection", { bg = "#3e4451", fg = "#abb2bf" })
    end
end

return M
