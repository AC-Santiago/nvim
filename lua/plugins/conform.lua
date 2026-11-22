return {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    ft = vim.fn.has("win32") == 1 and "typst" or nil,
    cmd = "ConformInfo",
    config = function()
        require("configs.conform").setup()
    end,
}
