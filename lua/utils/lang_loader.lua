-- Utilidad para cargar configuraciones de lenguajes de manera automática
local M = {}

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
    -- Excluimos lsp y lint porque son configuración directa
    local config_files = {
        "nvim-dap-python", -- Para mantener compatibilidad con el nombre actual
        "dap",
        "format",
        "conform",
        "treesitter"
    }
    
    -- Intentar cargar cada archivo de configuración que debe retornar plugin specs
    for _, config_file in ipairs(config_files) do
        local module_path = base_path .. "." .. config_file
        local ok, config = pcall(require, module_path)
        
        if ok and config then
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
            vim.notify("Loaded " .. config_file .. " config for " .. lang_name, vim.log.levels.DEBUG)
        elseif err and not string.find(err, "module .* not found") then
            vim.notify("Error loading " .. config_file .. " for " .. lang_name .. ": " .. err, vim.log.levels.WARN)
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

return M
