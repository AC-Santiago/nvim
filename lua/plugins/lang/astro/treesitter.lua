-- Treesitter configuration for Astro
-- Astro usa parsers de HTML, CSS, JavaScript/TypeScript
local M = {}

M.ensure_installed = {
    "astro",
    "html",
    "css",
    "typescript",
    "javascript",
    "tsx",
    "json",
    "jsonc",
}

return M