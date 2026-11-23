## docs/designs/neovim-modernization.md

- El usuario confirmó el arranque desde PowerShell en un equipo físico con Windows 11. Después de preparar el compilador, Windows rechazó las copias instaladas de `markdown.so` y `markdown_inline.so`. El parser de Markdown incluido cargó con `--clean`. Se confirmó que el CLI activo era x86 (`14C`). El intento posterior del smoke comprobó los cinco parsers y Markdown Oxide. Se detuvo al conectar Pyrefly en un equipo sin Python. Quedan por aprovisionar Pyrefly y confirmar el resto del smoke, además de las comprobaciones manuales de edición, terminal y recibos de Mason. [Plan de verificación](./docs/designs/neovim-modernization.md#verification-plan)
- La transferencia de Copilot al servidor del plugin sigue pendiente de una prueba autenticada de Next Edit Suggestions con Sidekick. El código conserva la definición y la activación nativas según la condición del diseño. [Definición nativa](./lsp/copilot.lua)

## docs/designs/neovim-modernization-linux-baseline.md

No drift detected.

## docs/designs/neovim-modernization-startup-checkpoint.md

No drift detected.

## docs/designs/neovim-modernization-language-tools-candidate.md

No drift detected.

## docs/designs/neovim-modernization-linux-verification.md

No drift detected.
