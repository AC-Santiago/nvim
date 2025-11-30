local lang_loader = require("utils.lang_loader")
lang_loader.load_lang_configs("sql")
local language_config = require("configs.languages")

if language_config.is_enabled("sql") then
    return {
        { import = "plugins.lang.sql.nvim-dbee" },
    }
else
    return {}
end
