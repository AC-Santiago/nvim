local lang_loader = require("utils.lang_loader")

local package_to_adapter = require("mason-nvim-dap.mappings.source").package_to_nvim_dap

local lang_adapters = vim.iter(lang_loader.get_install_list("dap_adapters"))
    :map(function(package_name)
        return package_to_adapter[package_name]
    end)
    :totable()

require("mason-nvim-dap").setup({
    ensure_installed = lang_adapters,
    automatic_installation = { exclude = {} },
})
