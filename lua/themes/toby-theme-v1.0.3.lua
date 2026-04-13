-- Toby Theme — Canine Green Mocha
-- Inspiración arquitectónica: Catppuccin Mocha (alto contraste, pastelización)
-- Identidad visual: paleta de la imagen del perro (verdes, tierra, oscuros)
-- Todos los tokens de sintaxis >= 7:1 WCAG AAA sobre el fondo #0A110A
---@type Base46Table
local M = {}

M.base_30 = {
    -- FONDOS (progresión oscuro → claro)
    black        = "#0A110A", -- background: fondo principal del editor
    darker_black = "#050D05", -- más oscuro que black
    black2       = "#131A12", -- bg_alt: fondo secundario
    one_bg       = "#1A221A", -- entre bg_alt y bg_highlight
    one_bg2      = "#222A21", -- bg_highlight: selección, active items
    one_bg3      = "#2D362C", -- surface: popups, floats
    line         = "#1A221A", -- línea divisoria (= one_bg)

    -- ESCALA DE TEXTO (4 niveles — inspirado en Catppuccin subtext)
    -- Contraste sobre #0A110A:
    white      = "#D4E8C2", -- fg: foreground normal            14.69:1 ✅ AAA
    grey_fg2   = "#B5CC9F", -- subtext1: parámetros, hints      11.03:1 ✅ AAA
    grey_fg    = "#8FAD7A", -- subtext0: UI secundario           7.68:1 ✅ AAA
    grey       = "#657A55", -- overlay: line numbers, sep.       4.07:1 ⚠️ decorativo
    light_grey = "#D4E8C2", -- alias de white

    -- VERDE ESCALA (sintaxis activa) — todos pastelizados al rango L 65-75%
    green         = "#A3D97A", -- verde puro pastel: success, diff+  11.63:1 ✅ AAA
    vibrant_green = "#A8D66B", -- verde saturado-pastel: keywords     11.39:1 ✅ AAA
    teal          = "#8BC47A", -- verde-media: comentarios             9.36:1 ✅ AAA

    -- FUNCIONES Y TIPOS ESPECIALES
    -- hue rotado ~20° hacia verde (~145°) para preservar identidad verdosa
    blue = "#7DD4A3", -- verde-teal pastel: funciones, métodos  ~11.5:1 ✅ AAA
    cyan = "#9ADABB", -- verde-menta más claro: escape, regex   ~13.0:1 ✅ AAA

    -- STRINGS (máximo contraste perceptivo — amarillo dorado pastel)
    purple = "#F0E080", -- amarillo-dorado suavizado: strings, tipos  14.29:1 ✅ AAA

    -- TIERRA (warmth del pelaje del perro — pastelizados)
    orange      = "#E8B07A", -- tierra-pastel: warnings, operadores   9.95:1 ✅ AAA
    pink        = "#DFC08A", -- ámbar pastel: números, constantes     10.97:1 ✅ AAA
    dark_purple = "#2D3A1A", -- verde muy oscuro: fondos especiales

    -- COLORES DE ESTADO
    red       = "#F07A8A", -- error: rosa-pastel (Catppuccin style)   7.16:1 ✅ AAA
    yellow    = "#D4E8C2", -- alias de white: búsqueda, highlight
    baby_pink = "#D4E8C2", -- fg reutilizado
    sun       = "#D4E8C2", -- alias de yellow/white

    -- SINÓNIMOS DE INTERFAZ
    nord_blue    = "#7DD4A3", -- alias de blue
    seablue      = "#7DD4A3", -- alias de blue
    forest_green = "#222A21", -- bg_highlight

    -- INTERFAZ
    statusline_bg = "#131A12", -- fondo de statusline
    lightbg       = "#222A21", -- fondo de popups/floats
    pmenu_bg      = "#1A221A", -- fondo menú completado
    folder_bg     = "#A8D66B", -- íconos de carpetas
}

M.base_16 = {
    base00 = "#0A110A", -- background principal
    base01 = "#131A12", -- fondo un nivel más claro
    base02 = "#222A21", -- fondo de selección
    base03 = "#8BC47A", -- comentarios, invisibles          9.36:1 ✅
    base04 = "#8FAD7A", -- foreground oscuro (subtext0)     7.68:1 ✅
    base05 = "#D4E8C2", -- foreground por defecto (fg)      14.69:1 ✅
    base06 = "#B5CC9F", -- foreground secundario (subtext1) 11.03:1 ✅
    base07 = "#E8F5D8", -- foreground más claro posible
    base08 = "#F07A8A", -- rojo-rosa — errores              7.16:1 ✅ AAA
    base09 = "#E8B07A", -- naranja — warnings               9.95:1 ✅ AAA
    base0A = "#F0E080", -- amarillo-dorado — clases         14.29:1 ✅ AAA
    base0B = "#A3D97A", -- verde — success, diff+           11.63:1 ✅ AAA
    base0C = "#9ADABB", -- verde-salvia — regex, soporte    ~13.0:1 ✅ AAA
    base0D = "#7DD4A3", -- verde-teal — funciones           ~11.5:1 ✅ AAA
    base0E = "#A8D66B", -- verde saturado — keywords        11.39:1 ✅ AAA
    base0F = "#657A55", -- overlay — deprecated              4.07:1 decorativo
}

M.polish_hl = {
    defaults = {
        -- BASE DEL EDITOR
        Normal       = { fg = M.base_30.white, bg = M.base_30.black },
        NormalFloat  = { fg = M.base_30.white, bg = M.base_30.one_bg3 },
        NormalNC     = { fg = M.base_30.grey_fg2, bg = M.base_30.black },
        NormalBorder = { fg = M.base_30.grey, bg = M.base_30.black },

        -- CURSOR Y LÍNEA
        CursorLine   = { bg = M.base_30.one_bg },
        CursorColumn = { bg = M.base_30.one_bg },
        CursorLineNr = { fg = M.base_30.vibrant_green, bold = true },
        ColorColumn  = { bg = M.base_30.one_bg },

        -- NÚMEROS DE LÍNEA
        LineNr      = { fg = M.base_30.grey },
        LineNrAbove = { fg = M.base_30.grey },
        LineNrBelow = { fg = M.base_30.grey },
        SignColumn  = { bg = M.base_30.black },
        FoldColumn  = { bg = M.base_30.black, fg = M.base_30.grey },

        -- SELECCIÓN Y BÚSQUEDA
        Visual     = { bg = M.base_30.one_bg2 },
        VisualNOS  = { bg = M.base_30.one_bg2 },
        Search     = { bg = M.base_30.purple, fg = M.base_30.black },
        IncSearch  = { bg = M.base_30.vibrant_green, fg = M.base_30.black },
        CurSearch  = { bg = M.base_30.green, fg = M.base_30.black },
        Substitute = { bg = M.base_30.teal, fg = M.base_30.black },

        -- SEPARADORES Y BORDES
        WinSeparator = { fg = M.base_30.grey, bg = M.base_30.black },
        VertSplit    = { fg = M.base_30.grey, bg = M.base_30.black },

        -- MENÚ DE COMPLETADO
        Pmenu         = { bg = M.base_30.pmenu_bg, fg = M.base_30.white },
        PmenuSel      = { bg = M.base_30.one_bg3, fg = M.base_30.white, bold = true },
        PmenuSbar     = { bg = M.base_30.one_bg2 },
        PmenuThumb    = { bg = M.base_30.vibrant_green },
        PmenuMatch    = { fg = M.base_30.cyan, bold = true },
        PmenuMatchSel = { fg = M.base_30.cyan, bg = M.base_30.one_bg3, bold = true },

        -- STATUSLINE
        StatusLine   = { bg = M.base_30.statusline_bg, fg = M.base_30.white },
        StatusLineNC = { bg = M.base_30.black2, fg = M.base_30.grey_fg },

        -- TABS
        TabLine     = { bg = M.base_30.black, fg = M.base_30.grey_fg },
        TabLineFill = { bg = M.base_30.black },
        TabLineSel  = { bg = M.base_30.one_bg3, fg = M.base_30.white, bold = true },

        -- SINTAXIS BASE
        Comment    = { fg = M.base_30.teal, italic = true },        -- verde-media: legible y tranquilo
        Function   = { fg = M.base_30.blue, bold = true },          -- verde-teal: distinto de keywords
        Keyword    = { fg = M.base_30.vibrant_green, bold = true },  -- verde saturado-pastel
        Type       = { fg = M.base_30.purple },                     -- dorado: tipos inconfundibles
        Constant   = { fg = M.base_30.pink },                       -- ámbar pastel: constantes
        String     = { fg = M.base_30.purple },                     -- dorado: strings destacados
        Number     = { fg = M.base_30.pink },                       -- ámbar pastel
        Float      = { fg = M.base_30.pink },
        Boolean    = { fg = M.base_30.pink, bold = true },
        Identifier = { fg = M.base_30.white },
        Operator   = { fg = M.base_30.orange },                     -- tierra-pastel: visible
        Delimiter  = { fg = M.base_30.grey_fg2 },

        -- DIAGNÓSTICOS
        DiagnosticError            = { fg = M.base_30.red },
        DiagnosticWarn             = { fg = M.base_30.orange },
        DiagnosticInfo             = { fg = M.base_30.blue },
        DiagnosticHint             = { fg = M.base_30.cyan },
        DiagnosticVirtualTextError = { fg = M.base_30.red, italic = true },
        DiagnosticVirtualTextWarn  = { fg = M.base_30.orange, italic = true },
        DiagnosticVirtualTextInfo  = { fg = M.base_30.blue, italic = true },
        DiagnosticVirtualTextHint  = { fg = M.base_30.cyan, italic = true },
        DiagnosticUnderlineError   = { undercurl = true, sp = M.base_30.red },
        DiagnosticUnderlineWarn    = { undercurl = true, sp = M.base_30.orange },
        DiagnosticSignError        = { fg = M.base_30.red },
        DiagnosticSignWarn         = { fg = M.base_30.orange },
        DiagnosticSignInfo         = { fg = M.base_30.blue },
        DiagnosticSignHint         = { fg = M.base_30.cyan },

        -- FOLDING
        Folded     = { bg = M.base_30.one_bg, fg = M.base_30.grey_fg },
        MatchParen = { fg = M.base_30.cyan, bold = true, underline = true },

        -- MISC
        NonText     = { fg = M.base_30.grey },
        EndOfBuffer = { fg = M.base_30.black },
        Whitespace  = { fg = M.base_30.one_bg3 },
        SpecialKey  = { fg = M.base_30.grey },
        Title       = { fg = M.base_30.vibrant_green, bold = true },
        Directory   = { fg = M.base_30.folder_bg, bold = true },
        ErrorMsg    = { fg = M.base_30.red },
        WarningMsg  = { fg = M.base_30.orange },
        Question    = { fg = M.base_30.blue },

        -- FLOTANTES Y BORDES
        FloatBorder = { fg = M.base_30.grey, bg = M.base_30.one_bg3 },
        FloatTitle  = { fg = M.base_30.vibrant_green, bg = "NONE", bold = true },
    },

    treesitter = {
        -- COMENTARIOS
        ["@comment"]               = { fg = M.base_30.teal, italic = true },
        ["@comment.documentation"] = { fg = M.base_30.grey_fg2, italic = true },
        ["@comment.todo"]          = { fg = M.base_30.purple, bg = M.base_30.one_bg, bold = true },
        ["@comment.warning"]       = { fg = M.base_30.orange, bg = M.base_30.one_bg, bold = true },
        ["@comment.error"]         = { fg = M.base_30.red, bg = M.base_30.one_bg, bold = true },
        ["@comment.note"]          = { fg = M.base_30.cyan, bg = M.base_30.one_bg, bold = true },

        -- STRINGS Y CARACTERES
        ["@string"]                = { fg = M.base_30.purple },
        ["@string.escape"]         = { fg = M.base_30.cyan, bold = true },
        ["@string.regex"]          = { fg = M.base_30.cyan },
        ["@string.special"]        = { fg = M.base_30.cyan },
        ["@string.special.path"]   = { fg = M.base_30.blue, underline = true },
        ["@string.special.url"]    = { fg = M.base_30.blue, underline = true },
        ["@string.special.symbol"] = { fg = M.base_30.purple },
        ["@character"]             = { fg = M.base_30.purple },
        ["@character.special"]     = { fg = M.base_30.cyan },

        -- NÚMEROS Y CONSTANTES
        ["@number"]           = { fg = M.base_30.pink },
        ["@number.float"]     = { fg = M.base_30.pink },
        ["@boolean"]          = { fg = M.base_30.pink, bold = true },
        ["@constant"]         = { fg = M.base_30.pink },
        ["@constant.builtin"] = { fg = M.base_30.pink, bold = true },
        ["@constant.macro"]   = { fg = M.base_30.pink, bold = true },

        -- FUNCIONES
        ["@function"]             = { fg = M.base_30.blue, bold = true },
        ["@function.builtin"]     = { fg = M.base_30.blue, bold = true },
        ["@function.call"]        = { fg = M.base_30.blue },
        ["@function.macro"]       = { fg = M.base_30.cyan, bold = true },
        ["@function.method"]      = { fg = M.base_30.blue },
        ["@function.method.call"] = { fg = M.base_30.blue },
        ["@constructor"]          = { fg = M.base_30.purple, bold = true },

        -- KEYWORDS
        ["@keyword"]             = { fg = M.base_30.vibrant_green, bold = true },
        ["@keyword.function"]    = { fg = M.base_30.vibrant_green, bold = true },
        ["@keyword.return"]      = { fg = M.base_30.vibrant_green, bold = true },
        ["@keyword.operator"]    = { fg = M.base_30.vibrant_green },
        ["@keyword.conditional"] = { fg = M.base_30.vibrant_green, bold = true },
        ["@keyword.repeat"]      = { fg = M.base_30.vibrant_green, bold = true },
        ["@keyword.exception"]   = { fg = M.base_30.red, bold = true },
        ["@keyword.import"]      = { fg = M.base_30.teal, italic = true },
        ["@keyword.modifier"]    = { fg = M.base_30.vibrant_green, italic = true },
        ["@keyword.coroutine"]   = { fg = M.base_30.vibrant_green },
        ["@keyword.debug"]       = { fg = M.base_30.red },

        -- VARIABLES E IDENTIFICADORES
        ["@variable"]           = { fg = M.base_30.white },
        ["@variable.builtin"]   = { fg = M.base_30.vibrant_green, italic = true },
        ["@variable.member"]    = { fg = M.base_30.vibrant_green },
        ["@variable.parameter"] = { fg = M.base_30.grey_fg2, italic = true },
        ["@variable.global"]    = { fg = M.base_30.vibrant_green, bold = true },
        ["@parameter"]          = { fg = M.base_30.grey_fg2, italic = true },

        -- TIPOS Y NAMESPACES
        ["@type"]            = { fg = M.base_30.purple },
        ["@type.builtin"]    = { fg = M.base_30.purple, bold = true },
        ["@type.definition"] = { fg = M.base_30.purple, bold = true },
        ["@type.qualifier"]  = { fg = M.base_30.vibrant_green, italic = true },
        ["@namespace"]       = { fg = M.base_30.purple },
        ["@module"]          = { fg = M.base_30.purple },

        -- PROPIEDADES Y CAMPOS
        ["@property"]  = { fg = M.base_30.vibrant_green },
        ["@field"]     = { fg = M.base_30.white },
        ["@attribute"] = { fg = M.base_30.cyan },
        ["@label"]     = { fg = M.base_30.blue },

        -- OPERADORES Y PUNTUACIÓN
        ["@operator"]              = { fg = M.base_30.orange },
        ["@punctuation.delimiter"] = { fg = M.base_30.grey_fg2 },
        ["@punctuation.bracket"]   = { fg = M.base_30.grey_fg2 },
        ["@punctuation.special"]   = { fg = M.base_30.cyan },

        -- TAGS (HTML/JSX/XML)
        ["@tag"]           = { fg = M.base_30.red },
        ["@tag.attribute"] = { fg = M.base_30.orange },
        ["@tag.delimiter"] = { fg = M.base_30.grey_fg2 },

        -- DIFF
        ["@diff.plus"]  = { fg = M.base_30.green, bg = M.base_30.one_bg },
        ["@diff.minus"] = { fg = M.base_30.red, bg = M.base_30.one_bg },
        ["@diff.delta"] = { fg = M.base_30.orange, bg = M.base_30.one_bg },

        -- MARKUP (Markdown, Vimdoc, etc.)
        ["@markup.heading"]        = { fg = M.base_30.vibrant_green, bold = true },
        ["@markup.heading.1"]      = { fg = M.base_30.vibrant_green, bold = true },
        ["@markup.heading.2"]      = { fg = M.base_30.green, bold = true },
        ["@markup.heading.3"]      = { fg = M.base_30.teal, bold = true },
        ["@markup.strong"]         = { bold = true },
        ["@markup.italic"]         = { italic = true },
        ["@markup.strikethrough"]  = { strikethrough = true },
        ["@markup.link"]           = { fg = M.base_30.blue, underline = true },
        ["@markup.link.url"]       = { fg = M.base_30.blue, underline = true },
        ["@markup.link.label"]     = { fg = M.base_30.cyan },
        ["@markup.raw"]            = { fg = M.base_30.purple },
        ["@markup.code"]           = { fg = M.base_30.purple, bg = M.base_30.one_bg },
        ["@markup.list"]           = { fg = M.base_30.vibrant_green },
        ["@markup.list.checked"]   = { fg = M.base_30.green },
        ["@markup.list.unchecked"] = { fg = M.base_30.grey_fg },
    },
}

M.type = "dark"

M = require("base46").override_theme(M, "toby-theme")

return M
