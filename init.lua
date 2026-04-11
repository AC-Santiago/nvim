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
vim.g.neovide_opacity = 0.5
vim.g.neovide_normal_opacity = 0.5
vim.g.neovide_refresh_rate = 144
vim.g.neovide_confirm_quit = true
vim.g.neovide_scale_factor = 1.0

-- Providers - Auto-detect uv virtual environments
-- Función para detectar el Python del entorno virtual
local function get_python_path()
    -- Primero intentar con variable de entorno VIRTUAL_ENV (venv estándar)
    local venv_path = os.getenv("VIRTUAL_ENV")
    if venv_path then
        local venv_python = venv_path .. "/bin/python"
        if vim.fn.executable(venv_python) == 1 then
            return venv_python
        end
    end

    -- Intentar con uv (buscar .venv en el directorio actual o padres)
    local cwd = vim.fn.getcwd()
    local venv_dirs = { ".venv", "venv", ".virtualenv" }

    for _, venv_dir in ipairs(venv_dirs) do
        local path = cwd .. "/" .. venv_dir .. "/bin/python"
        if vim.fn.executable(path) == 1 then
            return path
        end

        -- Buscar en directorios padres
        local parent = vim.fn.fnamemodify(cwd, ":h")
        while parent ~= "/" do
            path = parent .. "/" .. venv_dir .. "/bin/python"
            if vim.fn.executable(path) == 1 then
                return path
            end
            parent = vim.fn.fnamemodify(parent, ":h")
        end
    end

    -- Fallback: usar el Python del sistema
    return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python3"
end

-- Configurar el Python host
vim.g.loaded_python3_provider = nil
vim.g.python3_host_prog = get_python_path()
vim.api.nvim_create_user_command("PythonPath", function()
    vim.notify("Python host: " .. vim.g.python3_host_prog, vim.log.levels.INFO)
end, {})

require("nvchad.autocmds")
require("autocmds")

-- Cargar comandos de limpieza

vim.schedule(function()
    require("mappings")
end)
