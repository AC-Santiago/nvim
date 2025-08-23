local lang_loader = require("utils.lang_loader")
lang_loader.load_lang_configs("html")
local language_config = require("configs.languages")

if language_config.is_enabled("html") then
    return { import = "plugins.lang.html.live_preview" }
else
    return {}
end
