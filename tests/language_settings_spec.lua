vim.opt.rtp:prepend(vim.fn.getcwd())

local nvchad = {
    on_attach = function() end,
    on_init = function() end,
    capabilities = {
        workspace = { didChangeWatchedFiles = { dynamicRegistration = false } },
    },
}
package.loaded["nvchad.configs.lspconfig"] = nvchad

local markdown = require("plugins.lang.markdown.lsp").markdown_oxide
assert(markdown.capabilities.workspace.didChangeWatchedFiles.dynamicRegistration)
assert(nvchad.capabilities.workspace.didChangeWatchedFiles.dynamicRegistration == false)
for _, item in ipairs({
    { "html", "html" }, { "css", "cssls" }, { "javascript", "vtsls" }, { "sql", "sqlls" },
    { "python", "ruff" }, { "python", "pyrefly" },
}) do
    local settings = require("plugins.lang." .. item[1] .. ".lsp")
    assert(type(settings[item[2]]) == "table")
end
print("Language LSP settings are declarative and Markdown capabilities are isolated.")
