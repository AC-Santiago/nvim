local python_options = {
    formatters_by_ft = {
        html = {
            "prettier",
        },
    },

    formatters = {},
}

require("conform").setup(python_options)
