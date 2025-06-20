return {
    { import = "nvchad.blink.lazyspec" },
    {
        "Saghen/blink.cmp",
        dependencies = {
            "fang2hou/blink-copilot",
            "rcarriga/cmp-dap",
            "Kaiser-Yang/blink-cmp-avante",
            {
                "saghen/blink.compat",
                version = "2.*",
                lazy = true,
                opts = {},
            },
        },
        opts = {
            sources = {
                default = function()
                    local sources = { "lazydev", "copilot", "avante", "lsp", "path", "snippets", "buffer" }
                    if require("cmp_dap").is_dap_buffer() then
                        return sources.concat({ "dap" })
                    else
                        return sources
                    end
                end,
                providers = {
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        score_offset = 100,
                    },
                    copilot = {
                        name = "copilot",
                        module = "blink-copilot",
                        score_offset = 100,
                        async = true,
                    },
                    avante = {
                        module = "blink-cmp-avante",
                        name = "Avante",
                        opts = {},
                    },

                    dap = {
                        name = "dap",
                        module = "blink.compat.source",
                    },
                },
            },
        },
    },
}
