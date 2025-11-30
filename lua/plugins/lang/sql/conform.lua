local sql_options = {
    formatters_by_ft = {
        sql = { "sql-formatter" },
    },
    formatters = {
        ["sql-formatter"] = {
            command = "sql-formatter",
            -- Añade argumentos de línea de comandos para sql-formatter
            -- Para una lista completa de opciones, visita: https://github.com/sql-formatter-org/sql-formatter
            args = {
                "--config",
                vim.fn.stdpath("config") .. "/.sqlformatterrc.json",
                "--language",
                "postgresql", -- Puedes cambiarlo a "mysql", "bigquery", "sqlite", etc.
            },
        },
    },
}
require("conform").setup(sql_options)
