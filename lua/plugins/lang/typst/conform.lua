local M = { typstyle = { root_markers = { "typst.toml" } } }
local probes = {}

function M.probe(record, workspace, retry, callback)
    local path, reason, status = require("utils.language_tools").command(record, workspace)
    local function deliver(result, message, state)
        if callback then
            callback(result, message, state)
        end
        return result, message, state
    end
    if not path or vim.fn.has("win32") ~= 1 then
        return deliver(path, reason, status)
    end

    local probe = probes[path]
    if probe and not (retry and probe.status == "failed") then
        if probe.status == "pending" then
            if callback then
                probe.callbacks[#probe.callbacks + 1] = callback
            end
            return nil, nil, "pending"
        end
        return deliver(probe.status == "ready" and path or nil, probe.message, probe.status)
    end

    probe = { status = "pending", callbacks = callback and { callback } or {} }
    probes[path] = probe
    local function finish(failure)
        probe.status = failure and "failed" or "ready"
        if failure then
            probe.message = ("Typstyle --version failed for %s (%s). Repair or set an absolute x64 executable override, then run :LanguageToolsInstall."):format(
                path,
                failure
            )
            if #probe.callbacks == 0 then
                vim.notify_once(probe.message, vim.log.levels.WARN)
            end
        end
        local callbacks = probe.callbacks
        probe.callbacks = nil
        for _, complete in ipairs(callbacks) do
            complete(not failure and path or nil, probe.message, probe.status)
        end
    end

    local ok, err = pcall(
        vim.system,
        { path, "--version" },
        { timeout = 5000, text = true },
        vim.schedule_wrap(function(result)
            finish(result.code ~= 0 and ("exit %d"):format(result.code) or nil)
        end)
    )
    if not ok then
        finish(tostring(err))
        return nil, probe.message, probe.status
    end
    return nil, nil, "pending"
end

return M
