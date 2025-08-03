local lang_loader = require("utils.lang_loader")
local configs = lang_loader.load_lang_configs("typst")

-- Agregar las configuraciones específicas de Typst que ya existían
local typst_configs = {
    { import = "plugins.lang.typst.typst-preview" },
}

-- Combinar con las configuraciones cargadas automáticamente
vim.list_extend(configs, typst_configs)

return configs
