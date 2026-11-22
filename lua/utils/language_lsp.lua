local tools = require("utils.language_tools")
local registry = require("utils.language_registry")
local M = {}
local defaults, enabled = {}, {}

local function profile_options(record)
    local profile = record.profile
    if profile then
        local path = ("lua/plugins/lang/%s/lsp.lua"):format(profile)
        if #vim.api.nvim_get_runtime_file(path, false) > 0 then
            return require("plugins.lang." .. profile .. ".lsp")[record.id] or {}
        end
    end
    return {}
end

local function configurations()
    local servers = {}
    for _, record in ipairs(registry.inventory()) do
        if record.enabled and record.role == "lsp" and not record.owner then
            local options = vim.tbl_deep_extend("force", {}, profile_options(record), record.options)
            local server = servers[record.id] or { record = record, options = options, filetypes = {} }
            if record.bin ~= server.record.bin
                or record.executable ~= server.record.executable
                or not vim.deep_equal(options, server.options)
            then
                server.conflict = true
            end
            if not vim.tbl_contains(server.filetypes, record.filetype) then
                server.filetypes[#server.filetypes + 1] = record.filetype
            end
            servers[record.id] = server
        end
    end
    return servers
end

local function activate(id, entry)
    local record = vim.deepcopy(entry.record)
    defaults[id] = defaults[id] or vim.deepcopy(vim.lsp.config[id] or {})
    local config = vim.tbl_deep_extend("force", {}, defaults[id], entry.options)
    local cmd = config.cmd
    if type(cmd) ~= "table" then
        vim.notify_once("Language tools: configure the native arguments for " .. id, vim.log.levels.WARN)
        return
    end

    record.bin = record.bin or cmd[1]
    local path, reason, status = tools.resolve(record)
    if not path then
        if status ~= "missing" then
            vim.notify_once(id .. ": " .. reason, vim.log.levels.WARN)
        end
        return
    end
    config.cmd = vim.deepcopy(cmd)
    config.cmd[1] = path
    config.filetypes = entry.filetypes
    local native_root = config.root_dir
    if record.options.root_markers and record.options.root_dir == nil then
        native_root = nil
    end
    local markers = config.root_markers
    config.root_dir = function(buf, on_dir)
        local function accept(root)
            if not vim.api.nvim_buf_is_valid(buf) or (not root and config.workspace_required) then
                return
            end
            local verified, reason = tools.command(record, tools.workspace(buf, root, markers))
            if verified == path then
                on_dir(root)
            elseif reason then
                vim.notify_once(id .. ": " .. reason, vim.log.levels.WARN)
            end
        end

        if type(native_root) == "function" then
            native_root(buf, accept)
        else
            accept(native_root or (markers and vim.fs.root(buf, markers) or nil))
        end
    end
    vim.lsp.config(id, config)
    if not enabled[id] then
        vim.lsp.enable(id)
        enabled[id] = true
    end
end

function M.refresh()
    local servers = configurations()
    for _, id in ipairs(vim.fn.sort(vim.tbl_keys(servers))) do
        local entry = servers[id]
        if entry.conflict then
            vim.notify_once("Language tools: conflicting LSP declarations for " .. id, vim.log.levels.ERROR)
        else
            activate(id, entry)
        end
    end
end

return M
