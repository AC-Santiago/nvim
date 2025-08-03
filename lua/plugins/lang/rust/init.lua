local lang_loader = require("utils.lang_loader")
local configs = lang_loader.load_lang_configs("rust")

-- Agregar las configuraciones específicas de Rust que ya existían
local rust_configs = {
    { import = "plugins.lang.rust.rustaceanvim" },
    { import = "plugins.lang.rust.crates" },
}

-- Combinar con las configuraciones cargadas automáticamente
vim.list_extend(configs, rust_configs)

return configs
