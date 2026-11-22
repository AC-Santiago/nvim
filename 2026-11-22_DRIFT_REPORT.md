## docs/designs/neovim-modernization.md

- El flujo de paridad para SQL pide instalar el paquete `sqlls` con Mason y conectar el servidor. La receta vigente instala SQL Language Server 1.7.1 con una dependencia que Node 24 rechaza al arrancar. El perfil optativo conserva el paquete y el formateador. La conexión real requirió el override externo documentado de `vscode-languageserver-protocol` 3.17.5. [Guía de SQL](./docs/README_LANGUAGE_SYSTEM.md#sql-opcional-en-linux)
- La aceptación nativa de Windows x64 sigue pendiente. Las pruebas en Linux y las simulaciones no cubren el arranque desde PowerShell, los recibos reales de Mason, Typstyle x64 ni las verificaciones de Go en esa plataforma. El diseño reserva ese paso para la VM de Windows 11. [Plan de verificación](./docs/designs/neovim-modernization.md#verification-plan)
- La transferencia de Copilot al servidor del plugin sigue pendiente de una prueba autenticada de Next Edit Suggestions con Sidekick. El código conserva la definición y la activación nativas según la condición del diseño. [Definición nativa](./lsp/copilot.lua)

## docs/designs/neovim-modernization-linux-baseline.md

No drift detected.

## docs/designs/neovim-modernization-startup-checkpoint.md

No drift detected.

## docs/designs/neovim-modernization-language-tools-candidate.md

No drift detected.

## docs/designs/neovim-modernization-linux-verification.md

No drift detected.
