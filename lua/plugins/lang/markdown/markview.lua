return {
    "OXY2DEV/markview.nvim",
    lazy = false,
    dependencies = { "saghen/blink.cmp" },
    ---@module "markview"
    ---@type markview.config
    opts = {
        markdown = {
            enable = true,
        },
        markdown_inline = {
            enable = true,
        },
        typst = {
            enable = true,
        },
    },
}
