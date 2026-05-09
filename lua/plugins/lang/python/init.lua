local lang_loader = require("utils.lang_loader")
local configs = lang_loader.load_lang_configs("python")
local language_config = require("configs.languages")

if language_config.is_enabled("python") then
    table.insert(configs, { import = "plugins.lang.python.uv-nvim" })
    return configs
else
    return {}
end
