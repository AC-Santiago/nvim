-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

local api = vim.api
local getNeoTreeWidth = function()
    for _, win in pairs(api.nvim_tabpage_list_wins(0)) do
        if vim.bo[api.nvim_win_get_buf(win)].ft == "neo-tree" then
            return api.nvim_win_get_width(win)
        end
    end
    return 0
end

M.base46 = {
    theme = "catppuccin",
    integrations = {
        "blink",
    },
    transparency = true,

    hl_override = {
        FloatTitle = { bg = "NONE" },
        PmenuSbar = { bg = "NONE" },
        PmenuThumb = { bg = "NONE" },
    },

    hl_add = {
        -- Noice (sin integración en base46)
        NoiceMini = { bg = "NONE" },
        NoicePopup = { bg = "NONE" },
        NoicePopupBorder = { fg = "grey", bg = "NONE" },
        NoiceCmdlinePopup = { bg = "NONE" },
        NoiceCmdlinePopupBorder = { fg = "grey", bg = "NONE" },
        -- nvim-notify body/background
        NotifyBackground = { bg = "NONE" },
        NotifyINFOBody = { bg = "NONE" },
        NotifyWARNBody = { bg = "NONE" },
        NotifyERRORBody = { bg = "NONE" },
        NotifyDEBUGBody = { bg = "NONE" },
        NotifyTRACEBody = { bg = "NONE" },
    },
}

M.ui = {
    telescope = {
        style = "borderless",
    },
    tabufline = {

        order = {
            "neotreeOffset",
            "treeOffset",
            "buffers",
            "tabs",
            "btns",
        },
        modules = {
            neotreeOffset = function()
                local w = getNeoTreeWidth()
                return w == 0 and "" or "%#NeoTreeTabActive#" .. string.rep(" ", w) .. "%#NeoTreeWinSeparator#" .. "│"
            end,
        },
    },
    statusline = {
        theme = "vscode_colored",
    },
}

M.nvdash = {
    load_on_startup = true,
    header = {
        " ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
        " ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
        " ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
        " ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
        " ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
        " ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
        "  Powered By  eovim ",
        "                      ",
    },
}

return M
