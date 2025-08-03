local lspconfig = package.loaded["lspconfig"]
local lang_loader = require("utils.lang_loader")

-- List of servers to ignore during install
local ignore_install = {}

-- Helper function to find if value is in table.
local function table_contains(table, value)
    for _, v in ipairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

-- Obtener servers de lenguajes habilitados
local lang_servers = lang_loader.get_install_list("lsp_servers")

-- Build a list of lsp servers to install minus the ignored list.
local all_servers = {}
-- Agregar servers de lenguajes habilitados
for _, server in ipairs(lang_servers) do
    if not table_contains(ignore_install, server) then
        table.insert(all_servers, server)
    end
end
-- Mantener compatibilidad con servers existentes
for _, s in ipairs(lspconfig.servers or {}) do
    if not table_contains(ignore_install, s) and not table_contains(all_servers, s) then
        table.insert(all_servers, s)
    end
end

require("mason-lspconfig").setup({
    ensure_installed = all_servers,
    automatic_installation = false,
})
