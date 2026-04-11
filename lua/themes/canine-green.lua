-- Canine Green
---@type Base46Table
local M = {}

M.base_30 = {
    -- FONDOS (progresión oscuro → claro)
    black          = "0A110A",  -- background: fondo principal del editor
    darker_black   = "031009",  -- más oscuro que black (~30% más oscuro)
    black2         = "171D15",  -- bg_alt: fondo secundario
    one_bg         = "1F2B1E",  -- entre bg_alt y bg_highlight (interpolado)
    one_bg2        = "282922",  -- bg_highlight: selección, active items
    one_bg3        = "363C33",  -- surface: popups, floats
    line           = "1F2B1E",  -- línea divisoria (= one_bg)

    -- GRISES VERDOSOS
    grey           = "5D5247",  -- muted: separadores, UI inactiva
    grey_fg        = "7D6654",  -- subtle: texto UI secundario
    grey_fg2       = "AD8B66",  -- fg_dark: parámetros, hints
    light_grey     = "DDE8B7",  -- fg_bright: casi blanco verdoso

    -- TEXTO PRINCIPAL
    white          = "D6E47E",  -- fg: foreground normal

    -- VERDE ESCALA (sintaxis)
    green          = "74A932",  -- func: verde principal
    vibrant_green  = "9CC346",  -- type: verde acento brillante
    teal           = "558A22",  -- keyword: verde-oliva medio

    -- TIERRA (warmth del pelaje del perro)
    orange         = "AD8B66",  -- fg_dark: warning, naranja tierra
    dark_purple    = "376019",  -- comment: verde oscuro → rol dark_purple

    -- COLORES DE ESTADO
    red            = "C44D4D",  -- error: rojo derivado (contrasta con fondos verdes)
    yellow         = "D6E47E",  -- fg: info/highlight (fg reutilizado como amarillo)
    baby_pink      = "DDE8B7",  -- fg_bright reutilizado
    pink           = "AD8B66",  -- fg_dark reutilizado para números

    -- AZULES/CIANOS (adaptados a la paleta verde)
    blue           = "74A932",  -- func: funciones (verde → rol de azul)
    nord_blue      = "558A22",  -- keyword: (verde-oliva → rol nord_blue)
    seablue        = "558A22",  -- unificado con nord_blue
    cyan           = "9CC346",  -- type: (verde vibrante → rol cyan)
    purple         = "BFD65F",  -- string: (verde-lima → rol purple)
    sun            = "D6E47E",  -- fg: alias de yellow
    forest_green   = "282922",  -- bg_highlight: verde oscuro de fondo

    -- INTERFAZ
    statusline_bg  = "171D15",  -- bg_alt: fondo de statusline
    lightbg        = "282922",  -- bg_highlight: fondo de popups/floats
    pmenu_bg       = "1F2B1E",  -- one_bg: fondo menú completado
    folder_bg      = "74A932",  -- func: color íconos de carpetas
}

M.base_16 = {
    base00 = "0A110A",  -- background principal
    base01 = "171D15",  -- fondo un nivel más claro
    base02 = "282922",  -- fondo de selección
    base03 = "558A22",  -- comentarios, invisibles (keyword verde)
    base04 = "7D6654",  -- foreground oscuro (subtle)
    base05 = "D6E47E",  -- foreground por defecto (fg)
    base06 = "DDE8B7",  -- foreground claro (fg_bright)
    base07 = "F0F5E0",  -- foreground más claro
    base08 = "C44D4D",  -- rojo — errores
    base09 = "AD8B66",  -- naranja — warnings (fg_dark)
    base0A = "D6E47E",  -- amarillo — highlights, clases (fg)
    base0B = "74A932",  -- verde — strings, success (func)
    base0C = "9CC346",  -- cyan — soporte, regex (type)
    base0D = "558A22",  -- azul — funciones (keyword)
    base0E = "BFD65F",  -- púrpura — keywords, storage (string)
    base0F = "5D5247",  -- marrón accent — deprecated (muted)
}

M.polish_hl = {
    defaults = {
        -- BASE DEL EDITOR
        Normal         = { fg = M.base_30.white,        bg = M.base_30.black },
        NormalFloat    = { fg = M.base_30.white,        bg = M.base_30.one_bg3 },
        NormalNC       = { fg = M.base_30.grey_fg2,     bg = M.base_30.black },
        NormalBorder   = { fg = M.base_30.grey,         bg = M.base_30.black },

        -- CURSOR Y LÍNEA
        CursorLine     = { bg = M.base_30.one_bg },
        CursorColumn   = { bg = M.base_30.one_bg },
        CursorLineNr   = { fg = M.base_30.vibrant_green, bold = true },
        ColorColumn    = { bg = M.base_30.one_bg },

        -- NÚMEROS DE LÍNEA
        LineNr         = { fg = M.base_30.grey },
        LineNrAbove    = { fg = M.base_30.grey },
        LineNrBelow    = { fg = M.base_30.grey },
        SignColumn     = { bg = M.base_30.black },
        FoldColumn     = { bg = M.base_30.black, fg = M.base_30.grey },

        -- SELECCIÓN Y BÚSQUEDA
        Visual         = { bg = M.base_30.one_bg2 },
        VisualNOS      = { bg = M.base_30.one_bg2 },
        Search         = { bg = M.base_30.yellow,  fg = M.base_30.black },
        IncSearch      = { bg = M.base_30.green,   fg = M.base_30.black },
        CurSearch      = { bg = M.base_30.vibrant_green, fg = M.base_30.black },
        Substitute     = { bg = M.base_30.teal,    fg = M.base_30.black },

        -- SEPARADORES Y BORDES
        WinSeparator   = { fg = M.base_30.grey,    bg = M.base_30.black },
        VertSplit      = { fg = M.base_30.grey,    bg = M.base_30.black },

        -- MENÚ DE COMPLETADO
        Pmenu          = { bg = M.base_30.pmenu_bg,  fg = M.base_30.white },
        PmenuSel       = { bg = M.base_30.one_bg3,   fg = M.base_30.white, bold = true },
        PmenuSbar      = { bg = M.base_30.one_bg2 },
        PmenuThumb     = { bg = M.base_30.green },
        PmenuMatch     = { fg = M.base_30.vibrant_green, bold = true },
        PmenuMatchSel  = { fg = M.base_30.vibrant_green, bg = M.base_30.one_bg3, bold = true },

        -- STATUSLINE
        StatusLine     = { bg = M.base_30.statusline_bg, fg = M.base_30.white },
        StatusLineNC   = { bg = M.base_30.black2, fg = M.base_30.grey_fg },

        -- TABS
        TabLine        = { bg = M.base_30.black,   fg = M.base_30.grey_fg },
        TabLineFill    = { bg = M.base_30.black },
        TabLineSel     = { bg = M.base_30.one_bg3, fg = M.base_30.white, bold = true },

        -- SINTAXIS BASE
        Comment        = { fg = M.base_30.teal, italic = true },
        Function       = { fg = M.base_30.blue, bold = true },
        Keyword        = { fg = M.base_30.vibrant_green, bold = true },
        Type           = { fg = M.base_30.purple },
        Constant       = { fg = M.base_30.pink },
        String         = { fg = M.base_30.purple },
        Number         = { fg = M.base_30.pink },
        Float          = { fg = M.base_30.pink },
        Boolean        = { fg = M.base_30.pink, bold = true },
        Identifier     = { fg = M.base_30.white },
        Operator       = { fg = M.base_30.yellow },
        Delimiter      = { fg = M.base_30.grey_fg2 },

        -- DIAGNÓSTICOS
        DiagnosticError            = { fg = M.base_30.red },
        DiagnosticWarn             = { fg = M.base_30.orange },
        DiagnosticInfo             = { fg = M.base_30.blue },
        DiagnosticHint             = { fg = M.base_30.cyan },
        DiagnosticVirtualTextError = { fg = M.base_30.red,    italic = true },
        DiagnosticVirtualTextWarn  = { fg = M.base_30.orange, italic = true },
        DiagnosticVirtualTextInfo  = { fg = M.base_30.blue,   italic = true },
        DiagnosticVirtualTextHint  = { fg = M.base_30.cyan,   italic = true },
        DiagnosticUnderlineError   = { undercurl = true, sp = M.base_30.red },
        DiagnosticUnderlineWarn    = { undercurl = true, sp = M.base_30.orange },
        DiagnosticSignError        = { fg = M.base_30.red },
        DiagnosticSignWarn         = { fg = M.base_30.orange },
        DiagnosticSignInfo         = { fg = M.base_30.blue },
        DiagnosticSignHint         = { fg = M.base_30.cyan },

        -- FOLDING
        Folded         = { bg = M.base_30.one_bg,  fg = M.base_30.grey_fg },
        MatchParen     = { fg = M.base_30.vibrant_green, bold = true, underline = true },

        -- MISC
        NonText        = { fg = M.base_30.grey },
        EndOfBuffer    = { fg = M.base_30.black },
        Whitespace     = { fg = M.base_30.one_bg3 },
        SpecialKey     = { fg = M.base_30.grey },
        Title          = { fg = M.base_30.vibrant_green, bold = true },
        Directory      = { fg = M.base_30.folder_bg, bold = true },
        ErrorMsg       = { fg = M.base_30.red },
        WarningMsg     = { fg = M.base_30.orange },
        Question       = { fg = M.base_30.blue },

        -- FLOTANTES Y BORDES
        FloatBorder    = { fg = M.base_30.grey,    bg = M.base_30.one_bg3 },
        FloatTitle     = { fg = M.base_30.vibrant_green, bg = "NONE", bold = true },
    },

    treesitter = {
        -- COMENTARIOS
        ["@comment"]               = { fg = M.base_30.teal,       italic = true },
        ["@comment.documentation"] = { fg = M.base_30.grey_fg2,   italic = true },
        ["@comment.todo"]          = { fg = M.base_30.yellow,     bg = M.base_30.one_bg, bold = true },
        ["@comment.warning"]       = { fg = M.base_30.orange,     bg = M.base_30.one_bg, bold = true },
        ["@comment.error"]         = { fg = M.base_30.red,        bg = M.base_30.one_bg, bold = true },
        ["@comment.note"]          = { fg = M.base_30.cyan,       bg = M.base_30.one_bg, bold = true },

        -- STRINGS Y CARACTERES
        ["@string"]                = { fg = M.base_30.purple },
        ["@string.escape"]         = { fg = M.base_30.cyan,       bold = true },
        ["@string.regex"]          = { fg = M.base_30.vibrant_green },
        ["@string.special"]        = { fg = M.base_30.cyan },
        ["@string.special.path"]   = { fg = M.base_30.blue,       underline = true },
        ["@string.special.url"]    = { fg = M.base_30.blue,       underline = true },
        ["@string.special.symbol"] = { fg = M.base_30.purple },
        ["@character"]             = { fg = M.base_30.purple },
        ["@character.special"]     = { fg = M.base_30.cyan },

        -- NÚMEROS Y CONSTANTES
        ["@number"]                = { fg = M.base_30.pink },
        ["@number.float"]          = { fg = M.base_30.pink },
        ["@boolean"]               = { fg = M.base_30.pink,       bold = true },
        ["@constant"]              = { fg = M.base_30.pink },
        ["@constant.builtin"]      = { fg = M.base_30.pink,       bold = true },
        ["@constant.macro"]        = { fg = M.base_30.pink,       bold = true },

        -- FUNCIONES
        ["@function"]              = { fg = M.base_30.blue,       bold = true },
        ["@function.builtin"]      = { fg = M.base_30.blue,       bold = true },
        ["@function.call"]         = { fg = M.base_30.blue },
        ["@function.macro"]        = { fg = M.base_30.cyan,       bold = true },
        ["@function.method"]       = { fg = M.base_30.blue },
        ["@function.method.call"]  = { fg = M.base_30.blue },
        ["@constructor"]           = { fg = M.base_30.purple,     bold = true },

        -- KEYWORDS
        ["@keyword"]               = { fg = M.base_30.vibrant_green, bold = true },
        ["@keyword.function"]      = { fg = M.base_30.vibrant_green, bold = true },
        ["@keyword.return"]        = { fg = M.base_30.vibrant_green, bold = true },
        ["@keyword.operator"]      = { fg = M.base_30.vibrant_green },
        ["@keyword.conditional"]   = { fg = M.base_30.vibrant_green, bold = true },
        ["@keyword.repeat"]        = { fg = M.base_30.vibrant_green, bold = true },
        ["@keyword.exception"]     = { fg = M.base_30.red,           bold = true },
        ["@keyword.import"]        = { fg = M.base_30.teal,          italic = true },
        ["@keyword.modifier"]      = { fg = M.base_30.vibrant_green, italic = true },
        ["@keyword.coroutine"]     = { fg = M.base_30.vibrant_green },
        ["@keyword.debug"]         = { fg = M.base_30.red },

        -- VARIABLES E IDENTIFICADORES
        ["@variable"]              = { fg = M.base_30.white },
        ["@variable.builtin"]      = { fg = M.base_30.vibrant_green, italic = true },
        ["@variable.member"]       = { fg = M.base_30.vibrant_green },
        ["@variable.parameter"]    = { fg = M.base_30.grey_fg2,      italic = true },
        ["@variable.global"]       = { fg = M.base_30.vibrant_green, bold = true },
        ["@parameter"]             = { fg = M.base_30.grey_fg2,      italic = true },

        -- TIPOS Y NAMESPACES
        ["@type"]                  = { fg = M.base_30.purple },
        ["@type.builtin"]          = { fg = M.base_30.purple,        bold = true },
        ["@type.definition"]       = { fg = M.base_30.purple,        bold = true },
        ["@type.qualifier"]        = { fg = M.base_30.vibrant_green, italic = true },
        ["@namespace"]             = { fg = M.base_30.purple },
        ["@module"]                = { fg = M.base_30.purple },

        -- PROPIEDADES Y CAMPOS
        ["@property"]              = { fg = M.base_30.vibrant_green },
        ["@field"]                 = { fg = M.base_30.white },
        ["@attribute"]             = { fg = M.base_30.cyan },
        ["@label"]                 = { fg = M.base_30.blue },

        -- OPERADORES Y PUNTUACIÓN
        ["@operator"]              = { fg = M.base_30.yellow },
        ["@punctuation.delimiter"] = { fg = M.base_30.grey_fg2 },
        ["@punctuation.bracket"]   = { fg = M.base_30.grey_fg2 },
        ["@punctuation.special"]   = { fg = M.base_30.cyan },

        -- TAGS (HTML/JSX/XML)
        ["@tag"]                   = { fg = M.base_30.red },
        ["@tag.attribute"]         = { fg = M.base_30.yellow },
        ["@tag.delimiter"]         = { fg = M.base_30.grey_fg2 },

        -- DIFF
        ["@diff.plus"]             = { fg = M.base_30.green,  bg = M.base_30.one_bg },
        ["@diff.minus"]            = { fg = M.base_30.red,    bg = M.base_30.one_bg },
        ["@diff.delta"]            = { fg = M.base_30.orange, bg = M.base_30.one_bg },

        -- MARKUP (Markdown, Vimdoc, etc.)
        ["@markup.heading"]        = { fg = M.base_30.vibrant_green, bold = true },
        ["@markup.heading.1"]      = { fg = M.base_30.vibrant_green, bold = true },
        ["@markup.heading.2"]      = { fg = M.base_30.green,         bold = true },
        ["@markup.heading.3"]      = { fg = M.base_30.teal,          bold = true },
        ["@markup.strong"]         = { bold = true },
        ["@markup.italic"]         = { italic = true },
        ["@markup.strikethrough"]  = { strikethrough = true },
        ["@markup.link"]           = { fg = M.base_30.blue,          underline = true },
        ["@markup.link.url"]       = { fg = M.base_30.blue,          underline = true },
        ["@markup.link.label"]     = { fg = M.base_30.cyan },
        ["@markup.raw"]            = { fg = M.base_30.purple },
        ["@markup.code"]           = { fg = M.base_30.purple, bg = M.base_30.one_bg },
        ["@markup.list"]           = { fg = M.base_30.vibrant_green },
        ["@markup.list.checked"]   = { fg = M.base_30.green },
        ["@markup.list.unchecked"] = { fg = M.base_30.grey_fg },
    },
}

M.type = "dark"

M = require("base46").override_theme(M, "canine-green")

return M
