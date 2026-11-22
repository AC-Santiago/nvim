vim.opt.rtp:prepend(vim.fn.getcwd())

local root = vim.fn.tempname() .. " Ruff lint & fixture"
vim.fn.mkdir(root .. "/src", "p")
vim.fn.writefile({}, root .. "/pyproject.toml")
local filename = root .. "/src/test & lint.py"
local buffer = vim.api.nvim_get_current_buf()
vim.api.nvim_buf_set_name(buffer, filename)
filename = vim.api.nvim_buf_get_name(buffer)
vim.api.nvim_buf_set_lines(buffer, 0, -1, false, { "import os" })
vim.bo.filetype = "python"

local has = vim.fn.has
vim.fn.has = function(feature)
    return feature == "win32" and 1 or has(feature)
end
local executable = "C:/Trusted Tools/Ruff/ruff.exe"
local ready = false
require("utils.language_tools").command = function(record, cwd)
    assert(record.id == "ruff" and cwd == vim.fs.normalize(root))
    if ready then
        return executable
    end
    return nil, "not found", "missing"
end

local requests, messages = {}, {}
local launch_fails = false
vim.system = function(argv, opts, callback)
    assert(
        vim.deep_equal(argv, {
            executable,
            "check",
            "--force-exclude",
            "--quiet",
            "--stdin-filename",
            filename,
            "--no-fix",
            "--output-format",
            "json",
            "-",
        }),
        vim.inspect(argv)
    )
    assert(opts.cwd == vim.fs.normalize(root) and opts.stdin == "import os\n")
    if launch_fails then
        error("spawn failed")
    end
    requests[#requests + 1] = callback
end
vim.notify = function(message)
    messages[#messages + 1] = message
end

local lint = require("lint")
lint.try_lint = function()
    error("Windows Ruff was dispatched through nvim-lint")
end
local ns = lint.get_namespace("ruff")
local adapter = require("configs.lint")
assert(type(adapter) == "table" and adapter.try_lint, "Missing registry-driven lint entry point")
adapter.try_lint()
assert(#requests == 0 and #messages == 0, "Missing Ruff launched or interrupted editing")

local function flush()
    local finished = false
    vim.schedule(function()
        finished = true
    end)
    assert(vim.wait(1000, function()
        return finished
    end, 5))
end

local issue =
    [=[[{"code":"F401","message":"unused import","location":{"row":1,"column":8},"end_location":{"row":1,"column":10}}]]=]
local function complete(request, output, code, signal)
    request({ code = code or 1, signal = signal or 0, stdout = output, stderr = "" })
    flush()
end
local function diagnostic()
    return vim.diagnostic.get(buffer, { namespace = ns })[1]
end
local function launch()
    adapter.try_lint()
    return assert(table.remove(requests, 1), "Ready Ruff did not run")
end

ready = true
adapter.refresh()
local pending = launch()
pending({ code = 1, signal = 0, stdout = issue, stderr = "" })
assert(not diagnostic(), "Diagnostics were published before the scheduled callback")
flush()
assert(diagnostic().code == "F401" and diagnostic().source == "ruff" and diagnostic().col == 7)

for _, invalid in ipairs({
    "{",
    "{}",
    "null",
    "[{}]",
    [=[[{"code":"F401","message":"x","location":{"row":1.5,"column":1},"end_location":{"row":2,"column":2}}]]=],
}) do
    complete(launch(), invalid)
    assert(diagnostic().code == "F401", "Malformed output cleared the last valid diagnostics: " .. invalid)
end
assert(#messages == 5, "Malformed Ruff output was not reported")

complete(launch(), "[]", 2)
assert(diagnostic().code == "F401" and #messages == 6, "Ruff process failure replaced diagnostics")
complete(launch(), "[]", 0, 15)
assert(diagnostic().code == "F401" and #messages == 7, "Interrupted Ruff replaced diagnostics")
launch_fails = true
adapter.try_lint()
assert(diagnostic().code == "F401" and #messages == 8 and messages[8]:find(executable, 1, true))
launch_fails = false

local original_parser = lint.linters.ruff.parser
lint.linters.ruff.parser = function()
    error("parser failed")
end
complete(launch(), issue)
assert(diagnostic().code == "F401" and #messages == 9, "Ruff parser failure replaced diagnostics")
lint.linters.ruff.parser = function()
    return {}
end
complete(launch(), issue)
assert(diagnostic().code == "F401" and #messages == 10, "An incomplete parser result cleared diagnostics")
lint.linters.ruff.parser = original_parser

local older, newer = launch(), launch()
complete(newer, " [ ]\n", 0)
assert(not diagnostic(), "A valid empty diagnostic array did not clear the Ruff namespace")
complete(older, issue)
assert(not diagnostic(), "An earlier Ruff result overwrote the current generation")

pending = launch()
vim.api.nvim_buf_set_lines(buffer, 0, -1, false, { "pass" })
complete(pending, issue)
assert(not diagnostic(), "Ruff published a result for older buffer contents")
vim.api.nvim_buf_set_lines(buffer, 0, -1, false, { "import os" })

pending = launch()
vim.api.nvim_buf_set_name(buffer, filename .. ".renamed")
complete(pending, issue)
assert(not diagnostic(), "Ruff published a result for the previous filename")
vim.api.nvim_buf_set_name(buffer, filename)

require("configs.languages").python = false
adapter.refresh()
adapter.try_lint()
assert(#requests == 0 and #messages == 10, "Disabled Ruff was dispatched")

vim.fn.delete(root, "rf")
print("language lint tests passed")
