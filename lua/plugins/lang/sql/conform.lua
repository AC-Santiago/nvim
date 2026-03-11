local conform = require("conform")

conform.formatters_by_ft.sql = { "sql-formatter" }

conform.formatters["sql-formatter"] = {
    command = "sql-formatter",
    -- Para una lista completa de opciones, visita: https://github.com/sql-formatter-org/sql-formatter
    args = {
        "--config",
        vim.fn.stdpath("config") .. "/.sqlformatterrc.json",
        "--language",
        "postgresql", -- Puedes cambiarlo a "mysql", "bigquery", "sqlite", etc.
    },
}
