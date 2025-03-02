local cmp = require("cmp")

local M = {}

M.sources = {
    { name = "copilot", group_index = 1, priority = 100 },
    { name = "nvim_lsp", group_index = 2, priority = 90 },
    { name = "luasnip", group_index = 2, priority = 80 },
    { name = "buffer", group_index = 3, priority = 70 },
    { name = "nvim_lua", group_index = 2, priority = 90 },
    { name = "path", group_index = 3, priority = 60 },
}

M.sorting = {
    priority_weight = 2,
    comparators = {
        require("copilot_cmp.comparators").prioritize,
        cmp.config.compare.offset,
        cmp.config.compare.exact,
        cmp.config.compare.score,
        cmp.config.compare.kind,
        cmp.config.compare.sort_text,
        cmp.config.compare.length,
        cmp.config.compare.order,
    },
}

return M
