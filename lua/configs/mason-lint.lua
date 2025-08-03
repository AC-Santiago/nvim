local lint = package.loaded["lint"]
local lang_loader = require("utils.lang_loader")

-- List of linters to ignore during install
local ignore_install = { "luacheck" }

-- Helper function to find if value is in table.
local function table_contains(table, value)
    for _, v in ipairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

-- Obtener linters de lenguajes habilitados
local lang_linters = lang_loader.get_install_list("linters")

-- Build a list of linters to install minus the ignored list.
local all_linters = {}
-- Agregar linters de lenguajes habilitados
for _, linter in ipairs(lang_linters) do
    if not table_contains(ignore_install, linter) and not table_contains(all_linters, linter) then
        table.insert(all_linters, linter)
    end
end
-- Mantener compatibilidad con linters existentes
for _, v in pairs(lint.linters_by_ft) do
    for _, linter in ipairs(v) do
        if not table_contains(ignore_install, linter) and not table_contains(all_linters, linter) then
            table.insert(all_linters, linter)
        end
    end
end

print("Linters to be installed: " .. vim.inspect(all_linters))

require("mason-nvim-lint").setup({
    ensure_installed = all_linters,
    automatic_installation = false,
})
