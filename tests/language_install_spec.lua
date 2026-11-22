vim.opt.rtp:prepend(vim.fn.getcwd())
local registry = require("utils.language_registry")
local tools = require("utils.language_tools")
local kinds = {
    { id = "ruff", role = "lint", bin = "ruff", enabled = true, package = "ruff" },
    { id = "ruff", role = "lsp", bin = "ruff", enabled = true, package = "ruff" },
    { id = "typstyle", bin = "typstyle", enabled = true, package = "typstyle", install = false },
    { id = "pyrefly", bin = "pyrefly", enabled = true, package = "pyrefly" },
    { id = "prettier", bin = "prettier", enabled = false, package = "prettier" },
}
local found = { pyrefly = true }
registry.inventory = function() return kinds end
tools.command = function(record)
    if found[record.bin] then return "/trusted/bin/" .. record.bin end
    return nil, "not found", "missing"
end

local refreshes, attempts, answer = 0, 0, nil
package.loaded["mason-registry"] = {
    refresh = function(callback)
        refreshes = refreshes + 1
        vim.schedule(function() callback(true) end)
    end,
    get_package = function(name)
        assert(name == "ruff", "Requested unexpected package " .. name)
        return {
            is_installed = function() return false end,
            is_installing = function() return false end,
            install = function(_, _, callback)
                attempts = attempts + 1
                answer = callback
            end,
        }
    end,
}

local installer = require("utils.language_install")
local function wait_for(test)
    assert(vim.wait(1000, test, 5))
end

local result
assert(refreshes == 0, "Importing the module refreshed the registry")
assert(installer.run("/", function(report) result = report end))
assert(not installer.run("/", function() error("ran duplicate command") end))
wait_for(function() return answer ~= nil end)
assert(attempts == 1 and refreshes == 1)
answer(false, "injected failure")
wait_for(function() return result ~= nil end)
assert(result.ruff.status == "failed" and result.ruff.message:find("injected failure", 1, true))
assert(result.typstyle.status == "external" and not result.pyrefly and not result.prettier)

result, answer = nil, nil
assert(installer.run("/", function(report) result = report end))
wait_for(function() return answer ~= nil end)
found.ruff = true
answer(true)
wait_for(function() return result ~= nil end)
assert(attempts == 2 and refreshes == 2 and result.ruff.status == "installed")

result = nil
assert(installer.run("/", function(report) result = report end))
wait_for(function() return result ~= nil end)
assert(attempts == 2 and refreshes == 2 and not result.ruff)
print("Explicit provisioning, shared packages, exclusions and retry checks passed.")
