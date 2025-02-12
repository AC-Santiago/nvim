require("nvchad.mappings")

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
map({ "n", "v" }, "<localleader>e", ":NvimTreeToggle<CR>", { desc = "NvimTree Toggle" })

-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself

map({ "n", "v" }, "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
map({ "n", "v" }, "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })
