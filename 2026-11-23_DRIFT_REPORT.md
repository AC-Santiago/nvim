## docs/designs/neovim-modernization.md

- El diseño pide identificar el ejecutable y una acción de recuperación cuando falla un arranque LSP que no tiene una sonda previa. El adaptador conserva el diagnóstico nativo de Neovim para salidas de proceso. Pyrefly agrega una notificación con el código de salida. La recuperación específica queda documentada para errores de resolución e instalación. [Adaptador LSP](./lua/utils/language_lsp.lua) · [Definición de Pyrefly](./lsp/pyrefly.lua)
- El plan incluye verificar el ejemplo Go en Windows y Linux. El registro contiene la prueba de Linux. La confirmación del usuario en Windows cubre los flujos principales y el ejercicio Go queda como escenario optativo. [Evidencia disponible](./docs/designs/neovim-modernization-linux-verification.md#cierre-egm)

## docs/designs/neovim-modernization-linux-baseline.md

No drift detected.

## docs/designs/neovim-modernization-startup-checkpoint.md

No drift detected.

## docs/designs/neovim-modernization-language-tools-candidate.md

No drift detected.

## docs/designs/neovim-modernization-linux-verification.md

No drift detected.
