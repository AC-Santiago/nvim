local M = {}

-- Archivo de estado para rastrear lenguajes habilitados
local state_file = vim.fn.stdpath("data") .. "/nvim_language_state.json"

-- Herramientas que NO deben desinstalarse automáticamente
local protected_tools = {
    -- Herramientas esenciales
    "lua_ls", -- Neovim configuración
    "stylua", -- Neovim configuración
    "prettier", -- Formateador común
}

-- Configuración del sistema de limpieza
local config = {
    -- Habilitar limpieza automática
    auto_cleanup = true,

    -- Mostrar notificaciones al desinstalar
    notify_on_uninstall = true,

    -- Confirmar antes de desinstalar (cuando hay múltiples herramientas)
    confirm_bulk_uninstall = true,

    -- Herramientas adicionales protegidas (configurables por usuario)
    user_protected_tools = {},
}

-- Función para cargar el estado anterior de lenguajes
function M.load_previous_state()
    local file = io.open(state_file, "r")
    if not file then
        return {}
    end

    local content = file:read("*all")
    file:close()

    if content == "" then
        return {}
    end

    local success, data = pcall(vim.json.decode, content)
    if success then
        return data.enabled_languages or {}
    else
        vim.notify("Error loading language state: " .. tostring(data), vim.log.levels.WARN)
        return {}
    end
end

-- Función para guardar el estado actual de lenguajes
function M.save_current_state()
    local lang_config = require("configs.languages")
    local current_languages = lang_config.get_enabled_languages()

    local data = {
        enabled_languages = current_languages,
        timestamp = os.time(),
        nvim_version = vim.version(),
    }

    local file = io.open(state_file, "w")
    if file then
        file:write(vim.json.encode(data))
        file:close()
    else
        vim.notify("Could not save language state", vim.log.levels.WARN)
    end
end

-- Función para detectar lenguajes que fueron desactivados
function M.get_disabled_languages()
    local previous_languages = M.load_previous_state()
    local lang_config = require("configs.languages")
    local current_languages = lang_config.get_enabled_languages()

    local disabled = {}

    for _, lang in ipairs(previous_languages) do
        local is_currently_enabled = false
        for _, current_lang in ipairs(current_languages) do
            if current_lang == lang then
                is_currently_enabled = true
                break
            end
        end

        if not is_currently_enabled then
            table.insert(disabled, lang)
        end
    end

    return disabled
end

-- Función para obtener todas las herramientas protegidas
function M.get_protected_tools()
    local all_protected = vim.deepcopy(protected_tools)
    vim.list_extend(all_protected, config.user_protected_tools)
    return all_protected
end

-- Función para verificar si una herramienta está protegida
function M.is_tool_protected(tool_name)
    local protected = M.get_protected_tools()
    for _, protected_tool in ipairs(protected) do
        if protected_tool == tool_name then
            return true
        end
    end
    return false
end

-- Función para obtener herramientas que ya no son necesarias
function M.get_unused_tools(disabled_languages)
    if not disabled_languages or #disabled_languages == 0 then
        return {}
    end

    local lang_config = require("configs.languages")
    local current_languages = lang_config.get_enabled_languages()

    -- Obtener todas las herramientas de lenguajes desactivados
    local unused_tools = {}

    for _, disabled_lang in ipairs(disabled_languages) do
        local lang_tools = lang_config.get_config(disabled_lang)

        -- Recopilar todas las herramientas del lenguaje desactivado
        local all_lang_tools = {}
        if lang_tools.lsp_servers then
            vim.list_extend(all_lang_tools, lang_tools.lsp_servers)
        end
        if lang_tools.formatters then
            vim.list_extend(all_lang_tools, lang_tools.formatters)
        end
        if lang_tools.linters then
            vim.list_extend(all_lang_tools, lang_tools.linters)
        end
        if lang_tools.dap_adapters then
            vim.list_extend(all_lang_tools, lang_tools.dap_adapters)
        end

        -- Verificar cada herramienta del lenguaje desactivado
        for _, tool in ipairs(all_lang_tools) do
            -- Saltar herramientas protegidas
            if not M.is_tool_protected(tool) then
                -- Verificar si la herramienta es usada por otros lenguajes habilitados
                local is_used_elsewhere = false

                for _, enabled_lang in ipairs(current_languages) do
                    local enabled_lang_tools = lang_config.get_config(enabled_lang)
                    local all_enabled_tools = {}

                    if enabled_lang_tools.lsp_servers then
                        vim.list_extend(all_enabled_tools, enabled_lang_tools.lsp_servers)
                    end
                    if enabled_lang_tools.formatters then
                        vim.list_extend(all_enabled_tools, enabled_lang_tools.formatters)
                    end
                    if enabled_lang_tools.linters then
                        vim.list_extend(all_enabled_tools, enabled_lang_tools.linters)
                    end
                    if enabled_lang_tools.dap_adapters then
                        vim.list_extend(all_enabled_tools, enabled_lang_tools.dap_adapters)
                    end

                    for _, enabled_tool in ipairs(all_enabled_tools) do
                        if enabled_tool == tool then
                            is_used_elsewhere = true
                            break
                        end
                    end

                    if is_used_elsewhere then
                        break
                    end
                end

                -- Si la herramienta no es usada por otros lenguajes, marcarla para desinstalación
                if not is_used_elsewhere then
                    table.insert(unused_tools, {
                        name = tool,
                        from_language = disabled_lang,
                    })
                end
            end
        end
    end

    return unused_tools
end

-- Función para desinstalar herramientas Mason
function M.uninstall_mason_tools(tools)
    if not tools or #tools == 0 then
        return true
    end

    local mason_registry = require("mason-registry")
    local uninstalled = {}
    local failed = {}

    for _, tool_info in ipairs(tools) do
        local tool_name = string.gsub(tool_info.name, "_", "-")

        if mason_registry.is_installed(tool_name) then
            local package = mason_registry.get_package(tool_name)

            local success, err = pcall(function()
                package:uninstall()
            end)

            if success then
                table.insert(uninstalled, tool_name)
                if config.notify_on_uninstall then
                    vim.notify(
                        "Uninstalled " .. tool_name .. " (was used by " .. tool_info.from_language .. ")",
                        vim.log.levels.INFO
                    )
                end
            else
                table.insert(failed, { tool = tool_name, error = err })
                vim.notify("Failed to uninstall " .. tool_name .. ": " .. tostring(err), vim.log.levels.WARN)
            end
        else
            -- Herramienta ya no está instalada
            table.insert(uninstalled, tool_name)
        end
    end

    return {
        uninstalled = uninstalled,
        failed = failed,
        success = #failed == 0,
    }
end

-- Función principal para ejecutar limpieza automática
function M.cleanup_disabled_languages()
    if not config.auto_cleanup then
        return { success = false, reason = "Auto cleanup is disabled" }
    end

    local disabled_languages = M.get_disabled_languages()

    if #disabled_languages == 0 then
        return { success = true, reason = "No languages were disabled" }
    end

    local unused_tools = M.get_unused_tools(disabled_languages)

    if #unused_tools == 0 then
        if config.notify_on_uninstall then
            vim.notify(
                "Languages disabled: "
                    .. table.concat(disabled_languages, ", ")
                    .. " but no tools need to be uninstalled",
                vim.log.levels.INFO
            )
        end
        return { success = true, reason = "No tools need to be uninstalled" }
    end

    -- Confirmar si hay múltiples herramientas y la confirmación está habilitada
    if config.confirm_bulk_uninstall and #unused_tools > 3 then
        local tool_names = {}
        for _, tool in ipairs(unused_tools) do
            table.insert(tool_names, tool.name)
        end

        local confirmation = vim.fn.confirm(
            "Uninstall " .. #unused_tools .. " Mason tools?\n" .. table.concat(tool_names, ", "),
            "&Yes\n&No\n&Show details",
            2 -- default to No
        )

        if confirmation == 2 then -- No
            return { success = false, reason = "User cancelled uninstallation" }
        elseif confirmation == 3 then -- Show details
            for _, tool in ipairs(unused_tools) do
                print("- " .. tool.name .. " (from " .. tool.from_language .. ")")
            end

            local second_confirmation = vim.fn.confirm("Proceed with uninstallation?", "&Yes\n&No", 2)

            if second_confirmation == 2 then
                return { success = false, reason = "User cancelled after reviewing details" }
            end
        end
    end

    -- Ejecutar desinstalación
    local result = M.uninstall_mason_tools(unused_tools)

    if result.success then
        vim.notify(
            "Cleaned up "
                .. #result.uninstalled
                .. " Mason tools from disabled languages: "
                .. table.concat(disabled_languages, ", "),
            vim.log.levels.INFO
        )
    end

    return result
end

-- Función para configurar el sistema de limpieza
function M.setup(user_config)
    config = vim.tbl_deep_extend("force", config, user_config or {})

    -- Agregar herramientas protegidas por el usuario
    if user_config and user_config.protected_tools then
        vim.list_extend(config.user_protected_tools, user_config.protected_tools)
    end
end

-- Función para obtener el estado actual del sistema
function M.get_status()
    return {
        auto_cleanup_enabled = config.auto_cleanup,
        protected_tools = M.get_protected_tools(),
        state_file = state_file,
        previous_languages = M.load_previous_state(),
        current_languages = require("configs.languages").get_enabled_languages(),
    }
end

return M
