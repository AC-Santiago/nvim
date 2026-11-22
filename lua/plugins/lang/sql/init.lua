local language_config = require("configs.languages")

if language_config.is_enabled("sql") then
    return {
        -- { import = "plugins.lang.sql.nvim-dbee" },
        { import = "plugins.lang.sql.vim-dadbod-ui" },
    }
else
    return {}
end
