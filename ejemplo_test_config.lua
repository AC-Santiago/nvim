-- Archivo de prueba para verificar que el sistema funciona correctamente
-- Este archivo simula cargar las configuraciones como lo haría Neovim

print("=== TESTING MODULAR LANGUAGE SYSTEM ===")

-- Test 1: Verificar que languages.lua funciona
print("\n1. Testing languages.lua...")
local lang_config = require("configs.languages")
print("✓ languages.lua loaded successfully")

local enabled_languages = lang_config.get_enabled_languages()
print("✓ Enabled languages:", table.concat(enabled_languages, ", "))

-- Test 2: Verificar que lang_loader funciona
print("\n2. Testing lang_loader...")
local lang_loader = require("utils.lang_loader")
print("✓ lang_loader loaded successfully")

-- Test 3: Probar carga de configuraciones de Python
print("\n3. Testing Python configuration loading...")
if lang_config.is_enabled("python") then
    print("✓ Python is enabled")

    -- Probar carga de plugin specs
    local python_configs = lang_loader.load_lang_configs("python")
    print("✓ Python plugin configs loaded, count:", #python_configs)

    -- Probar carga de configuraciones directas
    print("✓ Applying direct configs for Python...")
    lang_loader.apply_direct_configs("python")
    print("✓ Direct configs applied")
else
    print("✗ Python is disabled")
end

-- Test 4: Probar instalación automática de herramientas
print("\n4. Testing tool installation lists...")
local lsp_servers = lang_loader.get_install_list("lsp_servers")
local linters = lang_loader.get_install_list("linters")
local formatters = lang_loader.get_install_list("formatters")
local dap_adapters = lang_loader.get_install_list("dap_adapters")

print("✓ LSP Servers to install:", table.concat(lsp_servers, ", "))
print("✓ Linters to install:", table.concat(linters, ", "))
print("✓ Formatters to install:", table.concat(formatters, ", "))
print("✓ DAP Adapters to install:", table.concat(dap_adapters, ", "))

print("\n=== ALL TESTS COMPLETED ===")
print("If you see this message without errors, the system is working correctly!")
