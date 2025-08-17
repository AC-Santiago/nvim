require("oil-git").setup({
    highlights = {
        OilGitAdded = { fg = "#a6e3a1" }, -- green
        OilGitModified = { fg = "#f9e2af" }, -- yellow
        OilGitDeleted = { fg = "#f38ba8" }, -- red
        OilGitRenamed = { fg = "#cba6f7" }, -- purple
        OilGitUntracked = { fg = "#89b4fa" }, -- blue
        OilGitIgnored = { fg = "#6c7086" }, -- gray
    },
})
