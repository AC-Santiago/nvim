return {
    { import = "plugins.lang.python.nvim-dap-python" },
}
-- local python_plugins = {}
--
-- local plugin_modules = {
--     require("plugins.lang.python.nvim-dap-python"),
-- }
--
-- for _, module in ipairs(plugin_modules) do
--     if type(module) == "table" then
--         if module[1] then
--             for _, plugin in ipairs(module) do
--                 table.insert(python_plugins, plugin)
--             end
--         else
--             table.insert(python_plugins, module)
--         end
--     end
-- end
--
-- return python_plugins
