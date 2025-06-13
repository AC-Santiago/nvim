return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "saghen/blink.cmp" },
    config = function()
        require("nvchad.configs.lspconfig").defaults()
        require("configs.lspconfig")
    end,
}
