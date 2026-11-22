local conform = require("conform")
local registry = require("utils.language_registry")
local tools = require("utils.language_tools")
local typstyle = require("plugins.lang.typst.conform")
local M = {}
local configured_filetypes = {}

local function settings(profile)
    local module = "plugins.lang." .. profile .. ".conform"
    local ok, options = pcall(require, module)
    if ok then
        return options
    end
    if not tostring(options):find("module '" .. module .. "' not found:", 1, true) then
        error(options)
    end
    return {}
end

local function unavailable(config)
    -- Conform requires a nonempty command even if the tool became unavailable after its readiness check.
    config.args, config.range_args = nil, nil
    return "/"
end

local function command(record, config, ctx)
    local cwd = config.cwd and config.cwd(config, ctx)
    if (not cwd and config.require_cwd) or (config.condition and not config.condition(config, ctx)) then
        return unavailable(config)
    end
    if config.cwd then
        config.cwd = function()
            return cwd
        end
    end
    local workspace = tools.workspace(ctx.buf, cwd, config.root_markers)
    local resolve = record.id == "typstyle" and typstyle.probe or tools.command
    local path, reason, status = resolve(record, workspace)
    if not path then
        if reason and status ~= "failed" then
            vim.notify_once(
                ("%s unavailable: %s. Run :LanguageToolsInstall or set a trusted absolute executable override."):format(
                    record.id,
                    reason
                ),
                vim.log.levels.WARN
            )
        end
        return unavailable(config)
    end

    local key = ctx.range and config.range_args and "range_args" or "args"
    local args = config[key]
    if type(args) == "function" then
        args = args(config, ctx)
        config[key] = function()
            return args or {}
        end
    end
    if args ~= nil and not vim.islist(args) then
        vim.notify_once(
            record.id .. " requires a list of formatter arguments for direct execution.",
            vim.log.levels.WARN
        )
        return unavailable(config)
    end
    return path
end

function M.refresh()
    local chains, by_formatter, by_profile = {}, {}, {}
    for _, record in ipairs(registry.inventory()) do
        if record.role == "format" then
            local formats = by_formatter[record.id] or {}
            by_formatter[record.id] = formats
            if record.enabled then
                local ft, profile = record.filetype, record.profile
                by_profile[profile] = by_profile[profile] or settings(profile)
                local options = vim.tbl_deep_extend("force", by_profile[profile][record.id] or {}, record.options)
                options.format = nil
                options.command = function(config, ctx)
                    return command(record, config, ctx)
                end
                formats[ft] = options
                chains[ft] = chains[ft] or {}
                chains[ft][#chains[ft] + 1] = record.id
            end
        end
    end

    for id, formats in pairs(by_formatter) do
        conform.formatters[id] = function(bufnr)
            local options = formats[vim.bo[bufnr].filetype]
            return options and vim.deepcopy(options) or { inherit = false, command = "/" }
        end
    end
    for ft in pairs(configured_filetypes) do
        conform.formatters_by_ft[ft] = nil
    end
    for ft, chain in pairs(chains) do
        conform.formatters_by_ft[ft] = chain
    end
    configured_filetypes = chains
end

function M.setup()
    conform.setup({
        format_on_save = {
            timeout_ms = 500,
            lsp_format = "fallback",
        },
    })
    M.refresh()
    if vim.fn.has("win32") == 1 then
        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("LanguageToolsTypstyle", { clear = true }),
            pattern = "typst",
            callback = function(event)
                if vim.tbl_contains(conform.formatters_by_ft.typst or {}, "typstyle") then
                    conform.get_formatter_info("typstyle", event.buf)
                end
            end,
        })
    end
end

return M
