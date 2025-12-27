-- Otter.nvim for embedded language server support
return {
    "jmbuhr/otter.nvim",
    ft = { "quarto", "qmd", "markdown" },
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
    },
    opts = {
        lsp = {
            hover = {
                border = "rounded",
            },
        },
        buffers = {
            set_filetype = true,
        },
    },
}
