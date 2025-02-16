local dap = require("dap")

local dap_ui = require("dapui")

-- Inicio de Virtual text
require("nvim-dap-virtual-text").setup({})

for _, ft_path in pairs(vim.api.nvim_get_runtime_file("lua/configs/DAP/lang/*.lua", true)) do
    loadfile(ft_path)()
end

-- Simbolos del Debug
vim.fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "▶", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointRejected", { text = "🚫", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = "❓", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapLogPoint", { text = "💬", texthl = "", linehl = "", numhl = "" })

-- Setup de dapui
-- UI structure
dap_ui.setup({
    icons = { expanded = "🞃", collapsed = "🞂", current_frame = "→" },
    controls = {
        element = "repl",
        enabled = true,
        icons = {
            disconnect = "",
            pause = "",
            play = "",
            run_last = "",
            step_back = "",
            step_into = "",
            step_out = "",
            step_over = "",
            terminate = "",
        },
    },
    floating = {
        max_height = 0.8,
        max_width = 0.8,
        border = "rounded",
        mappings = {
            close = { "q", "<Esc>" },
        },
    },
    layouts = {
        {
            elements = {
                "scopes",
                "breakpoints",
                "stacks",
                "watches",
            },
            size = 40,
            position = "left",
        },
        {
            elements = {
                { id = "repl", size = 0.5 },
                { id = "console", size = 0.5 },
            },
            size = 10,
            position = "bottom",
        },
    },
})

-- Events Listeners
dap.listeners.after.event_initialized["dapui_config"] = function()
    dap_ui.open({})
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dap_ui.close({})
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dap_ui.close({})
end
