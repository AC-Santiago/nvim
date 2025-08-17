return {
    "benomahony/oil-git.nvim",
    dependencies = { "stevearc/oil.nvim" },
    opts = function()
        require("configs.oil-git")
    end,
}
