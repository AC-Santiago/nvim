local lang_loader = require("utils.lang_loader")

-- Obtener formatters de lenguajes habilitados
local lang_formatters = lang_loader.get_install_list("formatters")

require("mason-conform").setup({
    -- List of formatters to ignore during install
    ignore_install = {},
    -- Instalar formatters de lenguajes habilitados automáticamente
    ensure_installed = lang_formatters,
})
