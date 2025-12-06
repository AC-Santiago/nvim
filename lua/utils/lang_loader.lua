local M = {}

-- Cargar sistema de limpieza automática
local mason_cleanup = require("utils.mason_cleanup")

-- Función para cargar automáticamente todas las configuraciones de un lenguaje
function M.load_lang_configs(lang_name)
    local lang_config = require("configs.languages")

    -- Verificar si el lenguaje está habilitado
    if not lang_config.is_enabled(lang_name) then
        return {}
    end

    local base_path = "plugins.lang." .. lang_name
    local configs = {}

    -- Lista de archivos de configuración que SOLO retornan plugin specs
    local config_files = {
        "conform",
        "dap",
    }
    -- Intentar cargar cada archivo de configuración que debe retornar plugin specs
    for _, config_file in ipairs(config_files) do
        local module_path = base_path .. "." .. config_file
        local status, config = pcall(require, module_path)

        if status and config then
            -- Solo procesar si es una tabla válida para plugin specs
            if type(config) == "table" and config ~= vim.empty_dict() then
                -- Si es una tabla, agregarla a las configuraciones
                if #config > 0 then
                    -- Si es un array, agregarlo directamente
                    vim.list_extend(configs, config)
                elseif next(config) ~= nil then
                    -- Si es un objeto no vacío, agregarlo como un elemento
                    table.insert(configs, config)
                end
            end
        end
    end

    return configs
end

-- Función para aplicar configuraciones específicas que ejecutan directamente
function M.apply_direct_configs(lang_name)
    local lang_config = require("configs.languages")

    if not lang_config.is_enabled(lang_name) then
        return
    end

    -- Solo aplicar configuraciones que ejecutan directamente (no retornan plugin specs)
    local direct_config_files = { "lsp", "lint" }

    for _, config_file in ipairs(direct_config_files) do
        local config_path = "plugins.lang." .. lang_name .. "." .. config_file
        local ok, err = pcall(require, config_path)
        if ok then
            -- vim.notify("Loaded " .. config_file .. " config for " .. lang_name, vim.log.levels.DEBUG)
        elseif err and not string.find(err, "module .* not found") then
            -- vim.notify("Error loading " .. config_file .. " for " .. lang_name .. ": " .. err, vim.log.levels.WARN)
        end
    end
end

-- Función legacy para compatibilidad (deprecated)
function M.apply_lang_setup(lang_name)
    M.apply_direct_configs(lang_name)
end

-- Función para obtener todos los servers/tools que deben instalarse
function M.get_install_list(tool_type)
    local lang_config = require("configs.languages")
    local install_list = {}

    for _, lang in ipairs(lang_config.get_enabled_languages()) do
        local config = lang_config.get_config(lang)
        if config[tool_type] then
            vim.list_extend(install_list, config[tool_type])
        end
    end

    return install_list
end

-- Sistema de seguimiento de estado de lenguajes
-- ============================================

-- Función para inicializar el sistema de seguimiento de estado
function M.init_state_tracking()
    -- Verificar si es la primera vez que se ejecuta
    local previous_state = mason_cleanup.load_previous_state()
    if #previous_state == 0 then
        -- Primera ejecución: guardar estado actual sin ejecutar limpieza
        mason_cleanup.save_current_state()
        vim.notify("Language state tracking initialized", vim.log.levels.INFO)
    else
        -- Ejecuciones posteriores: verificar cambios y ejecutar limpieza si es necesario
        M.check_and_cleanup_languages()
    end
end

-- Función para verificar cambios en lenguajes y ejecutar limpieza automática
function M.check_and_cleanup_languages()
    local disabled_languages = mason_cleanup.get_disabled_languages()

    if #disabled_languages > 0 then
        vim.notify("Detected disabled languages: " .. table.concat(disabled_languages, ", "), vim.log.levels.INFO)

        -- Ejecutar limpieza automática
        local result = mason_cleanup.cleanup_disabled_languages()

        if result.success then
            vim.notify("Successfully cleaned up tools for disabled languages", vim.log.levels.INFO)
        else
            vim.notify("Cleanup result: " .. (result.reason or "Unknown"), vim.log.levels.WARN)
        end
    end

    -- Guardar estado actual para la próxima verificación
    mason_cleanup.save_current_state()
end

-- Función para actualizar estado manualmente (útil para testing)
function M.update_language_state()
    mason_cleanup.save_current_state()
    vim.notify("Language state updated manually", vim.log.levels.INFO)
end

-- Función para obtener información del estado actual
function M.get_state_info()
    local status = mason_cleanup.get_status()
    local disabled_languages = mason_cleanup.get_disabled_languages()

    return {
        auto_cleanup_enabled = status.auto_cleanup_enabled,
        protected_tools = status.protected_tools,
        previous_languages = status.previous_languages,
        current_languages = status.current_languages,
        disabled_languages = disabled_languages,
        state_file = status.state_file,
    }
end

-- Función para ejecutar limpieza manual (útil para testing)
function M.manual_cleanup()
    return mason_cleanup.cleanup_disabled_languages()
end

-- Autocomando para detectar cambios en la configuración de lenguajes
local function setup_autocmds()
    local augroup = vim.api.nvim_create_augroup("LanguageStateTracking", { clear = true })

    -- Ejecutar verificación cuando se modifique el archivo de configuración de lenguajes
    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        group = augroup,
        pattern = "*/configs/languages.lua",
        callback = function()
            vim.notify("Language configuration changed, checking for cleanup...", vim.log.levels.INFO)
            -- Ejecutar con un pequeño delay para permitir que se recargue la configuración
            vim.defer_fn(function()
                M.check_and_cleanup_languages()
            end, 1000)
        end,
        desc = "Check for language changes and cleanup tools",
    })

    -- También verificar al entrar a Neovim (por si los cambios se hicieron externamente)
    vim.api.nvim_create_autocmd("VimEnter", {
        group = augroup,
        callback = function()
            -- Ejecutar con delay para permitir que todo se cargue
            vim.defer_fn(function()
                M.init_state_tracking()
            end, 2000)
        end,
        desc = "Initialize language state tracking on startup",
    })
end

-- Configurar autocomandos al cargar el módulo
setup_autocmds()

return M
