local conform = require("conform")

-- Configurar formateo para archivos Astro
-- Astro tiene soporte nativo para Prettier a través de @astrojs/prettier
conform.formatters_by_ft.astro = { "prettier", "prettierd" }

-- Configuración de Prettier específica para Astro
-- El plugin de Astro para Prettier maneja el formateo de archivos .astro
conform.formatters.prettier = vim.tbl_deep_extend("force", conform.formatters.prettier or {}, {
    prepend_args = {
        "--single-quote",
        "--trailing-comma",
        "es5",
        "--tab-width",
        "2",
        "--semi",
        "--print-width",
        "100",
        "--bracket-spacing",
        "--arrow-parens",
        "avoid",
        "--end-of-line",
        "lf",
    },
})

-- También configurar para typescript y javascript que son parte de Astro
local js_filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" }
for _, ft in ipairs(js_filetypes) do
    if not conform.formatters_by_ft[ft] then
        conform.formatters_by_ft[ft] = {}
    end
    table.insert(conform.formatters_by_ft[ft], "prettier")
end

return {}