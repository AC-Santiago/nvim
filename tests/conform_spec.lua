vim.opt.rtp:prepend(vim.fn.getcwd())
vim.opt.rtp:append(assert(vim.env.CONFORM_RTP, "Set CONFORM_RTP to the pinned Conform checkout"))

local conform = require("conform")
local plugin = require("plugins.conform")
plugin.config()
assert(vim.deep_equal(conform.formatters_by_ft.python, { "ruff_fix", "ruff_format", "ruff_organize_imports" }))
assert(vim.deep_equal(conform.formatters_by_ft.lua, { "stylua" }))
assert(not conform.formatters_by_ft.html)
assert(plugin.cmd == "ConformInfo")

local languages = require("configs.languages")
languages.css, languages.html, languages.javascript, languages.sql = true, true, true, true
local config = require("configs.conform")
config.refresh()
config.refresh()
assert(vim.deep_equal(conform.formatters_by_ft.css, { "prettier" }))
assert(vim.deep_equal(conform.formatters_by_ft.xhtml, { "prettier" }))
assert(vim.deep_equal(conform.formatters_by_ft.jsonc, { "prettier" }))
assert(not conform.formatters_by_ft.mysql)

local root = vim.fn.tempname() .. " & formatter fixture"
local workspace = root .. "/project"
local trusted = root .. "/trusted"
local workspace_bin = workspace .. "/node_modules/.bin"
local function executable(dir, name, script)
    vim.fn.mkdir(dir, "p")
    local path = dir .. "/" .. name
    vim.fn.writefile({ "#!/bin/sh", script or "cat" }, path)
    assert(vim.uv.fs_chmod(path, 493))
    return path
end
local prettier = executable(trusted, "prettier")
local dprint = executable(trusted, "dprint", "printf '%s\\n' vetted")
executable(workspace_bin, "prettier")
executable(workspace_bin, "dprint", "printf '%s\\n' shadow")
local separator = vim.fn.has("win32") == 1 and ";" or ":"
local old_path = vim.env.PATH
vim.env.PATH = trusted .. separator .. old_path
vim.fn.mkdir(workspace .. "/.git", "p")
local buf = vim.api.nvim_create_buf(false, false)
local function file(filename, filetype)
    vim.api.nvim_buf_set_name(buf, workspace .. "/" .. filename)
    vim.bo[buf].filetype = filetype
end
local runner = require("conform.runner")
for _, example in ipairs({ { "a.css", "css", "80" }, { "a.html", "html", "120" }, { "a.jsonc", "jsonc", "100" } }) do
    file(example[1], example[2])
    local formatter = assert(conform.get_formatter_config("prettier", buf))
    local argv = runner.build_cmd("prettier", runner.build_context(buf, formatter), formatter)
    assert(argv[1] == prettier, vim.inspect(argv))
    local width = vim.fn.index(argv, "--print-width")
    assert(width >= 0 and argv[width + 2] == example[3], vim.inspect(argv))
    assert(argv[#argv] == workspace .. "/" .. example[1], vim.inspect(argv))
end

file("a.md", "markdown")
assert(not conform.get_formatter_info("dprint", buf).available)
vim.fn.writefile({ "{}" }, workspace .. "/dprint.json")
local info = conform.get_formatter_info("dprint", buf)
assert(info.available and info.command == dprint and info.cwd == workspace, vim.inspect(info))
vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "original" })
assert(conform.format({ bufnr = buf, lsp_format = "never", quiet = true }))
assert(vim.api.nvim_buf_get_lines(buf, 0, -1, false)[1] == "vetted")
vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "original" })
vim.api.nvim_create_autocmd("User", {
    pattern = "ConformFormatPre",
    once = true,
    callback = function()
        vim.env.PATH = workspace_bin .. separator .. vim.env.PATH
    end,
})
assert(conform.format({ bufnr = buf, lsp_format = "never", quiet = true }))
assert(vim.api.nvim_buf_get_lines(buf, 0, -1, false)[1] == "original")
assert(not conform.get_formatter_info("dprint", buf).available)

file("a.typ", "typst")
local typstyle = assert(conform.get_formatter_config("typstyle", buf))
assert(typstyle.stdin and not typstyle.args)
vim.env.PATH = old_path
languages.html = false
languages.go = true
languages.configs.go = { filetypes = { "go" }, format = { { id = "gofmt", bin = "gofmt" } } }
config.refresh()
assert(not conform.formatters_by_ft.html and not conform.formatters_by_ft.xhtml)
assert(vim.deep_equal(conform.formatters_by_ft.go, { "gofmt" }))

local tools = require("utils.language_tools")
local probe = require("plugins.lang.typst.conform").probe
local old_has, old_command, old_system = vim.fn.has, tools.command, vim.system
local launches, complete, rejected = 0, nil, false
local native = trusted .. "/typstyle.exe"
local record = { id = "typstyle", bin = "typstyle" }
vim.fn.has = function(name)
    return name == "win32" and 1 or old_has(name)
end
tools.command = function()
    if rejected then
        return nil, "workspace-local executable"
    end
    return native
end
vim.system = function(argv, opts, callback)
    assert(vim.deep_equal(argv, { native, "--version" }) and opts.timeout == 5000)
    launches = launches + 1
    complete = callback
end

local observed = {}
local function collect(path, _, status)
    observed[#observed + 1] = path or status
end
assert(not probe(record, workspace, false, collect))
assert(not probe(record, workspace, true, collect) and launches == 1)
complete({ code = 1, stdout = "", stderr = "unlaunchable" })
assert(vim.wait(100, function()
    return #observed == 2
end))
assert(vim.deep_equal(observed, { "failed", "failed" }))
assert(not probe(record, workspace, false) and launches == 1)
assert(not probe(record, workspace, true, collect) and launches == 2)
complete({ code = 0, stdout = "typstyle 0.15.2" })
assert(vim.wait(100, function()
    return #observed == 3
end))
assert(observed[3] == native and probe(record, workspace, false) == native)
rejected = true
assert(not probe(record, workspace, false) and launches == 2)
vim.fn.has, tools.command, vim.system = old_has, old_command, old_system
vim.fn.delete(root, "rf")
print("Conform registry, profile options, trust, and Typstyle probe checks passed.")
