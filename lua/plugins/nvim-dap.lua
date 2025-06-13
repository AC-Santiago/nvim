local M = {
    "mfussenegger/nvim-dap",
    event = {
        "VeryLazy",
    },

    dependencies = {
        -- Este muestra en el debug el contenido de la variable
        "theHamsta/nvim-dap-virtual-text",

        -- Interfaz de usuario del DAP
        "rcarriga/nvim-dap-ui",
        "nvim-telescope/telescope-dap.nvim", -- Integracion de Telescope
        -- Para trabajos asincronicos como APIs
        "nvim-neotest/nvim-nio",
    },
    -- stylua: ignore
    keys = {
        { "<localleader>d",  "",desc = "+debug",mode = { "n", "v" } },
        { "<localleader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
        { "<localleader>db", function() require("dap").toggle_breakpoint() end,desc = "Toggle Breakpoint" },
        { "<localleader>dc", function() require("dap").continue() end,desc = "Continue" },
        { "<localleader>da", function() require("dap").continue({ before = get_args }) end,desc = "Run with Args" },
        { "<localleader>dC", function() require("dap").run_to_cursor() end,desc = "Run to Cursor" },
        { "<localleader>dg", function() require("dap").goto_() end,desc = "Go to Line (No Execute)" },
        { "<localleader>di", function() require("dap").step_into() end,desc = "Step Into" },
        { "<localleader>dj", function() require("dap").down() end,desc = "Down" },
        { "<localleader>dk", function() require("dap").up() end,desc = "Up" },
        { "<localleader>dl", function() require("dap").run_last() end,desc = "Run Last" },
        { "<localleader>do", function() require("dap").step_out() end,desc = "Step Out" },
        { "<localleader>dO", function() require("dap").step_over() end,desc = "Step Over" },
        { "<localleader>dp", function() require("dap").pause() end,desc = "Pause" },
        { "<localleader>dr", function() require("dap").repl.toggle() end,desc = "Toggle REPL" },
        { "<localleader>ds", function() require("dap").session() end,desc = "Session" },
        { "<localleader>dt", function() require("dap").terminate() end,desc = "Terminate" },
        { "<localleader>dw", function() require("dap.ui.widgets").hover() end,desc = "Widgets" },
    },
    config = function()
        require("configs.DAP")
        local ok_telescope, telescope = pcall(require, "telescope")
        if ok_telescope then
            telescope.load_extension("dap")
        end
    end,
}

return M
