local M = {}

local languages = require("configs.languages")
local registry = require("utils.language_registry")
local state_file = vim.fn.stdpath("data") .. "/nvim_language_state.json"
local protected_tools = { "lua-language-server", "stylua", "prettier" }
local user_protected_tools = {}
local running = false

local function current_languages()
    local enabled = {}
    for profile in pairs(languages.configs) do
        if profile ~= "base" and languages.is_enabled(profile) then
            enabled[#enabled + 1] = profile
        end
    end
    table.sort(enabled)
    return enabled
end

function M.load_previous_state()
    local stat, _, code = vim.uv.fs_lstat(state_file)
    if not stat then
        return nil, code == "ENOENT" and "missing" or "invalid"
    end
    if stat.type ~= "file" then
        return nil, "invalid"
    end

    local read, lines = pcall(vim.fn.readfile, state_file)
    if read then
        local decoded, snapshot = pcall(vim.json.decode, table.concat(lines, "\n"))
        local enabled = decoded and type(snapshot) == "table" and snapshot.enabled_languages
        if type(enabled) == "table" and vim.islist(enabled) then
            if
                not vim.iter(enabled):any(function(profile)
                    return type(profile) ~= "string" or profile == ""
                end)
            then
                return enabled, "valid"
            end
        end
    end
    return nil, "invalid"
end

local function write_state(replace)
    local content = vim.json.encode({
        enabled_languages = current_languages(),
        timestamp = os.time(),
        nvim_version = vim.version(),
    }) .. "\n"

    local mkdir_ok, mkdir_error = pcall(vim.fn.mkdir, vim.fs.dirname(state_file), "p")
    if not mkdir_ok then
        return nil, mkdir_error
    end

    local fd, path, open_error
    if replace then
        fd, path = vim.uv.fs_mkstemp(state_file .. ".XXXXXX")
        if not fd then
            return nil, path
        end
    else
        local code
        fd, open_error, code = vim.uv.fs_open(state_file, "wx", tonumber("600", 8))
        if not fd then
            return code == "EEXIST", open_error
        end
        path = state_file
    end

    local bytes, write_error = vim.uv.fs_write(fd, content, 0)
    local closed, close_error = vim.uv.fs_close(fd)
    if bytes == #content and closed then
        if not replace then
            return true
        end
        local renamed, rename_error = vim.uv.fs_rename(path, state_file)
        if renamed then
            return true
        end
        write_error = rename_error
    end
    vim.uv.fs_unlink(path)
    return nil, write_error or close_error or "Incomplete write"
end

local function state_notice(written, error_message, success_message)
    if written then
        if success_message then
            vim.notify(success_message, vim.log.levels.INFO)
        end
    else
        vim.notify(
            ("Could not write language snapshot %s (%s)."):format(state_file, error_message),
            vim.log.levels.WARN
        )
    end
    return written
end

function M.init_state()
    local _, state = M.load_previous_state()
    if state == "missing" then
        local written, err = write_state(false)
        return state_notice(written, err)
    end
    return state == "valid"
end

function M.save_current_state()
    if running then
        vim.notify("Wait for Mason cleanup to finish before updating the baseline.", vim.log.levels.WARN)
        return false
    end
    local written, err = write_state(true)
    return state_notice(written, err, "Language cleanup baseline updated.")
end

function M.setup(config)
    config = config or {}
    vim.list_extend(user_protected_tools, config.user_protected_tools or {})
    vim.list_extend(user_protected_tools, config.protected_tools or {})
end

function M.get_protected_tools()
    return vim.list_extend(vim.deepcopy(protected_tools), user_protected_tools)
end

local function disabled_languages(previous)
    local disabled = {}
    for _, profile in ipairs(previous or {}) do
        if profile ~= "base" and (not languages.configs[profile] or not languages.is_enabled(profile)) then
            disabled[#disabled + 1] = profile
        end
    end
    return disabled
end

function M.get_status()
    local previous, state = M.load_previous_state()
    return {
        auto_cleanup_enabled = false,
        protected_tools = M.get_protected_tools(),
        state_file = state_file,
        snapshot_status = state,
        previous_languages = previous or {},
        current_languages = current_languages(),
        disabled_languages = disabled_languages(previous),
    }
end

local function removable_packages(disabled)
    local protected = {}
    for _, name in ipairs(M.get_protected_tools()) do
        protected[name] = true
    end

    local candidates, by_role = {}, { lsp = {}, format = {}, lint = {} }
    local function track(profile, package)
        if profile == "base" or languages.is_enabled(profile) then
            protected[package] = true
        elseif disabled[profile] then
            candidates[package] = true
        end
    end

    for _, record in ipairs(registry.inventory()) do
        if record.package then
            track(record.profile, record.package)
            if protected[record.id] then
                protected[record.package] = true
            end
            if by_role[record.role] then
                by_role[record.role][record.id] = record.package
            end
        end
    end

    for profile, config in pairs(languages.configs) do
        for role, field in pairs({ lsp = "lsp_servers", format = "formatters", lint = "linters" }) do
            if not config[role] then
                for _, name in ipairs(config[field] or {}) do
                    track(profile, by_role[role][name] or name)
                end
            end
        end
        for _, name in ipairs(config.dap_adapters or {}) do
            track(profile, name)
        end
    end

    for name in pairs(protected) do
        candidates[name] = nil
    end
    local names = vim.tbl_keys(candidates)
    table.sort(names)
    return names
end

function M.cleanup_disabled_languages()
    if running then
        vim.notify("Mason cleanup is already running.", vim.log.levels.INFO)
        return false
    end
    local previous, state = M.load_previous_state()
    if state == "missing" then
        local initialized = M.init_state()
        if initialized then
            vim.notify("Language cleanup baseline initialized.", vim.log.levels.INFO)
        end
        return initialized
    end
    if state == "invalid" then
        vim.notify(
            (
                "Unreadable or invalid language snapshot at %s. Restore it or run "
                .. ":lua require('utils.lang_loader').update_language_state() to accept the current baseline."
            ):format(state_file),
            vim.log.levels.WARN
        )
        return false
    end

    local disabled, unknown = {}, {}
    for _, profile in ipairs(disabled_languages(previous)) do
        if languages.configs[profile] then
            disabled[profile] = true
        else
            unknown[#unknown + 1] = profile
        end
    end
    if #unknown > 0 then
        vim.notify(
            ("No declaration found for previous language profiles %s. Kept installed packages."):format(
                table.concat(unknown, ", ")
            ),
            vim.log.levels.WARN
        )
        return false
    end

    local candidates = next(disabled) and removable_packages(disabled) or {}
    local mason
    if #candidates > 0 then
        local ok, result = pcall(require, "mason-registry")
        if not ok then
            vim.notify("Cannot load Mason's registry. Check :MasonLog and rerun cleanup.", vim.log.levels.WARN)
            return false
        end
        mason = result
        candidates = vim.tbl_filter(mason.is_installed, candidates)
    end
    if #candidates == 0 then
        vim.notify("No installed Mason packages need cleanup.", vim.log.levels.INFO)
        return true
    end
    if vim.fn.confirm("Uninstall these Mason packages?\n" .. table.concat(candidates, "\n"), "&Yes\n&No", 2) ~= 1 then
        return false
    end

    running = true
    local remaining = #candidates
    for _, name in ipairs(candidates) do
        local finished = false
        local function finish(success, detail)
            if finished then
                return
            end
            finished = true
            remaining = remaining - 1
            running = remaining > 0
            if success and not mason.is_installed(name) then
                vim.notify("Uninstalled " .. name .. ".", vim.log.levels.INFO)
            else
                if success then
                    detail = "Mason still reports the package as installed"
                end
                vim.notify(
                    ("Could not uninstall %s (%s). Check :MasonLog and rerun cleanup."):format(name, tostring(detail)),
                    vim.log.levels.WARN
                )
            end
        end
        local started, err = pcall(function()
            mason.get_package(name):uninstall({}, vim.schedule_wrap(finish))
        end)
        if not started then
            finish(false, err)
        end
    end
    return true
end

return M
