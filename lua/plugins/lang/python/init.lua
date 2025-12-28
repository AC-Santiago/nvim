local lang_loader = require("utils.lang_loader")
local configs = lang_loader.load_lang_configs("python")
local language_config = require("configs.languages")

if language_config.is_enabled("python") then
    table.insert(configs, { import = "plugins.lang.python.uv-nvim" })
    table.insert(configs, { import = "plugins.lang.python.jupytext-nvim" })
    table.insert(configs, { import = "plugins.lang.python.otter-nvim" })
    table.insert(configs, { import = "plugins.lang.python.molten-nvim" })
    table.insert(configs, { import = "plugins.lang.python.quarto-nvim" })
    return configs
else
    return {}
end
