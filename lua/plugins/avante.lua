return {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false,
    dependencies = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim",
        {
            -- Make sure to set this up properly if you have lazy=true
            "MeanderingProgrammer/render-markdown.nvim",
            opts = {
                file_types = { "markdown", "Avante" },
            },
            ft = { "markdown", "Avante" },
        },
    },
    cmd = {
        "AvanteAsk",
        "AvanteChat",
        "AvanteComplete",
        "AvanteEdit",
        "AvanteExplain",
        "AvanteInlineChat",
        "AvanteToggle",
    },
    keys = {
        { "<leader>aa", "<cmd>AvanteAsk<cr>", desc = "Ask AI" },
        { "<leader>ac", "<cmd>AvanteChat<cr>", desc = "Chat with AI" },
        { "<leader>ae", "<cmd>AvanteEdit<cr>", desc = "Edit with AI" },
        { "<leader>ai", "<cmd>AvanteInlineChat<cr>", desc = "Inline AI Chat" },
        { "<leader>ax", "<cmd>AvanteExplain<cr>", desc = "Explain with AI" },
    },
    opts = {
        autoformat = true, -- Format AI responses automatically
        -- or "openai" or "gpt-4" or "gpt-3.5-turbo" or "claude-3-opus"
        providers = "copilot",
        ui = {
            code_action = {
                icon = "🤖",
            },
            chat = {
                border = "rounded",
                width = 0.8, -- Percentage of screen width
                height = 0.8, -- Percentage of screen height
                spinner = "dots", -- Animation style
            },
        },
        chats = {
            auto_size = true, -- Auto-resize chat window
            auto_scroll = true, -- Auto-scroll to bottom of chat
            show_settings = true, -- Show settings button
            show_system_prompt = false, -- Don't show system prompt by default
        },
    },
    build = "make",
}
