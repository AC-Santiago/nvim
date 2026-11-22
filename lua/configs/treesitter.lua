local M = {}

function M.parsers()
    local parsers = { "bash", "fish", "lua", "luadoc", "toml", "vim", "vimdoc", "yaml" }
    for _, language in ipairs(require("configs.languages").get_enabled_languages()) do
        local path = ("lua/plugins/lang/%s/treesitter.lua"):format(language)
        if #vim.api.nvim_get_runtime_file(path, false) > 0 then
            local config = require("plugins.lang." .. language .. ".treesitter")
            vim.list_extend(parsers, config.ensure_installed or {})
        end
    end
    return vim.fn.uniq(vim.fn.sort(parsers))
end

function M.start()
    if not pcall(vim.treesitter.start) then
        return
    end
    vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
end

return M
