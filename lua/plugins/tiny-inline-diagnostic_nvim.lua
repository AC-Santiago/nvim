return {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "LspAttach", -- Or `LspAttach`
    priority = 1000, -- needs to be loaded in first
    config = function()
        require("tiny-inline-diagnostic").setup({
            signs = {
                left = "",
                right = "",
                diag = "●",
                arrow = "    ",
                up_arrow = "    ",
                vertical = " │",
                vertical_end = " └",
            },
            blend = {
                factor = 0.22,
            },
        })
        vim.diagnostic.config({ virtual_text = false })
    end,
}
