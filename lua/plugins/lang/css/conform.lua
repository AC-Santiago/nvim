local css_options = {
    formatters_by_ft = {
        css = { "prettier" },
        scss = { "prettier" },
        less = { "prettier" },
    },

    formatters = {
        prettier = {
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
        },
    },
}

require("conform").setup(css_options)
