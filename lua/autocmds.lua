local autocmd = vim.api.nvim_create_autocmd

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
-- -- Limpieza automática de herramientas Mason y parsers TreeSitter
-- autocmd("VimEnter", {
--     callback = function()
--         -- Ejecutar limpieza automática de Mason tools
--         vim.defer_fn(function()
--             local mason_cleanup = require("utils.mason_cleanup")
--             mason_cleanup.cleanup_disabled_languages()
--
--             -- Guardar el estado actual de lenguajes para futuras comparaciones
--             mason_cleanup.save_current_state()
--         end, 1000) -- Esperar 1 segundo para que Neovim termine de cargar
--
--         -- Ejecutar limpieza automática de parsers TreeSitter
--         vim.defer_fn(function()
--             local treesitter_cleanup = require("utils.treesitter_cleanup")
--             treesitter_cleanup.cleanup_parsers()
--         end, 2000) -- Esperar 2 segundos para que TreeSitter termine de cargar
--     end,
-- })
--
-- -- Limpieza cuando se cambian configuraciones de lenguajes
-- autocmd("User", {
--     pattern = "LanguageConfigChanged",
--     callback = function()
--         local mason_cleanup = require("utils.mason_cleanup")
--         local treesitter_cleanup = require("utils.treesitter_cleanup")
--
--         -- Limpiar herramientas Mason obsoletas
--         mason_cleanup.cleanup_disabled_languages()
--         mason_cleanup.save_current_state()
--
--         -- Limpiar parsers TreeSitter obsoletos
--         treesitter_cleanup.cleanup_parsers()
--
--         -- Refrescar configuración de TreeSitter
--         treesitter_cleanup.refresh_treesitter_config()
--     end,
-- })
