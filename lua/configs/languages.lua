local windows = vim.fn.has("win32") == 1
local javascript = { "javascript", "javascriptreact", "typescript", "typescriptreact" }

local M = {
    -- Lenguajes habilitados
    python = true,
    rust = not windows,
    typst = true,
    html = false,
    css = false,
    javascript = false,
    sql = false,
    markdown = true,

    -- Configuraciones específicas por lenguaje
    configs = {
        base = {
            filetypes = { "lua" },
            lsp = { { id = "lua_ls", package = "lua-language-server", bin = "lua-language-server" } },
            format = { { id = "stylua", package = "stylua", bin = "stylua" } },
            lint = windows and {} or { { id = "luacheck", bin = "luacheck" } },
        },
        python = {
            filetypes = { "python" },
            lsp = {
                { id = "pyrefly", package = "pyrefly", bin = "pyrefly" },
                { id = "ruff", package = "ruff", bin = "ruff" },
            },
            format = {
                { id = "ruff_fix", package = "ruff", bin = "ruff" },
                { id = "ruff_format", package = "ruff", bin = "ruff" },
                { id = "ruff_organize_imports", package = "ruff", bin = "ruff" },
            },
            lint = { { id = "ruff", package = "ruff", bin = "ruff" } },
            lsp_servers = { "pyrefly", "ruff" },
            linters = { "ruff" },
            formatters = { "ruff" },
            dap_adapters = { "debugpy" },
        },
        rust = {
            filetypes = { "rust" },
            lsp = {
                { id = "rust_analyzer", package = "rust-analyzer", bin = "rust-analyzer", owner = "rustaceanvim" },
            },
            lsp_servers = { "rust_analyzer" },
            linters = {},
            formatters = {},
            dap_adapters = { "codelldb" },
        },
        typst = {
            filetypes = { "typst" },
            lsp = { {
                id = "tinymist",
                package = "tinymist",
                bin = "tinymist",
                options = { root_markers = { "typst.toml", ".git" } },
            } },
            format = { { id = "typstyle", package = "typstyle", bin = "typstyle", install = not windows } },
            lsp_servers = { "tinymist" },
            linters = {},
            formatters = { "typstyle" },
            dap_adapters = {},
        },
        html = {
            filetypes = { "html" },
            lsp = { {
                id = "html",
                package = "html-lsp",
                bin = "vscode-html-language-server",
                options = { cmd = { "vscode-html-language-server", "--stdio" } },
            } },
            format = { { id = "prettier", package = "prettier", bin = "prettier", filetypes = { "html", "xhtml" } } },
            lsp_servers = { "html" },
            linters = {},
            formatters = { "prettier" },
            dap_adapters = {},
        },
        css = {
            filetypes = { "css", "scss", "less" },
            lsp = { {
                id = "cssls",
                package = "css-lsp",
                bin = "vscode-css-language-server",
                options = { cmd = { "vscode-css-language-server", "--stdio" } },
            } },
            format = { { id = "prettier", package = "prettier", bin = "prettier" } },
            lsp_servers = { "cssls" },
            linters = {},
            formatters = { "prettier" },
            dap_adapters = {},
        },
        javascript = {
            filetypes = javascript,
            lsp = { { id = "vtsls", package = "vtsls", bin = "vtsls" } },
            format = {
                { id = "prettier", package = "prettier", bin = "prettier", filetypes = {
                    "javascript", "javascriptreact", "typescript", "typescriptreact", "json", "jsonc",
                } },
            },
            lint = { { id = "oxlint", package = "oxlint", bin = "oxlint" } },
            lsp_servers = { "vtsls" },
            linters = { "oxlint" },
            formatters = { "prettier" },
            dap_adapters = { "js-debug-adapter" },
        },
        sql = {
            filetypes = { "sql", "mysql" },
            lsp = { { id = "sqlls", package = "sqlls", bin = "sql-language-server" } },
            format = { { id = "sql-formatter", package = "sql-formatter", bin = "sql-formatter", filetypes = { "sql" } } },
            lsp_servers = { "sqlls" },
            linters = {},
            formatters = { "sql-formatter" },
            dap_adapters = {},
        },
        markdown = {
            filetypes = { "markdown" },
            lsp = { { id = "markdown_oxide", package = "markdown-oxide", bin = "markdown-oxide" } },
            format = { { id = "dprint", package = "dprint", bin = "dprint" } },
            lsp_servers = { "markdown_oxide" },
            linters = {},
            formatters = {},
            dap_adapters = {},
        },
    },
}

function M.is_enabled(lang)
    return M[lang] == true
end

-- Función para obtener la configuración de un lenguaje
function M.get_config(lang)
    return M.configs[lang] or {}
end

-- Función para obtener todos los lenguajes habilitados
function M.get_enabled_languages()
    local enabled = {}
    for lang, enabled_status in pairs(M) do
        if type(enabled_status) == "boolean" and enabled_status and lang ~= "configs" then
            table.insert(enabled, lang)
        end
    end
    return enabled
end

function M.get_disable_languages()
    local disabled = {}
    for lang, enabled_status in pairs(M) do
        if type(enabled_status) == "boolean" and not enabled_status and lang ~= "configs" then
            table.insert(disabled, lang)
        end
    end
    return disabled
end

return M
