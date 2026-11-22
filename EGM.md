# Arquitectura de la configuración de Neovim

## System Overview

[init.lua](./init.lua) es el punto de entrada. Inicializa lazy.nvim, importa los plugins de NvChad v2.5 y las especificaciones locales, y aplica los ajustes de sesión. [README.md](./README.md) documenta la instalación y el uso del editor.

## Local Interface & Invariants

- `vim.g.mapleader` se establece en espacio antes de configurar lazy.nvim.
- `require("lazy").setup` usa `configs.lazy`, importa `nvchad.plugins` y `plugins`, y carga `options` desde la configuración de NvChad.
- `vim.g.base46_cache` apunta a `nvchad/base46/` en el directorio de datos. Luego se ejecutan los archivos `defaults` y `statusline` de esa caché.
- `:PythonPath` muestra el valor actual de `vim.g.python3_host_prog`. `get_python_path` prioriza el Python ejecutable de `VIRTUAL_ENV`, después busca `.venv`, `venv` y `.virtualenv`, en ese orden. Recorre el directorio de trabajo y sus padres para cada nombre, por lo que un `.venv` de un padre tiene prioridad sobre un `venv` local. Finalmente busca `python3` y `python` en el `PATH`, en ese orden. Si ninguno se encuentra, informa que no hay un intérprete seleccionado.
- `nvchad.autocmds` y `autocmds` se cargan durante el arranque. La carga de `mappings` se programa con `vim.schedule`.

## Subdirectories & System Boundaries

- [Configuración de arranque](./init.lua) y [especificaciones de plugins](./lua/plugins/init.lua).
- [Registro de lenguajes](./lua/configs/languages.lua) y [contrato de herramientas y limpieza](./lua/utils/EGM.md).
- [Guía de lenguajes](./docs/README_LANGUAGE_SYSTEM.md), [limpieza de Mason](./docs/MASON_CLEANUP_GUIDE.md) y [diseño EGM](./docs/designs/neovim-modernization.md).

## Global Invariants

- NvChad v2.5 proporciona la base de la configuración.
- Las especificaciones de plugins se administran a través de lazy.nvim. [lazy-lock.json](./lazy-lock.json) registra las revisiones fijadas.
- Los indicadores de [configs.languages](./lua/configs/languages.lua) controlan qué paquetes de idioma contribuyen configuración y herramientas. [language_registry](./lua/utils/language_registry.lua) normaliza las declaraciones y [lang_loader](./lua/utils/lang_loader.lua) actualiza los consumidores ya cargados.
- Los ajustes de `after/ftplugin/` se ejecutan por tipo de archivo. El arranque común se coordina desde `init.lua` y los módulos que importa.

## Global Side Effects

- Si falta lazy.nvim, `init.lua` clona la rama `stable` a un directorio temporal contiguo y lo publica tras validar la entrada Lua. Si el destino existe incompleto, el mensaje de arranque indica cómo recuperarlo.
- El arranque establece opciones globales de Neovide y busca Python en el entorno activo, en los entornos del proyecto y en PATH. `:PythonPath` muestra el resultado.
- Si `dms` está disponible, el portapapeles usa `dms cl copy` y `dms cl paste`, y habilita `unnamedplus`.
- El arranque crea la instantánea de idiomas solo si falta. `:LanguageToolsInstall` instala herramientas del registro bajo pedido. Las eliminaciones requieren confirmación en la limpieza manual. [Contrato de utilidades](./lua/utils/EGM.md)

## System Verification

- Desde la raíz, comprueba la sintaxis Lua sin ejecutar la configuración ni cargar plugins.

  ```bash
  NVIM_LOG_FILE=/dev/null nvim --headless -u NONE -i NONE -l <(
    git ls-files --cached --others --exclude-standard -z -- '*.lua' |
      xargs -0 -r printf 'assert(loadfile("%s"))\n'
  )
  ```
