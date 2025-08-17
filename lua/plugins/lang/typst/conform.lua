local typst_options = {
    formatters_by_ft = {
        typst = { "typstyle" },
    },

    formatters = {
        typstyle = {
            command = "typstyle",
            args = { "-i", "$FILENAME" },
            stdin = false,
        },
    },
}

require("conform").setup(typst_options)
