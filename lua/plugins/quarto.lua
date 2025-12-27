-- Quarto integration plugin
return {
    "quarto-dev/quarto-nvim",
    ft = { "quarto", "qmd" },
    dependencies = {
        "jmbuhr/otter.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    opts = {
        lspFeatures = {
            enabled = true,
            chunks = "all",
            languages = { "python", "bash", "lua" },
            diagnostics = {
                enabled = true,
                triggers = { "BufWritePost" },
            },
            completion = {
                enabled = true,
            },
        },
        codeRunner = {
            enabled = true,
            default_method = "molten",
        },
        keymap = {
            hover = "K",
            definition = "gd",
            rename = "<leader>rn",
            references = "gr",
            format = "<leader>fm",
        },
    },
}
