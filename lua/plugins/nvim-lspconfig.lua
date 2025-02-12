return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "folke/lazydev.nvim",
    },
    config = function()
        require("nvchad.configs.lspconfig").defaults()
        require("configs.lspconfig")
    end,
}
