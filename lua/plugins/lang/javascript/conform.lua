local conform = require("conform")

local js_filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "json", "jsonc" }
for _, ft in ipairs(js_filetypes) do
    conform.formatters_by_ft[ft] = { "prettier" }
end

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
