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
        rust = true,
        markdown = true,
        toml = true,
        ["*"] = false,
    },
    panel = { enabled = false },
    suggestion = { enabled = false },
}

return M
