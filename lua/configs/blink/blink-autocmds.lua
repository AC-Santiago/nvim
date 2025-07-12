-- Autocommands para blink.cmp personalizaciones
-- Esto asegura que los highlight groups se apliquen correctamente

local M = {}

function M.setup()
    local augroup = vim.api.nvim_create_augroup("BlinkCmpCustom", { clear = true })

    -- Aplicar highlights cuando se carga el colorscheme
    vim.api.nvim_create_autocmd("ColorScheme", {
        group = augroup,
        pattern = "*",
        callback = function()
            -- Pequeño delay para asegurar que base46 se haya cargado
            vim.defer_fn(function()
                local ok, highlights = pcall(require, "configs.blink.blink-highlights")
                if ok then
                    highlights.setup()
                    highlights.setup_theme_specific()
                end
            end, 100)
        end,
        desc = "Aplicar highlights personalizados de blink.cmp",
    })

    -- También aplicar al iniciar Neovim
    vim.api.nvim_create_autocmd("VimEnter", {
        group = augroup,
        pattern = "*",
        callback = function()
            vim.defer_fn(function()
                local ok, highlights = pcall(require, "configs.blink.blink-highlights")
                if ok then
                    highlights.setup()
                    highlights.setup_theme_specific()
                end
            end, 200)
        end,
        desc = "Aplicar highlights de blink.cmp al iniciar",
    })

    -- Aplicar highlights cuando se abre blink.cmp
    vim.api.nvim_create_autocmd("User", {
        group = augroup,
        pattern = "BlinkCmpMenuOpen",
        callback = function()
            local ok, highlights = pcall(require, "configs.blink.blink-highlights")
            if ok then
                highlights.setup()
            end
        end,
        desc = "Asegurar highlights cuando se abre el menú de blink.cmp",
    })
end

return M
