-- Otter.nvim for embedded language server support
return {
    "jmbuhr/otter.nvim",
    ft = { "quarto", "qmd", "markdown", "ipython" },
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
    },
    ---@type OtterConfig
    opts = {},
}
