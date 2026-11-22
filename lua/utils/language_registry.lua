local M = {}

function M.inventory()
    local languages = require("configs.languages")
    local profiles = vim.tbl_keys(languages.configs)
    table.sort(profiles)

    local records = {}
    for _, profile in ipairs(profiles) do
        local config = languages.get_config(profile)
        for _, role in ipairs({ "lsp", "format", "lint" }) do
            for _, tool in ipairs(config[role] or {}) do
                for _, filetype in ipairs(tool.filetypes or config.filetypes or {}) do
                    records[#records + 1] = {
                        profile = profile,
                        enabled = profile == "base" or languages.is_enabled(profile),
                        role = role,
                        filetype = filetype,
                        id = tool.id,
                        package = tool.package,
                        bin = tool.bin,
                        executable = tool.executable,
                        options = vim.deepcopy(tool.options or {}),
                        owner = tool.owner,
                        install = tool.install ~= false,
                    }
                end
            end
        end
    end
    return records
end

return M
