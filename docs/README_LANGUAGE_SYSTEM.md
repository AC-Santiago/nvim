# Sistema Modular de Lenguajes para mi configuración de Neovim

## Descripción

Cada perfil declara los tipos de archivo y las herramientas que Neovim usa para LSP, formato y lint. Activa los perfiles que necesites y usa `:LanguageToolsInstall` para instalar sus herramientas faltantes.

## Archivos principales

- `lua/configs/languages.lua` contiene las opciones de activación y las declaraciones de `configs`. El perfil `base` siempre está activo.
- `lua/utils/language_registry.lua` reúne las declaraciones en un inventario que consultan Neovim LSP, Conform y nvim-lint. La activación considera los perfiles habilitados.

Cada perfil declara `filetypes` y las listas `lsp`, `format` y `lint` que necesita. Las herramientas se identifican por el `id` de su integración. Usa `package` para indicar el nombre del paquete en Mason u omítelo para una herramienta externa. `bin` indica el nombre del comando en el `PATH` y puede omitirse si la integración ya lo define de forma estática. `options` contiene los ajustes de la integración. Una herramienta con sus propios `filetypes` usa esa lista en lugar de la del perfil.

## Cómo usar

### Habilitar o deshabilitar un lenguaje

1. Edita `lua/configs/languages.lua` y cambia la opción del perfil. Por ejemplo, usa `python = false` para deshabilitar Python.
2. Reinicia Neovim para aplicar el cambio. Los paquetes instalados permanecen disponibles en disco.
3. Después de habilitar un perfil, ejecuta `:LanguageToolsInstall` desde el proyecto si te faltan herramientas.

El comando usa los ejecutables disponibles y solicita a Mason los paquetes faltantes de los perfiles activos. Varias entradas pueden compartir un paquete. Por ejemplo, el servidor, el linter y los formateadores de Ruff usan una sola instalación. Si el comando indica que una herramienta es externa, instálala con la distribución o el gestor de paquetes correspondiente. Para un fallo de Mason, consulta `:MasonLog`, corrige la causa y vuelve a ejecutar `:LanguageToolsInstall`.

### Lua Language Server

El perfil `base` incluye Lua LS y StyLua. Desde un proyecto, ejecuta `:LanguageToolsInstall` si faltan, abre un archivo `.lua` y consulta `:LspInfo`. Usa `gd` sobre una referencia para comprobar la navegación. Lua LS busca primero la `.luarc.json` o `.luarc.jsonc` más cercana, después los marcadores de lint o formato y por último `.git`. En Linux, Luacheck se instala por separado y aporta diagnósticos de lint.

Si la raíz elegida abarca tu directorio de datos de Neovim y la ruta de Mason se rechaza como local al proyecto, abre Neovim desde el proyecto con una raíz propia. Para conservar esa raíz amplia, declara el `executable` absoluto de un Lua LS de confianza en `configs.base.lsp`.

### Agregar un linter a Python en Linux

Añade la entrada de Pylint a la lista `configs.python.lint` existente.

```lua
lint = {
    { id = "ruff", package = "ruff", bin = "ruff" },
    { id = "pylint", package = "pylint", bin = "pylint" },
},
```

Reinicia Neovim y ejecuta `:LanguageToolsInstall`. En Windows, la integración de lint actual ejecuta Ruff para Python mediante su lanzador nativo.

### Agregar un lenguaje con herramientas existentes

Este ejemplo habilita Go con una declaración. Instala la distribución de Go y comprueba que `go` y `gofmt` estén en el `PATH` de Neovim. Añade el bloque a `lua/configs/languages.lua` antes de `return M`.

```lua
M.go = true
M.configs.go = {
    filetypes = { "go" },
    lsp = {
        {
            id = "gopls",
            package = "gopls",
            options = {
                root_markers = { "go.work", "go.mod", ".git" },
                settings = { gopls = { hints = { assignVariableTypes = true } } },
            },
        },
    },
    format = { { id = "gofmt" } },
}
```

Reinicia Neovim, ejecuta `:LanguageToolsInstall` y abre un archivo `.go`. `gopls` usa los marcadores de raíz de la declaración y ofrece sugerencias de tipos de variables. Puedes mostrar las sugerencias con `<leader>ih`. `gofmt` proviene de la distribución de Go y Conform lo usa al guardar. El ejemplo se verificó con gopls 0.24.0, que usa `assignVariableTypes`. [Opciones de gopls](https://go.dev/gopls/inlayHints)

## Ejecutables externos y Typstyle en Windows

El campo `executable` admite una ruta absoluta a un ejecutable de confianza y tiene prioridad sobre el `PATH`. Úsalo si la primera coincidencia en el `PATH` está dentro del proyecto o apunta a un ejecutable que necesitas reemplazar. Reinicia Neovim después de editar la declaración.

En Windows x64, descarga la versión oficial 0.15.2 de Typstyle y agrega su ruta absoluta a la entrada `configs.typst.format`. Mantén `install = not windows` para usar Mason en Linux y el ejecutable externo en Windows. [Archivos oficiales de Typstyle 0.15.2](https://github.com/typstyle-rs/typstyle/releases/expanded_assets/v0.15.2)

```lua
format = {
    {
        id = "typstyle",
        package = "typstyle",
        bin = "typstyle",
        install = not windows,
        executable = windows and "C:/Herramientas/Typstyle/typstyle-x86_64-pc-windows-msvc.exe" or nil,
    },
},
```

Después de reiniciar, ejecuta `:LanguageToolsInstall` para que Neovim compruebe `typstyle --version`. Abre un archivo `.typ` y consulta `:ConformInfo` para ver el formateador. La verificación de extremo a extremo en Windows x64 nativo está pendiente. [Plan de verificación](designs/neovim-modernization.md#verification-plan)

## Depuración en Linux

Los perfiles de Linux declaran los paquetes de depuración en `dap_adapters`. Mason DAP gestiona su instalación por separado de `:LanguageToolsInstall`. En Python, `debugpy-adapter` inicia el adaptador y la configuración de lanzamiento elige el intérprete del proyecto, con `/usr/bin/python3` como alternativa. Usa los atajos de DAP para colocar un punto de interrupción e iniciar la sesión. [Atajos de depuración](../README.md#debugging-dap)

## SQL opcional en Linux

Mason instala `sql-language-server` 1.7.1. Con Node 24.20.0 y `vscode-languageserver-protocol` 3.18.6, el servidor sale con `ERR_PACKAGE_PATH_NOT_EXPORTED`. El formato sigue disponible mediante `sql-formatter`. [Proyecto del servidor SQL](https://github.com/joe-re/sql-language-server)

Para usar el LSP con esa versión, crea un directorio fuera de tus proyectos SQL, guarda allí este `package.json` y ejecuta `npm install` desde ese directorio.

```json
{
  "private": true,
  "dependencies": { "sql-language-server": "1.7.1" },
  "overrides": {
    "sql-language-server": { "vscode-languageserver-protocol": "3.17.5" }
  }
}
```

Agrega `executable` a la entrada `sqlls` de `configs.sql.lsp` con la ruta absoluta de `node_modules/.bin/sql-language-server` en ese directorio y reinicia Neovim. Esta combinación se verificó hasta la conexión del LSP en un búfer SQL. [Configuración de perfiles](../lua/configs/languages.lua)
