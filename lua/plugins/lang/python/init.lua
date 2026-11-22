if not require("configs.languages").is_enabled("python") then
    return {}
end

return {
    { import = "plugins.lang.python.dap" },
    { import = "plugins.lang.python.uv-nvim" },
}
