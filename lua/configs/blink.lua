local M = {
    keymap = {
        preset = "default",
        ["<CR>"] = { "accept", "fallback" },
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
    },
    appearance = {
        nerd_font_variant = "mono",
    },

    completion = { documentation = { auto_show = false } },

    sources = {
        default = { "lazydev", "copilot", "avante", "lsp", "path", "snippets", "buffer" },
        compat = { "dap" },

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
                enabled = function()
                    return require("cmp_dap").is_dap_buffer()
                end,
            },
        },
    },

    fuzzy = { implementation = "prefer_rust_with_warning" },
}

return M
