local conform = require("conform")

conform.formatters_by_ft.css = { "prettier" }
conform.formatters_by_ft.scss = { "prettier" }
conform.formatters_by_ft.less = { "prettier" }

conform.formatters.prettier = vim.tbl_deep_extend("force", conform.formatters.prettier or {}, {
    prepend_args = {
        "--tab-width",
        "2",
        "--single-quote",
        "--print-width",
        "80",
        "--end-of-line",
        "lf",
        "--bracket-spacing",
        "--semi",
    },
})
