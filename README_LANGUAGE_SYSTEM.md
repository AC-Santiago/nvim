# Sistema Modular de Lenguajes para Neovim

## Descripción

Este sistema te permite gestionar configuraciones de lenguajes de programación de manera modular y automática. Puedes habilitar/deshabilitar lenguajes completos y agregar nuevas configuraciones fácilmente.

## Archivos principales

### 1. `lua/configs/languages.lua`
Archivo de configuración central donde defines:
- Qué lenguajes están habilitados
- Qué herramientas instalar automáticamente para cada lenguaje

```lua
local M = {
    -- Lenguajes habilitados
    python = true,
    rust = true,
    typst = false,  -- Cambiar a false para deshabilitar
    
    configs = {
        python = {
            lsp_servers = { "pyright", "ruff" },
            linters = { "ruff" },
            formatters = { "ruff" },
            dap_adapters = { "debugpy" },
        },
        -- ...
    }
}
```

### 2. `lua/utils/lang_loader.lua`
Utilidad que carga automáticamente todas las configuraciones de un lenguaje.

## Cómo usar

### Habilitar/Deshabilitar un lenguaje

1. Edita `lua/configs/languages.lua`
2. Cambia `python = true` a `python = false` para deshabilitar Python
3. Reinicia Neovim

### Agregar un nuevo linter a Python

**Opción 1: Agregar a la configuración central**
```lua
-- En lua/configs/languages.lua
python = {
    linters = { "ruff", "pylint" },  -- Agregar pylint
}
```

**Opción 2: Crear archivo específico**
```lua
-- Crear lua/plugins/lang/python/extra-lint.lua
local lint = require("lint")

-- Agregar pylint a la configuración existente
if lint.linters_by_ft.python then
    table.insert(lint.linters_by_ft.python, "pylint")
else
    lint.linters_by_ft.python = { "pylint" }
end

return {}
```

### Agregar un nuevo lenguaje

1. **Crear la carpeta**: `lua/plugins/lang/nuevo_lenguaje/`

2. **Crear el init.lua**:
```lua
-- lua/plugins/lang/nuevo_lenguaje/init.lua
local lang_loader = require("utils.lang_loader")
return lang_loader.load_lang_configs("nuevo_lenguaje")
```

3. **Agregar a la configuración**:
```lua
-- En lua/configs/languages.lua
local M = {
    nuevo_lenguaje = true,
    configs = {
        nuevo_lenguaje = {
            lsp_servers = { "servidor_lsp" },
            linters = { "linter" },
            formatters = { "formatter" },
            dap_adapters = { "adaptador" },
        }
    }
}
```

4. **Importar en plugins**:
```lua
-- En lua/plugins/init.lua
return {
    -- ...
    { import = "plugins.lang.nuevo_lenguaje" },
}
```

## Estructura de archivos por lenguaje

Cada lenguaje puede tener estos archivos (todos opcionales):

```
lua/plugins/lang/python/
├── init.lua          # Punto de entrada (requerido)
├── lsp.lua           # Configuración LSP
├── lint.lua          # Configuración de linting
├── dap.lua           # Configuración de debug
├── format.lua        # Configuración de formateo
├── conform.lua       # Configuración de conform
├── treesitter.lua    # Configuración de treesitter
└── cualquier_otro.lua # Configuraciones personalizadas
```

## Ventajas del sistema

✅ **Modular**: Cada lenguaje es independiente
✅ **Automático**: Las herramientas se instalan automáticamente
✅ **Flexible**: Fácil agregar/quitar configuraciones
✅ **Organizado**: Estructura clara y consistente
✅ **Extensible**: Fácil agregar nuevos lenguajes

## Ejemplos de uso

### Ejemplo 1: Solo Python con configuración mínima
```lua
-- lua/configs/languages.lua
local M = {
    python = true,
    rust = false,
    typst = false,
}
```

### Ejemplo 2: Python con linters adicionales
```lua
-- lua/plugins/lang/python/extra-tools.lua
local lint = require("lint")

-- Agregar más linters
local additional_linters = { "pylint", "flake8", "mypy" }
for _, linter in ipairs(additional_linters) do
    table.insert(lint.linters_by_ft.python, linter)
end

return {}
```

### Ejemplo 3: Configuración personalizada por proyecto
```lua
-- En tu proyecto específico, crea .nvim.lua
-- y sobrescribe configuraciones según necesites
```

