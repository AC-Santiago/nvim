return {
    "mrcjkb/rustaceanvim",
    version = "^6",
    ft = { "rust" },
    default_settings = {
        -- rust-analyzer language server configuration
        ["rust-analyzer"] = {
            cargo = {
                allFeatures = true,
            },
            checkOnSave = true,
            diagnostics = {
                enable = true,
            },
            procMacro = {
                enable = true,
                ignored = {
                    ["async-trait"] = { "async_trait" },
                    ["napi-derive"] = { "napi" },
                    ["async-recursion"] = { "async_recursion" },
                },
            },
            files = {
                excludeDirs = {
                    ".direnv",
                    ".git",
                    ".github",
                    ".gitlab",
                    "bin",
                    "node_modules",
                    "target",
                    "venv",
                    ".venv",
                },
            },
        },
    },
}
