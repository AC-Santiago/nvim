local lang_loader = require("utils.lang_loader")
local configs = lang_loader.load_lang_configs("css")
local language_config = require("configs.languages")

if language_config.is_enabled("css") then
    return { import = "plugins.lang.css.nvim-html-css" }
else
    return {}
end

return configs
