-- Keymaps específicos para archivos Rust
local bufnr = vim.api.nvim_get_current_buf()

vim.keymap.set("n", "K", function()
    vim.cmd.RustLsp({ "hover", "actions" })
end, { silent = true, buffer = bufnr, desc = "Hover actions" })

-- Debug
vim.keymap.set("n", "<localleader>da", function()
    vim.cmd.RustLsp("debuggables")
end, { silent = true, buffer = bufnr, desc = "Debug test" })

-- Tests
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

vim.keymap.set("n", "<localleader>pm", function()
    vim.cmd.RustLsp("parentModule")
end, { silent = true, buffer = bufnr, desc = "Go to parent module" })

-- Herramientas
vim.keymap.set("n", "<localleader>rr", function()
    vim.cmd.RustLsp("runnables")
end, { silent = true, buffer = bufnr, desc = "Run" })

vim.keymap.set("n", "<localleader>rem", function()
    vim.cmd.RustLsp("expandMacro")
end, { silent = true, buffer = bufnr, desc = "Expand macro" })

vim.keymap.set("n", "<localleader>rh", function()
    vim.cmd.RustLsp("hover", "actions")
end, { silent = true, buffer = bufnr, desc = "Hover actions" })

vim.keymap.set("n", "<localleader>rj", function()
    vim.cmd.RustLsp("joinLines")
end, { silent = true, buffer = bufnr, desc = "Join lines" })

vim.keymap.set("n", "<localleader>rd", function()
    vim.cmd.RustLsp({ "renderDiagnostic", "current" })
end, { silent = true, buffer = bufnr, desc = "Render diagnostic" })

vim.keymap.set("n", "<localleader>ree", function()
    vim.cmd.RustLsp({ "explainError", "current" })
end, { silent = true, buffer = bufnr, desc = "Explain error" })

-- Documentation
vim.keymap.set("n", "<localleader>roc", function()
    vim.cmd.RustLsp("openDocs")
end, { silent = true, buffer = bufnr, desc = "Open docs" })
