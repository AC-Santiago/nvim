local lang_loader = require("utils.lang_loader")
lang_loader.load_lang_configs("markdown")
lang_loader.apply_direct_configs("markdown", "conform")
local language_config = require("configs.languages")

if language_config.is_enabled("markdown") then
    return {
        { import = "plugins.lang.markdown.markview" },
        { import = "plugins.lang.markdown.obsidian-nvim" },
        { import = "plugins.lang.markdown.render-markdown-nvim" },
    }
else
    return {}
end
