---@type vim.lsp.Config
return {
    cmd = { "markdown-oxide" },
    filetypes = { "markdown" },
    root_markers = { ".moxide.toml", ".obsidian", ".git" },
}
