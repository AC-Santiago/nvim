local conform = require("conform")
local mason_typstyle = vim.fn.stdpath("data") .. "/mason/bin/typstyle"

conform.formatters_by_ft.typst = { "typstyle" }

conform.formatters.typstyle = {
    command = function()
        return vim.fn.executable(mason_typstyle) == 1 and mason_typstyle or "typstyle"
    end,
    args = { "-i", "$FILENAME" },
    stdin = false,
}
