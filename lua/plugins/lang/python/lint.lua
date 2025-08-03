local lint = require("lint")

lint.linters_by_ft.python = { "ruff" }

-- Este archivo ejecuta configuración directa, no retorna plugin specs
-- Solo se ejecuta cuando el lenguaje Python está habilitado
