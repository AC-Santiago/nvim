vim.opt.rtp:prepend(vim.fn.getcwd())
local registry = require("utils.language_registry")
local root = vim.uv.fs_mkdtemp(vim.fn.tempname() .. "-lsp-XXXXXX")
local workspace, trusted = root .. "/project", root .. "/paths"
vim.fn.mkdir(workspace, "p")
vim.fn.mkdir(trusted, "p")
vim.fn.writefile({}, workspace .. "/project.marker")
local buffer = vim.api.nvim_get_current_buf()
vim.api.nvim_buf_set_name(buffer, workspace .. "/first.egm")

local command = "egm-lsp-fixture"
local path = trusted .. "/" .. command
vim.fn.writefile({ "#!/bin/sh", "exit 0" }, path)
assert(vim.uv.fs_chmod(path, 493))
local inherited_path = vim.env.PATH
vim.env.PATH = trusted .. ":" .. inherited_path

vim.lsp.config("egm-fixture", {
    cmd = { command, "--server" },
    root_dir = function() error("unexpected stock root callback") end,
    settings = { fixture = { original = true, override = false } },
})
registry.inventory = function()
    return { {
        id = "egm-fixture", role = "lsp", enabled = true, filetype = "egm_ft", bin = command,
        options = {
            root_markers = { "project.marker" },
            settings = { fixture = { override = true } },
        },
    } }
end

local activated = {}
vim.lsp.enable = function(name)
    activated[#activated + 1] = name
end
local adapter = require("utils.language_lsp")
adapter.refresh()
adapter.refresh()
assert(vim.deep_equal(activated, { "egm-fixture" }))
local configured = vim.lsp.config["egm-fixture"]
assert(vim.deep_equal(configured.cmd, { path, "--server" }))
assert(vim.deep_equal(configured.filetypes, { "egm_ft" }))
assert(configured.settings.fixture.original and configured.settings.fixture.override)
local accepted
configured.root_dir(buffer, function(found) accepted = found end)
assert(accepted == workspace)
vim.fn.writefile({ "#!/bin/sh", "exit 0" }, workspace .. "/" .. command)
assert(vim.uv.fs_chmod(workspace .. "/" .. command, 493))
vim.env.PATH = workspace .. ":" .. vim.env.PATH
configured.root_dir(buffer, function() error("workspace executable was accepted") end)
vim.env.PATH = inherited_path
vim.fn.delete(root, "rf")
print("LSP ownership, settings and launch-time trust checks passed.")
