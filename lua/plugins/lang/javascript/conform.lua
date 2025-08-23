local javascript_options = {
    formatters_by_ft = {
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
    },

    formatters = {
        prettier = {
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
        },
    },
}

require("conform").setup(javascript_options)
