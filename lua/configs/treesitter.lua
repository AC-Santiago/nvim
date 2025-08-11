-- Configuración base de treesitter que será extendida por configuraciones específicas de lenguajes
local M = {}

-- Configuración base que siempre se incluye
M.base_config = {
    ensure_installed = {
        "bash",
        "fish",
        "lua",
        "luadoc",
        "markdown",
        "toml",
        "vim",
        "vimdoc",
        "yaml",
    },

    highlight = {
        enable = true,
        use_languagetree = true,
    },

    indent = { enable = true },
}

function M.add_langs_extend()
    local langs_init = vim.deepcopy(M.base_config.ensure_installed)

    local enabled_langs = require("configs.languages").get_enabled_languages()

    for _, lang in ipairs(enabled_langs) do
        local module_name = "plugins.lang." .. lang .. ".treesitter"
        local ok, lang_config = pcall(require, module_name)

        if ok then
            if lang_config.ensure_installed and type(lang_config.ensure_installed) == "table" then
                vim.list_extend(langs_init, lang_config.ensure_installed)
            end
        else
            vim.notify("No se encontro la configuración para " .. lang, vim.log.levels.WARN)
        end
    end

    return langs_init
end

-- Función para combinar configuraciones de lenguajes específicos
function M.setup()
    local final_config = vim.deepcopy(M.base_config)
    local new_ensure_installed_status = require("configs.languages").get_enabled_languages()

    if #new_ensure_installed_status > 0 then
        final_config.ensure_installed = M.add_langs_extend()
    else
        final_config.ensure_installed = M.base_config.ensure_installed
    end

    -- Remover duplicados de ensure_installed
    local seen = {}
    local unique_installed = {}
    for _, parser in ipairs(final_config.ensure_installed) do
        if not seen[parser] then
            seen[parser] = true
            table.insert(unique_installed, parser)
        end
    end
    final_config.ensure_installed = unique_installed

    require("nvim-treesitter.configs").setup(final_config)
end

M.setup()

return M
