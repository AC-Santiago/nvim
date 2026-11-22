local language_config = require("configs.languages")

if language_config.is_enabled("css") then
    return { import = "plugins.lang.css.nvim-html-css" }
else
    return {}
end
