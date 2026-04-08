local lang_loader = require("utils.lang_loader")
local language_config = require("configs.languages")

-- Cargar configuraciones específicas del lenguaje
local configs = {}

if language_config.is_enabled("astro") then
    -- Treesitter para Astro
    local treesitter_ok, treesitter_config = pcall(require, "plugins.lang.astro.treesitter")
    if treesitter_ok and treesitter_config then
        vim.list_extend(configs, treesitter_config)
    end

    -- LSP para Astro
    local lsp_ok, lsp_config = pcall(require, "plugins.lang.astro.lsp")
    if lsp_ok then
        -- La configuración LSP se aplica directamente en el archivo lsp.lua
    end

    -- Formateo (Conform) para Astro
    local conform_ok, conform_config = pcall(require, "plugins.lang.astro.conform")
    if conform_ok and conform_config and #conform_config > 0 then
        vim.list_extend(configs, conform_config)
    end
end

return configs