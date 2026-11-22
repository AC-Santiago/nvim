return {
    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("configs.lint")
        end,
    },

    {
        "jay-babu/mason-nvim-dap.nvim",
        cond = vim.fn.has("win32") == 0,
        event = "VeryLazy",
        config = function()
            require("configs.mason-dap")
        end,
    },
    { import = "plugins.lang.python.init" },
    { import = "plugins.lang.typst.init" },
    { import = "plugins.lang.rust.init" },
    { import = "plugins.lang.css.init" },
    { import = "plugins.lang.html.init" },
    { import = "plugins.lang.sql.init" },
    { import = "plugins.lang.markdown.init" },
}
