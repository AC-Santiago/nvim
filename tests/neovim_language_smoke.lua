local api = vim.api
local root = assert(vim.uv.fs_mkdtemp(vim.fn.tempname() .. "-language-smoke-XXXXXX"))

local function fixture(relative, lines)
    local file = vim.fs.joinpath(root, relative)
    vim.fn.mkdir(vim.fs.dirname(file), "p")
    assert(vim.fn.writefile(lines, file) == 0)
    return file
end

local function edit(file, filetype)
    vim.cmd.edit({ args = { file }, magic = { file = false, bar = false } })
    assert(vim.bo.filetype == filetype, "Expected " .. filetype .. " for " .. file)
    return api.nvim_get_current_buf()
end

local function client(buf, name)
    local server
    assert(vim.wait(10000, function()
        server = vim.lsp.get_clients({ bufnr = buf, name = name })[1]
        return server ~= nil and server.initialized
    end, 30), name .. " did not attach. Check the executable and :LspInfo.")
    return server
end

local function expect_definition(buf, server, line, character, target)
    local params = {
        textDocument = { uri = vim.uri_from_bufnr(buf) },
        position = { line = line, character = character },
    }
    local found
    for _ = 1, 4 do
        local response = server:request_sync("textDocument/definition", params, 2500, buf)
        local result = response and response.result
        if result then
            local locations = vim.islist(result) and result or { result }
            for _, location in ipairs(locations) do
                local uri = location.targetUri or location.uri
                if uri and vim.uv.fs_realpath(vim.uri_to_fname(uri)) == vim.uv.fs_realpath(target) then
                    found = true
                end
            end
        end
        if found then
            break
        end
        vim.wait(150, function() return false end)
    end
    assert(found, server.name .. " did not resolve definition in " .. target)
end

local function expect_root(server, expected_file)
    assert(vim.uv.fs_realpath(server.root_dir or "") == vim.uv.fs_realpath(vim.fs.dirname(expected_file)),
        ("Unexpected %s root: %s"):format(server.name, tostring(server.root_dir)))
end

local function format(buf, wanted, expected)
    local conform = require("conform")
    assert(vim.wait(6000, function()
        return vim.tbl_contains(
            vim.tbl_map(function(item) return item.name end, conform.list_formatters(buf)),
            wanted
        )
    end, 30), "Missing formatter " .. wanted .. ". Check :ConformInfo and :LanguageToolsInstall.")
    local err
    assert(conform.format({ bufnr = buf, lsp_format = "never", timeout_ms = 5000 }, function(failure) err = failure end))
    assert(not err, tostring(err))
    assert(vim.deep_equal(api.nvim_buf_get_lines(buf, 0, -1, false), expected), wanted .. " produced unexpected output")
    assert(vim.bo[buf].endofline, wanted .. " removed the final newline")
end

local function smoke()
    assert(vim.fn.exists(":LanguageToolsInstall") == 2, "Load the modernized config in a disposable profile.")

    local parser_errors = {}
    for _, language in ipairs({ "markdown", "markdown_inline", "python", "typst", "lua" }) do
        local ok, loaded, err = pcall(vim.treesitter.language.add, language)
        if not ok or not loaded then
            parser_errors[#parser_errors + 1] = ("%s: %s"):format(language, tostring(ok and err or loaded))
        end
    end
    assert(#parser_errors == 0, "Tree-sitter parser errors:\n" .. table.concat(parser_errors, "\n"))

    local marker = fixture("notes/.moxide.toml", {})
    vim.fn.mkdir(vim.fs.joinpath(root, "notes", ".git"), "p")
    local target = fixture("notes/target.md", { "# Target" })
    local md = edit(fixture("notes/index.md", { "# Notes", "", "[[target]]" }), "markdown")
    local moxide = client(md, "markdown_oxide")
    expect_root(moxide, marker)
    expect_definition(md, moxide, 2, 4, target)
    assert(not require("conform").get_formatter_info("dprint", md).available, "dprint accepted a project without dprint.json")

    marker = fixture("project with spaces & tools/pyproject.toml", { "[project]", 'name = "smoke"', 'version = "1.0.0"' })
    local library = fixture("project with spaces & tools/library.py", { "def answer():", "    return 42" })
    local py = edit(fixture("project with spaces & tools/app.py", { "from library import answer", "", "answer()" }), "python")
    local pyrefly = client(py, "pyrefly")
    expect_root(pyrefly, marker)
    expect_definition(py, pyrefly, 2, 2, library)
    client(py, "ruff")
    py = edit(fixture("project with spaces & tools/format.py", { "x=1" }), "python")
    local conform = require("conform")
    assert(vim.deep_equal(conform.formatters_by_ft.python, { "ruff_fix", "ruff_format", "ruff_organize_imports" }))
    format(py, "ruff_format", { "x = 1" })
    vim.bo[py].modified = false
    local lint_buf = edit(fixture("project with spaces & tools/lint.py", { "import os" }), "python")
    local namespace = require("lint").get_namespace("ruff")
    assert(vim.wait(8000, function()
        return vim.iter(vim.diagnostic.get(lint_buf, { namespace = namespace })):any(function(item)
            return item.code == "F401"
        end)
    end, 30), "Ruff did not publish F401")

    marker = fixture("typst/typst.toml", {})
    local typ = edit(fixture("typst/main.typ", { "#let x=1" }), "typst")
    expect_root(client(typ, "tinymist"), marker)
    format(typ, "typstyle", { "#let x = 1" })
    format(typ, "typstyle", { "#let x = 1" })
    vim.bo[typ].modified = false

    marker = fixture("lua/.luarc.json", { "{}" })
    fixture("lua/.stylua.toml", { 'indent_type = "Spaces"' })
    local lua_target = fixture("lua/main.lua", { "local value=42", "return value" })
    local lua = edit(lua_target, "lua")
    local server = client(lua, "lua_ls")
    expect_root(server, marker)
    expect_definition(lua, server, 1, 9, lua_target)
    format(lua, "stylua", { "local value = 42", "return value" })
end

local ok, failure = xpcall(smoke, debug.traceback)
vim.fn.delete(root, "rf")
if not ok then
    vim.api.nvim_err_writeln(failure)
    vim.cmd.cquit(1)
end
print("Markdown, Python, Typst and Lua language smoke checks passed.")
vim.cmd("qa!")
