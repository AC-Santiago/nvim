local language_config = require("configs.languages")

if language_config.is_enabled("rust") then
    return {
        { import = "plugins.lang.rust.crates" },
        { import = "plugins.lang.rust.rustaceanvim" },
    }
else
    return {}
end
