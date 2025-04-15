-- Keymaps específicos para archivos Rust
local bufnr = vim.api.nvim_get_current_buf()

-- Acciones de código y hover
vim.keymap.set("n", "<leader>ca", function()
    vim.cmd.RustLsp("codeAction")
end, { silent = true, buffer = bufnr, desc = "Code actions" })

vim.keymap.set("n", "K", function()
    vim.cmd.RustLsp({ "hover", "actions" })
end, { silent = true, buffer = bufnr, desc = "Hover actions" })

-- Debug
vim.keymap.set("n", "<leader>dt", function()
    vim.cmd.RustLsp("debuggables")
end, { silent = true, buffer = bufnr, desc = "Debug test" })

vim.keymap.set("n", "<leader>dr", function()
    vim.cmd.RustLsp("runnables")
end, { silent = true, buffer = bufnr, desc = "Run" })

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

vim.keymap.set("n", "<leader>pm", function()
    vim.cmd.RustLsp("parentModule")
end, { silent = true, buffer = bufnr, desc = "Go to parent module" })

-- Herramientas
vim.keymap.set("n", "<leader>rr", function()
    vim.cmd.RustLsp("runnables")
end, { silent = true, buffer = bufnr, desc = "Run" })

vim.keymap.set("n", "<leader>rem", function()
    vim.cmd.RustLsp("expandMacro")
end, { silent = true, buffer = bufnr, desc = "Expand macro" })

vim.keymap.set("n", "<leader>rh", function()
    vim.cmd.RustLsp("hover", "actions")
end, { silent = true, buffer = bufnr, desc = "Hover actions" })

vim.keymap.set("n", "<leader>rj", function()
    vim.cmd.RustLsp("joinLines")
end, { silent = true, buffer = bufnr, desc = "Join lines" })

vim.keymap.set("n", "<leader>rd", function()
    vim.cmd.RustLsp("renderDiagnostic")
end, { silent = true, buffer = bufnr, desc = "Render diagnostic" })

vim.keymap.set("n", "<leader>re", function()
    vim.cmd.RustLsp("explainError")
end, { silent = true, buffer = bufnr, desc = "Explain error" })

-- Documentation
vim.keymap.set("n", "<leader>doc", function()
    vim.cmd.RustLsp("openDocs")
end, { silent = true, buffer = bufnr, desc = "Open docs" })
