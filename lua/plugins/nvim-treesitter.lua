return {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    branch = "main",
    build = ":TSUpdate",
    config = function()
        require("configs.treesitter")
    end,
}
