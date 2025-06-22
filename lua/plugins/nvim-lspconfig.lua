return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "saghen/blink.cmp" },
    config = function()
        dofile(vim.g.base46_cache .. "lsp")
        require("nvchad.lsp").diagnostic_config()
        require("configs.lspconfig")
    end,
}
