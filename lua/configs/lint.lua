local lint = require("lint")
local lang_loader = require("utils.lang_loader")

-- Configuración base de lint
lint.linters_by_ft = {
    lua = { "luacheck" },
}

lint.linters.luacheck.args = {
    "--globals",
    "love",
    "vim",
    "--formatter",
    "plain",
    "--codes",
    "--ranges",
    "-",
}

-- Aplicar configuraciones de lint de todos los lenguajes habilitados
local lang_config = require("configs.languages")
for _, lang in ipairs(lang_config.get_enabled_languages()) do
    lang_loader.apply_direct_configs(lang, "lint")
end
