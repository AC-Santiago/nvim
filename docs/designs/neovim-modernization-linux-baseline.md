# Línea base de Linux para la modernización de Neovim

Capturada el 22 de noviembre de 2026, antes de los cambios de modernización, según la [secuencia del diseño](./neovim-modernization.md#sequence-and-exit-checks). La copia incluye los cambios locales que ya estaban en el proyecto. El perfil activo y el lockfile se conservaron.

## Estado capturado

- Ubuntu 26.04.1 LTS x86_64, kernel 7.0.0-43-generic y Neovim 0.12.5.
- Tree-sitter CLI 0.27.2, GCC 15.2.0, tar 1.35, curl 8.18.0, Git 2.53.0, Python 3.14.4, Node 24.20.0 y herdr 0.9.5.
- Commit base del proyecto `b4432a1bcd9dc4de41aa2e8372276e3a2fd4488a`. SHA-256 del lockfile local `0bc0f265b71516765fc72f664a8ebfc23863d32464a8ca2cd3e7e82cafe6c1f4`.
- 61 checkouts locales con su revisión efectiva, incluido lazy.nvim `306a05526ada86a7b30af95c5cc81ffba93fef97`, NvChad `87d6a41ec07ab995de912a892749b6b4805ad2b3` y nvim-treesitter `04f17886f75416dfdc25374c950a52c63f0e98fe`. Las 61 revisiones coinciden con el lockfile. `obsidian.nvim` y `render-markdown.nvim` figuran en el lockfile y carecen de checkout en el perfil capturado.
- 11 paquetes Mason con recibos 2.0 y 17 parsers instalados en `site/parser`. El inventario también registra los enlaces de Mason, los hashes de los parsers y `nvim_language_state.json`.
- Perfiles habilitados de Markdown, Python, Rust y Typst. HTML, CSS, JavaScript y SQL estaban deshabilitados. La lista habilitada coincide con la instantánea de limpieza.

| Paquetes Mason | Versiones |
| --- | --- |
| Lua | Lua LS 3.19.1 y StyLua 2.5.2 |
| Markdown | Markdown Oxide 0.25.12 y dprint 0.57.4 |
| Python | Pyrefly 1.3.1, Ruff 0.16.8 y debugpy 1.8.22 |
| Typst | Tinymist 0.15.8 y Typstyle 0.15.3 |
| Rust | rust-analyzer 2026-09-14 y CodeLLDB 1.12.3 |

## Flujos observados

Ejecuté Neovim en una pseudoterminal con una copia del perfil, archivos de prueba en rutas con espacios y `TMUX` sin definir. Las pruebas usaron los paquetes y parsers ya instalados. El entorno de ejecución restringió la red. Los proyectos de prueba tenían raíces propias.

| Flujo | Resultado de referencia |
| --- | --- |
| Arranque, guardado y terminal | Lazy completó el arranque. Neovim abrió y guardó archivos en la copia. La terminal integrada ejecutó un comando local y devolvió código 0. |
| Python del proveedor | Se seleccionó `/usr/bin/python3` sin entorno. Desde un subdirectorio se encontró el `.venv` del proyecto. Con `VIRTUAL_ENV` activo se priorizó su intérprete. |
| Markdown | Tree-sitter analizó el archivo. Markdown Oxide se conectó a la raíz de las notas y resolvió `[[target]]`. Conform habilitó dprint solo donde había `dprint.json`. La prueba del comando de formato quedó incompleta porque el archivo de configuración de prueba no incluía el plugin de Markdown de dprint. |
| Python | Tree-sitter analizó el archivo. Pyrefly resolvió la definición en otro módulo y Ruff LSP se conectó. Conform convirtió `x=1` en `x = 1` con `ruff_fix`, `ruff_format` y `ruff_organize_imports`, y conservó el salto final. |
| Ruff en nvim-lint | No se publicó F401. La llamada de referencia con `--fix --no-unsafe-fixes` salió con código 2 porque faltaba `check`. La llamada de control con `ruff check` devolvió F401 para `import os`. [Configuración actual](../../lua/plugins/lang/python/lint.lua) |
| Python DAP | El lanzamiento seleccionado salió con código 1. `/usr/bin/python3 -m debugpy` confirmó que ese intérprete carece de `debugpy`, aunque el ejecutable de Mason respondió con la versión 1.8.22. |
| Typst | Tree-sitter analizó el archivo y Tinymist se conectó a la raíz. Typstyle convirtió `#let x=1` en `#let x = 1` y mantuvo el resultado en la segunda pasada. |
| Lua | Tree-sitter, StyLua y Luacheck externo funcionaron. Lua LS inició el proceso en la copia y la prueba no observó que se conectara al búfer. |
| Rust | Tree-sitter analizó el archivo y Rustaceanvim conectó rust-analyzer. La carga completa del workspace quedó sin verificar por problemas de Rustup en el entorno de prueba. |
| HTML, CSS, JavaScript y SQL | Los perfiles permanecieron deshabilitados. Sin embargo, el LSP de dprint se conectó a JavaScript, JSON y JSONC por la configuración compartida. |

Mason emitió errores de permisos y las descargas de componentes opcionales fallaron en el entorno de prueba. Quedaron pendientes la autenticación de Copilot, las sugerencias de Sidekick bajo herdr, la vista previa de Typst y las pruebas de Windows.

## Copia de referencia

La copia privada se guardó en `.atl/linux-pre-modernization-2026-11-22.mttNjl/`, fuera del control de versiones. Contiene `snapshot/config`, `snapshot/data`, el lockfile, `inventory.json`, `snapshot-manifest.jsonl` y los resultados de las pruebas. Se conservaron los checkouts con sus metadatos Git, Mason, `site` con parsers y consultas, los temas generados, los datos de vista previa de Typst y la instantánea de lenguajes. Los directorios de estado y caché del editor, y el directorio de datos de Copilot, quedaron fuera de la copia.

En la copia desechable de prueba se reubicaron los enlaces absolutos de Tree-sitter y los lanzadores de Lua LS y debugpy para apuntar al directorio temporal. La copia de referencia conserva sus rutas originales. En la prueba posterior de actualización y reversión, hay que restaurar la configuración y los datos a sus rutas absolutas originales dentro de la VM Linux aislada y repetir estos flujos. [Plan de verificación](./neovim-modernization.md#verification-plan)
