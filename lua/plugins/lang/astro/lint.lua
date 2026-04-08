local lint = require("lint")

-- Astro usa principalmente el LSP de Astro para linting
-- pero también puede usar eslint con el plugin de Astro

-- Configurar lint para archivos Astro
-- El LSP de Astro ya proporciona diagnósticos, pero puedes agregar eslint si lo necesitas
lint.linters_by_ft.astro = { "eslint" }

-- Si quieres usar el LSP de Astro como linter (recomendado)
-- el LSP de Astro ya incluye diagnostics, no necesitas configuración adicional aquí

-- Para proyectos que usan eslint con Astro:
-- 1. Instala @astrojs/eslint (https://github.com/astro-community/astro-eslint)
-- 2. Configura eslint en tu proyecto
-- 3. El LSP de Astro funciona automáticamente

return {}