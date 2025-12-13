return {
    "benomahony/uv.nvim",
    ft = { "python" },
    dependencies = {
        "nvim-telescope/telescope.nvim",
    },
    opts = {
        picker_integration = true,
        keymaps = {
            prefix = "<localleader>x", -- Main prefix for uv commands
        },
    },
}
