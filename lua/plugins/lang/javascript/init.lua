local lang_loader = require("utils.lang_loader")
local configs = lang_loader.load_lang_configs("javascript")
local language_config = require("configs.languages")

if language_config.is_enabled("javascript") then
    return configs
else
    return {}
end
