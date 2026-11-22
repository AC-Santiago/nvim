local language_config = require("configs.languages")

if language_config.is_enabled("typst") then
    return { { import = "plugins.lang.typst.typst-preview" } }
else
    return {}
end
