-- Molten for Jupyter notebook integration
return {
    "benlubas/molten-nvim",
    version = "^1.0.0",
    ft = { "python", "quarto", "qmd" },
    dependencies = {
        "3rd/image.nvim",
    },
    build = ":UpdateRemotePlugins",
    init = function()
        -- Molten configuration
        vim.g.molten_image_provider = "image.nvim"
        vim.g.molten_output_win_max_height = 20
        vim.g.molten_auto_open_output = false
        vim.g.molten_wrap_output = true
        vim.g.molten_virt_text_output = true
        vim.g.molten_virt_lines_off_by_1 = true
    end,
    config = function()
        -- Keymaps for Molten
        local map = vim.keymap.set

        -- Initialize Molten
        map("n", "<leader>mi", ":MoltenInit<CR>", { desc = "Molten Init", silent = true })
        
        -- Evaluate
        map("n", "<leader>me", ":MoltenEvaluateOperator<CR>", { desc = "Molten Evaluate Operator", silent = true })
        map("n", "<leader>ml", ":MoltenEvaluateLine<CR>", { desc = "Molten Evaluate Line", silent = true })
        map("v", "<leader>mv", ":<C-u>MoltenEvaluateVisual<CR>gv", { desc = "Molten Evaluate Visual", silent = true })
        map("n", "<leader>mr", ":MoltenReevaluateCell<CR>", { desc = "Molten Re-evaluate Cell", silent = true })
        
        -- Output
        map("n", "<leader>mo", ":MoltenShowOutput<CR>", { desc = "Molten Show Output", silent = true })
        map("n", "<leader>mh", ":MoltenHideOutput<CR>", { desc = "Molten Hide Output", silent = true })
        map("n", "<leader>md", ":MoltenDelete<CR>", { desc = "Molten Delete Cell", silent = true })
        
        -- Navigation
        map("n", "]c", ":MoltenNext<CR>", { desc = "Molten Next Cell", silent = true })
        map("n", "[c", ":MoltenPrev<CR>", { desc = "Molten Previous Cell", silent = true })
    end,
}
