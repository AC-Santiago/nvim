# 🧹 Sistema de Limpieza Automática de Mason

Este sistema permite desinstalar automáticamente herramientas de Mason cuando se desactivan lenguajes, manteniendo limpio tu entorno de desarrollo.

## 🚀 Características

- ✅ **Detección automática** de lenguajes desactivados
- ✅ **Desinstalación inteligente** de herramientas no utilizadas
- ✅ **Protección de herramientas compartidas** (prettier, black, etc.)
- ✅ **Configuración personalizable** por usuario
- ✅ **Notificaciones informativas** del proceso
- ✅ **Integración transparente** con el sistema modular existente

## 📁 Archivos del Sistema

```
lua/
├── utils/
│   ├── mason_cleanup.lua     # Sistema principal de limpieza
│   └── lang_loader.lua       # Integración y seguimiento de estado
└── configs/
    └── languages.lua         # Configuración de lenguajes
```

## ⚙️ Configuración

### Configuración Básica

Agrega esto a tu `init.lua` o archivo de configuración principal:

```lua
-- Configuración del sistema de limpieza automática
require('utils.mason_cleanup').setup({
    -- Habilitar limpieza automática (por defecto: true)
    auto_cleanup = true,
    
    -- Mostrar notificaciones al desinstalar (por defecto: true)
    notify_on_uninstall = true,
    
    -- Confirmar antes de desinstalar múltiples herramientas (por defecto: true)
    confirm_bulk_uninstall = true,
    
    -- Herramientas adicionales protegidas
    protected_tools = {
        "mi_herramienta_especial",
        "otra_herramienta_importante"
    }
})
```

### Herramientas Protegidas por Defecto

El sistema protege automáticamente estas herramientas comunes:

```lua
-- Formatters compartidos
"prettier"              -- HTML, CSS, JS, TS, JSON, etc.
"black"                 -- Python estándar

-- LSP servers compartidos  
"emmet_language_server" -- HTML, CSS, JSX, etc.

-- Linters compartidos
"stylelint"             -- CSS, SCSS, SASS

-- Herramientas esenciales
"lua_ls"                -- Configuración Neovim
"stylua"                -- Configuración Neovim
```

## 🔧 Uso del Sistema

### Automático

El sistema se activa automáticamente en estas situaciones:

1. **Al iniciar Neovim**: Detecta cambios desde la última sesión
2. **Al modificar `languages.lua`**: Ejecuta limpieza inmediata
3. **Cambios externos**: Detecta modificaciones hechas fuera de Neovim

### Manual

Puedes ejecutar limpieza manual con estos comandos:

```lua
-- Ejecutar limpieza manual completa
:lua require('utils.lang_loader').manual_cleanup()

-- Verificar y ejecutar limpieza automática
:lua require('utils.lang_loader').check_and_cleanup_languages()

-- Actualizar estado manualmente
:lua require('utils.lang_loader').update_language_state()

-- Obtener información del estado actual
:lua vim.print(require('utils.lang_loader').get_state_info())
```

## 📊 Monitoreo y Estado

### Verificar Estado Actual

```lua
:lua vim.print(require('utils.lang_loader').get_state_info())
```

Esto mostrará:
- Lenguajes habilitados actualmente
- Lenguajes que estaban habilitados anteriormente  
- Lenguajes detectados como desactivados
- Estado de la limpieza automática
- Herramientas protegidas
- Ubicación del archivo de estado

### Información de Mason

```lua
-- Ver estado de Mason
:lua vim.print(require('utils.mason_cleanup').get_status())

-- Ver herramientas protegidas
:lua vim.print(require('utils.mason_cleanup').get_protected_tools())
```

## 🧪 Ejemplo Práctico

### Escenario: Desactivar Rust

1. **Estado inicial**: Rust habilitado en `languages.lua`
   ```lua
   rust = true,  -- Habilitado
   ```

2. **Herramientas instaladas**: 
   - `rust_analyzer` (LSP)
   - `rustfmt` (formatter)
   - `codelldb` (DAP)

3. **Desactivar Rust**:
   ```lua
   rust = false,  -- Deshabilitado
   ```

4. **Resultado automático**:
   - ✅ Sistema detecta que Rust fue desactivado
   - ✅ Identifica herramientas asociadas: `rust_analyzer`, `rustfmt`, `codelldb`
   - ✅ Verifica que no son usadas por otros lenguajes habilitados
   - ✅ Desinstala automáticamente las herramientas
   - ✅ Muestra notificación: "Uninstalled rust_analyzer (was used by rust)"

### Escenario: Herramienta Compartida

1. **Configuración**:
   ```lua
   html = true,   -- Usa prettier
   css = true,    -- Usa prettier  
   ```

2. **Desactivar HTML**:
   ```lua
   html = false,  -- Deshabilitado
   css = true,    -- Sigue habilitado
   ```

3. **Resultado**:
   - ✅ `prettier` NO se desinstala (usado por CSS)
   - ✅ `html-lsp` SÍ se desinstala (solo usado por HTML)
   - ✅ Notificación informa qué se desinstaló y qué se mantuvo

## 🛡️ Seguridad y Protecciones

### Herramientas Protegidas

El sistema nunca desinstalará:
- Herramientas en la lista de protegidas por defecto
- Herramientas agregadas por el usuario en `protected_tools`
- Herramientas usadas por múltiples lenguajes habilitados

### Confirmación de Desinstalación

Para desinstalaciones masivas (>3 herramientas), el sistema:
1. Muestra diálogo de confirmación
2. Lista las herramientas a desinstalar
3. Permite cancelar o ver detalles
4. Solo procede con confirmación explícita

### Reversibilidad

- La desinstalación es reversible: reactivar el lenguaje reinstalará las herramientas
- Mason permite reinstalación manual: `:Mason` → buscar herramienta
- El sistema mantiene logs de lo que desinstaló

## 🔍 Troubleshooting

### Problema: Sistema no se activa

**Solución**:
```lua
-- Verificar que esté habilitado
:lua vim.print(require('utils.mason_cleanup').get_status().auto_cleanup_enabled)

-- Reactivar si está deshabilitado
:lua require('utils.mason_cleanup').setup({auto_cleanup = true})
```

### Problema: Herramienta se desinstaló por error

**Solución**:
```lua
-- Reinstalar desde Mason
:Mason
-- Buscar la herramienta y reinstalar

-- O agregar a herramientas protegidas
require('utils.mason_cleanup').setup({
    protected_tools = {"nombre_herramienta"}
})
```

### Problema: No se detectan cambios

**Solución**:
```lua
-- Forzar actualización del estado
:lua require('utils.lang_loader').update_language_state()

-- Ejecutar verificación manual
:lua require('utils.lang_loader').check_and_cleanup_languages()
```

## 📝 Logs y Depuración

### Habilitar Logs Detallados

```lua
-- En tu configuración
vim.g.mason_cleanup_debug = true
```

### Ubicaciones de Archivos

- **Estado**: `~/.local/share/nvim/nvim_language_state.json`
- **Mason tools**: `~/.local/share/nvim/mason/`
- **Logs**: Buffer de mensajes de Neovim (`:messages`)

## 🔧 Comandos Útiles

```lua
-- Ver todos los lenguajes habilitados
:lua vim.print(require('configs.languages').get_enabled_languages())

-- Ver configuración de un lenguaje específico  
:lua vim.print(require('configs.languages').get_config('python'))

-- Ver herramientas de un tipo específico
:lua vim.print(require('utils.lang_loader').get_install_list('lsp_servers'))

-- Estado completo del sistema
:lua vim.print(require('utils.lang_loader').get_state_info())

-- Ejecutar limpieza con confirmación
:lua require('utils.lang_loader').manual_cleanup()
```

## 🚀 Próximas Características

- [ ] Interfaz gráfica para gestión de herramientas
- [ ] Backup automático antes de desinstalación
- [ ] Estadísticas de uso de herramientas
- [ ] Integración con profiles de desarrollo

---

**💡 Tip**: Ejecuta `:lua vim.print(require('utils.lang_loader').get_state_info())` después de cada cambio en lenguajes para monitorear el sistema.

**🎯 Objetivo**: Mantener tu entorno de desarrollo limpio y eficiente automáticamente.

