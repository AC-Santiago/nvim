local M = {}

---@param kind string
function M.pick(kind)
    return function()
        local actions = require("CopilotChat.actions")
        local items = actions[kind .. "_actions"]()
        if not items then
            vim.notify("No " .. kind .. " found on the current line", vim.log.levels.WARN)
            return
        end
        local ok, fzf_lua = pcall(require, "fzf-lua")
        if ok then
            fzf_lua.pick(items)
        else
            require("telescope").pick(items)
        end
    end
end

M = {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    cmd = "CopilotChat",
    dependencies = {
        { "zbirenbaum/copilot.lua" },
        { "nvim-lua/plenary.nvim" },
    },
    opts = function()
        local user = vim.env.USER or "User"
        user = user:sub(1, 1):upper() .. user:sub(2)
        return {
            auto_insert_mode = true,
            show_help = true,
            question_header = "  " .. user .. " ",
            answer_header = "  Copilot ",
            window = {
                width = 0.4,
            },
            selection = function(source)
                local select = require("CopilotChat.select")
                return select.visual(source) or select.buffer(source)
            end,
        }
    end,
    keys = {
        { "<c-s>", "<CR>", ft = "copilot-chat", desc = "Submit Prompt", remap = true },
        { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
        {
            "<leader>aa",
            function()
                require("CopilotChat").toggle()
            end,
            desc = "Toggle (CopilotChat)",
            mode = { "n", "v" },
        },
        {
            "<leader>ax",
            function()
                require("CopilotChat").reset()
            end,
            desc = "Clear (CopilotChat)",
            mode = { "n", "v" },
        },
        {
            "<leader>aq",
            function()
                local input = vim.fn.input("Quick Chat: ")
                if input ~= "" then
                    require("CopilotChat").ask(input)
                end
            end,
            desc = "Quick Chat (CopilotChat)",
            mode = { "n", "v" },
        },
        { "<leader>ad", M.pick("help"), desc = "Diagnostic Help (CopilotChat)", mode = { "n", "v" } },
        { "<leader>ap", M.pick("prompt"), desc = "Prompt Actions (CopilotChat)", mode = { "n", "v" } },
    },
    config = function(_, opts)
        local chat = require("CopilotChat")
        require("CopilotChat.integrations.cmp").setup()

        vim.api.nvim_create_autocmd("BufEnter", {
            pattern = "copilot-chat",
            callback = function()
                vim.opt_local.relativenumber = false
                vim.opt_local.number = false
            end,
        })

        chat.setup(opts)
    end,
}

return M
