return {
    "GCBallesteros/jupytext.nvim",
    lazy = false,
    config = function()
        require("jupytext").setup({
            style = "markdown",
            output_extension = "md",
            force_ft = "markdown",
            custom_language_formatting = {
                python = {
                    extension = "qmd",
                    style = "quarto",
                    force_ft = "quarto",
                },
                r = {
                    extension = "qmd",
                    style = "quarto",
                    force_ft = "quarto",
                },
            },
        })
    end,
}
