# Contrato EGM de las utilidades de lenguaje

## Descripción

Estas utilidades leen las declaraciones de lenguaje, resuelven ejecutables y gestionan la instalación y la limpieza manual. La configuración de lenguajes declara los perfiles y sus herramientas. [Configuración de lenguajes](../configs/languages.lua)

## Interfaz

| Módulo | Responsabilidad |
| --- | --- |
| [language_registry.lua](./language_registry.lua) | `inventory()` devuelve registros de LSP, formato y lint por perfil y tipo de archivo. Incluye perfiles deshabilitados, con `id`, `package`, `bin`, opciones y estado de activación según la declaración. |
| [language_tools.lua](./language_tools.lua) | `resolve(tool)` selecciona la ruta canónica. `command(tool, workspace)` comprueba si esa ruta se puede usar en el proyecto. `workspace()` determina la raíz para esa comprobación. |
| [language_lsp.lua](./language_lsp.lua) | `refresh()` combina los ajustes nativos y los del perfil, agrupa los tipos de archivo por ID y habilita los servidores elegibles administrados por Neovim. Los servidores con un propietario declarado conservan su propia integración. |
| [language_install.lua](./language_install.lua) | `run(workspace, complete)` instala los paquetes elegibles que faltan, comprueba la disponibilidad después de instalar y entrega el resultado al comando `:LanguageToolsInstall`. |
| [lang_loader.lua](./lang_loader.lua) | `refresh_tools()` actualiza los adaptadores LSP, Conform y lint ya cargados. `get_install_list("dap_adapters")` conserva el acceso a las declaraciones DAP. Expone `init_state_tracking()`, `get_state_info()`, `manual_cleanup()` y `update_language_state()`. |
| [mason_cleanup.lua](./mason_cleanup.lua) | Lee y escribe la línea base, protege paquetes y ejecuta la desinstalación confirmada. `setup({ protected_tools = { ... } })` amplía la lista de protecciones. |

## Invariantes

- El inventario completo permite identificar los paquetes de perfiles antes habilitados. La instalación y la activación usan el perfil `base` y los registros habilitados. La instalación deduplica por ID de paquete Mason. DAP conserva su aprovisionamiento separado. [Configuración de DAP](../configs/mason-dap.lua)
- El ejecutable declarado mediante ruta absoluta tiene prioridad. Sin esa ruta se toma la primera coincidencia de PATH y se rechaza si su ruta canónica cae dentro del proyecto. En Windows, un wrapper reconocido de Mason requiere un enlace registrado que resuelva a un `.exe` dentro del paquete.
- La configuración LSP común combina los argumentos, las condiciones y la raíz nativos con los ajustes del perfil. Informa de conflictos de configuración para un mismo ID y verifica la ruta al activar el servidor en un proyecto.
- La limpieza preserva paquetes del perfil `base`, de perfiles habilitados, de sus adaptadores DAP y de la lista de protecciones. Una línea base inválida o con perfiles sin declaración impide desinstalar. Cada lista de candidatos instalados exige **Yes**, incluidos los casos con un solo paquete. [Guía de limpieza](../../docs/MASON_CLEANUP_GUIDE.md)

## Efectos secundarios

- La inicialización crea `nvim_language_state.json` si falta. La actualización explícita reemplaza la línea base. La consulta de estado, incluida la función heredada `check_and_cleanup_languages()`, es de solo lectura.
- El instalador explícito puede actualizar el registro de Mason y solicitar instalaciones. El comando publica el resultado y actualiza los adaptadores cargados al terminar. [Comando de instalación](../plugins/mason.lua)
- La limpieza confirmada informa del resultado de cada paquete cuando Mason termina y permite reintentar los que siguen instalados. Conserva la línea base para que el siguiente intento vuelva a compararla con los perfiles actuales.

## Verificación

Desde la raíz del repositorio, ejecuta las pruebas de las utilidades con Neovim en modo headless.

```sh
nvim --headless -u NONE -i NONE -l tests/language_tools_spec.lua
nvim --headless -u NONE -i NONE -l tests/language_lsp_spec.lua
nvim --headless -u NONE -i NONE -l tests/language_install_spec.lua
nvim --headless -u NONE -i NONE -l tests/mason_cleanup_spec.lua
```
