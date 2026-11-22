vim.g.base46_cache = vim.fn.stdpath("data") .. "/nvchad/base46/"
vim.g.mapleader = " "

local function has_lazy_entry(path)
    local entry = vim.uv.fs_stat(path .. "/lua/lazy/init.lua")
    return entry and entry.type == "file"
end

local function bootstrap_lazy(path)
    local existing = vim.uv.fs_lstat(path)
    if has_lazy_entry(path) then
        return
    end

    local recovery = ("Move the incomplete lazy.nvim checkout at %s aside, then restart Neovim."):format(path)
    if existing then
        error(recovery)
    end

    vim.fn.mkdir(vim.fs.dirname(path), "p")
    local temporary, mkdir_error = vim.uv.fs_mkdtemp(path .. ".tmp-XXXXXX")
    if not temporary then
        error(("Cannot prepare a lazy.nvim checkout at %s: %s"):format(path, mkdir_error))
    end

    local ok, result = pcall(function()
        return vim.system({
            "git", "clone", "--filter=blob:none", "--branch=stable",
            "https://github.com/folke/lazy.nvim.git", temporary,
        }, { text = true }):wait()
    end)
    if not ok or result.code ~= 0 or not has_lazy_entry(temporary) then
        vim.fn.delete(temporary, "rf")
        if has_lazy_entry(path) then
            return
        end

        local detail = ok and vim.trim(result.stderr or "") or tostring(result)
        if detail == "" then
            detail = "Git did not produce lua/lazy/init.lua."
        end
        error(("Cannot clone lazy.nvim for %s: %s"):format(path, detail))
    end

    local renamed, rename_error
    if not vim.uv.fs_lstat(path) then
        renamed, rename_error = vim.uv.fs_rename(temporary, path)
    end
    if not renamed then
        vim.fn.delete(temporary, "rf")
        if has_lazy_entry(path) then
            return
        end
        error(vim.uv.fs_lstat(path) and recovery or ("Cannot install lazy.nvim at %s: %s"):format(path, rename_error))
    end
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
bootstrap_lazy(lazypath)
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

local function path_in(directory, relative)
    return vim.fs.normalize(directory:gsub("/$", "") .. "/" .. relative, { expand_env = false })
end

local function windows_python_available(path)
    local normalized = vim.fs.normalize(path, { expand_env = false }):lower()
    if not normalized:match("/microsoft/windowsapps/python3?%.exe$") then
        return true
    end

    -- A Store redirect can be present before Python is installed.
    local ok, result = pcall(function()
        return vim.system({ path, "--version" }, { text = true }):wait(1000)
    end)
    return ok and result.code == 0
end

local function get_python_path()
    local windows = vim.fn.has("win32") == 1
    local interpreter = windows and "Scripts/python.exe" or "bin/python"
    local venv_path = vim.env.VIRTUAL_ENV
    if venv_path and venv_path ~= "" then
        local venv_python = path_in(venv_path, interpreter)
        if vim.fn.executable(venv_python) == 1 then
            return venv_python
        end
    end

    local cwd = path_in(vim.fn.getcwd(), ".")
    for _, venv_dir in ipairs({ ".venv", "venv", ".virtualenv" }) do
        local directory = cwd
        while directory do
            local path = path_in(directory, venv_dir .. "/" .. interpreter)
            if vim.fn.executable(path) == 1 then
                return path
            end
            local parent = path_in(directory, "..")
            if parent == directory then
                break
            end
            directory = parent
        end
    end

    local search_cwd = vim.env.NoDefaultCurrentDirectoryInExePath
    if windows then
        vim.env.NoDefaultCurrentDirectoryInExePath = "1"
    end
    local candidates = { vim.fn.exepath("python3"), vim.fn.exepath("python") }
    if windows then
        vim.env.NoDefaultCurrentDirectoryInExePath = search_cwd
    end
    for _, path in ipairs(candidates) do
        if path ~= "" and (not windows or windows_python_available(path)) then
            return path
        end
    end
end

vim.g.loaded_python3_provider = nil
vim.g.python3_host_prog = get_python_path()
vim.api.nvim_create_user_command("PythonPath", function()
    local path = vim.g.python3_host_prog
    vim.notify(path and ("Python host: " .. path) or "No se encontró un intérprete de Python.", vim.log.levels.INFO)
end, {})

require("nvchad.autocmds")
require("autocmds")

-- Cargar comandos de limpieza

vim.schedule(function()
    require("mappings")
end)

if vim.fn.executable("dms") == 1 then
    vim.g.clipboard = {
        name = "DankShell Clipboard",
        copy = {
            ["+"] = { "dms", "cl", "copy" },
            ["*"] = { "dms", "cl", "copy" },
        },
        paste = {
            ["+"] = { "dms", "cl", "paste" },
            ["*"] = { "dms", "cl", "paste" },
        },
        cache_enabled = 0,
    }

    vim.opt.clipboard = "unnamedplus"
end
