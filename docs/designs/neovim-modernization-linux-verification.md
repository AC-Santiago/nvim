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

## Actualización y reversión

La configuración nueva arrancó y pasó el smoke sobre una copia de los datos anteriores, en las rutas de configuración y datos originales. La prueba usó un espacio de montaje aislado con el directorio de usuario activo oculto y sin red. Los intentos de descarga de Copilot y websocat demostraron que las funciones opcionales requerían red y el smoke terminó con código 0.

Para revertir se montó una copia nueva de la configuración, el lockfile y los datos de la línea base. La prueba en pseudoterminal recuperó las 20 observaciones satisfactorias iniciales y Lua LS también se conectó. Se reprodujeron los dos fallos de referencia, Ruff lint y Python DAP, que están corregidos en el candidato. [Línea base](./neovim-modernization-linux-baseline.md)

## Aceptación pendiente

La prueba de extremo a extremo en Windows x64 se hará al final en una VM limpia de Windows 11 con PowerShell y sin WSL. Desde esa VM se usará `develop` y se comprobarán también el arranque, el aprovisionamiento explícito, Typstyle x64 y la declaración de Go. La conexión autenticada de Sidekick Next Edit Suggestions sigue siendo la condición para retirar el servidor nativo de Copilot. [Plan de verificación](./neovim-modernization.md#verification-plan)
