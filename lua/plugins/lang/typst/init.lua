local lang_loader = require("utils.lang_loader")
local configs = lang_loader.load_lang_configs("typst")
local language_config = require("configs.languages")

if language_config.is_enabled("typst") then
    return { import = "plugins.lang.typst.typst-preview" }
else
    return {}
end

return configs
