local html_options = {
    formatters_by_ft = {
        html = { "prettier" },
        xhtml = { "prettier" },
    },

    formatters = {
        prettier = {
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
        },
    },
}

require("conform").setup(html_options)
