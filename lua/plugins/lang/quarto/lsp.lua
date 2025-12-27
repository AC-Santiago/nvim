local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

-- Configuración para Quarto LSP
vim.lsp.config("quarto", {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
    filetypes = { "quarto", "qmd" },
    root_dir = function(fname)
        local found = vim.fs.find({ "_quarto.yml", ".git" }, { upward = true, path = fname })
        if found and #found > 0 then
            return vim.fs.dirname(found[1])
        end
        -- Fallback to current directory
        return vim.fn.getcwd()
    end,
})
