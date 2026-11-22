vim.opt.rtp:prepend(vim.fn.getcwd())
local registry = require("utils.language_registry")
local languages = require("configs.languages")
local tools = require("utils.language_tools")

local function find(records, profile, role, id, filetype)
    return vim.iter(records):find(function(record)
        return record.profile == profile and record.role == role and record.id == id and record.filetype == filetype
    end)
end

local records = registry.inventory()
assert(find(records, "base", "lsp", "lua_ls", "lua").package == "lua-language-server")
assert(find(records, "markdown", "format", "dprint", "markdown").enabled)
assert(find(records, "python", "lint", "ruff", "python").package == "ruff")
assert(not find(records, "javascript", "format", "prettier", "jsonc").enabled)
assert(not find(records, "javascript", "lint", "oxlint", "jsonc"))
assert(not find(records, "html", "lsp", "html", "xhtml"))
assert(find(records, "html", "format", "prettier", "xhtml"))
assert(find(records, "rust", "lsp", "rust_analyzer", "rust").owner == "rustaceanvim")

languages.go = true
languages.configs.go = {
    filetypes = { "go" },
    lsp = {
        { id = "gopls", package = "gopls", bin = "gopls", options = {
            settings = { gopls = { hints = { assignVariableTypes = true } } },
        } },
    },
    format = { { id = "gofmt", bin = "gofmt" } },
}
records = registry.inventory()
assert(find(records, "go", "lsp", "gopls", "go").options.settings.gopls.hints.assignVariableTypes)
assert(find(records, "go", "format", "gofmt", "go").package == nil)
assert(find(records, "markdown", "lsp", "markdown_oxide", "markdown").enabled)

local root = vim.uv.fs_mkdtemp(vim.fn.tempname() .. "-tools-XXXXXX")
local project, trusted = root .. "/project", root .. "/project-sibling"
local function executable(dir, name)
    vim.fn.mkdir(dir, "p")
    local path = dir .. "/" .. name
    vim.fn.writefile({ "#!/bin/sh", "exit 0" }, path)
    assert(vim.uv.fs_chmod(path, 493))
    return path
end

local bin = "egm-fixture-bin"
local good = executable(trusted, bin)
local shadow = executable(project, bin)
local path = vim.env.PATH
vim.env.PATH = project .. ":" .. trusted .. ":" .. path
local override = { id = bin, bin = bin, executable = good }
local implicit = { id = bin, bin = bin }
local command, reason = tools.command(implicit, project)
assert(not command and reason:find("workspace", 1, true))
assert(tools.command(override, project) == good)
override.executable = "relative"
assert(not tools.command(override, project))
local link = root .. "/symlink-bin"
vim.fn.mkdir(link, "p")
assert(vim.uv.fs_symlink(shadow, link .. "/" .. bin))
vim.env.PATH = link .. ":" .. trusted .. ":" .. path
assert(not tools.command(implicit, project))
vim.env.PATH = trusted .. ":" .. path
assert(tools.command(implicit, project) == good)
local gofmt = executable(trusted, "gofmt")
package.preload["conform.formatters.gofmt"] = function() return { command = "gofmt" } end
assert(tools.command({ id = "gofmt", role = "format" }, project) == gofmt)
local gopls = executable(trusted, "gopls")
vim.lsp.config("gopls", { cmd = { "gopls" } })
assert(tools.command({ id = "gopls", role = "lsp" }, project) == gopls)
vim.env.PATH = path

local receipts = {
    ["1.0"] = { bin = { ruff = "package/ruff.exe" } },
    ["2.0"] = { bin = { ["ruff.cmd"] = "package/ruff.exe" } },
}
for schema, receipt in pairs(receipts) do
    assert(tools.receipt_link({
        get_schema_version = function() return schema end,
        get_links = function() return receipt end,
    }, "ruff") == "package/ruff.exe")
end
assert(not tools.receipt_link(nil, "ruff"))
assert(not tools.receipt_link({
    get_schema_version = function() return "2.0" end,
    get_links = function() return { bin = { ruff = "wrong-key.exe" } } end,
}, "ruff"))
local shim_dir = root .. "/mason/bin"
local package_dir = root .. "/mason/packages/ruff"
local wrapper = executable(shim_dir, "ruff.cmd")
local native = executable(package_dir, "ruff.exe")
local old_has, old_stdpath, old_exepath = vim.fn.has, vim.fn.stdpath, vim.fn.exepath
vim.fn.has = function(name) return name == "win32" and 1 or old_has(name) end
vim.fn.stdpath = function(name) return name == "data" and root or old_stdpath(name) end
local implicit_windows_cwd = vim.env.NoDefaultCurrentDirectoryInExePath
vim.fn.exepath = function()
    assert(vim.env.NoDefaultCurrentDirectoryInExePath == "1")
    return wrapper
end
local windows_tool = { id = "ruff", bin = "ruff", package = "ruff" }
local bin_link = "ruff.exe"
local bad_json = false
local lookups = 0
package.loaded["mason-registry"] = {
    get_package = function()
        lookups = lookups + 1
        return {
            get_install_path = function() return package_dir end,
            get_receipt = function()
                assert(not bad_json, "malformed JSON")
                return { or_else = function()
                    return {
                        get_schema_version = function() return "2.0" end,
                        get_links = function() return { bin = { ["ruff.cmd"] = bin_link } } end,
                    }
                end }
            end,
        }
    end,
}
assert(tools.command(windows_tool, project) == native)
assert(vim.env.NoDefaultCurrentDirectoryInExePath == implicit_windows_cwd)
local outside = executable(root .. "/mason/packages", "elsewhere.exe")
bin_link = "../elsewhere.exe"
assert(not tools.command(windows_tool, project), outside)
bin_link = "ruff.exe"
bad_json = true
assert(not tools.command(windows_tool, project))
local typstyle = executable(shim_dir, "typstyle.cmd")
vim.fn.exepath = function() return typstyle end
local old_lookups = lookups
assert(not tools.command({ id = "typstyle", bin = "typstyle", package = "typstyle" }, project))
assert(lookups == old_lookups)
vim.fn.has, vim.fn.stdpath, vim.fn.exepath = old_has, old_stdpath, old_exepath
vim.fn.delete(root, "rf")
print("Language registry, launch trust and receipt schema checks passed.")
