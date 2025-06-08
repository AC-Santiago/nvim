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

    -- hl_override = {
    -- 	Comment = { italic = true },
    -- 	["@comment"] = { italic = true },
    -- },
}

M.ui = {
    telescope = {
        style = "bordered",
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
}

M.ui.cmp = {
    style = "atom_colored",
}
return M
