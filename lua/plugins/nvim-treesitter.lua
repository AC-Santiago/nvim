return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    event = function()
        return {}
    end,
    cmd = function()
        return {}
    end,
    opts = false,
    build = ":TSUpdate",
}
