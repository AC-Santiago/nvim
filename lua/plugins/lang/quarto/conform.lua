local quarto_options = {
    formatters_by_ft = {
        quarto = { "injected" },
        qmd = { "injected" },
    },
}

require("conform").setup(quarto_options)
