require("mason-nvim-dap").setup({
    ensure_installed = { "python", "codelldb" },
    automatic_installation = { exclude = {} },
})
