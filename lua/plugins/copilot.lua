return {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "InsertEnter",
    opts = {
        filetypes = {
            python = true,
            lua = true,
            markdown = true,
            ["*"] = false,
        },
        panel = { enabled = false },
        suggestion = { enabled = false },
    },
}
