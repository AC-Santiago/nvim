local language_config = require("configs.languages")

if language_config.is_enabled("html") then
    return { import = "plugins.lang.html.live_preview" }
else
    return {}
end
