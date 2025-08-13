local python_options = {
    formatters_by_ft = {
        css = {
            "prettier",
        },
    },

    formatters = {},
}

require("conform").setup(python_options)
