local lang_loader = require("utils.lang_loader")
lang_loader.load_lang_configs("rust")
local language_config = require("configs.languages")

if language_config.is_enabled("rust") then
    return {
        { import = "plugins.lang.rust.crates" },
        { import = "plugins.lang.rust.rustaceanvim" },
    }
else
    return {}
end
