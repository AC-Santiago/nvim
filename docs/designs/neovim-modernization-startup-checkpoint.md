# Primera etapa de implementación de la modernización de Neovim

22 de noviembre de 2026. Comprobaciones posteriores a los cambios de arranque, con las versiones de la [línea base de Linux](./neovim-modernization-linux-baseline.md) y el mismo lockfile. El [plan de implementación](./neovim-modernization.md#sequence-and-exit-checks) mantiene el aprovisionamiento de herramientas y el registro de lint actuales durante esta etapa.

## Cambios

- El arranque de Lazy clona en un directorio temporal junto al destino y publica el checkout después de validar la entrada Lua. Un checkout válido publicado por otro proceso se reutiliza. Los destinos incompletos que ya existen se informan con instrucciones de recuperación.
- El proveedor de Python busca primero el entorno activo, luego el proyecto y sus padres por nombre de entorno, y finalmente PATH. En Windows usa `Scripts/python.exe`, evita la búsqueda implícita en el directorio actual y comprueba con `--version` los alias de WindowsApps antes de seleccionarlos. Si falta el intérprete, `:PythonPath` lo indica. [Resolución de ejecutables en Neovim](https://neovim.io/doc/user/vimfn/#executable()) · [Alias de Python en Windows](https://learn.microsoft.com/en-us/windows/dev-environment/python#why-does-running-pythonexe-open-the-microsoft-store)
- Telescope abre nombres escritos desde `stdpath("config")` y conserva los caracteres literales del nombre.
- Tree-sitter se carga al iniciar y conserva `:TSUpdate` como compilación del plugin. Los parsers faltantes se solicitan con `:TSInstall`. Los búferes sin parser conservan sus opciones de plegado e indentación. [Guía de la revisión fijada](https://github.com/nvim-treesitter/nvim-treesitter/blob/04f17886f75416dfdc25374c950a52c63f0e98fe/README.md#requirements)
- Sidekick usa la terminal integrada fuera de Windows. El perfil Windows omite los plugins y fuentes no esenciales de Copilot, DAP, las imágenes integradas y la vista previa de Typst. Copilot Chat mantiene su selector de modelos y omite el paso opcional de Make en Windows.

## Verificación

| Prueba | Resultado |
| --- | --- |
| Comprobaciones focalizadas | Reintento tras clon incompleto, dos casos de arranque concurrente, conservación de un destino previo, selección de Python, drive y UNC, rechazo del alias de Store fallido, ambos atajos de Telescope y cambio de un búfer con parser a otro sin parser. |
| Perfil Linux en pseudoterminal | Se repitieron las 20 observaciones satisfactorias del perfil anterior. Se conservaron el arranque, guardado, terminal sin tmux, Markdown Oxide, Pyrefly, Ruff LSP y formato, y Tinymist y Typstyle. Se reprodujeron los fallos anteriores del lint Ruff y de debugpy. La conexión de Lua LS siguió sin confirmarse. |
| Sidekick y primer búfer de Python en Linux | En una pseudoterminal que heredó el entorno de herdr, Sidekick inició un comando local de prueba en su terminal integrada con tmux y Zellij deshabilitados para la prueba. Con Python como primer archivo, el adaptador DAP se registró. |
| Selección de Windows simulada en Linux | Lazy excluyó los adaptadores y fuentes de Blink previstos. Markdown, Python y Typst abrieron y guardaron en una copia sin los plugins opcionales y sin parser de Typst. El selector `:CopilotChatModels` estaba registrado. Las pruebas de rutas de Windows usaron la normalización de Neovim con entradas de unidad y UNC. |

Los resultados estructurados se guardaron en `.atl/linux-pre-modernization-2026-11-22.mttNjl/startup-results/`.

En este checkpoint quedaron pendientes el primer arranque desde PowerShell en Windows x64 y la instalación de los parsers faltantes. El registro posterior recoge el resultado en Windows. [Verificación y cierre](./neovim-modernization-linux-verification.md#cierre-egm)
