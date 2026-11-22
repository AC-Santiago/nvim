---@type vim.lsp.Config
return {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    settings = {
        Lua = {
            completion = {
                callSnippet = "Replace",
            },
            -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
            diagnostics = {
                globals = { "nixCats", "dd", "bt" },
                disable = { "missing-fields" },
            },
        },
    },
}
