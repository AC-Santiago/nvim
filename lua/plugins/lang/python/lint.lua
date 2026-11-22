local api = vim.api
local M = {
    options = { ruff = { root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml" } } },
}
local generation = 0

local function valid_position(position)
    return type(position) == "table"
        and type(position.row) == "number"
        and position.row >= 1
        and position.row % 1 == 0
        and type(position.column) == "number"
        and position.column >= 1
        and position.column % 1 == 0
end

local function diagnostic_count(output)
    if not output or not output:match("^%s*%[") then
        return nil
    end
    local ok, results = pcall(vim.json.decode, output)
    if not ok or not vim.islist(results) then
        return nil
    end
    for _, result in ipairs(results) do
        if
            type(result) ~= "table"
            or type(result.code) ~= "string"
            or type(result.message) ~= "string"
            or not valid_position(result.location)
            or not valid_position(result.end_location)
        then
            return nil
        end
    end
    return #results
end

function M.run(bufnr, cwd, linter)
    local filename = api.nvim_buf_get_name(bufnr)
    local changedtick = api.nvim_buf_get_changedtick(bufnr)
    local stdin = table.concat(api.nvim_buf_get_lines(bufnr, 0, -1, false), "\n") .. "\n"
    local lint = require("lint")
    local parser = require("lint.linters.ruff").parser
    local argv = { linter.cmd }
    for _, arg in ipairs(linter.args) do
        table.insert(argv, type(arg) == "function" and arg() or arg)
    end
    generation = generation + 1
    local request = generation
    vim.b[bufnr].ruff_lint_generation = request

    local function report(message)
        vim.notify(
            "Ruff lint (" .. linter.cmd .. "): " .. message .. ". Check :LanguageToolsInstall.",
            vim.log.levels.WARN
        )
    end

    local function on_exit(result)
        if
            not api.nvim_buf_is_valid(bufnr)
            or api.nvim_buf_get_name(bufnr) ~= filename
            or api.nvim_buf_get_changedtick(bufnr) ~= changedtick
            or vim.b[bufnr].ruff_lint_generation ~= request
        then
            return
        end
        if result.signal ~= 0 or (result.code ~= 0 and result.code ~= 1) then
            report(("exit %d, signal %d: %s"):format(result.code, result.signal, vim.trim(result.stderr or "")))
            return
        end
        local count = diagnostic_count(result.stdout)
        if not count then
            report("invalid JSON diagnostics")
            return
        end
        local parsed, diagnostics = pcall(parser, result.stdout)
        if not parsed or type(diagnostics) ~= "table" or #diagnostics ~= count then
            report("could not parse diagnostics")
            return
        end
        vim.diagnostic.set(lint.get_namespace("ruff"), bufnr, diagnostics)
    end

    local options = { cwd = cwd, stdin = stdin, env = linter.env, text = true }
    local ok, err = pcall(vim.system, argv, options, vim.schedule_wrap(on_exit))
    if not ok then
        report(tostring(err))
    end
end

return M
