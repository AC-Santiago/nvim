local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

-- Native LSP configuration for Neovim 0.11+
-- Using vim.lsp.config instead of lspconfig

-- list of all servers configured.
local configured_servers = {
    "lua_ls",
}

-- list of servers configured with default config.
local default_servers = {}

-- lsps with default config
for _, lsp in ipairs(default_servers) do
    vim.lsp.config(lsp, {
        on_attach = on_attach,
        on_init = on_init,
        capabilities = capabilities,
    })
end

-- Lua Language Server configuration
vim.lsp.config("lua_ls", {
    cmd = { "lua-language-server" },
    root_markers = {
        ".luarc.json",
        ".luarc.jsonc",
        ".luacheckrc",
        ".stylua.toml",
        "stylua.toml",
        "selene.toml",
        "selene.yml",
        ".git",
    },
    filetypes = { "lua" },
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,

    settings = {
        Lua = {
            diagnostics = {
                enable = false, -- Disable all diagnostics from lua_ls
                -- globals = { "vim" },
            },
            hint = {
                enable = true, -- Enable inlay hints
                setType = true, -- Set type hints
                semicolon = "All",
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

-- Store configured servers for compatibility
vim.g.configured_lsp_servers = configured_servers

-- .config/nvim/lua/configs/lspconfig.lua
vim.diagnostic.config({
    underline = false,
    virtual_text = false,
    update_in_insert = false,
    severity_sort = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = " ",
            [vim.diagnostic.severity.INFO] = " ",
        },
    },
})

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
})
