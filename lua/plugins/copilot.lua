local M = {
    "zbirenbaum/copilot.lua",
    cond = vim.fn.has("win32") == 0,
    cmd = "Copilot",
    event = "InsertEnter",
}

M.opts = {
    filetypes = {
        python = true,
        lua = true,
        rust = true,
        markdown = true,
        toml = true,
        ["*"] = false,
    },
    panel = { enabled = false },
    suggestion = { enabled = false },
}

return M
