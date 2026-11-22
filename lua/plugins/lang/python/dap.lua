return {
    {
        "mfussenegger/nvim-dap-python",
        cond = vim.fn.has("win32") == 0,
        ft = "python",
        dependencies = {
            "mfussenegger/nvim-dap",
            "rcarriga/nvim-dap-ui",
        },
    },
}
