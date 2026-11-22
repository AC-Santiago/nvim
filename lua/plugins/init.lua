return {

    {
        "williamboman/mason-lspconfig.nvim",
        cond = false,
        event = "VeryLazy",
        dependencies = { "nvim-lspconfig" },
        config = function()
            require("configs.mason-lspconfig")
        end,
    },

    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("configs.lint")
        end,
    },

    {
        "rshkarin/mason-nvim-lint",
        cond = false,
        event = "VeryLazy",
        dependencies = { "nvim-lint" },
        config = function()
            require("configs.mason-lint")
        end,
    },

    {
        "zapling/mason-conform.nvim",
        cond = false,
        event = "VeryLazy",
        dependencies = { "conform.nvim" },
        config = function()
            require("configs.mason-conform")
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
    { import = "plugins.lang.javascript.init" },
    { import = "plugins.lang.sql.init" },
    { import = "plugins.lang.markdown.init" },
}
