-- Quarto integration plugin
return {
    "quarto-dev/quarto-nvim",
    ft = { "quarto", "qmd" },
    dependencies = {
        "jmbuhr/otter.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    opts = {
        lspFeatures = {
            languages = { "r", "python", "rust" },
            chunks = "all",
            diagnostics = {
                enabled = true,
                triggers = { "BufWritePost" },
            },
            completion = {
                enabled = true,
            },
        },
        codeRunner = {
            enabled = true,
            default_method = "molten", -- Usar molten para Jupyter
            ft_runners = {
                python = "molten",
            },
            never_run = { "yaml" },
        },
        keymap = {
            hover = "K",
            definition = "gd",
            type_definition = "gD",
            rename = "<leader>ra",
            format = "<leader>fm",
            references = "gr",
            document_symbols = "gS",
        },
    },
    config = function(_, opts)
        require("quarto").setup(opts)

        local runner = require("quarto.runner")
        local keymap = vim.keymap.set
        keymap("n", "<localleader>qp", ":QuartoPreview<CR>", { desc = "Quarto Preview", silent = true })
        keymap("n", "<localleader>qq", ":QuartoClosePreview<CR>", { desc = "Quarto Close Preview", silent = true })
        keymap("n", "<localleader>qa", ":QuartoActivate<CR>", { desc = "Quarto Activate", silent = true })

        -- Ejecutar celdas
        keymap("n", "<localleader>rc", runner.run_cell, { desc = "Run Cell", silent = true })
        keymap("n", "<localleader>ra", runner.run_above, { desc = "Run Cell and Above", silent = true })
        keymap("n", "<localleader>rA", runner.run_all, { desc = "Run All Cells", silent = true })
        keymap("n", "<localleader>rl", runner.run_line, { desc = "Run Line", silent = true })
        keymap("v", "<localleader>r", runner.run_range, { desc = "Run Visual Range", silent = true })
    end,
}
