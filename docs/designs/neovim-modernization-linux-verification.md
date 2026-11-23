# Verificación de la modernización en Linux

22 de noviembre de 2026. Perfil desechable en Ubuntu 26.04.1 x86_64 con Neovim 0.12.5, Tree-sitter CLI 0.27.2, Python 3.14.4 y Node.js 24.20.0. El candidato usa NvChad v2.5 y retira tres adaptadores redundantes de Mason. [Línea base](./neovim-modernization-linux-baseline.md) · [Diseño](./neovim-modernization.md)

| Flujo | Resultado en Linux |
| --- | --- |
| Markdown | Markdown Oxide 0.25.12 se conectó a la raíz de notas y resolvió un enlace interno. dprint 0.57.4 formateó un archivo con el plugin Markdown 0.29.0. |
| Python | Pyrefly 1.3.1 resolvió una definición local. Ruff 0.16.8 se conectó, aplicó la cadena de tres formateadores y publicó F401. debugpy 1.8.22 llegó a un breakpoint, reanudó con el Python del proyecto y salió con código 0. |
| Typst | Tinymist 0.15.8 se conectó a la raíz declarada y Typstyle 0.15.3 formateó el archivo. |
| Lua | Lua LS 3.19.1 se conectó y resolvió una definición. StyLua 2.5.2 formateó el archivo y la comprobación de paridad conservó Luacheck. |
| Web | Los servidores HTML y CSS 4.10.0 y VTSLS 0.3.0 se conectaron. Prettier 3.10.1 formateó HTML, CSS, JavaScript y JSONC. Oxlint 1.94.0 publicó `eslint(no-unused-vars)` con la regla habilitada. |
| SQL | SQL Formatter 15.9.1 aplicó mayúsculas y cuatro espacios con su configuración vigente. El servidor 1.7.1 se conectó con el override documentado de su dependencia de protocolo. [Recuperación de SQL](../README_LANGUAGE_SYSTEM.md#sql-opcional-en-linux) |
| Go | Una declaración optativa habilitó gopls 0.24.0 y gofmt con Go 1.27.4. Las sesiones con `assignVariableTypes` activo e inactivo devolvieron resultados de pistas distintos. Al deshabilitar el perfil y reiniciar se retiró la activación con gopls aún instalado. |
| Rust | Rustaceanvim conectó rust-analyzer al proyecto Cargo. El servidor aceptó las opciones actualizadas de comprobación al guardar y Clippy. [Configuración de rust-analyzer](https://rust-analyzer.github.io/book/configuration.html#rust-analyzer.checkOnSave) |
| Instalación y limpieza | El comando explícito aprovisionó web, SQL y Go en la copia. Las pruebas de limpieza comprobaron la confirmación, la protección de paquetes compartidos y el reintento de fallos con paquetes de prueba. |

Se ejecutaron siete pruebas focalizadas y el smoke con herramientas reales. Desde el perfil preparado para Markdown, Python, Typst y Lua, se puede repetir el smoke con el comando siguiente.

```sh
nvim --headless -i NONE -n -c "luafile tests/neovim_language_smoke.lua"
```

## Revisión de Lua en herdr

Con Lua LS 3.19.1 se reprodujo la selección de la raíz padre cuando contenía una `.luarc.json` y el proyecto hijo tenía `.luarc.jsonc`. Tras agrupar los marcadores, Lua LS usó el ejecutable de Mason y la raíz del proyecto hijo en el primer búfer. Resolvió una definición entre archivos en una ruta con espacios y otra en un archivo suelto. También pasaron las siete pruebas focalizadas y el smoke de Markdown, Python, Typst y Lua. [Prueba de regresión](../../tests/language_lsp_spec.lua)

## Actualización y reversión

La configuración nueva arrancó y pasó el smoke sobre una copia de los datos anteriores, en las rutas de configuración y datos originales. La prueba usó un espacio de montaje aislado con el directorio de usuario activo oculto y sin red. Los intentos de descarga de Copilot y websocat demostraron que las funciones opcionales requerían red y el smoke terminó con código 0.

Para revertir se montó una copia nueva de la configuración, el lockfile y los datos de la línea base. La prueba en pseudoterminal recuperó las 20 observaciones satisfactorias iniciales y Lua LS también se conectó. Se reprodujeron los dos fallos de referencia, Ruff lint y Python DAP, que están corregidos en el candidato. [Línea base](./neovim-modernization-linux-baseline.md)

## Aceptación de Windows 11

El usuario confirmó que Neovim arrancó y mostró el panel de NvChad desde PowerShell en un equipo físico con Windows 11. La aceptación continúa en ese equipo con la edición, la terminal, el aprovisionamiento explícito y el smoke de Markdown, Python, Typst y Lua. Go sirve para verificar el registro con un perfil optativo. SQL queda fuera de la aceptación. La conexión autenticada de Sidekick Next Edit Suggestions sigue siendo la condición para retirar el servidor nativo de Copilot. [Plan de verificación](./neovim-modernization.md#verification-plan)

### Preparar MSVC para Tree-sitter

En el primer intento de `:TSInstall` en Windows se descargaron las cinco gramáticas. El paso `tree-sitter build` dio `program not found` al ejecutar `cl.exe`. El reintento creó un `markdown.so` en el directorio de datos que Windows rechazó como aplicación Win32 inválida. El usuario confirmó que el parser incluido cargó con `--clean`. El usuario comprobó con `dumpbin` que el `tree-sitter.exe` activo era x86 (`14C`). Esa arquitectura concuerda con el destino `i686` observado al probar Zig y con los errores de carga en Neovim x64.

Si falta el compilador, instala o modifica **Build Tools for Visual Studio** y selecciona **Desarrollo para el escritorio con C++**, con las herramientas MSVC x64/x86 y un SDK de Windows. Abre **x64 Native Tools Command Prompt for VS** desde Inicio y ejecuta `powershell -NoLogo` allí. Así PowerShell hereda las rutas del compilador, los encabezados y las bibliotecas del SDK. Si usas `NVIM_APPNAME`, vuelve a definir en esa sesión el valor del perfil que probaste. [Instalación de C y C++](https://learn.microsoft.com/en-us/cpp/build/vscpp-step-0-installation?view=msvc-170) · [Entorno de compilación x64](https://learn.microsoft.com/en-us/cpp/build/building-on-the-command-line?view=msvc-170)

Descarga el CLI de Tree-sitter para **Windows x64**. En PowerShell, confirma qué ejecutable selecciona el `PATH` antes de abrir Neovim. [Distribuciones oficiales de Tree-sitter](https://github.com/tree-sitter/tree-sitter/releases)

```powershell
$treeSitter = (Get-Command tree-sitter.exe -ErrorAction Stop).Source
$treeSitter
dumpbin /headers $treeSitter | Select-String 'machine'
Get-Command cl.exe -ErrorAction Stop
```

Busca `8664 machine (x64)`. Si aparece `14C machine (x86)`, usa `Get-Command tree-sitter.exe -All` para identificar la copia que está primero en el `PATH` y dale prioridad a la versión x64. [Tipos de máquina de Windows](https://learn.microsoft.com/en-us/windows/win32/debug/pe-format#machine-types)

Abre Neovim desde esa PowerShell y comprueba que `:echo executable('cl.exe')` devuelve `1`. Si Python y Typst se instalaron con el CLI x86 y Windows rechaza sus binarios, ejecuta `:TSUninstall python typst`, espera a que termine y vuelve a instalarlos con `:TSInstall python typst`. Usa los parsers de Lua y Markdown incluidos con Neovim.

El perfil de Windows rechazó también `markdown_inline.so`. Si los parsers incluidos cargan con `--clean` y el perfil rechaza las copias de `nvim-data/site/parser`, retira ambas copias con `:TSUninstall markdown markdown_inline` y reinicia. Si Lua da el mismo error, confirma su copia incluida y recupera el parser con `:TSUninstall lua`. [Resolución de parsers de Neovim](https://neovim.io/doc/user/treesitter/#treesitter-parsers)

### Ejecutar la aceptación en PowerShell

Si el perfil ya arranca, continúa desde la carpeta donde clonaste el repositorio en la misma sesión de PowerShell. Para repetir el arranque con un perfil limpio, usa los [requisitos del README](../../README.md#requirements) y el bloque siguiente. Guarda el commit y el hash del lockfile con los resultados.

```powershell
$env:NVIM_APPNAME = 'nvim-egm'
$cfg = nvim --headless -u NONE -i NONE -c 'lua io.write(vim.fn.stdpath([[config]]))' -c 'qa!'
git clone --branch develop https://github.com/AC-Santiago/nvim.git $cfg
Set-Location $cfg
git rev-parse HEAD
Get-FileHash .\lazy-lock.json -Algorithm SHA256
nvim
```

1. Abre, guarda y ejecuta `:terminal` antes de instalar herramientas. Comprueba `:PythonPath` con y sin un entorno virtual.
2. Prepara el [Typstyle x64 oficial](../README_LANGUAGE_SYSTEM.md#ejecutables-externos-y-typstyle-en-windows). Ejecuta `:TSInstall python typst` si faltan esos parsers y después `:LanguageToolsInstall`. Comprueba en `:Mason` que se instalaron Lua LS, Markdown Oxide, Pyrefly, Ruff y Tinymist. Para un fallo, consulta `:MasonLog` y repite el comando después de corregirlo.
3. Cuando terminen las instalaciones, cierra Neovim y ejecuta el smoke en la misma sesión de PowerShell. El smoke comprueba primero los cinco parsers y enumera todos los fallos de carga antes de probar los LSP. Registra el código de salida y cualquier fallo. Los casos de recibos y rutas se detallan en el plan de verificación.

```powershell
nvim --headless -i NONE -n -c "luafile tests/neovim_language_smoke.lua"
$LASTEXITCODE
```
