local dap = require("dap")
local dap_python = require("dap-python")

-- configuracion al adaptador usando debugpy
local path_python = function()
    local cwd = vim.fn.getcwd()
    if vim.fn.executable(cwd .. "/venv/bin/python3") == 1 then
        return cwd .. "/venv/bin/python3"
    elseif vim.fn.executable(cwd .. "/.venv/bin/python3") == 1 then
        return cwd .. "/.venv/bin/python3"
    elseif vim.fn.executable(cwd .. "/env/bin/python3") == 1 then
        return cwd .. "/env/bin/python3"
    elseif vim.fn.executable(cwd .. "/.env/bin/python3") == 1 then
        return cwd .. "/.env/bin/python3"
    else
        return "/usr/bin/python3"
    end
end

dap_python.setup(path_python())

-- configuracion para el lanzamiento de debug en python
dap.configurations.python = {
    {
        type = "python",
        request = "launch",
        name = "launch file",

        -- Para ejecutar el archivo actual
        program = "${file}",

        pythonPath = path_python(),
    },
}
