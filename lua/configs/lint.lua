local registry = require("utils.language_registry")
local tools = require("utils.language_tools")
local python = require("plugins.lang.python.lint")
local windows = vim.fn.has("win32") == 1
local M = {}
local by_filetype
local profile_options = {
    base = {
        luacheck = {
            args = { "--globals", "love", "vim", "--formatter", "plain", "--codes", "--ranges", "-" },
            root_markers = { ".luacheckrc" },
        },
    },
    javascript = require("plugins.lang.javascript.lint"),
    python = python.options,
}

local function windows_ruff(record)
    return record.filetype == "python" and record.id == "ruff"
end

function M.refresh()
    by_filetype = {}
    for _, record in ipairs(registry.inventory()) do
        -- The pinned nvim-lint runner wraps every process in cmd.exe on Windows.
        if record.enabled and record.role == "lint" and (not windows or windows_ruff(record)) then
            by_filetype[record.filetype] = by_filetype[record.filetype] or {}
            table.insert(by_filetype[record.filetype], record)
        end
    end
end

function M.try_lint()
    local bufnr = vim.api.nvim_get_current_buf()
    local records = by_filetype[vim.bo[bufnr].filetype]
    if not records or vim.bo[bufnr].buftype ~= "" then
        return
    end

    local lint = require("lint")
    for _, record in ipairs(records) do
        local native = lint.linters[record.id]
        if not native then
            vim.notify_once("Unknown nvim-lint definition: " .. record.id, vim.log.levels.WARN)
        else
            if type(native) == "function" then
                native = native()
            end
            local settings = (profile_options[record.profile] or {})[record.id] or {}
            local linter = vim.tbl_deep_extend("force", native, settings, record.options)
            local cwd = tools.workspace(bufnr, linter.cwd, linter.root_markers)
            if not record.bin and type(native.cmd) == "string" then
                record.bin = native.cmd
            end
            local command, reason, status = tools.command(record, cwd)
            if command then
                linter.cmd = command
                if windows then
                    python.run(bufnr, cwd, linter)
                else
                    lint.try_lint(record.id, {
                        cwd = cwd,
                        wrap_linter = function(defaults)
                            linter.name = linter.name or defaults.name
                            return linter
                        end,
                    })
                end
            elseif status ~= "missing" then
                vim.notify_once(
                    record.id .. " lint: " .. reason .. ". Check :LanguageToolsInstall.",
                    vim.log.levels.WARN
                )
            end
        end
    end
end

M.refresh()
return M
