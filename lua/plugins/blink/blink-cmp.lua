return {
    { import = "nvchad.blink.lazyspec" },
    {
        "saghen/blink.cmp",
        dependencies = {
            "rafamadriz/friendly-snippets",
            "fang2hou/blink-copilot",
            "rcarriga/cmp-dap",
            "Kaiser-Yang/blink-cmp-avante",
            {
                "saghen/blink.compat",
                version = "2.*",
                lazy = true,
                opts = {},
            },
            {
                "windwp/nvim-autopairs",
                opts = {
                    fast_wrap = {},
                    disable_filetype = { "TelescopePrompt", "vim" },
                },
            },
            {
                "L3MON4D3/LuaSnip",
                dependencies = "rafamadriz/friendly-snippets",
                opts = { history = true, updateevents = "TextChanged,TextChangedI" },
                config = function(_, opts)
                    require("luasnip").config.set_config(opts)
                    require("nvchad.configs.luasnip")
                end,
            },
        },

        version = "1.*",

        opts = function()
            require("configs.blink")
        end,
        opts_extend = { "sources.default" },
    },
}
