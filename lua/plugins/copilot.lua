local M = {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "InsertEnter",
}

M.opts = {
    filetypes = {
        python = true,
        lua = true,
        markdown = true,
        ["*"] = false,
    },
    panel = { enabled = true },
    suggestion = { enabled = true },
}

return M
