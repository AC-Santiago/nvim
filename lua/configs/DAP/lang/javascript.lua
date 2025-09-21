local dap = require("dap")

dap.adapters["pwa-node"] = {
    type = "server",
    host = "localhost",
    port = "${port}",
    executable = {
        command = "js-debug-adapter",
        args = { "${port}" },
    },
}

dap.adapters["pwa-chrome"] = {
    type = "server",
    host = "localhost",
    port = "${port}",
    executable = {
        command = "js-debug-adapter",
        args = { "${port}" },
    },
}

dap.adapters["node-terminal"] = {
    type = "server",
    host = "localhost",
    port = "${port}",
    executable = {
        command = "js-debug-adapter",
        args = { "${port}" },
    },
}

local function get_browser_path()
    local browsers = {
        "/usr/bin/google-chrome-stable",
        "/usr/bin/google-chrome",
        "/usr/bin/chromium-browser",
        "/usr/bin/chromium",
        "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome",
        "/Applications/Chromium.app/Contents/MacOS/Chromium",
    }

    for _, browser in ipairs(browsers) do
        if vim.fn.executable(browser) == 1 then
            return browser
        end
    end

    return "google-chrome" -- fallback
end

for _, language in ipairs({ "typescript", "javascript" }) do
    dap.configurations[language] = {
        {
            type = "pwa-node",
            request = "launch",
            name = "🚀 Launch Current File",
            program = "${file}",
            cwd = "${workspaceFolder}",
            sourceMaps = true,
            skipFiles = { "<node_internals>/**" },
            protocol = "inspector",
            console = "integratedTerminal",
            internalConsoleOptions = "neverOpen",
        },
        {
            type = "pwa-node",
            request = "launch",
            name = "🔧 Launch with Arguments",
            program = "${file}",
            args = function()
                local args_string = vim.fn.input("Arguments: ")
                return vim.split(args_string, " +", true)
            end,
            cwd = "${workspaceFolder}",
            sourceMaps = true,
            skipFiles = { "<node_internals>/**" },
            protocol = "inspector",
            console = "integratedTerminal",
        },
        {
            type = "pwa-node",
            request = "launch",
            name = "🧪 Jest Tests",
            runtimeExecutable = "node",
            runtimeArgs = {
                "./node_modules/jest/bin/jest.js",
                "--runInBand",
                "--no-cache",
                "--watchAll=false",
            },
            rootPath = "${workspaceFolder}",
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            internalConsoleOptions = "neverOpen",
            skipFiles = { "<node_internals>/**", "node_modules/**" },
            sourceMaps = true,
        },
        {
            type = "pwa-node",
            request = "launch",
            name = "📦 npm script",
            runtimeExecutable = "npm",
            runtimeArgs = {
                "run-script",
                function()
                    return vim.fn.input("Script name: ")
                end,
            },
            cwd = "${workspaceFolder}",
            sourceMaps = true,
            skipFiles = { "<node_internals>/**" },
            console = "integratedTerminal",
        },
        {
            type = "pwa-node",
            request = "attach",
            name = "🔗 Attach to Node Process",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
            sourceMaps = true,
            skipFiles = { "<node_internals>/**" },
            protocol = "inspector",
        },
        {
            type = "pwa-node",
            request = "attach",
            name = "🔗 Attach by Port",
            address = "localhost",
            port = function()
                return tonumber(vim.fn.input("Port: ", "9229"))
            end,
            localRoot = "${workspaceFolder}",
            remoteRoot = "${workspaceFolder}",
            sourceMaps = true,
            skipFiles = { "<node_internals>/**" },
            protocol = "inspector",
        },
    }
end

for _, language in ipairs({ "typescriptreact", "javascriptreact" }) do
    dap.configurations[language] = {
        {
            type = "pwa-chrome",
            request = "launch",
            name = "🌐 Launch React App",
            url = function()
                return vim.fn.input("App URL: ", "http://localhost:3000")
            end,
            webRoot = "${workspaceFolder}/src",
            sourceMaps = true,
            userDataDir = false,
            runtimeExecutable = get_browser_path(),
            runtimeArgs = {
                "--remote-debugging-port=9222",
                "--no-first-run",
                "--no-default-browser-check",
                "--disable-web-security",
            },
        },
        {
            type = "pwa-chrome",
            request = "attach",
            name = "🔗 Attach to Chrome",
            port = 9222,
            webRoot = "${workspaceFolder}",
            sourceMaps = true,
            trace = true,
            url = "http://localhost:*",
            pathMapping = {
                ["/"] = "${workspaceFolder}",
            },
        },
        {
            type = "pwa-chrome",
            request = "launch",
            name = "🚀 Launch Dev Server",
            url = "http://localhost:3000",
            webRoot = "${workspaceFolder}/src",
            sourceMaps = true,
            userDataDir = false,
            runtimeExecutable = get_browser_path(),
            runtimeArgs = {
                "--remote-debugging-port=9222",
                "--disable-web-security",
                "--disable-features=VizDisplayCompositor",
            },
        },
        {
            type = "pwa-node",
            request = "launch",
            name = "🔥 Next.js Dev Server",
            runtimeExecutable = "npm",
            runtimeArgs = { "run", "dev" },
            port = 9229,
            cwd = "${workspaceFolder}",
            sourceMaps = true,
            skipFiles = { "<node_internals>/**", ".next/**" },
            console = "integratedTerminal",
            env = {
                NODE_OPTIONS = "--inspect",
            },
        },
        {
            type = "pwa-node",
            request = "launch",
            name = "🧪 Vitest Tests",
            program = "${workspaceFolder}/node_modules/vitest/vitest.mjs",
            args = { "run", "${file}" },
            autoAttachChildProcesses = true,
            cwd = "${workspaceFolder}",
            env = { NODE_ENV = "test" },
            console = "integratedTerminal",
            skipFiles = { "<node_internals>/**", "node_modules/**" },
            sourceMaps = true,
        },
        {
            type = "pwa-node",
            request = "launch",
            name = "🧪 Jest Current File",
            runtimeExecutable = "node",
            runtimeArgs = {
                "./node_modules/jest/bin/jest.js",
                "--runInBand",
                "--no-cache",
                "--watchAll=false",
                "${file}",
            },
            rootPath = "${workspaceFolder}",
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            internalConsoleOptions = "neverOpen",
            skipFiles = { "<node_internals>/**", "node_modules/**" },
            sourceMaps = true,
        },
        {
            type = "pwa-node",
            request = "launch",
            name = "🔄 Launch with Nodemon",
            runtimeExecutable = "nodemon",
            program = "${file}",
            restart = true,
            console = "integratedTerminal",
            cwd = "${workspaceFolder}",
            sourceMaps = true,
            skipFiles = { "<node_internals>/**" },
        },
        {
            type = "pwa-node",
            request = "launch",
            name = "🌐 Express Server",
            program = "${workspaceFolder}/server.js",
            cwd = "${workspaceFolder}",
            env = {
                NODE_ENV = "development",
                PORT = "3000",
            },
            sourceMaps = true,
            skipFiles = { "<node_internals>/**" },
            console = "integratedTerminal",
        },
    }
end

for _, language in ipairs({ "typescriptreact", "javascriptreact" }) do
    dap.configurations[language] = {
        {
            type = "pwa-chrome",
            request = "launch",
            name = "🌐 Launch React App",
            url = function()
                return vim.fn.input("App URL: ", "http://localhost:3000")
            end,
            webRoot = "${workspaceFolder}/src",
            sourceMaps = true,
            userDataDir = false,
            runtimeExecutable = get_browser_path(),
            runtimeArgs = {
                "--remote-debugging-port=9222",
                "--no-first-run",
                "--no-default-browser-check",
                "--disable-web-security",
            },
        },
        {
            type = "pwa-chrome",
            request = "attach",
            name = "🔗 Attach to Chrome",
            port = 9222,
            webRoot = "${workspaceFolder}",
            sourceMaps = true,
            trace = true,
            url = "http://localhost:*",
            pathMapping = {
                ["/"] = "${workspaceFolder}",
            },
        },
        {
            type = "pwa-chrome",
            request = "launch",
            name = "🚀 Launch Dev Server",
            url = "http://localhost:3000",
            webRoot = "${workspaceFolder}/src",
            sourceMaps = true,
            userDataDir = false,
            runtimeExecutable = get_browser_path(),
            runtimeArgs = {
                "--remote-debugging-port=9222",
                "--disable-web-security",
                "--disable-features=VizDisplayCompositor",
            },
        },
        {
            type = "pwa-node",
            request = "launch",
            name = "🔥 Next.js Dev Server",
            runtimeExecutable = "npm",
            runtimeArgs = { "run", "dev" },
            port = 9229,
            cwd = "${workspaceFolder}",
            sourceMaps = true,
            skipFiles = { "<node_internals>/**", ".next/**" },
            console = "integratedTerminal",
            env = {
                NODE_OPTIONS = "--inspect",
            },
        },
        {
            type = "pwa-node",
            request = "launch",
            name = "🧪 React Jest Tests",
            runtimeExecutable = "node",
            runtimeArgs = {
                "./node_modules/jest/bin/jest.js",
                "--runInBand",
                "--no-cache",
                "--watchAll=false",
            },
            rootPath = "${workspaceFolder}",
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            internalConsoleOptions = "neverOpen",
            sourceMaps = true,
            skipFiles = { "<node_internals>/**", "node_modules/**" },
        },
        {
            type = "pwa-chrome",
            request = "launch",
            name = "⚡ Vite Dev Server",
            url = "http://localhost:5173",
            webRoot = "${workspaceFolder}/src",
            sourceMaps = true,
            userDataDir = false,
            runtimeExecutable = get_browser_path(),
            runtimeArgs = {
                "--remote-debugging-port=9222",
                "--disable-web-security",
            },
        },
    }
end

dap.configurations.vue = {
    {
        type = "pwa-chrome",
        request = "launch",
        name = "🔷 Launch Vue App",
        url = function()
            return vim.fn.input("Vue App URL: ", "http://localhost:8080")
        end,
        webRoot = "${workspaceFolder}/src",
        sourceMaps = true,
        userDataDir = false,
        runtimeExecutable = get_browser_path(),
        runtimeArgs = {
            "--remote-debugging-port=9222",
            "--disable-web-security",
        },
    },
    {
        type = "pwa-chrome",
        request = "launch",
        name = "🔷 Vue with Vite",
        url = "http://localhost:5173",
        webRoot = "${workspaceFolder}/src",
        sourceMaps = true,
        userDataDir = false,
        runtimeExecutable = get_browser_path(),
        runtimeArgs = {
            "--remote-debugging-port=9222",
            "--disable-web-security",
        },
    },
}

dap.configurations.svelte = {
    {
        type = "pwa-chrome",
        request = "launch",
        name = "🧡 Launch Svelte App",
        url = function()
            return vim.fn.input("Svelte App URL: ", "http://localhost:5000")
        end,
        webRoot = "${workspaceFolder}/src",
        sourceMaps = true,
        userDataDir = false,
        runtimeExecutable = get_browser_path(),
        runtimeArgs = {
            "--remote-debugging-port=9222",
            "--disable-web-security",
        },
    },
    {
        type = "pwa-chrome",
        request = "launch",
        name = "🧡 Svelte with Vite",
        url = "http://localhost:5173",
        webRoot = "${workspaceFolder}/src",
        sourceMaps = true,
        userDataDir = false,
        runtimeExecutable = get_browser_path(),
        runtimeArgs = {
            "--remote-debugging-port=9222",
            "--disable-web-security",
        },
    },
}

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "dap-repl" },
    callback = function()
        require("dap.ext.autocompl").attach()
    end,
})

local function ensure_js_debug_adapter()
    if vim.fn.executable("js-debug-adapter") == 0 then
        vim.notify(
            "⚠️  js-debug-adapter no encontrado. Instálalo con: npm install -g js-debug-adapter",
            vim.log.levels.WARN
        )
        return false
    end
    return true
end

if ensure_js_debug_adapter() then
    vim.notify("✅ DAP configurado para JavaScript/TypeScript con vscode-js-debug", vim.log.levels.INFO)
end
