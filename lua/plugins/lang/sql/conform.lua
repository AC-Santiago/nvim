local sql_options = {
    formatters = {
        ["sql-formatter"] = function()
            return {
                exe = "sql-formatter",
                args = {},
                stdin = true,
            }
        end,
    },
    formatters_by_ft = {
        sql = { "sql-formatter" },
    },
    format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
    },
}

-- require("conform").setup(sql_options)
