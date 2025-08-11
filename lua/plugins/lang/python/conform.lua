local python_options = {
    formatters_by_ft = {
        python = {
            "ruff_fix",
            "ruff_format",
            "ruff_organize_imports",
        },
    },

    formatters = {},
}

require("conform").setup(python_options)
