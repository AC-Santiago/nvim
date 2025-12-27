vim.g.base46_cache = vim.fn.stdpath("data") .. "/nvchad/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    local repo = "https://github.com/folke/lazy.nvim.git"
    vim.fn.system({ "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath })
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require("configs.lazy")

-- load plugins
require("lazy").setup({
    {
        "NvChad/NvChad",
        lazy = false,
        branch = "v2.5",
        import = "nvchad.plugins",
        config = function()
            require("options")
        end,
    },

    { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

-- load neovide settings
vim.g.neovide_opacity = 1
vim.g.neovide_normal_opacity = 1
vim.g.neovide_refresh_rate = 144
vim.g.neovide_confirm_quit = true
vim.g.neovide_scale_factor = 1.0

-- Providers - Auto-detect uv virtual environments
local function get_python_path()
    local cwd = vim.fn.getcwd()
    if not cwd then
        return "/usr/bin/python3"
    end
    
    -- Check for uv virtual environment
    local uv_venv = vim.fs.joinpath(cwd, ".venv", "bin", "python")
    if vim.fn.filereadable(uv_venv) == 1 then
        return uv_venv
    end
    
    -- Check for VIRTUAL_ENV environment variable
    local venv = vim.env.VIRTUAL_ENV
    if venv then
        return vim.fs.joinpath(venv, "bin", "python")
    end
    
    -- Fallback to system python
    return "/usr/bin/python3"
end

vim.g.loaded_python3_provider = 1
vim.g.python3_host_prog = get_python_path()

require("nvchad.autocmds")
require("autocmds")

-- Cargar comandos de limpieza

vim.schedule(function()
    require("mappings")
end)
