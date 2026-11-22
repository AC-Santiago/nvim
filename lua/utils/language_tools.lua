local M = {}
local uv = vim.uv

local function normalize(path)
    return vim.fs.normalize(path, { expand_env = false })
end

local function path_key(path)
    local normalized = normalize(path):gsub("/+$", "")
    return vim.fn.has("win32") == 1 and normalized:lower() or normalized
end

local function contains(directory, path)
    local root, file = path_key(directory), path_key(path)
    return file == root or vim.startswith(file, root .. "/")
end

local function absolute(path)
    if vim.fn.has("win32") == 1 then
        return path:match("^%a:[/\\]") or path:match("^[/\\][/\\][^/\\]+[/\\][^/\\]+")
    end
    return vim.startswith(path, "/")
end

local function relative_link(path)
    return type(path) == "string" and path ~= "" and not path:match("^[/\\]") and not path:match("^%a:")
end

function M.receipt_link(receipt, bin)
    if receipt then
        local version = receipt:get_schema_version()
        local key = version == "1.0" and bin or version == "2.0" and (bin .. ".cmd")
        local links = receipt:get_links()
        local path = key and type(links) == "table" and type(links.bin) == "table" and links.bin[key]
        if relative_link(path) then
            return path
        end
    end
end

local function windows_executable(path)
    return path:lower():sub(-4) == ".exe" and vim.fn.executable(path) == 1
end

local function mason_target(tool, wrapper)
    local bin = tool.bin
    local directory = uv.fs_realpath(vim.fn.stdpath("data") .. "/mason/bin")
    local parent = uv.fs_realpath(vim.fs.dirname(wrapper))
    if not directory or not parent or path_key(parent) ~= path_key(directory)
        or vim.fs.basename(wrapper):lower() ~= (bin .. ".cmd"):lower() or not tool.package
    then
        return nil, "unsupported Windows wrapper: " .. wrapper
    end

    if tool.package == "typstyle" then
        return nil, "use the official Typstyle x64 executable as an absolute override instead of " .. wrapper
    end

    local ok, target = pcall(function()
        local package = require("mason-registry").get_package(tool.package)
        local receipt = package:get_receipt():or_else(nil)
        local link = M.receipt_link(receipt, bin)
        if link then
            local root = uv.fs_realpath(package:get_install_path())
            local resolved = root and uv.fs_realpath(root .. "/" .. link)
            if resolved and contains(root, resolved) and windows_executable(resolved) then
                return resolved
            end
        end
    end)

    if ok and target then
        return normalize(target)
    end
    return nil, "repair the Mason package or set an absolute native executable override for " .. wrapper
end

function M.resolve(tool)
    local windows = vim.fn.has("win32") == 1
    local path = tool.executable
    if path ~= nil then
        if type(path) ~= "string" or not absolute(path) then
            return nil, "the executable override must be an absolute path"
        end
    elseif type(tool.bin) == "string" and tool.bin ~= "" then
        path = vim.fn.exepath(tool.bin)
    else
        return nil, "no executable name is configured for " .. tool.id
    end
    if path == "" then
        return nil, "not found on PATH: " .. tool.bin, "missing"
    end
    if windows and not tool.executable and path:lower():sub(-4) == ".cmd" then
        return mason_target(tool, path)
    end

    local resolved = uv.fs_realpath(path)
    if not resolved or not (windows and windows_executable(resolved) or not windows and vim.fn.executable(resolved) == 1) then
        return nil, "not a usable native executable: " .. path
    end
    return normalize(resolved)
end

function M.command(tool, workspace)
    local path, reason, status = M.resolve(tool)
    if not path then
        return nil, reason, status
    end
    if not tool.executable then
        local root = uv.fs_realpath(workspace or vim.fn.getcwd())
        if not root then
            return nil, "cannot resolve workspace: " .. tostring(workspace)
        end
        if contains(root, path) then
            return nil, "workspace-local executable requires an absolute override: " .. path
        end
    end
    return path
end

return M
