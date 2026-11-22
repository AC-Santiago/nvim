local tools = require("utils.language_tools")
local registry = require("utils.language_registry")

local M = {}
local running = false
local retry = " Check :MasonLog, then rerun :LanguageToolsInstall or configure an absolute override."

function M.report_key(record)
    return ("%s (%s/%s)"):format(record.id, record.profile, record.role)
end

local function requests_for(workspace)
    local requests, report = {}, {}
    local records = registry.inventory()
    for _, record in ipairs(records) do
        if record.enabled and record.role == "lsp" and not record.bin and not record.executable then
            local ok, lazy = pcall(require, "lazy")
            if ok then
                lazy.load({ plugins = { "nvim-lspconfig" } })
            end
            break
        end
    end
    for _, record in ipairs(records) do
        if record.enabled then
            local path, message, status = tools.command(record, workspace)
            if not path then
                if status == "missing" and record.package and record.install ~= false then
                    local request = requests[record.package] or {}
                    request[#request + 1] = record
                    requests[record.package] = request
                else
                    local external = not record.package or record.install == false
                    report[M.report_key(record)] = { status = external and "external" or "unavailable", message = message }
                end
            end
        end
    end
    return requests, report
end

local function install_package(mason, name, records, workspace, finish)
    local ok, package = pcall(mason.get_package, name)
    if not ok then
        finish("unsupported", ("Mason package unavailable: %s"):format(name))
        return
    end
    if package:is_installing() then
        finish("in_progress", "Install already in progress. Rerun after it finishes.")
        return
    end
    if package:is_installed() then
        finish("unavailable", "Installed package has no usable executable. Repair it or specify an override.")
        return
    end

    if not package:is_installable({}) then
        finish("unsupported", "No Mason recipe for this platform. Configure an absolute executable override.")
        return
    end

    local started, failure = pcall(package.install, package, {}, vim.schedule_wrap(function(success, detail)
        if not success then
            finish("failed", tostring(detail or "Mason did not complete the installation.") .. retry)
            return
        end
        for _, record in ipairs(records) do
            local path, message = tools.command(record, workspace)
            if not path then
                finish("unavailable", message)
                return
            end
        end
        finish("installed")
    end))
    if not started then
        finish("failed", tostring(failure) .. retry)
    end
end

function M.run(workspace, complete)
    if running then
        return false
    end
    local requests, report = requests_for(workspace)
    running = true
    local remaining = vim.tbl_count(requests)
    local function finish()
        running = false
        complete(report)
    end
    if remaining == 0 then
        vim.schedule(finish)
        return true
    end

    local function process(success, detail)
        for name, records in pairs(requests) do
            local finished = false
            local function package_finished(status, message)
                if finished then
                    return
                end
                finished = true
                report[name] = { status = status, message = message }
                remaining = remaining - 1
                if remaining == 0 then
                    finish()
                end
            end
            if success then
                local ok, failure = pcall(install_package, require("mason-registry"), name, records, workspace, package_finished)
                if not ok then
                    package_finished("failed", tostring(failure) .. retry)
                end
            else
                package_finished("failed", "Cannot refresh Mason registry: " .. tostring(detail) .. retry)
            end
        end
    end

    local ok, failure = pcall(function()
        require("mason-registry").refresh(vim.schedule_wrap(process))
    end)
    if not ok then
        vim.schedule(function() process(false, failure) end)
    end
    return true
end

return M
