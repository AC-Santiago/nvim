return {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
        { "tpope/vim-dadbod", lazy = true },
        { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" } }, -- Optional
    },
    cmd = {
        "DBUI",
        "DBUIToggle",
        "DBUIAddConnection",
        "DBUIFindBuffer",
    },
    init = function()
        -- Your DBUI configuration
        vim.g.db_ui_use_nerd_fonts = 1
    end,
    keys = {
        { "<leader>du", "<cmd>DBUI<cr>", desc = "Database UI" },
        { "<C-Enter>", "<cmd>DB < %<CR>", mode = "n", desc = "Runs SQL in current buffer" },
        { "<C-Enter>", "<cmd>'<,'> DB<CR>", mode = "v", desc = "Runs SQL in visual selection" },
    },
}
