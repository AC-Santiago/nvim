local lang_loader = require("utils.lang_loader")

-- Obtener adaptadores DAP de lenguajes habilitados
local lang_adapters = lang_loader.get_install_list("dap_adapters")

require("mason-nvim-dap").setup({
    ensure_installed = lang_adapters,
    automatic_installation = { exclude = {} },
})
