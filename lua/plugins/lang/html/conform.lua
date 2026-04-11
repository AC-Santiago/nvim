local conform = require("conform")

conform.formatters_by_ft.html = { "prettier" }
conform.formatters_by_ft.xhtml = { "prettier" }

conform.formatters.prettier = vim.tbl_deep_extend("force", conform.formatters.prettier or {}, {
    prepend_args = {
        "--tab-width",
        "2",
        "--print-width",
        "120",
        "--html-whitespace-sensitivity",
        "css",
        "--end-of-line",
        "lf",
        "--bracket-same-line",
        "--single-quote",
    },
})
