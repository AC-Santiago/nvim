local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require("lspconfig")

-- list of all servers configured.
lspconfig.servers = {
    "lua_ls",
    -- "clangd",
    -- "gopls",
    -- "hls",
    -- "ols",
    "pyright",
}

-- list of servers configured with default config.
local default_servers = {
    -- "ols",
    -- "pyright",
}

-- lsps with default config
for _, lsp in ipairs(default_servers) do
    lspconfig[lsp].setup({
        on_attach = on_attach,
        on_init = on_init,
        capabilities = capabilities,
    })
end

lspconfig.lua_ls.setup({
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,

    settings = {
        Lua = {
            diagnostics = {
                enable = false, -- Disable all diagnostics from lua_ls
                -- globals = { "vim" },
            },
            workspace = {
                library = {
                    vim.fn.expand("$VIMRUNTIME/lua"),
                    vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
                    vim.fn.stdpath("data") .. "/lazy/ui/nvchad_types",
                    vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy",
                    "${3rd}/love2d/library",
                },
                maxPreload = 100000,
                preloadFileSize = 10000,
            },
        },
    },
})

-- Configuracion para python
--
lspconfig.ruff.setup({
    on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        client.server_capabilities.hoverProvider = false -- Desactiva hover en Ruff
    end,
    trace = "messages",
    init_options = {
        settings = {
            logLevel = "warn",
            lint = {
                preview = true,
            },
            format = {
                preview = true,
            },
        },
    },
})

lspconfig.pyright.setup({
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,

    settings = {
        python = {
            analysis = {
                typeCheckingMode = "off", -- Disable type checking diagnostics
            },
        },
    },
})
