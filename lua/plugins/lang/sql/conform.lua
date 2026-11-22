return {
    ["sql-formatter"] = {
        inherit = "sql_formatter",
        args = {
            "--config",
            vim.fn.stdpath("config") .. "/.sqlformatterrc.json",
            "--language",
            "postgresql",
        },
    },
}
