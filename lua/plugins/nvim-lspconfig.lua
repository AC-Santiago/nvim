-- Native LSP configuration for Neovim 0.11+
-- This plugin definition is kept for backward compatibility and UI loading
return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "saghen/blink.cmp" },
    config = function()
        dofile(vim.g.base46_cache .. "lsp")
        require("nvchad.lsp").diagnostic_config()
        require("configs.lsp")
    end,
}
