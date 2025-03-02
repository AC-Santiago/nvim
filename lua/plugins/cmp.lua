return {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "InsertLeave" },
    dependencies = {
        {
            -- snippet plugin
            "L3MON4D3/LuaSnip",
            dependencies = "rafamadriz/friendly-snippets",
            opts = { history = true, updateevents = "TextChanged,TextChangedI" },
            config = function(_, opts)
                require("luasnip").config.set_config(opts)
                require("nvchad.configs.luasnip")
            end,
        },

        -- autopairing of (){}[] etc
        {
            "windwp/nvim-autopairs",
            opts = {
                fast_wrap = {},
                disable_filetype = { "TelescopePrompt", "vim" },
            },
            config = function(_, opts)
                require("nvim-autopairs").setup(opts)

                -- setup cmp for autopairs
                local cmp_autopairs = require("nvim-autopairs.completion.cmp")
                require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
            end,
        },
        {
            "hrsh7th/cmp-cmdline",
            event = { "CmdLineEnter" },
            opts = { history = true, updateevents = "CmdlineEnter,CmdlineChanged" },
            config = function()
                local cmp = require("cmp")

                cmp.setup.cmdline("/", {
                    mapping = cmp.mapping.preset.cmdline(),
                    sources = {
                        { name = "buffer" },
                    },
                })

                -- `:` cmdline setup.
                cmp.setup.cmdline(":", {
                    mapping = cmp.mapping.preset.cmdline(),
                    sources = cmp.config.sources({
                        { name = "path" },
                    }, {
                        {
                            name = "cmdline",
                            option = {
                                ignore_cmds = { "Man", "!" },
                            },
                        },
                    }),
                })
            end,
        },
        {
            "zbirenbaum/copilot-cmp",
            dependencies = {
                "zbirenbaum/copilot.lua",
                config = function()
                    require("copilot").setup({
                        suggestion = { enabled = false },
                        panel = { enabled = false },
                    })
                end,
            },
            config = function()
                require("copilot_cmp").setup()
            end,
        },
        -- cmp sources plugins
        {
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-git",
        },
    },
    opts = function()
        local base = require("nvchad.configs.cmp")
        local custom = require("custom.configs.cmp")

        base.sources = custom.sources
        base.sorting = custom.sorting

        return base
    end,
}
