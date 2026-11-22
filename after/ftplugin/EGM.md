# Ajustes por tipo de archivo

## Overview

Neovim carga estos scripts para búferes de Markdown, Python, Rust y Typst.

## Interface

- Rust también asigna `<localleader>rpm` al módulo padre, `<localleader>rem` a la expansión de macros y `<localleader>rj` a unir líneas. [rust.lua](./rust.lua)
- Markdown y Typst activan la corrección ortográfica en español. Markdown también fija `conceallevel` en 2. [markdown.lua](./markdown.lua) · [typst.lua](./typst.lua)
- Los cuatro scripts usan la configuración compartida de Tree-sitter para activar resaltado, plegado e indentación cuando hay un parser. [Configuración compartida](../../lua/configs/treesitter.lua)
- Rust asigna `gd` y `gD` a la navegación LSP, `K` a las acciones de documentación contextual y `<leader>tt` a la lista de pruebas. Los atajos con `<localleader>` dan acceso a documentación, depuración, acciones de código, programas ejecutables, diagnósticos y Cargo. [rust.lua](./rust.lua)

## Invariants

- Tree-sitter usa el analizador del tipo de archivo del búfer actual. La expresión de indentación la proporciona `nvim-treesitter`.
- Los atajos de Rust funcionan en modo normal y son locales al búfer. Las acciones de Rust que llaman a `:RustLsp` requieren que el comando esté disponible.
- La función de `LspAttach` de Markdown actúa sobre clientes llamados `obsidian-ls`.

## Side Effects

- Los scripts cambian opciones del editor e inician el resaltado de Tree-sitter.
- Markdown registra un autocomando `LspAttach` sin filtro de búfer. El autocomando desactiva las capacidades de definición y referencias del cliente, lo que puede afectar otros búferes que lo compartan.
