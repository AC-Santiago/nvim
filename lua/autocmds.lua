local autocmd = vim.api.nvim_create_autocmd
local user_cmd = vim.api.nvim_create_user_command

autocmd("BufDelete", {
    callback = function()
        local bufs = vim.t.bufs
        if #bufs == 1 and vim.api.nvim_buf_get_name(bufs[1]) == "" then
            vim.cmd("Nvdash")
        end
    end,
})

autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
    callback = function()
        require("lint").try_lint()
    end,
})

autocmd("BufEnter", {
    pattern = "oil://*",
    callback = function()
        require("oil-git").refresh()
    end,
})

-- TreeSitter cofiguración
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "lua" },
    callback = function()
        vim.treesitter.start()
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
})

if pcall(require, "vim_dadbod_completion") then
    user_cmd("DBUIFindBufferLSP", function()
        -- Guarda información del LSP actual
        local clients = vim.lsp.get_active_clients({ bufnr = 0 })

        -- Ejecuta DBUIFindBuffer
        vim.cmd("DBUIFindBuffer")

        -- Reconecta el LSP si es necesario
        vim.defer_fn(function()
            if #clients > 0 and #vim.lsp.get_active_clients({ bufnr = 0 }) == 0 then
                for _, client in ipairs(clients) do
                    vim.lsp.buf_attach_client(0, client.id)
                end
            end
        end, 200)
    end, {})
end
