local M = {}

local mason_cleanup = require("utils.mason_cleanup")

function M.get_install_list(tool_type)
    local lang_config = require("configs.languages")
    local install_list = {}

    for _, lang in ipairs(lang_config.get_enabled_languages()) do
        local config = lang_config.get_config(lang)
        if config[tool_type] then
            vim.list_extend(install_list, config[tool_type])
        end
    end

    return install_list
end

M.init_state_tracking = mason_cleanup.init_state
M.update_language_state = mason_cleanup.save_current_state
M.get_state_info = mason_cleanup.get_status
M.manual_cleanup = mason_cleanup.cleanup_disabled_languages

-- Keep the old check entry point safe for configurations that call it from autocmds.
M.check_and_cleanup_languages = M.get_state_info

function M.refresh_tools()
    for _, module in ipairs({ "configs.lsp", "configs.conform", "configs.lint" }) do
        local adapter = package.loaded[module]
        if type(adapter) == "table" and adapter.refresh then
            adapter.refresh()
        end
    end
end

return M
