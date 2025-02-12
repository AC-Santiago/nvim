local lint = require("lint")

lint.linters_by_ft = {
    lua = { "luacheck" },
    -- haskell = { "hlint" },
    python = { "ruff" },
}

lint.linters.luacheck.args = {
    "--globals",
    "love",
    "vim",
    "--formatter",
    "plain",
    "--codes",
    "--ranges",
    "-",
}

lint.linters.ruff.args = {
    "check",
}

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
    callback = function()
        lint.try_lint()
    end,
})
