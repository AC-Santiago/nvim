-- Copilot Language Server (copilot-language-server)
-- Usa el binario incluido en el plugin zbirenbaum/copilot.lua
-- Requerido por sidekick.nvim para Next Edit Suggestions (NES)
---@type vim.lsp.Config
return {
    cmd = {
        "node",
        vim.fn.stdpath("data") .. "/lazy/copilot.lua/copilot/js/language-server.js",
        "--stdio",
    },
    root_markers = { ".git", "." },
    filetypes = {
        "python",
        "lua",
        "rust",
        "markdown",
        "toml",
        "javascript",
        "typescript",
        "typescriptreact",
        "javascriptreact",
        "html",
        "css",
        "json",
        "yaml",
        "sql",
    },
    init_options = {
        copilot = {
            nextEditSuggestions = {
                enabled = true,
            },
        },
    },
}
