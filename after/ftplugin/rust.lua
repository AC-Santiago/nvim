local bufnr = vim.api.nvim_get_current_buf()

-- Keymaps para rust-analyzer
-- Hover y documentación
vim.keymap.set("n", "K", function()
    vim.cmd.RustLsp({ "hover", "actions" })
end, { silent = true, buffer = bufnr, desc = "Hover actions" })

vim.keymap.set("n", "<localleader>rh", function()
    vim.cmd.RustLsp({ "hover", "actions" })
end, { silent = true, buffer = bufnr, desc = "Hover actions" })

vim.keymap.set("n", "<localleader>roc", function()
    vim.cmd.RustLsp("openDocs")
end, { silent = true, buffer = bufnr, desc = "Open docs" })

-- Debug y tests
vim.keymap.set("n", "<localleader>da", function()
    vim.cmd.RustLsp("debuggables")
end, { silent = true, buffer = bufnr, desc = "Debug test" })

vim.keymap.set("n", "<leader>tt", function()
    vim.cmd.RustLsp("testables")
end, { silent = true, buffer = bufnr, desc = "Run tests" })

-- Navegación
vim.keymap.set("n", "gd", function()
    vim.cmd.RustLsp("definition")
end, { silent = true, buffer = bufnr, desc = "Go to definition" })

vim.keymap.set("n", "gr", function()
    vim.cmd.RustLsp("references")
end, { silent = true, buffer = bufnr, desc = "Go to references" })

vim.keymap.set("n", "<localleader>rpm", function()
    vim.cmd.RustLsp("parentModule")
end, { silent = true, buffer = bufnr, desc = "Go to parent module" })

-- Code actions y herramientas
vim.keymap.set("n", "<localleader>rca", function()
    vim.cmd.RustLsp('codeAction')
end, { silent = true, buffer = bufnr, desc = "Code actions" })

vim.keymap.set("n", "<localleader>rr", function()
    vim.cmd.RustLsp("runnables")
end, { silent = true, buffer = bufnr, desc = "Run" })

vim.keymap.set("n", "<localleader>rem", function()
    vim.cmd.RustLsp("expandMacro")
end, { silent = true, buffer = bufnr, desc = "Expand macro" })

vim.keymap.set("n", "<localleader>rj", function()
    vim.cmd.RustLsp("joinLines")
end, { silent = true, buffer = bufnr, desc = "Join lines" })

-- Diagnostics
vim.keymap.set("n", "<localleader>rd", function()
    vim.cmd.RustLsp({ "renderDiagnostic", "current" })
end, { silent = true, buffer = bufnr, desc = "Render diagnostic" })

vim.keymap.set("n", "<localleader>ree", function()
    vim.cmd.RustLsp({ "explainError", "current" })
end, { silent = true, buffer = bufnr, desc = "Explain error" })

-- Cargo
vim.keymap.set("n", "<localleader>rc", function()
    vim.cmd.RustLsp('openCargo')
end, { silent = true, buffer = bufnr, desc = "Open Cargo.toml" })
