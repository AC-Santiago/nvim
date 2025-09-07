local M = {
    -- Lenguajes habilitados
    python = true,
    rust = true,
    typst = true,
    html = false,
    css = false,
    javascript = false,

    -- Configuraciones específicas por lenguaje
    configs = {
        python = {
            lsp_servers = { "pyright", "ruff" },
            linters = { "ruff" },
            formatters = { "ruff" },
            dap_adapters = { "debugpy" },
        },
        rust = {
            lsp_servers = { "rust_analyzer" },
            linters = {},
            formatters = {},
            dap_adapters = { "codelldb" },
        },
        typst = {
            lsp_servers = { "tinymist" },
            linters = {},
            formatters = { "typstyle" },
            dap_adapters = {},
        },
        html = {
            lsp_servers = { "html" },
            linters = {},
            formatters = { "prettier" },
            dap_adapters = {},
        },
        css = {
            lsp_servers = { "cssls" },
            linters = {},
            formatters = { "prettier" },
            dap_adapters = {},
        },
        javascript = {
            lsp_servers = { "vtsls" },
            linters = { "oxlint" },
            formatters = { "prettier" },
            dap_adapters = { "js-debug-adapter" },
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
