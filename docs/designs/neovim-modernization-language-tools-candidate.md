# Perfil candidato de herramientas de lenguaje

La rama `modernization/language-tools` prepara la segunda etapa del [diseño EGM](./neovim-modernization.md#sequence-and-exit-checks). Se ejecuta en un perfil aislado con los tres adaptadores automáticos de Mason desactivados. La selección y la provisión separada de DAP para Linux siguen presentes.

## Configuración y comando

`lua/configs/languages.lua` conserva las opciones de habilitación y define los LSP, formateadores y linters por perfil. Cada rol puede sobrescribir los tipos de archivo del perfil y pasar opciones nativas. `:LanguageToolsInstall` consulta las herramientas que faltan, solicita una instalación por paquete y actualiza los consumidores cargados al terminar. Los errores de instalación permiten repetir el comando. [Contrato del registro](./neovim-modernization.md#registry-and-adapter-contract)

Antes del lanzamiento, los adaptadores comprueban la ruta seleccionada frente al workspace. Si la primera coincidencia de PATH pertenece al proyecto, informa la ruta. La recuperación es retirar esa coincidencia de PATH o configurar la ruta absoluta de un ejecutable de confianza. Los recibos locales de Mason permiten resolver los wrappers de Windows compatibles. Para Typstyle en Windows, se usa el ejecutable independiente x64 y se verifica con `--version`. [Comportamiento de ejecución](./neovim-modernization.md#resolution-and-runtime-behavior)

Para la prueba de Go, añade `root_markers = { "go.work", "go.mod", ".git" }` en las opciones de `gopls` junto al ajuste de pistas. La lista explícita reemplaza el cálculo de raíz nativo que invoca `go env` en la revisión fijada. El comando del servidor sigue resolviéndose al abrir el búfer. [Definición de gopls](https://github.com/neovim/nvim-lspconfig/blob/6e72b89d499455611f09f46d13ee9f79325406e5/lsp/gopls.lua)

## Verificación

- Las pruebas headless cubren el registro y los tipos de archivo, el rechazo de rutas locales o recibos incompatibles, la instalación deduplicada y el reintento, y la selección de comandos de LSP, Conform y nvim-lint.
- La prueba en Linux repitió las 20 observaciones satisfactorias de la [línea base](./neovim-modernization-linux-baseline.md). Ruff publicó F401 y el comando explícito confirmó que las herramientas del perfil preparado ya estaban disponibles.
- Los casos de CSS, HTML y JSONC verifican la configuración de Prettier por perfil con un ejecutable controlado. El caso de Oxlint usa su contrato CLI y la ruta de diagnósticos sobre una salida de prueba. Los casos de Ruff y Typstyle para Windows simulan el sistema y el proceso en Linux.

Quedan pendientes la aceptación en Windows x64 nativo, los flujos con binarios reales de web y SQL, la conexión de Lua LS y la sesión DAP de Python. La migración definitiva y la limpieza manual del inventario se evalúan en el corte posterior. [Plan de verificación](./neovim-modernization.md#verification-plan)
