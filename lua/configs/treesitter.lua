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

function M.langs_unistall()
    local langs_unistall = {}
    local disable_languages = require("configs.languages").get_disable_languages()
    local parser_list = require("nvim-treesitter").get_installed()

    for _, lang in ipairs(disable_languages) do
        local module_name = "plugins.lang." .. lang .. ".treesitter"
        local ok, lang_config = pcall(require, module_name)
        if ok and lang_config.ensure_installed and type(lang_config.ensure_installed) == "table" then
            for _, parser in ipairs(lang_config.ensure_installed) do
                if vim.tbl_contains(parser_list, parser) then
                    table.insert(langs_unistall, parser)
                end
            end
        end
    end
    require("nvim-treesitter.install").uninstall(langs_unistall)
    -- print("Parsers uninstalled: " .. table.concat(langs_unistall, ", "))
end

function M.setup()
    local final_config = vim.deepcopy(M.base_config)
    local new_ensure_installed_status = require("configs.languages").get_enabled_languages()

    if #new_ensure_installed_status > 0 then
        final_config.ensure_installed = M.add_langs_extend()
    else
        final_config.ensure_installed = M.base_config.ensure_installed
    end

    local seen = {}
    local unique_installed = {}
    for _, parser in ipairs(final_config.ensure_installed) do
        if not seen[parser] then
            seen[parser] = true
            table.insert(unique_installed, parser)
        end
    end
    final_config.ensure_installed = unique_installed

    require("nvim-treesitter").install(final_config.ensure_installed)
    M.langs_unistall()
end

M.setup()

return M
