---@diagnostic disable:missing-fields
return {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    config = function()
        local notify = require("notify")
        -- this for transparency
        notify.setup({ background_colour = "#000000", opacity = 0, render = "simple" })
        -- this overwrites the vim notify function
        vim.notify = notify.notify
    end,
}
