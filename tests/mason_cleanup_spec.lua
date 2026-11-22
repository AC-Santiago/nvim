vim.opt.rtp:prepend(vim.fn.getcwd())

local data = vim.fn.tempname()
vim.fn.mkdir(data, "p")
local stdpath = vim.fn.stdpath
vim.fn.stdpath = function(kind)
    return kind == "data" and data or stdpath(kind)
end

local state = data .. "/nvim_language_state.json"
local stored = { "sql", "old_web" }
local installed = {
    ["sql-formatter"] = true,
    ["lua-language-server"] = true,
    ["stylua"] = true,
    ["prettier"] = true,
    ["ruff"] = true,
    ["debugpy"] = true,
    ["leave-installed"] = true,
}
local attempts, callbacks, notices, prompts = {}, {}, {}, {}
local answer
vim.fn.confirm = function(prompt, choices, default)
    assert(choices == "&Yes\n&No" and default == 2, "cleanup must default to keeping packages")
    prompts[#prompts + 1] = prompt
    return answer
end
vim.notify = function(message)
    notices[#notices + 1] = message
end

package.loaded["mason-registry"] = {
    is_installed = function(name)
        return installed[name] == true
    end,
    get_package = function(name)
        assert(installed[name], "attempted to uninstall a package that was already absent")
        return {
            uninstall = function(_, _, callback)
                attempts[#attempts + 1] = name
                callbacks[name] = callback
            end,
        }
    end,
}

local languages = require("configs.languages")
languages.configs.old_web = {
    formatters = { "sql-formatter", "ruff", "prettier", "stylua", "leave-installed" },
    lsp_servers = { "lua_ls", "html" },
    dap_adapters = { "debugpy" },
}
local loader = require("utils.lang_loader")
local cleanup = require("utils.mason_cleanup")
cleanup.setup({ protected_tools = { "leave-installed" }, confirm_bulk_uninstall = false })

local function snapshot(names)
    local content = vim.json.encode({
        enabled_languages = names,
        timestamp = 1,
        nvim_version = { major = 0, minor = 11, patch = 0 },
    })
    assert(vim.fn.writefile({ content }, state) == 0)
    return content
end

local function complete(name, success, message, still_installed)
    assert(callbacks[name], "Mason was not asked to remove " .. name)
    local callback = callbacks[name]
    callbacks[name] = nil
    if success and not still_installed then
        installed[name] = nil
    end
    callback(success, message)
    assert(vim.wait(1000, function()
        return #notices > 0
    end, 5) or next(callbacks))
end

local function contains_notice(phrase)
    return vim.iter(notices):any(function(message)
        return message:find(phrase, 1, true) ~= nil
    end)
end

loader.init_state_tracking()
local seeded = vim.json.decode(table.concat(vim.fn.readfile(state), "\n"))
assert(vim.tbl_contains(seeded.enabled_languages, "python") and not vim.tbl_contains(seeded.enabled_languages, "sql"))
assert(type(seeded.timestamp) == "number" and type(seeded.nvim_version) == "table")
assert(#attempts == 0 and #prompts == 0, "seeding must leave Mason alone")

local baseline = snapshot(stored)
loader.init_state_tracking()
vim.cmd("doautocmd BufWritePost")
loader.check_and_cleanup_languages()
assert(
    #attempts == 0 and #prompts == 0 and vim.fn.readfile(state)[1] == baseline,
    "baseline startup, save, and check must be read-only"
)

for _, reply in ipairs({ 2, 0 }) do
    answer = reply
    loader.manual_cleanup()
    assert(#attempts == 0, "No and Escape must cancel even a one-package cleanup")
    local prompt = assert(prompts[#prompts], "one installed candidate must still be confirmed")
    assert(prompt:find("sql-formatter", 1, true))
    for _, name in ipairs({ "ruff", "stylua", "prettier", "lua-language-server", "debugpy", "leave-installed", "sqlls" }) do
        assert(not prompt:find(name, 1, true), "unexpected removal candidate " .. name)
    end
    assert(select(2, prompt:gsub("sql%-formatter", "")) == 1, "package appeared twice in confirmation")
end

answer, notices = 1, {}
loader.manual_cleanup()
assert(vim.deep_equal(attempts, { "sql-formatter" }))
assert(not contains_notice("Uninstalled"), "uninstall was reported before Mason completed")
complete("sql-formatter", true)
assert(contains_notice("sql-formatter"), "completed removal should be reported")
assert(vim.fn.readfile(state)[1] == baseline, "manual cleanup should preserve the baseline")

installed["sql-formatter"], installed.sqlls = true, true
attempts, notices = {}, {}
loader.manual_cleanup()
assert(vim.deep_equal(attempts, { "sql-formatter", "sqlls" }))
loader.manual_cleanup()
assert(vim.deep_equal(attempts, { "sql-formatter", "sqlls" }), "overlapping runs should share no second uninstall")
notices = {}
complete("sql-formatter", true)
notices = {}
complete("sqlls", false, "injected Mason failure")
assert(
    contains_notice("sqlls") and contains_notice("injected Mason failure"),
    "report the actual failed package and error"
)
attempts, notices = {}, {}
loader.manual_cleanup()
assert(vim.deep_equal(attempts, { "sqlls" }), "rerun should retry only the package still installed")
complete("sqlls", true)
assert(vim.fn.readfile(state)[1] == baseline, "retries should preserve the baseline")

installed["html-lsp"] = true
attempts, notices = {}, {}
snapshot({ "old_web" })
loader.manual_cleanup()
assert(vim.deep_equal(attempts, { "html-lsp" }), "legacy LSP ID should resolve to the Mason package")
complete("html-lsp", true, nil, true)
assert(
    contains_notice("Could not uninstall html-lsp"),
    "a package still installed after completion must be reported as a failure"
)
attempts, notices = {}, {}
loader.manual_cleanup()
assert(vim.deep_equal(attempts, { "html-lsp" }))
complete("html-lsp", true)

installed["sql-formatter"] = true
attempts, prompts, notices = {}, {}, {}
baseline = snapshot({})
loader.init_state_tracking()
loader.manual_cleanup()
assert(
    #attempts == 0 and #prompts == 0 and vim.fn.readfile(state)[1] == baseline,
    "valid empty snapshot supplies no candidates"
)

for _, malformed in ipairs({
    "",
    "[]",
    "{}",
    '{"enabled_languages":{}}',
    '{"enabled_languages":["sql",null]}',
    "broken {",
}) do
    assert(vim.fn.writefile({ malformed }, state) == 0)
    notices = {}
    loader.manual_cleanup()
    assert(#attempts == 0 and #prompts == 0, "invalid snapshot must refuse removal")
    assert(contains_notice("update_language_state"), "invalid snapshot must explain recovery")
    assert(vim.fn.readfile(state)[1] == malformed, "invalid snapshot was replaced")
end

assert(vim.fn.delete(state) == 0)
vim.fn.mkdir(state)
notices = {}
loader.manual_cleanup()
assert(#attempts == 0 and #prompts == 0 and contains_notice("update_language_state"))
assert(vim.fn.isdirectory(state) == 1, "an unreadable snapshot path must be preserved")
assert(vim.fn.delete(state, "d") == 0)

baseline = snapshot({ "removed_profile", "sql" })
notices = {}
loader.manual_cleanup()
assert(#attempts == 0 and #prompts == 0, "cannot establish package ownership for a removed profile")
assert(contains_notice("removed_profile"))
assert(vim.fn.readfile(state)[1] == baseline)

loader.update_language_state()
local updated = vim.json.decode(table.concat(vim.fn.readfile(state), "\n"))
assert(vim.tbl_contains(updated.enabled_languages, "python") and not vim.tbl_contains(updated.enabled_languages, "sql"))
assert(#attempts == 0 and installed["sql-formatter"], "updating the baseline must leave packages installed")
assert(vim.fn.delete(data, "rf") == 0)
print("Mason cleanup checks passed")
