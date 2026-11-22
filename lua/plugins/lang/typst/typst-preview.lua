return {
    "chomosuke/typst-preview.nvim",
    cond = vim.fn.has("win32") == 0,
    ft = { "typst" },
    version = "1.*",
    opts = {
        dependencies_bin = {
            ["tinymist"] = "tinymist",
        },
    },
}
