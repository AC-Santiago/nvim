return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        cmd = { "Neotree toggle" },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- Opcional, pero recomendado
            "MunifTanjim/nui.nvim", -- Necesario para algunas funcionalidades
        },
        opts = {
            window = {
                position = "left", -- Posición de la ventana
                width = "30",
            },
            filesystem = {
                filtered_items = {
                    hide_dotfiles = false,
                    hide_gitignored = true,
                },
                find_args = { "--exclude", ".git", "--exclude", "node_modules" }, -- Excluir carpetas grandes
            },
        },
        keys = {
            { "<localleader>e", ":Neotree toggle<CR>", { noremap = true, silent = true, desc = ":Neotree toggle" } },
        },
    },
}
